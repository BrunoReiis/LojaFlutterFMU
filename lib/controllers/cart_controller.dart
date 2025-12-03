import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:lojaflutter/models/product.dart';
import 'package:lojaflutter/models/cart_item.dart';
import 'package:get_storage/get_storage.dart';
import 'dart:convert';

class CartController extends GetxController {
  final _storage = GetStorage();
  
  final RxList<CartItem> _cartItems = <CartItem>[].obs;
  final RxList<int> _wishlistIds = <int>[].obs;

  List<CartItem> get cartItems => _cartItems;
  List<int> get wishlistIds => _wishlistIds;

  double get total => _cartItems.fold(0, (sum, item) => sum + item.subtotal);
  int get itemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);

  @override
  void onInit() {
    super.onInit();
    _loadCartFromStorage();
    _loadWishlistFromStorage();
  }

  void addToCart(Product product) {
    final index = _cartItems.indexWhere((item) => item.product.id == product.id);
    
    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(
        quantity: _cartItems[index].quantity + 1,
      );
    } else {
      _cartItems.add(CartItem(product: product, quantity: 1));
    }
    _saveCartToStorage();
  }

  void removeFromCart(int productId) {
    _cartItems.removeWhere((item) => item.product.id == productId);
    _saveCartToStorage();
  }

  void updateQuantity(int productId, int quantity) {
    if (quantity <= 0) {
      removeFromCart(productId);
      return;
    }
    
    final index = _cartItems.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      _cartItems[index] = _cartItems[index].copyWith(quantity: quantity);
      _saveCartToStorage();
    }
  }

  void clearCart() {
    _cartItems.clear();
    _storage.remove('cart');
  }

  void toggleWishlist(Product product) {
    if (_wishlistIds.contains(product.id)) {
      _wishlistIds.remove(product.id);
    } else {
      _wishlistIds.add(product.id);
    }
    _saveWishlistToStorage();
  }

  bool isInWishlist(int productId) => _wishlistIds.contains(productId);

  void _saveCartToStorage() {
    final cartData = _cartItems.map((item) => item.toMap()).toList();
    _storage.write('cart', jsonEncode(cartData));
  }

  void _loadCartFromStorage() {
    try {
      final cartData = _storage.read('cart');
      if (cartData != null) {
        final List<dynamic> decoded = jsonDecode(cartData);
        _cartItems.value = decoded
            .map((item) => CartItem.fromMap(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Erro ao carregar carrinho: $e');
    }
  }

  void _saveWishlistToStorage() {
    _storage.write('wishlist', jsonEncode(_wishlistIds));
  }

  void _loadWishlistFromStorage() {
    try {
      final wishlistData = _storage.read('wishlist');
      if (wishlistData != null) {
        final List<dynamic> decoded = jsonDecode(wishlistData);
        _wishlistIds.value = decoded.cast<int>();
      }
    } catch (e) {
      debugPrint('Erro ao carregar wishlist: $e');
    }
  }
}
