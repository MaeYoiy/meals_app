import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';
import 'package:meals/screens/meal_details.dart';
import 'package:meals/widgets/meal_item.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen(
      {super.key,
      this.title,
      required this.meals,
      required this.onToggleFavorite});

  final String? title;
  final List<Meal> meals;
  final void Function(Meal meal) onToggleFavorite;

  void selectMeal(BuildContext context, Meal meal) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (ctx) => MealDetailsScreen(
          meal: meal,
          onToggleFavorite: onToggleFavorite,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // เก็บ Widget ไว้ในตัวแปร content
    Widget content = Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Uh oh ... nothing here!',
            style: Theme.of(context).textTheme.headlineLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
          const SizedBox(
            height: 16,
          ),
          Text(
            'Try selecting a different category!',
            style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: Theme.of(context).colorScheme.onBackground,
                ),
          ),
        ],
      ),
    );

    if (meals.isNotEmpty) {
      // สร้าง list meal แล้วส่งค่าไปที่ meal_item.dart
      content = ListView.builder(
        // itemCount บอกจำนวนความยาวของ list meals
        itemCount: meals.length,
        itemBuilder: (ctx, index) => MealItem(
          meal: meals[index],
          // ถ้ากดตรง card meal แล้วมันจะเรียก function selectMeal ซึ่งก็จะ ส่งค่า meal และ onSelectMeal ไปที่ meal_item.dart เพื่อสร้าง list meal
          onSelectMeal: (meal) {
            selectMeal(context, meal);
          },
        ),
      );
    }

    // คือถ้า title เป็น null จะไม่แสดง AppBar แตจะเริ่มแสดงที่ content แทน
    // ซึ่งถ้าเรากด Icon Favorites แล้ว title ตัวนี้จะเป็นค่า null เพราะฉะนั้นมันจึงไม่แสดง AppBar ซ้ำ เพราะ AppBar นี้จะแสดงส่วนที่เป็น meal.title

    if (title == null) {
      return content;
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title!),
      ),
      // .builder ใช้ในกรณีที่มีรายการยาวๆ หรือเราต้องการเพิ่มประสิทธิภาพของ
      body: content,
    );
  }
}
