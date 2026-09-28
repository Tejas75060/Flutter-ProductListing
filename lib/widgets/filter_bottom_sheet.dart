import 'package:flutter/material.dart';

enum SortOption {
  featured('Featured'),
  priceLowToHigh('Price: Low to High'),
  priceHighToLow('Price: High to Low'),
  highestRated('Highest Rated'),
  mostReviewed('Most Reviewed');

  final String label;
  const SortOption(this.label);
}

class FilterBottomSheet extends StatefulWidget {
  final SortOption currentSort;
  final double currentMaxPrice;
  final double maxPriceLimit;
  final bool inStockOnly;
  final bool favoritesOnly;
  final Function({
    required SortOption sort,
    required double maxPrice,
    required bool inStockOnly,
    required bool favoritesOnly,
  }) onApply;

  const FilterBottomSheet({
    super.key,
    required this.currentSort,
    required this.currentMaxPrice,
    required this.maxPriceLimit,
    required this.inStockOnly,
    required this.favoritesOnly,
    required this.onApply,
  });

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  late SortOption _selectedSort;
  late double _maxPrice;
  late bool _inStockOnly;
  late bool _favoritesOnly;

  @override
  void initState() {
    super.initState();
    _selectedSort = widget.currentSort;
    _maxPrice = widget.currentMaxPrice;
    _inStockOnly = widget.inStockOnly;
    _favoritesOnly = widget.favoritesOnly;
  }

  void _reset() {
    setState(() {
      _selectedSort = SortOption.featured;
      _maxPrice = widget.maxPriceLimit;
      _inStockOnly = false;
      _favoritesOnly = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
          const SizedBox(height: 16),

          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Filters & Sorting',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
              TextButton(
                onPressed: _reset,
                child: const Text(
                  'Reset All',
                  style: TextStyle(
                    color: Color(0xFF6366F1),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const Divider(),
          const SizedBox(height: 12),

          // Sort Options
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SortOption.values.map((option) {
              final isSelected = _selectedSort == option;
              return ChoiceChip(
                label: Text(option.label),
                selected: isSelected,
                selectedColor: const Color(0xFF6366F1),
                labelStyle: TextStyle(
                  color: isSelected ? Colors.white : null,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  fontSize: 12,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                onSelected: (selected) {
                  if (selected) {
                    setState(() {
                      _selectedSort = option;
                    });
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 18),

          // Price range slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Max Price',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
              ),
              Text(
                '\$${_maxPrice.toInt()}',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF6366F1),
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF6366F1),
              thumbColor: const Color(0xFF6366F1),
              inactiveTrackColor: const Color(0xFF6366F1).withValues(alpha: 0.2),
              overlayColor: const Color(0xFF6366F1).withValues(alpha: 0.15),
            ),
            child: Slider(
              value: _maxPrice,
              min: 50,
              max: widget.maxPriceLimit,
              divisions: 49,
              label: '\$${_maxPrice.toInt()}',
              onChanged: (val) {
                setState(() {
                  _maxPrice = val;
                });
              },
            ),
          ),
          const SizedBox(height: 10),

          // In-Stock Only Switch
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            activeTrackColor: const Color(0xFF6366F1),
            title: const Text(
              'In Stock Only',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Hide out-of-stock items',
              style: TextStyle(fontSize: 12),
            ),
            value: _inStockOnly,
            onChanged: (val) {
              setState(() {
                _inStockOnly = val;
              });
            },
          ),

          // Favorites Only Switch
          SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            activeTrackColor: const Color(0xFF6366F1),
            title: const Text(
              'Saved / Favorites Only',
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            ),
            subtitle: const Text(
              'Show only your bookmarked items',
              style: TextStyle(fontSize: 12),
            ),
            value: _favoritesOnly,
            onChanged: (val) {
              setState(() {
                _favoritesOnly = val;
              });
            },
          ),
          const SizedBox(height: 20),

          // Action buttons
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6366F1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              onPressed: () {
                widget.onApply(
                  sort: _selectedSort,
                  maxPrice: _maxPrice,
                  inStockOnly: _inStockOnly,
                  favoritesOnly: _favoritesOnly,
                );
                Navigator.of(context).pop();
              },
              child: const Text(
                'Apply Filters',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
