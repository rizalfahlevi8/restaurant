import 'package:flutter/material.dart';
import 'package:restaurant/data/model/restaurant.dart';

class RestaurantCard extends StatelessWidget {
  final Restaurant restaurant;
  final Function() onTap;

  const RestaurantCard(
      {super.key, required this.restaurant, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 80,
                  minHeight: 80,
                  maxWidth: 120,
                  minWidth: 120,
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Hero(
                      tag: restaurant.pictureId,
                      child: Image.network(
                        'https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}',
                        fit: BoxFit.cover,
                      ),
                    ))),
            SizedBox.square(
              dimension: 8,
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(restaurant.name),
                  SizedBox.square(
                    dimension: 6,
                  ),
                  Row(
                    children: [
                      Icon(Icons.location_on),
                      SizedBox.square(
                        dimension: 4,
                      ),
                      Expanded(child: Text(restaurant.city)),
                    ],
                  ),
                  SizedBox.square(
                    dimension: 4,
                  ),
                  Row(
                    children: [
                      Icon(Icons.star, color: Colors.amberAccent,),
                      SizedBox.square(
                        dimension: 4,
                      ),
                      Expanded(child: Text(restaurant.rating.toString())),
                    ],
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
