import 'dart:convert';

import 'package:ResellMe/models/product_model.dart';
import 'package:ResellMe/screens/cart/cart_screen.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:provider/provider.dart';
import '../../helper/cart_provider.dart';
import '../../models/Cart.dart';
import '../../network/api_service.dart';

class ApplyCouponScreen extends StatefulWidget {

  const ApplyCouponScreen({super.key});

  @override
  _ApplyCouponScreenState createState() => _ApplyCouponScreenState();
}

class _ApplyCouponScreenState extends State<ApplyCouponScreen> {
  late ApiService _apiService;
  bool isLoading = true;
  List<Coupon> catalogData = [];
  List<Coupon> applied = [];
  List<Cart> cartItems = [];



  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _apiService = ApiService(dio);
    // Fetch products once during initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartItems = Provider.of<CartProvider>(context, listen: false).cartItems;
      fetchProducts(1, cartItems, "token", true, 12);
    });
  }

  Future<void> fetchProducts(
      int userId, List<Cart> cartItems, String token, bool editPrice, int categoryId) async {
    try {

      final productJsonList = ProductJsonList(
        productJson: [

          ProductJson(
            productId: cartItems.first.product.products[cartItems.first.selectedIndex].productId, // Replace with an actual ID or keep it null
            quantity: cartItems.first.quantity,  // Replace with an actual quantity or keep it null
          ),
        ],
      );

      // Convert to JSON
      final jsonString = jsonEncode(productJsonList.toJson());

      final response = await _apiService.getAvailableCoupons(userId, cartItems.first.product.groupId, "getCoupons",jsonString,token);

      // Parse the response
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      print(responseData);

      final data = responseData['data']['offerJson'] as List<dynamic>;
      setState(() {
        catalogData = data.map((item) => Coupon.fromJson(item as Map<String, dynamic>)).toList();
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> verifyCoupons(
     List<Cart> cartItems, String token, String couponCode) async {
    try {

      final productJsonList = ProductJsonList(
        productJson: [

          ProductJson(
            productId: cartItems.first.product.products[cartItems.first.selectedIndex].productId, // Replace with an actual ID or keep it null
            quantity: cartItems.first.quantity,  // Replace with an actual quantity or keep it null
          ),
        ],
      );

      // Convert to JSON
      final jsonString = jsonEncode(productJsonList.toJson());

      final response = await _apiService.verifyCoupons(1,cartItems.first.product.groupId, couponCode,"applyCoupon",jsonString,token);

      // Parse the response
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      print(responseData);

      final data = responseData['data']['offerJson'] as List<dynamic>;
      setState(() {
        applied = data.map((item) => Coupon.fromJson(item as Map<String, dynamic>)).toList();
        if(applied.first.canApply){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>  const CartScreen(),
            ),
          );
        }else{

        }
      });
    } catch (e) {
      print('Failed to fetch products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply Coupon'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : catalogData.isEmpty
          ? const Center(
        child: Text(
          'No Coupons Available',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // TextField for entering coupon code
            TextField(
              decoration: InputDecoration(
                labelText: 'Enter Coupon Code',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                suffixIcon: TextButton(
                  onPressed: () {
                    // Handle Apply button click
                  },
                  child: const Text(
                    'APPLY',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            // Coupons list
            Expanded(
              child: ListView.builder(
                itemCount: catalogData.length,
                itemBuilder: (context, index) {
                  final coupon = catalogData[index];
                  return ListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                      side: BorderSide(color: Colors.grey.shade300),
                    ),
                    title: Text(
                      coupon.couponCode,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: Text(
                      'Get ₹${coupon.couponAmount.toStringAsFixed(0)} Off. (${coupon.couponType})',
                    ),
                    trailing: coupon.canApply
                        ? TextButton(
                      onPressed: () {
                        // Handle Apply button click
                        verifyCoupons(cartItems,'',coupon.couponCode);
                      },
                      child: const Text(
                        'APPLY',
                        style: TextStyle(
                          color: Colors.pink,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                        : const Text(
                      'NOT APPLICABLE',
                      style: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

}
