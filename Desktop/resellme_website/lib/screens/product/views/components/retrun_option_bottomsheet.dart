import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ResellMe/models/Cart.dart';
import 'package:ResellMe/models/product_model.dart';
import 'package:ResellMe/route/screen_export.dart';

import '../../../../helper/cart_provider.dart';

class ReturnOptionsBottomSheet extends StatelessWidget {
  final String selectedOption;
  final Function(String) onOptionSelected;

  ReturnOptionsBottomSheet({
    required this.selectedOption,
    required this.onOptionSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min, // This ensures the bottom sheet wraps content
        children: [
          Center(
            child: Container(
              height: 4.0,
              width: 40.0,
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
          ),
          Text(
            'Select Return Option',
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16.0),
          _buildOption(
            title: 'Easy Return',
            price: '\$5.00',
            subtext: 'Quick and hassle-free returns.',
            isSelected: selectedOption == 'Easy Return',
            onTap: () => onOptionSelected('Easy Return'),
          ),
          const SizedBox(height: 16.0),
          _buildOption(
            title: 'Genuine Return',
            price: '\$2.00',
            subtext: 'Ensures authenticity of returns.',
            isSelected: selectedOption == 'Genuine Return',
            onTap: () => onOptionSelected('Genuine Return'),
          ),
        ],
      ),
    );
  }

  Widget _buildOption({
    required String title,
    required String price,
    required String subtext,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: isSelected ? Colors.pink.withOpacity(0.2) : Colors.white,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(
            color: isSelected ? Colors.pink : Colors.grey[300]!,
            width: 2.0,
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
              color: isSelected ? Colors.pink : Colors.grey,
            ),
            const SizedBox(width: 12.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.0,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    subtext,
                    style: TextStyle(
                      fontSize: 14.0,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12.0),
            Text(
              price,
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showReturnOptionsBottomSheet(BuildContext context, StockInfo stockInfo, CatalogData catalogData, int selectedIndex) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allow the sheet to wrap content
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(16.0)),
    ),
    builder: (context) {
      return ReturnOptionsBottomSheet(
        selectedOption: 'Easy Return', // Replace with the selected option
        onOptionSelected: (selectedOption) {
          Navigator.pop(context, selectedOption);
          Provider.of<CartProvider>(context, listen: false).addToCart(Cart(
              product: catalogData,
              selectedOption: selectedOption,
              stockInfo: stockInfo,
              selectedIndex: selectedIndex,
              quantity: 1
          ));
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CartScreen(),
            ),
          );
        },
      );
    },
  );
}
