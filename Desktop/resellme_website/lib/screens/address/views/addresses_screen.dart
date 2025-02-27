import 'dart:convert';

import 'package:ResellMe/models/Address.dart';
import 'package:ResellMe/screens/order/views/order_summary_screnn.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:provider/provider.dart';

import '../../../helper/cart_provider.dart';
import '../../../models/Cart.dart';
import '../../../network/api_service.dart';
import 'add_address_screen.dart';

class SelectAddressScreen extends StatefulWidget {
  const SelectAddressScreen({super.key});

  @override
  _SelectAddressScreenState createState() => _SelectAddressScreenState();
}

class _SelectAddressScreenState extends State<SelectAddressScreen> {
  late ApiService _apiService;
  bool isLoading = true;
  List<Cart> cartItems = [];
  List<Address> addresses = [];

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _apiService = ApiService(dio);
    // Fetch products once during initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      cartItems = Provider.of<CartProvider>(context, listen: false).cartItems;
      fetchAddress(1, "token");
    });
  }

  Future<void> fetchAddress(int userId, String token) async {
    try {
      final response = await _apiService.getUserAddress(userId, token);

      // Parse the response
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      print(responseData);

      final data = responseData['data'] as List<dynamic>;
      setState(() {
        addresses = data
            .map((item) => Address.fromJson(item as Map<String, dynamic>))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  Future<void> createOrder(int userId, String token) async {
    try {
      // Start loading before the request begins
      setState(() {
        isLoading = true;
      });

      // Initialize shoppingCartList as an empty list
      final List<ShoppingCart> shoppingCartList = [];
      OrderData? orderData; // Declare it as nullable initially

      // Creating the shopping cart item
      final shoppingCart = ShoppingCart(
        groupId: cartItems.first.product.groupId,
        groupName: cartItems.first.product.groupName,
        collectionId: cartItems.first.product.sourceCatalogId,
        collectionTitle: cartItems.first.product.catalogTitle,
        productId: cartItems.first.product.products[cartItems.first.selectedIndex].productId,
        quantity: cartItems.first.stockInfo.sizeQuantity,
        isHidden: cartItems.first.product.isHidden,
        askForAvailability: true,
        size: cartItems.first.stockInfo.sizeString,
        imageUrl: cartItems.first.product.products[cartItems.first.selectedIndex].imageUrl,
        sourceCatalogId: cartItems.first.product.sourceCatalogId,
        additionalNotes: "",
        verificationType: 3,
        cashbackPerOrder: cartItems.first.product.maxCashbackPerOrder.toInt(),
        startingPrice: cartItems.first.product.startingPrice,
        maxMrp: cartItems.first.product.maxMrp,
        margin: cartItems.first.product.maxMargin.toInt(),
        easyReturnSelected: true,
        easyReturnAmount: 35,
      );

      // Adding the shopping cart item to the list
      shoppingCartList.add(shoppingCart);

      // Creating the CreateOrder object
      final createOrder = CreateOrder(
        orderType: 319,
        addressInfo: addresses[selectedAddressIndex!], // Ensure selectedAddressIndex is not null
        productDetails: shoppingCartList,
        versionCode: 792,
        isMosix: false,
        bulkDiscount: 0.0,
      );

      // Sending the create order request
      final response = await _apiService.createOrder(131862, createOrder.toJsonString(), 1, token);

      // Parse the response safely
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      print(responseData);


      final data = responseData['data'] as Map<String, dynamic>;

       orderData = OrderData.fromJson(data);
        print('create order: $orderData');

        if(orderData.groupName.isNotEmpty){
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PaymentPage(address: addresses[selectedAddressIndex!]),
            ),
          );
        }


      // Update UI after processing response
      setState(() {
        isLoading = false; // Stop the loading state
      });


    } catch (e) {
      // Catching errors and updating the UI accordingly
      print('Failed to create order: $e');
      setState(() {
        isLoading = false; // Ensure loading is stopped in case of an error
      });
    }
  }



  int? selectedAddressIndex; // To track the selected address

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Address'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Column(
        children: [
          // "Add New Address" button
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: InkWell(
              onTap: () {
                // Navigate to AddAddressScreen
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => AddAddressScreen()),
                );
              },
              child: const Row(
                children: [
                  Icon(Icons.add, color: Colors.pink),
                  SizedBox(width: 8),
                  Text(
                    'ADD NEW ADDRESS',
                    style: TextStyle(
                      color: Colors.pink,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),

          Divider(),
          // Address list
          Expanded(
            child: ListView.builder(
              itemCount: addresses.length,
              itemBuilder: (context, index) {
                final address = addresses[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        title: Text(
                          addresses[index].customerName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                          '${addresses[index].customerNumber}\n${addresses[index].fullAddress}',
                        ),
                        trailing: Radio<int>(
                          value: index,
                          groupValue: selectedAddressIndex,
                          activeColor: Colors.pink,
                          onChanged: (value) {
                            setState(() {
                              selectedAddressIndex = value;
                            });
                          },
                        ),
                      ),
                      if (index == selectedAddressIndex)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: TextButton(
                            onPressed: () {
                              // Handle edit address
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => AddAddressScreen(address:addresses[index])),
                              );
                            },
                            child: const Text(
                              'Edit Address',
                              style: TextStyle(color: Colors.pink),
                            ),
                          ),
                        ),
                      Divider(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ElevatedButton(
          onPressed: () {
            if (selectedAddressIndex == null) {
              Fluttertoast.showToast(
                msg: "Please select an address",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.black,
                textColor: Colors.white,
              );
            } else {
              createOrder(1,"");

            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.pink,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
          child: const Text(
            'CONFIRM ADDRESS',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
