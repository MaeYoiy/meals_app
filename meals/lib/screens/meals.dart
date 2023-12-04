import 'package:flutter/material.dart';
import 'package:meals/models/meal.dart';

class MealsScreen extends StatelessWidget {
  const MealsScreen({super.key, required this.title, required this.meals});

  final String title;
  final List<Meal> meals;

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
      content = ListView.builder(
        // itemCount บอกจำนวนความยาวของ list meals
        itemCount: meals.length,
        itemBuilder: (ctx, index) => Text(
          meals[index].title,
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      // .builder ใช้ในกรณีที่มีรายการยาวๆ หรือเราต้องการเพิ่มประสิทธิภาพของ
      body: content,
    );
  }
}
