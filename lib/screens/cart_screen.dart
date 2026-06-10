import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  final TextEditingController _promoController = TextEditingController();
  String? _errorMessage;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _applyPromo(CartProvider cartProvider) {
    if (_promoController.text.trim().isEmpty) return;
    bool success = cartProvider.applyPromoCode(_promoController.text);
    setState(() {
      if (success) {
        _errorMessage = null;
        _promoController.clear();
      } else {
        _errorMessage = 'Invalid code. Try TASTE25, FOOD15, or FREEDELIV';
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    final cartProvider = Provider.of<CartProvider>(context);
    final items = cartProvider.items;
    bool isWide = !Responsive.isMobile(context);
    double hPad = Responsive.horizontalPadding(context);
    double fs = Responsive.fontScale(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart', style: TextStyle(fontSize: 20 * fs)),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: items.isEmpty
          ? _buildEmptyCartUI(context, isDark, fs)
          : Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                    maxWidth: Responsive.maxContentWidth(context)),
                child: isWide
                    // ── WIDE: Side-by-side ──
                    ? Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: hPad, vertical: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Left: Cart items list
                            Expanded(
                              flex: 3,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: items.length,
                                itemBuilder: (context, index) =>
                                    CartItemTile(cartItem: items[index]),
                              ),
                            ),
                            const SizedBox(width: 32),
                            // Right: Summary panel (sticky)
                            SizedBox(
                              width: 360,
                              child: SingleChildScrollView(
                                child: _buildSummaryPanel(
                                    context, isDark, fs, cartProvider),
                              ),
                            ),
                          ],
                        ),
                      )
                    // ── MOBILE: Stacked ──
                    : Column(
                        children: [
                          Expanded(
                            child: ListView.builder(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              physics: const BouncingScrollPhysics(),
                              itemCount: items.length,
                              itemBuilder: (context, index) =>
                                  CartItemTile(cartItem: items[index]),
                            ),
                          ),
                          _buildSummaryPanel(
                              context, isDark, fs, cartProvider),
                        ],
                      ),
              ),
            ),
    );
  }

  Widget _buildSummaryPanel(BuildContext context, bool isDark, double fs,
      CartProvider cartProvider) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius: Responsive.isMobile(context)
            ? const BorderRadius.vertical(
                top: Radius.circular(AppTheme.radiusLarge))
            : BorderRadius.circular(AppTheme.radiusLarge),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 15,
            offset: const Offset(0, -4),
          )
        ],
        border: Border.all(
          color: isDark
              ? Colors.white.withValues(alpha: 0.04)
              : Colors.black.withValues(alpha: 0.02),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Promo code section
          if (cartProvider.appliedPromoCode == null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: TextField(
                    controller: _promoController,
                    decoration: InputDecoration(
                      hintText: 'Enter Promo Code',
                      errorText: _errorMessage,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 12),
                      hintStyle: TextStyle(
                          fontSize: 13 * fs,
                          color: isDark
                              ? AppTheme.darkTextSecondary
                              : AppTheme.lightTextSecondary),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => _applyPromo(cartProvider),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 14),
                  ),
                  child: const Text('Apply'),
                ),
              ],
            )
          else
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withValues(alpha: 0.1),
                borderRadius:
                    BorderRadius.circular(AppTheme.radiusMedium),
                border: Border.all(
                    color: AppTheme.secondaryColor.withValues(alpha: 0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.local_offer_rounded,
                          color: AppTheme.secondaryColor, size: 16),
                      const SizedBox(width: 8),
                      Text(
                        '"${cartProvider.appliedPromoCode}" Applied',
                        style: TextStyle(
                            color: AppTheme.secondaryColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 13 * fs),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: cartProvider.removePromoCode,
                    child: const Icon(Icons.cancel_rounded,
                        color: Colors.grey, size: 20),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Bill breakdown
          _row(context, isDark, fs, 'Subtotal',
              '\$${cartProvider.subtotal.toStringAsFixed(2)}'),
          if (cartProvider.discountAmount > 0) ...[
            const SizedBox(height: 8),
            _row(context, isDark, fs, 'Discount',
                '-\$${cartProvider.discountAmount.toStringAsFixed(2)}',
                textColor: AppTheme.secondaryColor),
          ],
          const SizedBox(height: 8),
          _row(
            context, isDark, fs, 'Delivery Fee',
            cartProvider.deliveryFee == 0
                ? 'FREE'
                : '\$${cartProvider.deliveryFee.toStringAsFixed(2)}',
            textColor:
                cartProvider.deliveryFee == 0 ? AppTheme.secondaryColor : null,
          ),
          const SizedBox(height: 8),
          _row(context, isDark, fs, 'Tax (8%)',
              '\$${cartProvider.taxAmount.toStringAsFixed(2)}'),
          const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Divider(height: 1)),
          _row(context, isDark, fs, 'Total',
              '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
              isTotal: true),
          const SizedBox(height: 20),

          // Checkout button
          GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, '/order-success'),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius:
                    BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Center(
                child: Text('Proceed to Checkout',
                    style: Theme.of(context)
                        .textTheme
                        .labelLarge
                        ?.copyWith(fontSize: 16 * fs)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCartUI(
      BuildContext context, bool isDark, double fs) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkCard : Colors.white,
                shape: BoxShape.circle,
                boxShadow: AppTheme.getShadow(context),
              ),
              child: Icon(Icons.shopping_basket_outlined,
                  size: 70,
                  color: AppTheme.primaryColor.withValues(alpha: 0.7)),
            ),
            const SizedBox(height: 24),
            Text('Your Cart is Empty',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 22 * fs, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text(
              'Looks like you haven\'t added anything yet. Let\'s explore!',
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 14 * fs, height: 1.5),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: () => Navigator.pop(context),
              style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 32, vertical: 16)),
              child: const Text('Browse Food Items'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    bool isDark,
    double fs,
    String label,
    String value, {
    Color? textColor,
    bool isTotal = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
              fontSize: isTotal ? 18 * fs : 14 * fs,
              fontWeight:
                  isTotal ? FontWeight.bold : FontWeight.normal,
              color: isTotal
                  ? (isDark
                      ? AppTheme.darkTextPrimary
                      : AppTheme.lightTextPrimary)
                  : (isDark
                      ? AppTheme.darkTextSecondary
                      : AppTheme.lightTextSecondary),
            )),
        Text(value,
            style: TextStyle(
              fontSize: isTotal ? 20 * fs : 14 * fs,
              fontWeight:
                  isTotal ? FontWeight.bold : FontWeight.w600,
              color: textColor ??
                  (isTotal
                      ? AppTheme.primaryColor
                      : (isDark
                          ? AppTheme.darkTextPrimary
                          : AppTheme.lightTextPrimary)),
            )),
      ],
    );
  }
}
