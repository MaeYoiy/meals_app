import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:meals/provider/meals_provider.dart';

enum Filter {
  glutenFree,
  lactoseFree,
  vegetarian,
  vegan,
}

class FiltersNotifier extends StateNotifier<Map<Filter, bool>> {
  FiltersNotifier()
      : super({
          Filter.glutenFree: false,
          Filter.lactoseFree: false,
          Filter.vegetarian: false,
          Filter.vegan: false,
        });

  void setFilters(Map<Filter, bool> chosenFilters) {
    state = chosenFilters;
  }

  void setFilter(Filter filter, bool isActive) {
    // state[filter] = isActive; // not allowed! => mutating state
    state = {
      ...state,
      filter: isActive,
    };
  }
}

final filtersProvider =
    StateNotifierProvider<FiltersNotifier, Map<Filter, bool>>(
  (ref) => FiltersNotifier(),
);

final filterMealsProvider = Provider((ref) {
  final meals = ref.watch(mealsProvider);
  final activeFilters = ref.watch(filtersProvider);

  return meals.where((meal) {
    // เงื่อนไข 1 : Map<Filter, bool> _selectedFilters = {
    //             Filter.glutenFree: true,
    //             Filter.lactoseFree: false,
    //             Filter.vegetarian: false,
    //             Filter.vegan: false,
    //            };
    // เงื่อนไข 2 : meal.isGlutenFree เป็น false (คืออาหารนั้นไม่ได้ "gluten-free"), แล้วเงื่อนไขจะส่งค่า false กลับมา ซึ่งหมายความว่าอาหารนั้นจะไม่ถูกรวมเข้าไปใน availableMeals.
    if (activeFilters[Filter.glutenFree]! && !meal.isGlutenFree) {
      print('gluten bool is ${meal.isGlutenFree}');
      return false;
    }
    if (activeFilters[Filter.lactoseFree]! && !meal.isLactoseFree) {
      return false;
    }
    if (activeFilters[Filter.vegetarian]! && !meal.isVegetarian) {
      return false;
    }
    if (activeFilters[Filter.vegan]! && !meal.isVegan) {
      return false;
    }
    return true;
  }).toList();
});
