import 'package:flutter/material.dart';
// import 'package:meals/data/dummy_data.dart';
import 'package:meals/screens/categories.dart';
import 'package:meals/screens/filters.dart';
import 'package:meals/screens/meals.dart';
// import 'package:meals/models/meal.dart';
import 'package:meals/widgets/main_drawer.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider/favorites_provider.dart';
import 'package:meals/provider/filters_provider.dart';

// ตัวแปรส่วนกลางที่ใช้ร่วมกันได้หมด
const kInitialFilters = {
  Filter.glutenFree: false,
  Filter.lactoseFree: false,
  Filter.vegetarian: false,
  Filter.vegan: false,
};

class TabsScreen extends ConsumerStatefulWidget {
  const TabsScreen({super.key});

  @override
  ConsumerState<TabsScreen> createState() {
    return _TabsScreenState();
  }
}

class _TabsScreenState extends ConsumerState<TabsScreen> {
  int _selectedPageIndex = 0;
  // ณ ตอนนี้เรามี Provider จัดการกับเพิ่มอาหารโปรด และลดอาหารโปรดแล้ว ดังนั้น _toggleMealFavoriteStatus จึงไม่ได้ใช้อีกต่อไป
  // function ที่ใช้เพิ่มอาหารโปรด และลดอาหารโปรด
  // void _toggleMealFavoriteStatus(Meal meal) {
  // contains เป็นเมธอดที่ใช้ตรวจสอบว่าค่าอยู่ในหรือไม่ ซึ่งคอลเล็กชันที่รองรับ contains ได้รวมถึง List, Set, และ Map (เมื่อใช้กับ Map จะเป็นการตรวจสอบว่ามี key หรือไม่).
  // return True or False
  //   final isExisting = _favoriteMeals.contains(meal);

  //   if (isExisting) {
  //     setState(() {
  //       _favoriteMeals.remove(meal);
  //     });
  //     _showInfoMessage('Meal is no longer a favorite.');
  //   } else {
  //     setState(() {
  //       _favoriteMeals.add(meal);
  //     });
  //     _showInfoMessage('Marked as a favorite!');
  //   }
  // }

  void _selectedPage(int index) {
    setState(() {
      _selectedPageIndex = index;
    });
  }

  void _setScreen(String identifier) async {
    Navigator.of(context).pop();
    if (identifier == 'filters') {
      // เมื่อกด Filters ที่หน้า tabs แล้วจะ push ไปที่หน้า filter จากนั้นจะทำการ map ค่า ระหว่าง Filter คู่กับ Boolean
      await Navigator.of(context).push<Map<Filter, bool>>(
        MaterialPageRoute(
          builder: (ctx) => const FiltersScreen(),
        ),
      );
      //print(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final availableMeals = ref.watch(filterMealsProvider);

    Widget activePage = CategoriesScreen(
      availableMeals: availableMeals,
    );
    var activePageTitle = 'Categories';

    if (_selectedPageIndex == 1) {
      final favoriteMeals = ref.watch(favoriteMealsProvider);
      // TabsScreen -> MealsScreen -> MealDetailsScreen
      activePage = MealsScreen(
        meals: favoriteMeals,
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
