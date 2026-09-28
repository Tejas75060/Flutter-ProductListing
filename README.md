# 🛍️ TechPulse Store — Modern Flutter Product Catalog & Listing App

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
[![Material Design 3](https://img.shields.io/badge/Material%20Design-3-795548?style=for-the-badge&logo=materialdesign&logoColor=white)](https://m3.material.io/)
[![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS%20%7C%20Web%20%7C%20macOS%20%7C%20Windows-blue?style=for-the-badge)](https://flutter.dev/multi-platform)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg?style=for-the-badge)](https://opensource.org/licenses/MIT)

**TechPulse Store** is a modern, responsive, and visually refined e-commerce product catalog application built with **Flutter** and **Material 3**. Designed with clean architecture and modern UX patterns, it features live multi-attribute search, category chip navigation, dynamic filtering and sorting, interactive bottom sheets for product details, cart counter updates, and full Light & Dark mode support.

---

## ✨ Features

- **🔍 Real-Time Intelligent Search**:
  - Live filtering across product titles, brand names, categories, and keywords/tags.
  - Instant query clear button and active search feedback.

- **🏷️ Interactive Category Pills**:
  - Horizontal scrollable filter pills (`All`, `Smartphones`, `Audio`, `Laptops`, `Wearables`, `Gaming`, `Accessories`).
  - Active category highlight with smooth transition.

- **⚙️ Multi-Faceted Filter & Sort Modal**:
  - **Sort By**: *Featured*, *Price: Low to High*, *Price: High to Low*, *Highest Rated*, and *Most Reviewed*.
  - **Price Range Slider**: Interactive range control with dynamic maximum limit filtering.
  - **Availability Toggles**: Filter by in-stock items only or view your saved favorites.
  - Active filter badges with one-tap reset.

- **💳 Rich Product Cards**:
  - High-resolution cached product imagery with graceful loading indicators.
  - Brand badges, star ratings, and review count indicators.
  - Original price strikethrough with automatic percentage discount badges.
  - Instant heart button to toggle wishlist/favorites.
  - Quick "Add to Cart" action with visual confirmation.

- **📱 Interactive Product Detail Bottom Sheet**:
  - Draggable, expandable modal sheet (`DraggableScrollableSheet`).
  - Full product description, specifications table, and categorized tags.
  - Direct Add-to-Cart and Favorite toggling within the sheet.

- **🛒 Integrated Shopping Cart Counter**:
  - Reactive badge in the top navigation app bar reflecting total items added.
  - Floating Snackbars with action feedback upon adding items to the cart.

- **🌓 Material 3 & Dual Theme**:
  - Bespoke **Light Theme** (clean slate and indigo accents) and **Dark Theme** (deep midnight `#0B0F19` and `#1E293B` containers).
  - Adapts automatically to the system theme mode.

- **📱 Cross-Platform Ready**:
  - Runs natively on Android, iOS, Web, macOS, Linux, and Windows.

---

## 📸 Application Structure

```
lib/
├── main.dart                          # Application entry point & theme configuration
├── models/
│   └── product.dart                   # Product data model, specifications, & sample dataset
├── screens/
│   └── product_listing_screen.dart    # Main catalog screen with search, filters & state
└── widgets/
    ├── category_pills.dart            # Horizontal category selection chips
    ├── empty_state.dart               # Visual fallback state when no products match filters
    ├── filter_bottom_sheet.dart       # Modal sheet for price range, stock, favorites & sorting
    ├── product_card.dart              # Card view displaying item information & actions
    └── product_detail_sheet.dart      # Expandable bottom sheet with specs & full details
```

---

## 🛠️ Tech Stack & Dependencies

- **Language**: [Dart](https://dart.dev) (v3.13+)
- **Framework**: [Flutter](https://flutter.dev) (Material 3 enabled)
- **Icons**: `cupertino_icons: ^1.0.8`
- **Formatting**: `intl: ^0.20.3` (currency formatting & internationalization)
- **Linter**: `flutter_lints: ^6.0.0`

---

## 🚀 Getting Started

### Prerequisites

Ensure you have Flutter installed on your system:
```bash
flutter --version
```
If not installed, follow the [official Flutter installation guide](https://docs.flutter.dev/get-started/install).

### Installation

1. **Clone the repository**:
   ```bash
   git clone https://github.com/Tejas75060/Flutter-ProductListing.git
   cd Flutter-ProductListing
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Verify the code**:
   ```bash
   flutter analyze
   ```

4. **Run the app**:
   - On Chrome / Web:
     ```bash
     flutter run -d chrome
     ```
   - On macOS Desktop:
     ```bash
     flutter run -d macos
     ```
   - On an Android Emulator / iOS Simulator:
     ```bash
     flutter run
     ```

---

## 📄 License

This project is licensed under the [MIT License](LICENSE).

