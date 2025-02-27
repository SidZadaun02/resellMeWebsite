import 'package:flutter/material.dart';
import '../../../models/Cart.dart';

class CartCard extends StatelessWidget {
  const CartCard({
    Key? key,
    required this.cart,
    required this.onQuantityChanged, // Add callback for quantity change
  }) : super(key: key);

  final Cart cart;
  final ValueChanged<int> onQuantityChanged; // Callback to update quantity



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 88,
          child: AspectRatio(
            aspectRatio: 0.88,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F9),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Image.network(cart.product.products[cart.selectedIndex].imageUrl),
            ),
          ),
        ),
        const SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              cart.product.catalogTitle,
              style: const TextStyle(color: Colors.black, fontSize: 16),
              maxLines: 2,
            ),
            const SizedBox(height: 8),
            Text.rich(
              TextSpan(
                text: "\$${cart.product.startingPrice}",
                style: const TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.pink),
                children: [
                  TextSpan(
                      text: " x${cart.quantity}",
                      style: Theme.of(context).textTheme.bodyLarge),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: () {
                    if (cart.quantity > 1) {
                      onQuantityChanged(cart.quantity - 1);
                    }
                  },
                ),
                Text(cart.quantity.toString()),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (cart.quantity < cart.stockInfo.sizeQuantity) {
                      onQuantityChanged(cart.quantity +1);
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
