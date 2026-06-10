import 'package:flutter/material.dart';
import '../models/food_item.dart';
import '../models/cart_item.dart';

class CartProvider with ChangeNotifier {
  final List<CartItem> _items = [];
  final Set<String> _favoriteIds = {};
  String? _appliedPromoCode;
  double _promoDiscountPercentage = 0.0;

  List<CartItem> get items => [..._items];
  Set<String> get favoriteIds => _favoriteIds;
  String? get appliedPromoCode => _appliedPromoCode;

  // Add to cart logic
  void addToCart({
    required FoodItem foodItem,
    required String size,
    required List<String> extras,
    required double basePrice,
    int quantity = 1,
  }) {
    // Check if the exact same item (same id, size, and extras) is already in the cart
    int index = _items.indexWhere((item) =>
        item.foodItem.id == foodItem.id &&
        item.selectedSize == size &&
        _areExtrasEqual(item.selectedExtras, extras));

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(CartItem(
        foodItem: foodItem,
        selectedSize: size,
        selectedExtras: List.from(extras),
        basePrice: basePrice,
        quantity: quantity,
      ));
    }
    notifyListeners();
  }

  // Remove completely from cart
  void removeFromCart(CartItem cartItem) {
    _items.remove(cartItem);
    notifyListeners();
  }

  // Decrease quantity
  void decreaseQuantity(CartItem cartItem) {
    if (cartItem.quantity > 1) {
      cartItem.quantity--;
    } else {
      _items.remove(cartItem);
    }
    notifyListeners();
  }

  // Increase quantity
  void increaseQuantity(CartItem cartItem) {
    cartItem.quantity++;
    notifyListeners();
  }

  // Clear all cart contents
  void clearCart() {
    _items.clear();
    _appliedPromoCode = null;
    _promoDiscountPercentage = 0.0;
    notifyListeners();
  }

  // Helper to check if extras lists are identical (ignoring order)
  bool _areExtrasEqual(List<String> list1, List<String> list2) {
    if (list1.length != list2.length) return false;
    return list1.every((item) => list2.contains(item));
  }

  // Total quantity of items in cart
  int get itemCount {
    return _items.fold(0, (total, item) => total + item.quantity);
  }

  // Price calculations
  double get subtotal {
    return _items.fold(0.0, (total, item) => total + item.totalPrice);
  }

  double get deliveryFee {
    if (_items.isEmpty) return 0.0;
    // Base delivery fee is $4.99, but promo code could discount it
    if (_appliedPromoCode == "FREEDELIV") {
      return 0.0;
    }
    return 4.99;
  }

  double get taxAmount {
    // 8% tax rate
    return subtotal * 0.08;
  }

  double get discountAmount {
    return subtotal * _promoDiscountPercentage;
  }

  double get totalAmount {
    if (_items.isEmpty) return 0.0;
    double amount = subtotal + deliveryFee + taxAmount - discountAmount;
    return amount < 0 ? 0.0 : amount;
  }

  // Apply promo code logic
  bool applyPromoCode(String code) {
    String formattedCode = code.trim().toUpperCase();
    if (formattedCode == "FOOD15") {
      _appliedPromoCode = "FOOD15";
      _promoDiscountPercentage = 0.15; // 15% off subtotal
      notifyListeners();
      return true;
    } else if (formattedCode == "FREEDELIV") {
      _appliedPromoCode = "FREEDELIV";
      _promoDiscountPercentage = 0.0; // Free delivery (handled in deliveryFee)
      notifyListeners();
      return true;
    } else if (formattedCode == "TASTE25") {
      _appliedPromoCode = "TASTE25";
      _promoDiscountPercentage = 0.25; // 25% off subtotal
      notifyListeners();
      return true;
    }
    return false;
  }

  // Remove promo code
  void removePromoCode() {
    _appliedPromoCode = null;
    _promoDiscountPercentage = 0.0;
    notifyListeners();
  }

  // Favorites Management
  bool isFavorite(String id) {
    return _favoriteIds.contains(id);
  }

  void toggleFavorite(String id) {
    if (_favoriteIds.contains(id)) {
      _favoriteIds.remove(id);
    } else {
      _favoriteIds.add(id);
    }
    notifyListeners();
  }
}
