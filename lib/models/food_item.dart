class FoodItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final String imageUrl;
  final double rating;
  final String prepTime;
  final String category;
  final List<String> sizes;
  final List<String> extras;

  FoodItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.imageUrl,
    required this.rating,
    required this.prepTime,
    required this.category,
    this.sizes = const ['Small', 'Medium', 'Large'],
    this.extras = const ['Cheese', 'Spicy Sauce', 'Extra Veggies'],
  });
}
