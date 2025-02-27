import 'dart:convert';



class Address {
  final int pincode;
  final String senderName;
  final int senderNumber;
  final int userAddressId;
  final String nearestLandmark;
  final String fullAddress;
  final String state;
  final int customerNumber;
  final int userId;
  final String customerName;
  final String cityOrTown;

  Address({
    required this.pincode,
    required this.senderName,
    required this.senderNumber,
    required this.userAddressId,
    required this.nearestLandmark,
    required this.fullAddress,
    required this.state,
    required this.customerNumber,
    required this.userId,
    required this.customerName,
    required this.cityOrTown,
  });

  factory Address.fromJson(Map<String, dynamic> json) {
    return Address(
      pincode: json['pincode'] as int,
      senderName: json['senderName'] as String,
      senderNumber: json['senderNumber'] as int,
      userAddressId: json['userAddressId'] as int,
      nearestLandmark: json['nearestLandmark'] as String,
      fullAddress: json['fullAddress'] as String,
      state: json['state'] as String,
      customerNumber: json['customerNumber'] as int,
      userId: json['userId'] as int,
      customerName: json['customerName'] as String,
      cityOrTown: json['cityOrTown'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pincode': pincode,
      'senderName': senderName,
      'senderNumber': senderNumber,
      'userAddressId': userAddressId,
      'nearestLandmark': nearestLandmark,
      'fullAddress': fullAddress,
      'state': state,
      'customerNumber': customerNumber,
      'userId': userId,
      'customerName': customerName,
      'cityOrTown': cityOrTown,
    };
  }
}
