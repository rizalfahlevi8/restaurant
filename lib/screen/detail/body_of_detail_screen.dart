import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:restaurant/data/api/api_service.dart';
import 'package:restaurant/data/model/restaurant.dart';
import 'package:restaurant/provider/detail/restaurant_detail_provider.dart';
import 'package:restaurant/screen/detail/card_screen.dart';

class BodyOfDetailScreen extends StatefulWidget {
  const BodyOfDetailScreen({super.key, required this.restaurant});

  final Restaurant restaurant;

  @override
  State<BodyOfDetailScreen> createState() => _BodyOfDetailScreenState();
}

class _BodyOfDetailScreenState extends State<BodyOfDetailScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        children: [
          Hero(
            tag: widget.restaurant.pictureId,
            child: Image.network(
              'https://restaurant-api.dicoding.dev/images/small/${widget.restaurant.pictureId}',
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox.square(dimension: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.restaurant.name,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    Row(
                      children: [
                        Flexible(
                          child: Text(
                            widget.restaurant.address! + ', ',
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.w400),
                          ),
                        ),
                        Flexible(
                          child: Text(
                            widget.restaurant.city,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amberAccent),
                  const SizedBox.square(dimension: 4),
                  Text(
                    widget.restaurant.rating.toString(),
                    style: Theme.of(context).textTheme.bodyLarge,
                  )
                ],
              ),
            ],
          ),
          Text(
            widget.restaurant.description,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox.square(dimension: 16),
          CardScreen(
              title: "Foods",
              icon: Icon(Icons.fastfood),
              items: widget.restaurant.menus!.foods),
          const SizedBox.square(dimension: 16),
          CardScreen(
              title: "Drinks",
              icon: Icon(Icons.emoji_food_beverage_rounded),
              items: widget.restaurant.menus!.drinks),
          const SizedBox.square(dimension: 16),
          CardScreen(
              title: "Category",
              icon: Icon(Icons.category),
              items: widget.restaurant.categories!),
          const SizedBox.square(dimension: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Customer Review",
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium
                        ?.copyWith(fontWeight: FontWeight.w400),
                  ),
                  const SizedBox.square(dimension: 8),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    elevation: 4,
                    shadowColor: Colors.grey.withOpacity(0.2),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          TextField(
                            controller: _nameController,
                            decoration: InputDecoration(
                              labelText: 'Name of Reviewer',
                              hintText: 'Enter Name of Reviewer',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            controller: _reviewController,
                            maxLines: 4,
                            decoration: InputDecoration(
                              labelText: 'Review',
                              hintText: 'Enter Review',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Align(
                            alignment: Alignment.centerRight,
                            child: ElevatedButton.icon(
                              onPressed: () async {
                                if (_nameController.text.isEmpty ||
                                    _reviewController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                          content: Text(
                                              'Nama dan ulasan tidak boleh kosong!')));
                                } else {
                                  final result = await ApiService()
                                      .postReviewRestaurant(
                                          widget.restaurant.id,
                                          _nameController.text,
                                          _reviewController.text);

                                  if (result.error == false) {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Berhasil menambahkan review!'),
                                      backgroundColor: Colors.green,
                                    ));
                                    _nameController.clear();
                                    _reviewController.clear();
                                    context
                                        .read<RestaurantDetailProvider>()
                                        .fetchRestaurantDetail(
                                            widget.restaurant.id);
                                  } else {
                                    ScaffoldMessenger.of(context)
                                        .showSnackBar(SnackBar(
                                      content:
                                          Text('Gagal menambahkan review!'),
                                      backgroundColor: Colors.green,
                                    ));
                                  }
                                }
                              },
                              icon: Icon(
                                Icons.send,
                                color: Colors.white,
                              ),
                              label: Text("Submit"),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ))
            ],
          ),
          const SizedBox(height: 16),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...widget.restaurant.customerReviews!.map((review) {
                    return Card(
                      margin: EdgeInsets.only(bottom: 16),
                      shadowColor: Colors.grey.withOpacity(0.2),
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Container(
                        padding: EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 20,
                                  backgroundColor: Colors.teal[100],
                                  child: Icon(
                                    Icons.person,
                                    color: Colors.teal[700],
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  review.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyLarge
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                            const SizedBox.square(dimension: 8),
                            Text(
                              review.review,
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            const SizedBox.square(dimension: 8),
                            Text(
                              review.date,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ],
              ))
            ],
          ),
        ],
      ),
    );
  }
}
