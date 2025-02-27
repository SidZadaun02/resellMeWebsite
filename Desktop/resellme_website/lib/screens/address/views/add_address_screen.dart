import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../models/Address.dart';
import '../../../network/api_service.dart';


class AddAddressScreen extends StatefulWidget {
  final Address? address;

  const AddAddressScreen({Key? key, this.address}) : super(key: key);

  @override
  _AddAddressScreenState createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  late ApiService _apiService;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  final TextEditingController landmarkController = TextEditingController();
  final TextEditingController cityController = TextEditingController();
  final TextEditingController stateController = TextEditingController();
  final TextEditingController pinCodeController = TextEditingController();
  final TextEditingController senderNameController = TextEditingController();
  final TextEditingController senderNumberController = TextEditingController();

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _apiService = ApiService(dio);
    // Populate controllers if address is not null
    if (widget.address != null) {
      nameController.text = widget.address!.customerName;
      mobileController.text = widget.address!.customerNumber.toString();
      addressController.text = widget.address!.fullAddress;
      landmarkController.text = widget.address!.nearestLandmark;
      cityController.text = widget.address!.cityOrTown;
      stateController.text = widget.address!.state;
      pinCodeController.text = widget.address!.pincode.toString();
      senderNameController.text = widget.address!.senderName;
      senderNumberController.text = widget.address!.senderNumber.toString();
    }
  }

  Future<void> postAddress(int userId, String token,Address addrees) async {
    try {
      final response = await _apiService.postUserAddress(userId, token,addrees);

      // Parse the response
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      print(responseData);
      // final data = responseData['data'] as List<dynamic>;
      Navigator.pop(context);

    } catch (e) {
      print('Failed to fetch products: $e');
      setState(() {
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.pink,
        title: const Text("New Address"),
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
          children: [
            const Text("Customer Name", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Full Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Customer Mobile Number", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: mobileController,
              decoration: InputDecoration(
                hintText: "10-digit Mobile Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Full Address", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: "House Number, Building, Street, Area, Locality",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Landmark (Optional)", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: landmarkController,
              decoration: InputDecoration(
                hintText: "Nearby Location",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("Town / City / District", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                hintText: "Town, City or District",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("State", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: stateController,
              decoration: InputDecoration(
                hintText: "Enter State Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 16),
            const Text("PIN Code", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: pinCodeController,
              decoration: InputDecoration(
                hintText: "6-digit Code [0-9]",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            const Divider(), // Separator between fields
            const SizedBox(height: 24),
            const Text(
              "Sender Details",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const SizedBox(height: 8),
            const Text("Name", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: senderNameController,
              decoration: InputDecoration(
                hintText: "Full Name",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const Text("Number", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            TextField(
              controller: senderNumberController,
              decoration: InputDecoration(
                hintText: "Sender Number",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                ),
                onPressed: () {
                  // Handle save address logic here
                  postAddress(1, "token", Address(pincode: int.parse(pinCodeController.text), senderName: senderNameController.text, senderNumber: int.parse(senderNumberController.text), userAddressId: -1, nearestLandmark: landmarkController.text, fullAddress: addressController.text, state: stateController.text, customerNumber: int.parse(mobileController.text), userId: -1, customerName: nameController.text, cityOrTown: cityController.text));
                },
                child: const Text("SAVE ADDRESS", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}