import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/cart_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;

  const CartItemTile({
    super.key,
    required this.cartItem,
  });

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = Provider.of<CartProvider>(context, listen: false);

    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        cartProvider.removeFromCart(cartItem);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${cartItem.foodItem.name} removed from cart'),
            action: SnackBarAction(
              label: 'UNDO',
              onPressed: () {
                cartProvider.addToCart(
                  foodItem: cartItem.foodItem,
                  size: cartItem.selectedSize,
                  extras: cartItem.selectedExtras,
                  basePrice: cartItem.basePrice,
                  quantity: cartItem.quantity,
                );
              },
            ),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20.0),
        decoration: BoxDecoration(
          color: Colors.redAccent.withOpacity(0.15),
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
        ),
        child: const Icon(
          Icons.delete_sweep_rounded,
          color: Colors.redAccent,
          size: 28,
        ),
      ),
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkCard : Colors.white,
          borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(isDark ? 0.2 : 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            )
          ],
          border: Border.all(
            color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.02),
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Image of Food
            ClipRRect(
              borderRadius: BorderRadius.circular(AppTheme.radiusSmall * 1.5),
              child: SizedBox(
                width: 70,
                height: 70,
                child: Image.network(
                  cartItem.foodItem.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF2C3E50), const Color(0xFF000000)]
                              : [const Color(0xFFFFE8E0), const Color(0xFFFFFAF8)],
                        ),
                      ),
                      child: const Center(
                        child: Icon(Icons.fastfood_rounded, size: 24, color: AppTheme.primaryColor),
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(width: 16),

            // Content: Title, size, extras, total price
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartItem.foodItem.name,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 4),

                  // Selected Attributes
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppTheme.primaryColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          cartItem.selectedSize,
                          style: const TextStyle(
                            color: AppTheme.primaryColor,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      if (cartItem.selectedExtras.isNotEmpty) ...[
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            '+ ${cartItem.selectedExtras.join(', ')}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  fontSize: 11,
                                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                                ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 6),

                  // Calculated Item Price
                  Text(
                    '\$${cartItem.totalPrice.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryColor,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ],
              ),
            ),

            // Quantity Controls
            Column(
              children: [
                GestureDetector(
                  onTap: () {
                    cartProvider.removeFromCart(cartItem);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.delete_outline_rounded,
                      color: Colors.redAccent.withOpacity(0.6),
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    // Minus Button
                    GestureDetector(
                      onTap: () => cartProvider.decreaseQuantity(cartItem),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                        ),
                        child: const Icon(Icons.remove, size: 14),
                      ),
                    ),
                    // Quantity
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        cartItem.quantity.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                    ),
                    // Plus Button
                    GestureDetector(
                      onTap: () => cartProvider.increaseQuantity(cartItem),
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
                        ),
                        child: const Icon(Icons.add, size: 14),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
