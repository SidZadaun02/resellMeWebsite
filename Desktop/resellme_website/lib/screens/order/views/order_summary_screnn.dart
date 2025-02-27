import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../helper/cart_provider.dart';
import '../../../models/Address.dart';
import '../../../models/Cart.dart';
import '../../cart/components/check_out_card.dart';

class PaymentPage extends StatefulWidget {
  final Address address;

  const PaymentPage({super.key, required this.address});

  @override
  State<PaymentPage> createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  List<Cart> cartItems = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        cartItems = Provider.of<CartProvider>(context, listen: false).cartItems;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Pay in Cash
            const Text('PAY IN CASH', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey)),
            const SizedBox(height: 10),
            _buildPaymentOption(
              icon: Icons.money,
              title: 'Cash on Delivery',
              subtitle: 'Extra ₹50 charge for COD orders',
            ),
            const SizedBox(height: 20),

            // Order Summary
            const Text('Order Summary', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildOrderSummaryCard(),
            const SizedBox(height: 20),

            // Delivery Address
            const Text('Delivery Address', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildAddressCard(),
            const SizedBox(height: 20),

            // Price Details
            const Text('Price Details', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            _buildPriceDetails(),
            const SizedBox(height: 20),

            // Apply Coupon
            _buildApplyCoupon(),
          ],
        ),
      ),
      bottomNavigationBar: const PlaceOrderCard(), // Pass cart items to CheckoutCard
    );
  }

  Widget _buildPaymentOption({required IconData icon, required String title, String? subtitle}) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
      ),
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Icon(icon, color: Colors.green),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
                if (subtitle != null) Text(subtitle, style: const TextStyle(fontSize: 12, color: Colors.grey)),
              ],
            ),
          ),
          Radio(value: null, groupValue: null, onChanged: (value) {}), // Placeholder radio button
        ],
      ),
    );
  }

  Widget _buildOrderSummaryCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: cartItems.map((cartItem) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.network(
                    cartItem.product.products[cartItem.selectedIndex].imageUrl, // Dynamic image URL
                    width: 80,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(cartItem.product.catalogTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text(cartItem.product.groupName, style: const TextStyle(color: Colors.grey)),
                        Text('₹${cartItem.product.customerPrice}', style: const TextStyle(fontWeight: FontWeight.bold)),
                        Text('Size: ${cartItem.stockInfo.sizeString} - Qty: ${cartItem.stockInfo.sizeQuantity}'),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }


  Widget _buildAddressCard() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.address.customerName}, ${widget.address.customerNumber}, ${widget.address.fullAddress}, ${widget.address.cityOrTown}, ${widget.address.state}, ${widget.address.pincode}',
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text('Dispatch in 1 day', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceDetails() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildPriceRow('Total Price (1 item)', '₹389'),
            _buildPriceRow('Easy Return Charge', '+ ₹25'),
            _buildPriceRow('Delivery Charge', 'FREE'),
            const Divider(),
            _buildPriceRow('Order Total', '₹414', isBold: true),
          ],
        ),
      ),
    );
  }

  Widget _buildApplyCoupon() {
    return InkWell(
      onTap: () {
        // Handle apply coupon tap
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Apply Coupon', style: TextStyle(fontWeight: FontWeight.w500)),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceRow(String label, String value, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(label, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey.shade300))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text('₹414 ORDER TOTAL', style: TextStyle(fontWeight: FontWeight.bold)),
          ElevatedButton(
            onPressed: () {
              // Handle place order
            },
            child: const Text('PLACE ORDER'),
          ),
        ],
      ),
    );
  }
}
