import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';

class FoodDetailsScreen extends StatefulWidget {
  final FoodItem foodItem;

  const FoodDetailsScreen({super.key, required this.foodItem});

  @override
  State<FoodDetailsScreen> createState() => _FoodDetailsScreenState();
}

class _FoodDetailsScreenState extends State<FoodDetailsScreen> {
  late String _selectedSize;
  final List<String> _selectedExtras = [];
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    _selectedSize = widget.foodItem.sizes.isNotEmpty
        ? widget.foodItem.sizes[0]
        : 'Medium';
  }

  double get _currentBasePrice {
    double base = widget.foodItem.price;
    int sizeIndex = widget.foodItem.sizes.indexOf(_selectedSize);
    if (sizeIndex == 1) return base + 2.00;
    if (sizeIndex == 2) return base + 4.00;
    return base;
  }

  double get _totalPrice {
    double extrasCost = _selectedExtras.length * 1.50;
    return (_currentBasePrice + extrasCost) * _quantity;
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    bool isWide = !Responsive.isMobile(context);
    double fs = Responsive.fontScale(context);
    double hPad = Responsive.horizontalPadding(context);

    return Scaffold(
      body: isWide ? _buildWideLayout(context, isDark, fs, hPad) : _buildMobileLayout(context, isDark, fs),
    );
  }

  // ── WIDE (Tablet / Desktop): Two-column layout ──
  Widget _buildWideLayout(BuildContext context, bool isDark, double fs, double hPad) {
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
          child: Column(
            children: [
              // Top Bar
              Padding(
                padding: EdgeInsets.symmetric(horizontal: hPad, vertical: 16),
                child: Row(
                  children: [
                    _backButton(context, isDark),
                    const Spacer(),
                    _favoriteButton(context, isDark),
                  ],
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: hPad),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left: Food image
                      Expanded(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(AppTheme.radiusLarge),
                          child: Hero(
                            tag: 'food-img-${widget.foodItem.id}',
                            child: Image.network(
                              widget.foodItem.imageUrl,
                              fit: BoxFit.cover,
                              height: double.infinity,
                              errorBuilder: (_, __, ___) => _imageFallback(isDark),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 40),
                      // Right: Details + Actions
                      Expanded(
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildDetailsContent(context, isDark, fs),
                              const SizedBox(height: 24),
                              _buildBottomActions(context, isDark, fs, inline: true),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ── MOBILE: Stacked layout with sticky bottom ──
  Widget _buildMobileLayout(BuildContext context, bool isDark, double fs) {
    return Stack(
      children: [
        CustomScrollView(
          physics: const BouncingScrollPhysics(),
          slivers: [
            SliverAppBar(
              expandedHeight: 300,
              pinned: true,
              stretch: true,
              backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
              automaticallyImplyLeading: false,
              leading: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Center(child: _backButton(context, isDark)),
              ),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: _favoriteButton(context, isDark),
                ),
              ],
              flexibleSpace: FlexibleSpaceBar(
                stretchModes: const [StretchMode.zoomBackground],
                background: Hero(
                  tag: 'food-img-${widget.foodItem.id}',
                  child: Image.network(
                    widget.foodItem.imageUrl,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => _imageFallback(isDark),
                  ),
                ),
              ),
            ),
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildDetailsContent(context, isDark, fs),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ],
        ),
        // Sticky bottom panel
        Positioned(
          bottom: 0, left: 0, right: 0,
          child: _buildBottomActions(context, isDark, fs, inline: false),
        ),
      ],
    );
  }

  Widget _backButton(BuildContext context, bool isDark) {
    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.85),
          shape: BoxShape.circle,
        ),
        child: Icon(Icons.arrow_back_ios_new_rounded,
            color: isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary, size: 18),
      ),
    );
  }

  Widget _favoriteButton(BuildContext context, bool isDark) {
    return Consumer<CartProvider>(
      builder: (context, cartProvider, _) {
        bool isFav = cartProvider.isFavorite(widget.foodItem.id);
        return GestureDetector(
          onTap: () => cartProvider.toggleFavorite(widget.foodItem.id),
          child: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: (isDark ? Colors.black : Colors.white).withValues(alpha: 0.85),
              shape: BoxShape.circle,
            ),
            child: Icon(
              isFav ? Icons.favorite_rounded : Icons.favorite_border_rounded,
              color: isFav ? AppTheme.primaryColor : Colors.grey,
              size: 18,
            ),
          ),
        );
      },
    );
  }

  Widget _imageFallback(bool isDark) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [const Color(0xFF2C3E50), const Color(0xFF000000)]
              : [const Color(0xFFFFE8E0), const Color(0xFFFFFAF8)],
        ),
      ),
      child: const Center(
          child: Icon(Icons.fastfood_rounded, size: 80, color: AppTheme.primaryColor)),
    );
  }

  Widget _buildDetailsContent(BuildContext context, bool isDark, double fs) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Prep time + rating row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: AppTheme.secondaryColor.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  const Icon(Icons.flash_on_rounded, color: AppTheme.secondaryColor, size: 14),
                  const SizedBox(width: 4),
                  Text(widget.foodItem.prepTime,
                      style: TextStyle(
                          color: AppTheme.secondaryColor,
                          fontSize: 12 * fs,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.star_rounded, color: AppTheme.accentColor, size: 20),
                const SizedBox(width: 4),
                Text('${widget.foodItem.rating} Rating',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14 * fs)),
              ],
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Title
        Text(widget.foodItem.name,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                fontSize: 24 * fs, fontWeight: FontWeight.bold)),
        const SizedBox(height: 12),

        // Description
        Text(widget.foodItem.description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14 * fs, height: 1.6)),
        const SizedBox(height: 24),

        // Size selector
        Text('Select Size',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 16 * fs)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 12,
          runSpacing: 8,
          children: widget.foodItem.sizes.map((size) {
            bool isSelected = size == _selectedSize;
            return GestureDetector(
              onTap: () => setState(() => _selectedSize = size),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppTheme.primaryColor
                      : (isDark ? AppTheme.darkCard : Colors.white),
                  borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                  border: Border.all(
                    color: isSelected
                        ? AppTheme.primaryColor
                        : (isDark
                            ? Colors.white10
                            : Colors.black.withValues(alpha: 0.06)),
                  ),
                ),
                child: Text(size,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : (isDark ? AppTheme.darkTextPrimary : AppTheme.lightTextPrimary),
                      fontWeight: FontWeight.bold,
                      fontSize: 14 * fs,
                    )),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 24),

        // Extras
        Text('Add Extra Ingredients (+\$1.50 each)',
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontSize: 16 * fs)),
        const SizedBox(height: 8),
        ...widget.foodItem.extras.map((extra) {
          bool isAdded = _selectedExtras.contains(extra);
          return Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: CheckboxListTile(
              title: Text(extra, style: TextStyle(fontSize: 14 * fs)),
              value: isAdded,
              activeColor: AppTheme.primaryColor,
              checkColor: Colors.white,
              dense: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppTheme.radiusSmall)),
              tileColor: isDark ? AppTheme.darkCard : Colors.white,
              onChanged: (val) => setState(() {
                if (val == true) {
                  _selectedExtras.add(extra);
                } else {
                  _selectedExtras.remove(extra);
                }
              }),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, bool isDark, double fs, {required bool inline}) {
    final content = Row(
      children: [
        // Quantity
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.grey[100],
            borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
          ),
          child: Row(
            children: [
              GestureDetector(
                onTap: () { if (_quantity > 1) setState(() => _quantity--); },
                child: const Icon(Icons.remove, size: 18),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(_quantity.toString(),
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16 * fs)),
              ),
              GestureDetector(
                onTap: () => setState(() => _quantity++),
                child: const Icon(Icons.add, size: 18),
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
        // Add to cart button
        Expanded(
          child: GestureDetector(
            onTap: () {
              Provider.of<CartProvider>(context, listen: false).addToCart(
                foodItem: widget.foodItem,
                size: _selectedSize,
                extras: _selectedExtras,
                basePrice: _currentBasePrice,
                quantity: _quantity,
              );
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppTheme.secondaryColor),
                      const SizedBox(width: 10),
                      Expanded(child: Text('${widget.foodItem.name} added to cart!')),
                    ],
                  ),
                  behavior: SnackBarBehavior.floating,
                  duration: const Duration(seconds: 3),
                  action: SnackBarAction(
                    textColor: AppTheme.primaryColor,
                    label: 'View Cart',
                    onPressed: () => Navigator.pushNamed(context, '/cart'),
                  ),
                ),
              );
              Navigator.pop(context);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                gradient: AppTheme.primaryGradient,
                borderRadius: BorderRadius.circular(AppTheme.radiusMedium),
                boxShadow: [
                  BoxShadow(
                    color: AppTheme.primaryColor.withValues(alpha: 0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 5),
                  )
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Add to Cart',
                      style: Theme.of(context)
                          .textTheme
                          .labelLarge
                          ?.copyWith(fontSize: 16 * fs)),
                  const SizedBox(width: 10),
                  Text('|  \$${_totalPrice.toStringAsFixed(2)}',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16 * fs)),
                ],
              ),
            ),
          ),
        ),
      ],
    );

    if (inline) return content;

    // Sticky bottom for mobile
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkCard : Colors.white,
        borderRadius:
            const BorderRadius.vertical(top: Radius.circular(AppTheme.radiusLarge)),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.1),
              blurRadius: 20,
              offset: const Offset(0, -5))
        ],
      ),
      child: content,
    );
  }
}
