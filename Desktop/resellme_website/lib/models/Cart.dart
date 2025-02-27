import 'dart:convert';

import 'package:ResellMe/models/product_model.dart';

import 'Address.dart';


class Cart {
  final CatalogData product;
  final String selectedOption;
  final StockInfo stockInfo;
  final int selectedIndex;
  late  int quantity;

  Cart({required this.product, required this.selectedOption,required this.stockInfo,required this.selectedIndex,required this.quantity});
}



class Coupon {
  final int couponId;
  final String couponCode;
  final String couponType;
  final bool canApply;
  final double couponAmount;

  Coupon({
    required this.couponId,
    required this.couponCode,
    required this.couponType,
    required this.canApply,
    required this.couponAmount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      couponId: json['couponId'],
      couponCode: json['couponCode'],
      couponType: json['couponType'],
      canApply: json['canApply'],
      couponAmount: json['couponAmount'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'couponId': couponId,
      'couponCode': couponCode,
      'couponType': couponType,
      'canApply': canApply,
      'couponAmount': couponAmount,
    };
  }
}



class ShoppingCart {
  final int groupId;
  final String groupName;
  final int collectionId;
  final String collectionTitle;
  final int productId;
  int quantity;
  final bool isHidden;
  final bool askForAvailability;
  String size;
  final String imageUrl;
  final int sourceCatalogId;
  String additionalNotes;
  final int verificationType;
  final int cashbackPerOrder;
  double startingPrice;
  double maxMrp;
  final int margin;
  final bool easyReturnSelected;
  final int easyReturnAmount;

  ShoppingCart({
    required this.groupId,
    required this.groupName,
    required this.collectionId,
    required this.collectionTitle,
    required this.productId,
    required this.quantity,
    required this.isHidden,
    required this.askForAvailability,
    required this.size,
    required this.imageUrl,
    required this.sourceCatalogId,
    required this.additionalNotes,
    required this.verificationType,
    required this.cashbackPerOrder,
    required this.startingPrice,
    required this.maxMrp,
    required this.margin,
    required this.easyReturnSelected,
    required this.easyReturnAmount,
  });

  factory ShoppingCart.fromJson(Map<String, dynamic> json) {
    return ShoppingCart(
      groupId: json['groupId'],
      groupName: json['groupName'],
      collectionId: json['collectionId'],
      collectionTitle: json['collectionTitle'],
      productId: json['productId'],
      quantity: json['quantity'],
      isHidden: json['isHidden'],
      askForAvailability: json['askForAvailability'],
      size: json['sizeString'],
      imageUrl: json['imageUrl'],
      sourceCatalogId: json['sourceCatalogId'],
      additionalNotes: json['additionalInfo'],
      verificationType: json['verificationType'],
      cashbackPerOrder: json['cashbackPerOrder'],
      startingPrice: (json['startingPrice'] as num).toDouble(),
      maxMrp: (json['maxMrp'] as num).toDouble(),
      margin: json['margin'],
      easyReturnSelected: json['easyReturnSelected'],
      easyReturnAmount: json['easyReturnAmount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupId': groupId,
      'groupName': groupName,
      'collectionId': collectionId,
      'collectionTitle': collectionTitle,
      'productId': productId,
      'quantity': quantity,
      'isHidden': isHidden,
      'askForAvailability': askForAvailability,
      'sizeString': size,
      'imageUrl': imageUrl,
      'sourceCatalogId': sourceCatalogId,
      'additionalInfo': additionalNotes,
      'verificationType': verificationType,
      'cashbackPerOrder': cashbackPerOrder,
      'startingPrice': startingPrice,
      'maxMrp': maxMrp,
      'margin': margin,
      'easyReturnSelected': easyReturnSelected,
      'easyReturnAmount': easyReturnAmount,
    };
  }
}




class CreateOrder {
  final int orderType;
  final Address addressInfo;
  final List<ShoppingCart> productDetails;
  final int versionCode;
  final bool isMosix;
  final double bulkDiscount;

  CreateOrder({
    required this.orderType,
    required this.addressInfo,
    required this.productDetails,
    required this.versionCode,
    required this.isMosix,
    required this.bulkDiscount,
  });

  Map<String, dynamic> toJson() {
    return {
      'orderType': orderType,
      'addressInfo': addressInfo.toJson(), // Assumes Address class has toJson method
      'productDetails': productDetails.map((cart) => cart.toJson()).toList(), // Convert each ShoppingCart to JSON
      'versionCode': versionCode,
      'isMosix': isMosix,
      'bulkDiscount': bulkDiscount,
    };
  }

  String toJsonString() {
    return jsonEncode(toJson());
  }
}


class OrderCreatedDataWOtherDetails {
  final bool error;
  final int errorType;
  final int amountToAdd;
  final int statusCode;
  final String message;
  final OrderData data;

