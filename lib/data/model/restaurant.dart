import 'package:restaurant/data/model/category.dart';
import 'package:restaurant/data/model/customer_review.dart';
import 'package:restaurant/data/model/menus.dart';

class Restaurant {
  final String id;
  final String name;
  final String description;
  final String pictureId;
  final String city;
  final double rating;
  final String address;
  List<Category>? categories;
  Menus? menus;
  List<CustomerReview>? customerReviews;

  Restaurant({
    required this.id,
    required this.name,
    required this.description,
    required this.pictureId,
    required this.city,
    required this.rating,
    required this.address,
    this.categories,
    this.menus,
    this.customerReviews,
  });

  factory Restaurant.fromJson(Map<String, dynamic> json) {
    return Restaurant(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      pictureId: json['pictureId'],
      city: json['city'],
      rating: json['rating'].toDouble(),
      address: json['address'] ?? '',
      categories: json["categories"] != null
          ? List<Category>.from(
              json["categories"].map((x) => Category.fromJson(x)),
            )
          : <Category>[],
      menus: json["menus"] != null ? Menus.fromJson(json["menus"]) : Menus(foods: [], drinks: []),
      customerReviews: json["customerReviews"] != null
          ? List<CustomerReview>.from(
              json["customerReviews"].map((x) => CustomerReview.fromJson(x)),
            )
          : <CustomerReview>[],
    );
  }
}