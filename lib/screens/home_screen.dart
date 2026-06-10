import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/mock_data.dart';
import '../models/food_item.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../utils/responsive.dart';
import '../widgets/category_selector.dart';
import '../widgets/food_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  List<FoodItem> get _filteredItems {
    return mockFoodItems.where((item) {
      final matchesCategory =
          _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch =
          item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              item.description
                  .toLowerCase()
                  .contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool isDark = Theme.of(context).brightness == Brightness.dark;
    double hPad = Responsive.horizontalPadding(context);
    double fs = Responsive.fontScale(context);
    int cols = Responsive.gridColumns(context);

    // Adjust card aspect ratio for more columns
    double cardAspect = cols >= 3 ? 0.75 : 0.72;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints:
                BoxConstraints(maxWidth: Responsive.maxContentWidth(context)),
            child: CustomScrollView(
              physics: const BouncingScrollPhysics(),
              slivers: [
                // ── Top Bar ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.fromLTRB(hPad, 16, hPad, 8),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Location
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.location_on_rounded,
                                    color: AppTheme.primaryColor, size: 18),
                                const SizedBox(width: 4),
                                Text(
                                  'Colombo, Sri Lanka',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15 * fs,
                                      ),
                                ),
                                const Icon(Icons.keyboard_arrow_down_rounded,
                                    color: AppTheme.primaryColor, size: 18),
                              ],
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Find premium gourmet foods',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(fontSize: 12 * fs),
                            ),
                          ],
                        ),

                        // Cart badge
                        Consumer<CartProvider>(
                          builder: (context, cartProvider, child) {
                            return GestureDetector(
                              onTap: () =>
                                  Navigator.pushNamed(context, '/cart'),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? AppTheme.darkCard
                                          : Colors.white,
                                      shape: BoxShape.circle,
                                      boxShadow:
                                          AppTheme.getShadow(context),
                                      border: Border.all(
                                        color: isDark
                                            ? Colors.white10
                                            : Colors.black
                                                .withValues(alpha: 0.04),
                                        width: 1,
                                      ),
                                    ),
                                    child: Icon(
                                      Icons.shopping_bag_outlined,
                                      color: isDark
                                          ? AppTheme.darkTextPrimary
                                          : AppTheme.lightTextPrimary,
                                      size: 22,
                                    ),
                                  ),
                                  if (cartProvider.itemCount > 0)
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: Container(
                                        padding: const EdgeInsets.all(6),
                                        decoration: const BoxDecoration(
                                          color: AppTheme.primaryColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          cartProvider.itemCount.toString(),
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Headline + Search ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'What would you\nlike to order?',
                          style: Theme.of(context)
                              .textTheme
                              .displayLarge
                              ?.copyWith(
                                fontSize: 28 * fs,
                                fontWeight: FontWeight.w900,
                                height: 1.2,
                              ),
                        ),
                        const SizedBox(height: 16),
                        TextField(
                          controller: _searchController,
                          onChanged: (v) =>
                              setState(() => _searchQuery = v),
                          decoration: InputDecoration(
                            hintText: 'Search pizza, burgers, sushi...',
                            prefixIcon: const Icon(Icons.search_rounded,
                                color: AppTheme.primaryColor),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? GestureDetector(
                                    onTap: () {
                                      _searchController.clear();
                                      setState(() => _searchQuery = '');
                                    },
                                    child: const Icon(Icons.clear_rounded,
                                        color: Colors.grey),
                                  )
                                : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Promo Banner ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: hPad, vertical: 8),
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFF2E3A59), Color(0xFF161F33)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius:
                            BorderRadius.circular(AppTheme.radiusLarge),
                        boxShadow: AppTheme.getShadow(context),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: AppTheme.primaryColor
                                        .withValues(alpha: 0.2),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    'PROMO CODE',
                                    style: TextStyle(
                                      color: AppTheme.primaryColor,
                                      fontSize: 9 * fs,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  'Get 25% discount on checkout!',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15 * fs,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Use coupon code TASTE25',
                                  style: TextStyle(
                                    color: Colors.white60,
                                    fontSize: 12 * fs,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Container(
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color:
                                  Colors.white.withValues(alpha: 0.08),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.local_offer_rounded,
                                color: AppTheme.accentColor, size: 40),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Categories ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: hPad, vertical: 4),
                          child: Text(
                            'Categories',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18 * fs,
                                ),
                          ),
                        ),
                        CategorySelector(
                          selectedCategory: _selectedCategory,
                          onCategoryChanged: (cat) =>
                              setState(() => _selectedCategory = cat),
                        ),
                      ],
                    ),
                  ),
                ),

                // ── Section Title ──
                SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.fromLTRB(hPad, 4, hPad, 12),
                    child: Text(
                      _selectedCategory == 'All'
                          ? 'All Items'
                          : _selectedCategory,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge
                          ?.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 18 * fs,
                          ),
                    ),
                  ),
                ),

                // ── Grid ──
                _filteredItems.isEmpty
                    ? SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(40.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.search_off_rounded,
                                  size: 60,
                                  color:
                                      Colors.grey.withValues(alpha: 0.6)),
                              const SizedBox(height: 16),
                              const Text(
                                'No items match your criteria',
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                'Try looking for something else.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      )
                    : SliverPadding(
                        padding: EdgeInsets.symmetric(horizontal: hPad),
                        sliver: SliverGrid(
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: cols,
                            childAspectRatio: cardAspect,
                            crossAxisSpacing: 16,
                            mainAxisSpacing: 16,
                          ),
                          delegate: SliverChildBuilderDelegate(
                            (context, index) =>
                                FoodCard(foodItem: _filteredItems[index]),
                            childCount: _filteredItems.length,
                          ),
                        ),
                      ),

                const SliverToBoxAdapter(child: SizedBox(height: 40)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