  OrderCreatedDataWOtherDetails({
    required this.error,
    required this.errorType,
    required this.amountToAdd,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory OrderCreatedDataWOtherDetails.fromJson(Map<String, dynamic> json) {
    return OrderCreatedDataWOtherDetails(
      error: json['error'],
      errorType: json['errorType'],
      amountToAdd: json['amountToAdd'],
      statusCode: json['statusCode'],
      message: json['message'],
      data: OrderData.fromJson(json['data']),
    );
  }
}

class OrderData {
  final int orderType;
  final int ownerStatus;
  final int orderId;
  final int groupId;
  final int numOfItems;
  final double codCharge;
  final int coinsEarned;
  final double easyReturnAmount;
  final int dealerDiscount;
  final int groupPlan;
  final int catalogId;
  final double bulkOrderDiscount;
  final double shippingAmount;
  final int groupOwnerId;
  final AddressInfo addressInfo;
  final double margin;
  final int sourceCatalogId;
  final int leafOrderId;
  final double prepaidDiscountApplicable;
  final double couponDiscount;
  final double productAmount;
  final String groupName;
  final double cashbackEarned;
  final double firstOrder;
  final int dispatchDays;

  OrderData({
    required this.orderType,
    required this.ownerStatus,
    required this.orderId,
    required this.groupId,
    required this.numOfItems,
    required this.codCharge,
    required this.coinsEarned,
    required this.easyReturnAmount,
    required this.dealerDiscount,
    required this.groupPlan,
    required this.catalogId,
    required this.bulkOrderDiscount,
    required this.shippingAmount,
    required this.groupOwnerId,
    required this.addressInfo,
    required this.margin,
    required this.sourceCatalogId,
    required this.leafOrderId,
    required this.prepaidDiscountApplicable,
    required this.couponDiscount,
    required this.productAmount,
    required this.groupName,
    required this.cashbackEarned,
    required this.firstOrder,
    required this.dispatchDays,
  });

  factory OrderData.fromJson(Map<String, dynamic> json) {
    return OrderData(
      orderType: json['orderType'] ?? 0, // Provide a default value if null
      ownerStatus: json['ownerStatus'] ?? 0,
      orderId: json['orderId'] ?? 0,
      groupId: json['groupId'] ?? 0,
      numOfItems: json['numOfItems'] ?? 0,
      codCharge: (json['codCharge'] ?? 0).toDouble(),
      coinsEarned: json['coinsEarned'] ?? 0,
      easyReturnAmount: (json['easyReturnAmount'] ?? 0).toDouble(),
      dealerDiscount: json['dealerDiscount'] ?? 0,
      groupPlan: json['groupPlan'] ?? 0,
      catalogId: json['catalogId'] ?? 0,
      bulkOrderDiscount: (json['bulkOrderDiscount'] ?? 0).toDouble(),
      shippingAmount: (json['shippingAmount'] ?? 0).toDouble(),
      groupOwnerId: json['groupOwnerId'] ?? 0,
      addressInfo: AddressInfo.fromJson(json['addressInfo'] ?? {}), // Handle null addressInfo
      margin: (json['margin'] ?? 0).toDouble(),
      sourceCatalogId: json['sourceCatalogId'] ?? 0,
      leafOrderId: json['leafOrderId'] ?? 0,
      prepaidDiscountApplicable: (json['prepaidDiscountApplicable'] ?? 0).toDouble(),
      couponDiscount: (json['couponDiscount'] ?? 0).toDouble(),
      productAmount: (json['productAmount'] ?? 0).toDouble(),
      groupName: json['groupName'] ?? '', // Provide a default value if null
      cashbackEarned: (json['cashbackEarned'] ?? 0).toDouble(),
      firstOrder: (json['firstOrder'] ?? 0).toDouble(),
      dispatchDays: json['dispatchDays'] ?? 0,
    );
  }
}

class AddressInfo {
  final int fromNumber;
  final int pincode;
  final String? addressLineTwo; // Nullable field
  final String? nearestLandmark; // Nullable field
  final String toName;
  final String addressLineOne;
  final String? fullAddress; // Nullable field
  final String fromName;
  final String state;
  final String? addressLineThree; // Nullable field
  final int toNumber;
  final String cityOrTown;

  AddressInfo({
    required this.fromNumber,
    required this.pincode,
    this.addressLineTwo,
    this.nearestLandmark,
    required this.toName,
    required this.addressLineOne,
    this.fullAddress,
    required this.fromName,
    required this.state,
    this.addressLineThree,
    required this.toNumber,
    required this.cityOrTown,
  });

  factory AddressInfo.fromJson(Map<String, dynamic> json) {
    return AddressInfo(
      fromNumber: json['fromNumber'] ?? 0,
      pincode: json['pincode'] ?? 0,
      addressLineTwo: json['addressLineTwo'],
      nearestLandmark: json['nearestLandmark'],
      toName: json['toName'] ?? '', // Provide a default value if null
      addressLineOne: json['addressLineOne'] ?? '',
      fullAddress: json['fullAddress'],
      fromName: json['fromName'] ?? '',
      state: json['state'] ?? '',
      addressLineThree: json['addressLineThree'],
      toNumber: json['toNumber'] ?? 0,
      cityOrTown: json['cityOrTown'] ?? '',
    );
  }
}




