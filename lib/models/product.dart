class Product {
  final String id;
  final String title;
  final String brand;
  final String category;
  final double price;
  final double? originalPrice;
  final double rating;
  final int reviewCount;
  final String imageUrl;
  final String description;
  final bool inStock;
  final bool isFavorite;
  final List<String> tags;
  final Map<String, String> specifications;

  const Product({
    required this.id,
    required this.title,
    required this.brand,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.rating,
    required this.reviewCount,
    required this.imageUrl,
    required this.description,
    this.inStock = true,
    this.isFavorite = false,
    this.tags = const [],
    this.specifications = const {},
  });

  /// Calculates discount percentage if original price is higher than current price.
  int get discountPercent {
    if (originalPrice != null && originalPrice! > price) {
      return (((originalPrice! - price) / originalPrice!) * 100).round();
    }
    return 0;
  }

  /// Creates a copy of this product with specified fields replaced.
  Product copyWith({
    String? id,
    String? title,
    String? brand,
    String? category,
    double? price,
    double? originalPrice,
    double? rating,
    int? reviewCount,
    String? imageUrl,
    String? description,
    bool? inStock,
    bool? isFavorite,
    List<String>? tags,
    Map<String, String>? specifications,
  }) {
    return Product(
      id: id ?? this.id,
      title: title ?? this.title,
      brand: brand ?? this.brand,
      category: category ?? this.category,
      price: price ?? this.price,
      originalPrice: originalPrice ?? this.originalPrice,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      imageUrl: imageUrl ?? this.imageUrl,
      description: description ?? this.description,
      inStock: inStock ?? this.inStock,
      isFavorite: isFavorite ?? this.isFavorite,
      tags: tags ?? this.tags,
      specifications: specifications ?? this.specifications,
    );
  }

  /// Curated sample catalog with diverse products across categories
  static List<Product> getSampleProducts() {
    return [
      const Product(
        id: 'p1',
        title: 'Sony WH-1000XM5 Wireless Noise Canceling Headphones',
        brand: 'Sony',
        category: 'Audio',
        price: 349.99,
        originalPrice: 399.99,
        rating: 4.8,
        reviewCount: 1420,
        imageUrl:
            'https://images.unsplash.com/photo-1505740420928-5e560c06d30e?auto=format&fit=crop&w=600&q=80',
        description:
            'Industry-leading noise canceling with two processors and 8 microphones. Magnificent audio quality with 30mm precision-engineered drivers and up to 30 hours battery life.',
        inStock: true,
        isFavorite: false,
        tags: ['wireless', 'anc', 'bluetooth', 'over-ear', 'premium'],
        specifications: {
          'Battery Life': 'Up to 30 hours',
          'Connectivity': 'Bluetooth 5.2 / 3.5mm Aux',
          'Weight': '250g',
          'Noise Cancellation': 'Active Dual Processor',
        },
      ),
      const Product(
        id: 'p2',
        title: 'Apple MacBook Air 15" M3 Chip (16GB, 512GB)',
        brand: 'Apple',
        category: 'Laptops',
        price: 1299.00,
        originalPrice: 1499.00,
        rating: 4.9,
        reviewCount: 940,
        imageUrl:
            'https://images.unsplash.com/photo-1517336714731-489689fd1ca8?auto=format&fit=crop&w=600&q=80',
        description:
            'Supercharged by the next-generation M3 chip, this strikingly thin and fast laptop delivers exceptional speed and up to 18 hours of battery life with Liquid Retina display.',
        inStock: true,
        isFavorite: true,
        tags: ['m3', 'ultrabook', 'macos', 'retina', 'lightweight'],
        specifications: {
          'Processor': 'Apple M3 8-core CPU',
          'Memory': '16GB Unified RAM',
          'Storage': '512GB SSD',
          'Display': '15.3-inch Liquid Retina',
        },
      ),
      const Product(
        id: 'p3',
        title: 'Samsung Galaxy S24 Ultra 5G (Titanium Gray)',
        brand: 'Samsung',
        category: 'Smartphones',
        price: 1199.99,
        originalPrice: 1299.99,
        rating: 4.7,
        reviewCount: 2150,
        imageUrl:
            'https://images.unsplash.com/photo-1610945415295-d9bbf067e59c?auto=format&fit=crop&w=600&q=80',
        description:
            'Unleash whole new levels of creativity and productivity with Galaxy AI. Features a titanium frame, 200MP camera system, built-in S Pen, and Snapdragon 8 Gen 3 processor.',
        inStock: true,
        isFavorite: false,
        tags: ['ai', '5g', 'amoled', 'spen', 'camera', 'flagship'],
        specifications: {
          'Display': '6.8" Dynamic AMOLED 2X 120Hz',
          'Main Camera': '200MP + 50MP + 12MP + 10MP',
          'Battery': '5000 mAh Fast Charging',
          'Water Resistance': 'IP68 Certified',
        },
      ),
      const Product(
        id: 'p4',
        title: 'Apple Watch Ultra 2 Titanium GPS + Cellular 49mm',
        brand: 'Apple',
        category: 'Wearables',
        price: 749.00,
        originalPrice: 799.00,
        rating: 4.8,
        reviewCount: 680,
        imageUrl:
            'https://images.unsplash.com/photo-1523275335684-37898b6baf30?auto=format&fit=crop&w=600&q=80',
        description:
            'The most rugged and capable Apple Watch. Designed for outdoor adventure, endurance sports, and ocean diving with 3000-nit display and dual-frequency GPS.',
        inStock: true,
        isFavorite: false,
        tags: ['fitness', 'gps', 'cellular', 'diving', 'titanium'],
        specifications: {
          'Case Size': '49mm Aerospace Titanium',
          'Water Resistance': '100 meters / EN13319',
          'Battery Life': 'Up to 36 hours (72 in Low Power)',
          'Sensors': 'ECG, Blood Oxygen, Depth Gauge',
        },
      ),
      const Product(
        id: 'p5',
        title: 'Sony PlayStation 5 DualSense Edge Wireless Controller',
        brand: 'Sony',
        category: 'Gaming',
        price: 199.99,
        rating: 4.6,
        reviewCount: 450,
        imageUrl:
            'https://images.unsplash.com/photo-1606318801954-d46846fe5d77?auto=format&fit=crop&w=600&q=80',
        description:
            'Get an edge in gameplay by creating custom controls. Features remappable buttons, tunable triggers, swappable stick caps, and haptic feedback.',
        inStock: false,
        isFavorite: false,
        tags: ['console', 'controller', 'ps5', 'pro-gaming', 'customizable'],
        specifications: {
          'Compatibility': 'PS5, PC, Mac, iOS, Android',
          'Feedback': 'Haptic Triggers & Adaptive Resistance',
          'Connection': 'USB-C Braided & Wireless',
        },
      ),
      const Product(
        id: 'p6',
        title: 'Dell XPS 16 OLED InfinityEdge Laptop',
        brand: 'Dell',
        category: 'Laptops',
        price: 2199.00,
        originalPrice: 2499.00,
        rating: 4.5,
        reviewCount: 310,
        imageUrl:
            'https://images.unsplash.com/photo-1593642632823-8f785ba67e45?auto=format&fit=crop&w=600&q=80',
        description:
            'Iconic design crafted with CNC aluminum and Gorilla Glass. Features Intel Core Ultra 7 processor and stunning 4K OLED touch display with NVIDIA RTX graphics.',
        inStock: true,
        isFavorite: false,
        tags: ['creator', 'oled', 'rtx', 'intel', 'windows11'],
        specifications: {
          'Processor': 'Intel Core Ultra 7 155H',
          'GPU': 'NVIDIA GeForce RTX 4060',
          'RAM': '32GB LPDDR5x',
          'Screen': '16.3" 4K+ OLED Touchscreen',
        },
      ),
      const Product(
        id: 'p7',
        title: 'Bose QuietComfort Ultra Noise-Canceling Earbuds',
        brand: 'Bose',
        category: 'Audio',
        price: 279.00,
        originalPrice: 299.00,
        rating: 4.7,
        reviewCount: 890,
        imageUrl:
            'https://images.unsplash.com/photo-1590658268037-6bf12165a8df?auto=format&fit=crop&w=600&q=80',
        description:
            'Revolutionary spatial audio brings your music to life. World-class active noise cancellation customized specifically to your ears with CustomTune technology.',
        inStock: true,
        isFavorite: false,
        tags: ['earbuds', 'anc', 'spatial-audio', 'waterproof', 'compact'],
        specifications: {
          'Battery': '6 hours (24 hours with case)',
          'Water Resistance': 'IPX4 Sweat & Weather',
          'Bluetooth': '5.3 with Snapdragon Sound',
        },
      ),
      const Product(
        id: 'p8',
        title: 'Google Pixel 8 Pro with Gemini AI (128GB Bay Blue)',
        brand: 'Google',
        category: 'Smartphones',
        price: 899.00,
        originalPrice: 999.00,
        rating: 4.6,
        reviewCount: 1240,
        imageUrl:
            'https://images.unsplash.com/photo-1598327105666-5b89351aff97?auto=format&fit=crop&w=600&q=80',
        description:
            'Engineered by Google, Tensor G3 is fast, secure, and packed with cutting-edge AI photography features like Best Take and Magic Editor.',
        inStock: true,
        isFavorite: false,
        tags: ['google', 'pixel', 'ai', 'camera', 'android'],
        specifications: {
          'Processor': 'Google Tensor G3',
          'Camera': '50MP Main + 48MP Ultrawide + 48MP Telephoto',
          'OS Support': '7 Years of OS & Security Updates',
        },
      ),
      const Product(
        id: 'p9',
        title: 'Logitech MX Master 3S Wireless Performance Mouse',
        brand: 'Logitech',
        category: 'Accessories',
        price: 99.99,
        rating: 4.9,
        reviewCount: 3820,
        imageUrl:
            'https://images.unsplash.com/photo-1615663245857-ac93bb7c39e7?auto=format&fit=crop&w=600&q=80',
        description:
            'Quiet Clicks feel satisfying yet make 90% less noise. MagSpeed electromagnetic scrolling delivers remarkable speed, precision, and near silence on any surface.',
        inStock: true,
        isFavorite: true,
        tags: ['mouse', 'ergonomic', 'bluetooth', 'productivity'],
        specifications: {
          'Sensor': 'Darkfield 8000 DPI (tracks on glass)',
          'Battery': 'Up to 70 days on full charge',
          'Connectivity': 'Bluetooth Low Energy & Logi Bolt',
        },
      ),
      const Product(
        id: 'p10',
        title: 'Razer BlackWidow V4 Pro Mechanical Gaming Keyboard',
        brand: 'Razer',
        category: 'Gaming',
        price: 229.99,
        originalPrice: 249.99,
        rating: 4.7,
        reviewCount: 520,
        imageUrl:
            'https://images.unsplash.com/photo-1587829741301-dc798b83add3?auto=format&fit=crop&w=600&q=80',
        description:
            'Full-blown battlestation immersion with the Razer Command Dial, 8 dedicated macro keys, 8000Hz polling rate, and vibrant per-key Chroma RGB underglow.',
        inStock: false,
        isFavorite: false,
        tags: ['mechanical', 'rgb', 'gaming', 'switches', 'macros'],
        specifications: {
          'Switch Type': 'Razer Green Clicky Mechanical',
          'Keycaps': 'Doubleshot ABS Keycaps',
          'Polling Rate': 'Up to 8,000 Hz HyperPolling',
        },
      ),
      const Product(
        id: 'p11',
        title: 'Garmin Fenix 7 Pro Solar Multisport GPS Smartwatch',
        brand: 'Garmin',
        category: 'Wearables',
        price: 799.99,
        rating: 4.8,
        reviewCount: 410,
        imageUrl:
            'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?auto=format&fit=crop&w=600&q=80',
        description:
            'Conquer every hour with advanced training features, 24/7 health tracking, LED flashlight, and solar charging lens for up to 37 days of battery life.',
        inStock: true,
        isFavorite: false,
        tags: ['solar', 'triathlon', 'gps', 'heart-rate', 'endurance'],
        specifications: {
          'Lens Material': 'Power Sapphire Solar Charging',
          'Water Rating': '10 ATM (100 meters)',
          'Battery': 'Up to 22 days in smartwatch mode',
        },
      ),
      const Product(
        id: 'p12',
        title: 'Anker 737 Power Bank (PowerCore 24K, 140W 3-Port)',
        brand: 'Anker',
        category: 'Accessories',
        price: 139.99,
        originalPrice: 159.99,
        rating: 4.8,
        reviewCount: 2300,
        imageUrl:
            'https://images.unsplash.com/photo-1609592426868-b769ea84c472?auto=format&fit=crop&w=600&q=80',
        description:
            'Ultra-powerful two-way charging with Power Delivery 3.1 and bi-directional technology to quickly recharge the 24,000mAh portable charger or get 140W ultra-powerful charge.',
        inStock: true,
        isFavorite: false,
        tags: ['charger', 'usb-c', 'battery', 'fast-charge', 'laptop-charging'],
        specifications: {
          'Capacity': '24,000 mAh',
          'Total Output': '140W Max Fast Output',
          'Display': 'Smart Digital Color Display',
        },
      ),
    ];
  }
}
