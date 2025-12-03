class Product {
  final String name;
  final String category;
  final double price;
  final double? oldPrice;
  final String imageUrl;
  final bool isFavorite;
  final String description;

  const Product({
    required this.category,
    required this.description,
    required this.imageUrl,
    required this.name,
    required this.price,
    this.oldPrice,
    this.isFavorite = false,
  });
}

final List<Product> products = [
  const Product(
    name: 'shoes',
    category: 'footwear',
    price: 69.00,
    oldPrice: 189.00,
    isFavorite: true,
    imageUrl: 'assets/images/shoe.jpg',
    description: 'This is a descprition of the product 1',
  ),
  const Product(
    name: 'Laptop',
    category: 'Electronics',
    price: 69.00,
    oldPrice: 189.00,
    imageUrl: 'assets/images/laptop.jpg',
    description: 'This is a descprition of the product 2',
  ),
  const Product(
    name: 'Jordan Shoes',
    category: 'footwear',
    price: 69.00,
    oldPrice: 189.00,
    imageUrl: 'assets/images/shoe2.jpg',
    description: 'This is a descprition of the product 3',
  ),
  const Product(
    name: 'Puma',
    category: 'footwear',
    price: 69.00,
    oldPrice: 189.00,
    imageUrl: 'assets/images/shoes2.jpg',
    description: 'This is a descprition of the product 4',
  ),
];
