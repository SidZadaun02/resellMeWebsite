import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

AppBar buildAppBar(String catalogTitle, int cartQuantity, VoidCallback onCartPressed) {
  return AppBar(
    title: Center(
      child: Text(
        catalogTitle,
        style: GoogleFonts.poppins(
          fontSize: 28,
          color: Colors.pink,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    // Set the toolbar height to align the center
    toolbarHeight: 60,
    actions: [
      // Cart Icon with Quantity Indicator
      Stack(
        children: [
          IconButton(
            iconSize: 36.0, // Set the icon size here (default is 24.0)
            padding: const EdgeInsets.only(right: 40.0,left: 40.0), // Adds 20 pixels of padding on the left
            icon: const Icon(Icons.shopping_cart, color: Colors.pink),
            onPressed: onCartPressed,
          ),
          if (cartQuantity > 0) // Only show the indicator if cartQuantity > 0
            Positioned(
              right: 30,
              top: 2,
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(10),
                ),
                constraints: const BoxConstraints(
                  minWidth: 16,
                  minHeight: 16,
                ),
                child: Text(
                  '$cartQuantity', // Display cart quantity
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
        ],
      ),
    ],
  );
}
