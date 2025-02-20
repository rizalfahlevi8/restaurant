import 'package:flutter/material.dart';
import 'package:restaurant/data/model/category.dart';

class CardScreen extends StatelessWidget {
  const CardScreen({super.key, required this.title, required this.icon, required this.items});

  final String title;
  final Icon icon;
  final List<Category> items;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox.square(dimension: 8),
        Container(
          width: double.infinity, 
          height: 80, 
          child: ListView.separated(
            scrollDirection: Axis.horizontal, 
            shrinkWrap: true,
            physics: const BouncingScrollPhysics(),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8), 
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        icon.icon, 
                        size: 24,
                        color: Theme.of(context).primaryColor,
                      ),
                      const SizedBox(width: 8), 
                      Text(
                        item.name,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
