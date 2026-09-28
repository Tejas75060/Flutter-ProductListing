import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:product_listing/main.dart';
import 'package:product_listing/models/product.dart';
import 'package:product_listing/widgets/empty_state.dart';
import 'package:product_listing/widgets/product_card.dart';

void main() {
  group('Product Model Unit Tests', () {
    test('Product model calculates discount percentage accurately', () {
      const productWithDiscount = Product(
        id: 'test-1',
        title: 'Discounted Gadget',
        brand: 'TechCo',
        category: 'Audio',
        price: 80.0,
        originalPrice: 100.0,
        rating: 4.5,
        reviewCount: 100,
        imageUrl: '',
        description: 'Test description',
      );

      expect(productWithDiscount.discountPercent, 20);

      const productNoDiscount = Product(
        id: 'test-2',
        title: 'Regular Gadget',
        brand: 'TechCo',
        category: 'Audio',
        price: 100.0,
        rating: 4.5,
        reviewCount: 100,
        imageUrl: '',
        description: 'Test description',
      );

      expect(productNoDiscount.discountPercent, 0);
    });

    test('Product copyWith updates fields correctly', () {
      const original = Product(
        id: 'test-1',
        title: 'Original Title',
        brand: 'Original Brand',
        category: 'Audio',
        price: 150.0,
        rating: 4.0,
        reviewCount: 50,
        imageUrl: '',
        description: 'Original Desc',
        isFavorite: false,
      );

      final updated = original.copyWith(isFavorite: true, price: 120.0);

      expect(updated.isFavorite, true);
      expect(updated.price, 120.0);
      expect(updated.title, original.title);
      expect(updated.id, original.id);
    });

    test('getSampleProducts returns diverse catalog items', () {
      final samples = Product.getSampleProducts();
      expect(samples.isNotEmpty, true);
      expect(samples.length, greaterThanOrEqualTo(10));
    });
  });

  group('ProductListing Widget Tests', () {
    testWidgets('App renders ProductListingScreen and ListView.builder items',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProductCatalogApp());
      await tester.pumpAndSettle();

      // Check App Title
      expect(find.text('TechPulse Store'), findsOneWidget);
      expect(find.text('Explore Premium Gear'), findsOneWidget);

      // Verify ListView is present
      expect(find.byType(ListView), findsWidgets);

      // Verify ProductCard items are rendered
      expect(find.byType(ProductCard), findsWidgets);
    });

    testWidgets('Search query filters items dynamically via setState',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProductCatalogApp());
      await tester.pumpAndSettle();

      // Search for specific brand "Sony"
      final searchField = find.byType(TextField);
      expect(searchField, findsOneWidget);

      await tester.enterText(searchField, 'Sony');
      await tester.pumpAndSettle();

      // Should show items matching "Sony"
      expect(find.textContaining('Sony'), findsWidgets);

      // Active filter chip for search query should appear
      expect(find.text('Search: "Sony"'), findsOneWidget);

      // Clear search via clear button
      final clearButton = find.byIcon(Icons.clear_rounded);
      expect(clearButton, findsOneWidget);
      await tester.tap(clearButton);
      await tester.pumpAndSettle();

      // Filter chip should be dismissed
      expect(find.text('Search: "Sony"'), findsNothing);
    });

    testWidgets('Category pill filter updates list via setState',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProductCatalogApp());
      await tester.pumpAndSettle();

      // Tap on 'Audio' category
      final audioPill = find.widgetWithText(InkWell, 'Audio');
      expect(audioPill, findsOneWidget);

      await tester.tap(audioPill);
      await tester.pumpAndSettle();

      // Active filter chip should appear
      expect(find.text('Category: Audio'), findsOneWidget);

      // Tap 'All' category to reset
      final allPill = find.widgetWithText(InkWell, 'All');
      await tester.tap(allPill);
      await tester.pumpAndSettle();

      expect(find.text('Category: Audio'), findsNothing);
    });

    testWidgets('EmptyState displays on non-matching query and resets filters',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProductCatalogApp());
      await tester.pumpAndSettle();

      // Search for nonexistent term
      final searchField = find.byType(TextField);
      await tester.enterText(searchField, 'xyzNonExistentProductQuery12345');
      await tester.pumpAndSettle();

      // Expect EmptyState widget
      expect(find.byType(EmptyState), findsOneWidget);
      expect(find.text('No Products Found'), findsOneWidget);

      // Tap Reset All Filters
      final resetButton = find.widgetWithText(ElevatedButton, 'Reset All Filters');
      expect(resetButton, findsOneWidget);
      await tester.tap(resetButton);
      await tester.pumpAndSettle();

      // Products restored
      expect(find.byType(ProductCard), findsWidgets);
    });

    testWidgets('Toggling favorite button updates state and displays snackbar',
        (WidgetTester tester) async {
      await tester.pumpWidget(const ProductCatalogApp());
      await tester.pumpAndSettle();

      // Find first favorite button
      final favoriteButtons = find.byIcon(Icons.favorite_border_rounded);
      expect(favoriteButtons, findsWidgets);

      await tester.tap(favoriteButtons.first);
      await tester.pumpAndSettle();

      // SnackBar should be triggered
      expect(find.byType(SnackBar), findsOneWidget);
    });
  });
}
