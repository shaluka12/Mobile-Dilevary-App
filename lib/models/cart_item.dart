import 'food_item.dart';

class CartItem {
  final FoodItem foodItem;
  int quantity;
  final String selectedSize;
  final List<String> selectedExtras;
  final double basePrice; // Price based on size selection

  CartItem({
    required this.foodItem,
    this.quantity = 1,
    required this.selectedSize,
    required this.selectedExtras,
    required this.basePrice,
  });

  double get totalPrice {
    // Each selected extra adds $1.50 to the item price
    double extraCost = selectedExtras.length * 1.50;
    return (basePrice + extraCost) * quantity;
  }
}
