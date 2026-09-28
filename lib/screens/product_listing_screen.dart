import 'package:flutter/material.dart';
import '../models/product.dart';
import '../widgets/category_pills.dart';
import '../widgets/empty_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/product_card.dart';
import '../widgets/product_detail_sheet.dart';

class ProductListingScreen extends StatefulWidget {
  const ProductListingScreen({super.key});

  @override
  State<ProductListingScreen> createState() => _ProductListingScreenState();
}

class _ProductListingScreenState extends State<ProductListingScreen> {
  // Master list of products
  late List<Product> _allProducts;

  // Search & Filter State variables
  String _searchQuery = '';
  String _selectedCategory = 'All';
  SortOption _sortOption = SortOption.featured;
  double _maxPrice = 2500.0;
  static const double _maxPriceLimit = 2500.0;
  bool _inStockOnly = false;
  bool _favoritesOnly = false;

  // Shopping cart items count
  int _cartItemCount = 0;

  // Controller for Search text field
  final TextEditingController _searchController = TextEditingController();

  // Categories list
  final List<String> _categories = [
    'All',
    'Smartphones',
    'Audio',
    'Laptops',
    'Wearables',
    'Gaming',
    'Accessories',
  ];

  @override
  void initState() {
    super.initState();
    _allProducts = Product.getSampleProducts();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  /// Dynamic product computation based on search query, category, price, and filters
  List<Product> get _filteredProducts {
    return _allProducts.where((product) {
      // 1. Category filter
      if (_selectedCategory != 'All' && product.category != _selectedCategory) {
        return false;
      }

      // 2. Search query filter (matches title, brand, category, tags)
      if (_searchQuery.trim().isNotEmpty) {
        final query = _searchQuery.trim().toLowerCase();
        final matchTitle = product.title.toLowerCase().contains(query);
        final matchBrand = product.brand.toLowerCase().contains(query);
        final matchCategory = product.category.toLowerCase().contains(query);
        final matchTag =
            product.tags.any((tag) => tag.toLowerCase().contains(query));

        if (!matchTitle && !matchBrand && !matchCategory && !matchTag) {
          return false;
        }
      }

      // 3. Price filter
      if (product.price > _maxPrice) {
        return false;
      }

      // 4. In-stock filter
      if (_inStockOnly && !product.inStock) {
        return false;
      }

      // 5. Favorites filter
      if (_favoritesOnly && !product.isFavorite) {
        return false;
      }

      return true;
    }).toList()
      ..sort((a, b) {
        switch (_sortOption) {
          case SortOption.priceLowToHigh:
            return a.price.compareTo(b.price);
          case SortOption.priceHighToLow:
            return b.price.compareTo(a.price);
          case SortOption.highestRated:
            return b.rating.compareTo(a.rating);
          case SortOption.mostReviewed:
            return b.reviewCount.compareTo(a.reviewCount);
          case SortOption.featured:
            return 0; // Natural catalog ordering
        }
      });
  }

  /// Computes product counts per category dynamically for badges
  Map<String, int> get _categoryCounts {
    final Map<String, int> counts = {'All': _allProducts.length};
    for (final cat in _categories) {
      if (cat != 'All') {
        counts[cat] =
            _allProducts.where((prod) => prod.category == cat).length;
      }
    }
    return counts;
  }

  /// Whether any non-default filters are actively applied
  bool get _hasActiveFilters {
    return _searchQuery.isNotEmpty ||
        _selectedCategory != 'All' ||
        _sortOption != SortOption.featured ||
        _maxPrice < _maxPriceLimit ||
        _inStockOnly ||
        _favoritesOnly;
  }

  /// Resets all filters back to default values using setState
  void _resetAllFilters() {
    setState(() {
      _searchQuery = '';
      _selectedCategory = 'All';
      _sortOption = SortOption.featured;
      _maxPrice = _maxPriceLimit;
      _inStockOnly = false;
      _favoritesOnly = false;
      _searchController.clear();
    });
  }

  /// Toggles favorite status of a product using setState
  void _toggleFavorite(String productId) {
    setState(() {
      final index = _allProducts.indexWhere((p) => p.id == productId);
      if (index != -1) {
        final current = _allProducts[index];
        _allProducts[index] = current.copyWith(isFavorite: !current.isFavorite);
      }
    });

    final updated = _allProducts.firstWhere((p) => p.id == productId);
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          updated.isFavorite
              ? 'Saved "${updated.title}" to Wishlist'
              : 'Removed from Wishlist',
        ),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Adds a product to cart with animated SnackBar and badge update
  void _addToCart(Product product) {
    setState(() {
      _cartItemCount++;
    });

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF1E293B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded,
                color: Color(0xFF10B981), size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Added ${product.title} to cart!',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Colors.white, fontSize: 13),
              ),
            ),
          ],
        ),
        action: SnackBarAction(
          label: 'View Cart',
          textColor: const Color(0xFF818CF8),
          onPressed: () {
            // Cart action feedback
          },
        ),
      ),
    );
  }

  /// Opens product detail bottom modal sheet
  void _showProductDetails(Product product) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ProductDetailSheet(
        product: product,
        onToggleFavorite: () => _toggleFavorite(product.id),
        onAddToCart: () => _addToCart(product),
      ),
    );
  }

  /// Opens filter bottom sheet dialog
  void _openFilterDialog() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => FilterBottomSheet(
        currentSort: _sortOption,
        currentMaxPrice: _maxPrice,
        maxPriceLimit: _maxPriceLimit,
        inStockOnly: _inStockOnly,
        favoritesOnly: _favoritesOnly,
        onApply: ({
          required SortOption sort,
          required double maxPrice,
          required bool inStockOnly,
          required bool favoritesOnly,
        }) {
          // Updates filter state dynamically with setState
          setState(() {
            _sortOption = sort;
            _maxPrice = maxPrice;
            _inStockOnly = inStockOnly;
            _favoritesOnly = favoritesOnly;
          });
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredProducts;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? const Color(0xFF0B0F19) : const Color(0xFFF8FAFC),
      appBar: AppBar(
        elevation: 0,
        backgroundColor:
            isDark ? const Color(0xFF0F172A) : Colors.white,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(Icons.flash_on_rounded,
                  color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'TechPulse Store',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                Text(
                  'Explore Premium Gear',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    color: isDark ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          // Wishlist filter shortcut button
          IconButton(
            tooltip: 'Toggle Saved Items',
            icon: Icon(
              _favoritesOnly
                  ? Icons.favorite_rounded
                  : Icons.favorite_border_rounded,
              color: _favoritesOnly
                  ? const Color(0xFFF43F5E)
                  : (isDark ? Colors.white70 : Colors.black87),
            ),
            onPressed: () {
              setState(() {
                _favoritesOnly = !_favoritesOnly;
              });
            },
          ),
          // Shopping Cart with badge
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Stack(
              alignment: Alignment.center,
              children: [
                IconButton(
                  tooltip: 'Cart',
                  icon: const Icon(Icons.shopping_bag_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Cart contains $_cartItemCount item(s)'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                if (_cartItemCount > 0)
                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEF4444),
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 18,
                        minHeight: 18,
                      ),
                      child: Text(
                        '$_cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Top Search & Filter Bar Container
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              child: Row(
                children: [
                  // Search Input with live setState updates
                  Expanded(
                    child: Container(
                      height: 46,
                      decoration: BoxDecoration(
                        color: isDark
                            ? const Color(0xFF1E293B)
                            : const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          // Real-time search query filtering with setState
                          setState(() {
                            _searchQuery = value;
                          });
                        },
                        style: const TextStyle(fontSize: 14),
                        decoration: InputDecoration(
                          hintText: 'Search products, brands, tags...',
                          hintStyle: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade500,
                          ),
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: Colors.grey.shade500,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () {
                                    _searchController.clear();
                                    setState(() {
                                      _searchQuery = '';
                                    });
                                  },
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding:
                              const EdgeInsets.symmetric(vertical: 12),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Filter dialog button with active badge indicator
                  Stack(
                    children: [
                      Container(
                        height: 46,
                        width: 46,
                        decoration: BoxDecoration(
                          color: (_sortOption != SortOption.featured ||
                                  _maxPrice < _maxPriceLimit ||
                                  _inStockOnly)
                              ? const Color(0xFF6366F1)
                              : (isDark
                                  ? const Color(0xFF1E293B)
                                  : const Color(0xFFF1F5F9)),
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: IconButton(
                          icon: Icon(
                            Icons.tune_rounded,
                            size: 20,
                            color: (_sortOption != SortOption.featured ||
                                    _maxPrice < _maxPriceLimit ||
                                    _inStockOnly)
                                ? Colors.white
                                : (isDark ? Colors.white70 : Colors.black87),
                          ),
                          onPressed: _openFilterDialog,
                        ),
                      ),
                      if (_sortOption != SortOption.featured ||
                          _maxPrice < _maxPriceLimit ||
                          _inStockOnly)
                        Positioned(
                          top: 4,
                          right: 4,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Color(0xFF10B981),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),

            // Horizontal Categories Selector Pills
            Container(
              padding: const EdgeInsets.only(bottom: 10),
              color: isDark ? const Color(0xFF0F172A) : Colors.white,
              child: CategoryPills(
                categories: _categories,
                selectedCategory: _selectedCategory,
                categoryCounts: _categoryCounts,
                onSelectCategory: (category) {
                  // Updates category selection dynamically with setState
                  setState(() {
                    _selectedCategory = category;
                  });
                },
              ),
            ),

            // Active Filters Summary Bar
            if (_hasActiveFilters)
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                color: isDark
                    ? const Color(0xFF1E293B).withValues(alpha: 0.5)
                    : const Color(0xFFEEF2F6),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      Text(
                        'Active Filters: ',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: isDark ? Colors.grey[400] : Colors.grey[600],
                        ),
                      ),
                      if (_selectedCategory != 'All')
                        _buildFilterChip(
                          'Category: $_selectedCategory',
                          () => setState(() => _selectedCategory = 'All'),
                        ),
                      if (_searchQuery.isNotEmpty)
                        _buildFilterChip(
                          'Search: "$_searchQuery"',
                          () {
                            _searchController.clear();
                            setState(() => _searchQuery = '');
                          },
                        ),
                      if (_sortOption != SortOption.featured)
                        _buildFilterChip(
                          'Sort: ${_sortOption.label}',
                          () => setState(() => _sortOption = SortOption.featured),
                        ),
                      if (_maxPrice < _maxPriceLimit)
                        _buildFilterChip(
                          'Max: \$${_maxPrice.toInt()}',
                          () => setState(() => _maxPrice = _maxPriceLimit),
                        ),
                      if (_inStockOnly)
                        _buildFilterChip(
                          'In Stock Only',
                          () => setState(() => _inStockOnly = false),
                        ),
                      if (_favoritesOnly)
                        _buildFilterChip(
                          'Wishlist Only',
                          () => setState(() => _favoritesOnly = false),
                        ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: _resetAllFilters,
                        borderRadius: BorderRadius.circular(6),
                        child: const Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                          child: Text(
                            'Clear All',
                            style: TextStyle(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF6366F1),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

            // Items Count and Results Header
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Showing ${filtered.length} of ${_allProducts.length} items',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                  if (_sortOption != SortOption.featured)
                    Text(
                      _sortOption.label,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6366F1),
                      ),
                    ),
                ],
              ),
            ),

            // Dynamic Product List using ListView.builder
            Expanded(
              child: filtered.isEmpty
                  ? EmptyState(
                      searchQuery: _searchQuery,
                      onResetFilters: _resetAllFilters,
                    )
                  : RefreshIndicator(
                      color: const Color(0xFF6366F1),
                      onRefresh: () async {
                        // Simulates asynchronous reload
                        await Future.delayed(const Duration(milliseconds: 600));
                        setState(() {});
                      },
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics(),
                        ),
                        padding: const EdgeInsets.only(top: 4, bottom: 24),
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final product = filtered[index];
                          return ProductCard(
                            key: ValueKey(product.id),
                            product: product,
                            onTap: () => _showProductDetails(product),
                            onToggleFavorite: () =>
                                _toggleFavorite(product.id),
                            onAddToCart: () => _addToCart(product),
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Compact chip for active filter list with tap to remove
  Widget _buildFilterChip(String label, VoidCallback onRemove) {
    return Container(
      margin: const EdgeInsets.only(right: 6),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFF6366F1).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: const Color(0xFF6366F1).withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: Color(0xFF6366F1),
            ),
          ),
          const SizedBox(width: 4),
          InkWell(
            onTap: onRemove,
            child: const Icon(
              Icons.close_rounded,
              size: 13,
              color: Color(0xFF6366F1),
            ),
          ),
        ],
      ),
    );
  }
}
