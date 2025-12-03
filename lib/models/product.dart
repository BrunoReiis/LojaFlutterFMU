class Product {
  final int id;
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final bool isFavorite;
  final String description;
  final double rating;
  final int reviews;

  const Product({
    required this.id,
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.oldPrice,
    this.isFavorite = false,
    this.rating = 4.5,
    this.reviews = 0,
  });

  Product copyWith({
    int? id,
    String? name,
    String? category,
    double? price,
    double? oldPrice,
    String? imageUrl,
    bool? isFavorite,
    String? description,
    double? rating,
    int? reviews,
  }) {
    return Product(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      imageUrl: imageUrl ?? this.imageUrl,
      isFavorite: isFavorite ?? this.isFavorite,
      description: description ?? this.description,
      rating: rating ?? this.rating,
      reviews: reviews ?? this.reviews,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'price': price,
      'oldPrice': oldPrice,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'description': description,
      'rating': rating,
      'reviews': reviews,
    };
  }

  factory Product.fromMap(Map<String, dynamic> map) {
    return Product(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      category: map['category'] ?? '',
      price: (map['price'] ?? 0).toDouble(),
      oldPrice: map['oldPrice'] != null ? (map['oldPrice']).toDouble() : null,
      imageUrl: map['imageUrl'] ?? '',
      isFavorite: map['isFavorite'] ?? false,
      description: map['description'] ?? '',
      rating: (map['rating'] ?? 4.5).toDouble(),
      reviews: map['reviews'] ?? 0,
    );
  }
}

final List<Product> products = [
  const Product(
    id: 1,
    name: 'Classic Sneaker',
    category: 'Footwear',
    price: 89.99,
    oldPrice: 129.99,
    isFavorite: true,
    imageUrl: 'assets/images/shoe.jpg',
    description: 'Comfortable classic sneaker perfect for everyday wear',
    rating: 4.8,
    reviews: 245,
  ),
  const Product(
    id: 2,
    name: 'Pro Laptop',
    category: 'Electronics',
    price: 1299.99,
    oldPrice: 1599.99,
    imageUrl: 'assets/images/laptop.jpg',
    description: 'High-performance laptop for professionals',
    rating: 4.7,
    reviews: 156,
  ),
  const Product(
    id: 3,
    name: 'Jordan Air',
    category: 'Footwear',
    price: 179.99,
    oldPrice: 249.99,
    imageUrl: 'assets/images/shoe2.jpg',
    description: 'Iconic Jordan basketball shoes',
    rating: 4.9,
    reviews: 523,
  ),
  const Product(
    id: 4,
    name: 'Puma Running',
    category: 'Footwear',
    price: 99.99,
    oldPrice: 149.99,
    imageUrl: 'assets/images/shoes2.jpg',
    description: 'Lightweight running shoes for athletes',
    rating: 4.6,
    reviews: 312,
  ),
  const Product(
    id: 5,
    name: 'Wireless Headphones',
    category: 'Electronics',
    price: 199.99,
    oldPrice: 299.99,
    imageUrl: 'assets/images/headphones.jpg',
    description: 'Premium noise-cancelling wireless headphones',
    rating: 4.8,
    reviews: 489,
  ),
  const Product(
    id: 6,
    name: 'Smart Watch',
    category: 'Electronics',
    price: 299.99,
    oldPrice: 399.99,
    imageUrl: 'assets/images/smartwatch.jpg',
    description: 'Advanced fitness tracking smartwatch',
    rating: 4.5,
    reviews: 234,
  ),
  const Product(
    id: 7,
    name: 'Casual Shirt',
    category: 'Clothing',
    price: 49.99,
    oldPrice: 79.99,
    imageUrl: 'assets/images/shirt.jpg',
    description: 'Comfortable casual shirt for any occasion',
    rating: 4.4,
    reviews: 178,
  ),
  const Product(
    id: 8,
    name: 'Designer Jeans',
    category: 'Clothing',
    price: 129.99,
    oldPrice: 189.99,
    imageUrl: 'assets/images/jeans.jpg',
    description: 'Premium designer jeans with perfect fit',
    rating: 4.7,
    reviews: 356,
  ),
  const Product(
    id: 9,
    name: 'Sunglasses',
    category: 'Accessories',
    price: 159.99,
    oldPrice: 249.99,
    imageUrl: 'assets/images/sunglasses.jpg',
    description: 'Stylish UV-protection sunglasses',
    rating: 4.6,
    reviews: 267,
  ),
  const Product(
    id: 10,
    name: 'Leather Backpack',
    category: 'Accessories',
    price: 199.99,
    oldPrice: 299.99,
    imageUrl: 'assets/images/backpack.jpg',
    description: 'Durable leather backpack for travel',
    rating: 4.8,
    reviews: 412,
  ),
  const Product(
    id: 11,
    name: 'Sports Cap',
    category: 'Accessories',
    price: 34.99,
    oldPrice: 59.99,
    imageUrl: 'assets/images/cap.jpg',
    description: 'Breathable sports cap with UV protection',
    rating: 4.3,
    reviews: 145,
  ),
  const Product(
    id: 12,
    name: 'Premium Camera',
    category: 'Electronics',
    price: 899.99,
    oldPrice: 1199.99,
    imageUrl: 'assets/images/camera.jpg',
    description: '4K professional camera with accessories',
    rating: 4.9,
    reviews: 298,
  ),
];
