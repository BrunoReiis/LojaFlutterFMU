import 'package:flutter/material.dart';

class Product {
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  Product({
    required this.name,
    required this.imageUrl,
    required this.price,
    this.quantity = 1,
  });
}

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  // Exemplo de lista de produtos no carrinho
  final List<Product> products = [
    Product(
        name: 'Headset Gamer',
        imageUrl: 'assets/images/headset.png',
        price: 299.90),
    Product(
        name: 'Teclado Mecânico',
        imageUrl: 'assets/images/keyboard.png',
        price: 459.00),
    Product(
        name: 'Mouse RGB',
        imageUrl: 'assets/images/mouse.png',
        price: 199.00),
  ];

  double get totalPrice {
    return products.fold(0, (sum, item) => sum + (item.price * item.quantity));
  }

  void _removeItem(int index) {
    setState(() {
      products.removeAt(index);
    });
  }

  void _updateQuantity(int index, int delta) {
    setState(() {
      final product = products[index];
      product.quantity = (product.quantity + delta).clamp(1, 99);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meu Carrinho',
          style: TextStyle(
            color: isDark ? Colors.white : Colors.black,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.surface,
        iconTheme: IconThemeData(
          color: isDark ? Colors.white : Colors.black,
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: products.isEmpty
          ? const Center(
              child: Text(
                'Seu carrinho está vazio.',
                style: TextStyle(fontSize: 18),
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: products.length,
                    itemBuilder: (context, index) =>
                        _buildCartItem(context, index),
                  ),
                ),
                _buildTotalSection(),
              ],
            ),
    );
  }

  Widget _buildCartItem(BuildContext context, int index) {
    final product = products[index];
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black.withValues(alpha: 0.2)
                : Colors.grey.withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(left: Radius.circular(16)),
            child: Image.asset(
              product.imageUrl,
              width: 100,
              height: 100,
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'R\$ ${product.price.toStringAsFixed(2)}',
                    style: const TextStyle(fontSize: 15, color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline),
                        onPressed: () => _updateQuantity(index, -1),
                      ),
                      Text('${product.quantity}',
                          style: const TextStyle(fontSize: 16)),
                      IconButton(
                        icon: const Icon(Icons.add_circle_outline),
                        onPressed: () => _updateQuantity(index, 1),
                      ),
                      const Spacer(),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.red),
                        onPressed: () => _removeItem(index),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotalSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 6,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total:',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                Text(
                  'R\$ ${totalPrice.toStringAsFixed(2)}',
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Compra finalizada!')),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text(
                  'Finalizar compra',
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
