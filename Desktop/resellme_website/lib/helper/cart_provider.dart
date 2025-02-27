import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import '../models/Cart.dart';

class CartProvider with ChangeNotifier {
  final List<Cart> _cartItems = [];

  List<Cart> get cartItems => _cartItems;

  // Add an item to the cart
  void addToCart(Cart cartItem) {
    _cartItems.add(cartItem);
    notifyListeners();
  }

  // Remove an item from the cart
  void removeFromCart(Cart cartItem) {
    _cartItems.remove(cartItem);
    notifyListeners();
  }

  // Update the quantity of an item in the cart
  void updateQuantity(int index, int newQuantity) {
    if (index >= 0 && index < _cartItems.length) {
      _cartItems[index].quantity = newQuantity;
      notifyListeners();
    }
  }


}
