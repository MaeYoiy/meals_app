import 'package:flutter/material.dart';
import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/widgets/main_drawer.dart';

// ตัวแปรส่วนกลางที่ใช้ร่วมกันได้หมด
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key});

  @override
  State<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends State<TabsScreen> {
  int _selectedPageIndex = 0;
  final List<Meal> _favoriteMeals = [];
  Map<Filter, bool> _selectedFilters = kInitialFilters;

  // snack bar เพื่อโชว์ข้อมูลว่าเรากด Icon star
  void _showInfoMessage(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  // function ที่ใช้เพิ่มอาหารโปรด และลดอาหารโปรด
  void _toggleMealFavoriteStatus(Meal meal) {
    // contains เป็นเมธอดที่ใช้ตรวจสอบว่าค่าอยู่ในหรือไม่ ซึ่งคอลเล็กชันที่รองรับ contains ได้รวมถึง List, Set, และ Map (เมื่อใช้กับ Map จะเป็นการตรวจสอบว่ามี key หรือไม่).
    // return True or False
    final isExisting = _favoriteMeals.contains(meal);

    if (isExisting) {
      setState(() {
        _favoriteMeals.remove(meal);
      });
      _showInfoMessage('Meal is no longer a favorite.');
    } else {
      setState(() {
        _favoriteMeals.add(meal);
      });
      _showInfoMessage('Marked as a favorite!');
    }
  }

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    if (identifier == 'filters') {
      // เมื่อกด Filters ที่หน้า tabs แล้วจะ push ไปที่หน้า filter จากนั้นจะทำการ map ค่า ระหว่าง Filter คู่กับ Boolean
      final result = await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => FiltersScreen(
            currentFilters: _selectedFilters,
          ),
        ),
      );
      print(result);
      setState(() {
        // ถ้า result เป็นค่าว่าง มันจะมีค่า = kInitialFilters
        _selectedFilters = result ?? kInitialFilters;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = dummyMeals.where((meal) {
      // เงื่อนไข 1 : Map<Filter, bool> _selectedFilters = {
      //             Filter.glutenFree: true,
      //             Filter.lactoseFree: false,
      //             Filter.vegetarian: false,
      //             Filter.vegan: false,
      //            };
      // เงื่อนไข 2 : meal.isGlutenFree เป็น false (คืออาหารนั้นไม่ได้ "gluten-free"), แล้วเงื่อนไขจะส่งค่า false กลับมา ซึ่งหมายความว่าอาหารนั้นจะไม่ถูกรวมเข้าไปใน availableMeals.
      if (_selectedFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
        print('gluten bool is ${meal.isGlutenFree}');
        return false;
      }
      if (_selectedFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
        return false;
      }
      if (_selectedFilters[Filter.vegetarian]! && !meal.isVegetarian) {
        return false;
      }
      if (_selectedFilters[Filter.vegan]! && !meal.isVegan) {
        return false;
      }
      return true;
    }).toList();

    Widget activePage = CategoriesScreen(
      onToggleFavorite: _toggleMealFavoriteStatus,
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      // TabsScreen -> MealsScreen -> MealDetailsScreen
      activePage = MealsScreen(
        meals: _favoriteMeals,
        onToggleFavorite: _toggleMealFavoriteStatus,
      );
      activePageTitle = 'Your Favorites';
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(activePageTitle),
      ),
      drawer: MainDrawer(
        onSelectScreen: _setScreen,
      ),
      body: activePage,
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.set_meal),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.star),
            label: 'Favorites',
          ),
        ],
        onTap: _selectedPage,
        currentIndex: _selectedPageIndex,
      ),
    );
  }
}
