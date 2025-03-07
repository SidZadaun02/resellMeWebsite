// Root response model
class ResponseModel2 {
  final bool error;
  final int errorType;
  final int amountToAdd;
  final int statusCode;
  final String message;
  final List<Catalog> data;

  ResponseModel2({
    required this.error,
    required this.errorType,
    required this.amountToAdd,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ResponseModel2.fromJson(Map<String, dynamic> json) {
    return ResponseModel2(
      error: json['error'] as bool,
      errorType: json['errorType'] as int,
      amountToAdd: json['amountToAdd'] as int,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: (json['data'] as List<dynamic>)
          .map((e) => Catalog.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'errorType': errorType,
      'amountToAdd': amountToAdd,
      'statusCode': statusCode,
      'message': message,
      'data': data.map((e) => e.toJson()).toList(),
    };
  }
}

// Catalog model
class Catalog {
  final int prepaidDiscount;
  final int groupType;
  final ShippingChart shippingChart;
  final List<Offer> offerJson;
  final int groupId;
  final String catalogTitle;
  final double startingPrice;
  final int numLikes;
  final int dealerDiscount;
  final List<Product> products;
  final int catalogId;
  final double whatsAppPrice;
  final double startingPriceWOSale;
  final bool isOnSale;
  final double maxMargin;
  final int groupOwnerId;
  final int sourceCatalogId;
  final bool isCodAvailable;
  final int maxCoinsPerOrder;
  final double maxMrp;
  final bool isBrandCat;
  final double customerPrice;
  final bool isHidden;
  final int couponDiscount;
  final String groupName;
  final int couponDiscountApplied;
  final int planNo;
  final int numShares;
  final double salePercent;
  final int firstOrder;
  final String catalogDesc;
  final String lastPromotedTime;
  final int maxCashbackPerOrder;
  final bool isCodFree;
  final int categoryId;

  Catalog({
    required this.prepaidDiscount,
    required this.groupType,
    required this.shippingChart,
    required this.offerJson,
    required this.groupId,
    required this.catalogTitle,
    required this.startingPrice,
    required this.numLikes,
    required this.dealerDiscount,
    required this.products,
    required this.catalogId,
    required this.whatsAppPrice,
    required this.startingPriceWOSale,
    required this.isOnSale,
    required this.maxMargin,
    required this.groupOwnerId,
    required this.sourceCatalogId,
    required this.isCodAvailable,
    required this.maxCoinsPerOrder,
    required this.maxMrp,
    required this.isBrandCat,
    required this.customerPrice,
    required this.isHidden,
    required this.couponDiscount,
    required this.groupName,
    required this.couponDiscountApplied,
    required this.planNo,
    required this.numShares,
    required this.salePercent,
    required this.firstOrder,
    required this.catalogDesc,
    required this.lastPromotedTime,
    required this.maxCashbackPerOrder,
    required this.isCodFree,
    required this.categoryId,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
      prepaidDiscount: json['prepaidDiscount'] as int,
      groupType: json['groupType'] as int,
      shippingChart: ShippingChart.fromJson(json['shippingChart'] as Map<String, dynamic>),
      offerJson: (json['offerJson'] as List<dynamic>)
          .map((e) => Offer.fromJson(e as Map<String, dynamic>))
          .toList(),
      groupId: json['groupId'] as int,
      catalogTitle: json['catalogTitle'] as String,
      startingPrice: (json['startingPrice'] as num).toDouble(),
      numLikes: json['numLikes'] as int,
      dealerDiscount: json['dealerDiscount'] as int,
      products: (json['products'] as List<dynamic>)
          .map((e) => Product.fromJson(e as Map<String, dynamic>))
          .toList(),
      catalogId: json['catalogId'] as int,
      whatsAppPrice: (json['whatsAppPrice'] as num).toDouble(),
      startingPriceWOSale: (json['startingPriceWOSale'] as num).toDouble(),
      isOnSale: json['isOnSale'] as bool,
      maxMargin: (json['maxMargin'] as num).toDouble(),
      groupOwnerId: json['groupOwnerId'] as int,
      sourceCatalogId: json['sourceCatalogId'] as int,
      isCodAvailable: json['isCodAvailable'] as bool,
      maxCoinsPerOrder: json['maxCoinsPerOrder'] as int,
      maxMrp: (json['maxMrp'] as num).toDouble(),
      isBrandCat: json['isBrandCat'] as bool,
      customerPrice: (json['customerPrice'] as num).toDouble(),
      isHidden: json['isHidden'] as bool,
      couponDiscount: json['couponDiscount'] as int,
      groupName: json['groupName'] as String,
      couponDiscountApplied: json['couponDiscountApplied'] as int,
      planNo: json['planNo'] as int,
      numShares: json['numShares'] as int,
      salePercent: (json['salePercent'] as num).toDouble(),
      firstOrder: json['firstOrder'] as int,
      catalogDesc: json['catalogDesc'] as String,
      lastPromotedTime: json['lastPromotedTime'] as String,
      maxCashbackPerOrder: json['maxCashbackPerOrder'] as int,
      isCodFree: json['isCodFree'] as bool,
      categoryId: json['categoryId'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prepaidDiscount': prepaidDiscount,
      'groupType': groupType,
      'shippingChart': shippingChart.toJson(),
      'offerJson': offerJson.map((e) => e.toJson()).toList(),
      'groupId': groupId,
      'catalogTitle': catalogTitle,
      'startingPrice': startingPrice,
      'numLikes': numLikes,
      'dealerDiscount': dealerDiscount,
      'products': products.map((e) => e.toJson()).toList(),
      'catalogId': catalogId,
      'whatsAppPrice': whatsAppPrice,
      'startingPriceWOSale': startingPriceWOSale,
      'isOnSale': isOnSale,
      'maxMargin': maxMargin,
      'groupOwnerId': groupOwnerId,
      'sourceCatalogId': sourceCatalogId,
      'isCodAvailable': isCodAvailable,
      'maxCoinsPerOrder': maxCoinsPerOrder,
      'maxMrp': maxMrp,
      'isBrandCat': isBrandCat,
      'customerPrice': customerPrice,
      'isHidden': isHidden,
      'couponDiscount': couponDiscount,
      'groupName': groupName,
      'couponDiscountApplied': couponDiscountApplied,
      'planNo': planNo,
      'numShares': numShares,
      'salePercent': salePercent,
      'firstOrder': firstOrder,
      'catalogDesc': catalogDesc,
      'lastPromotedTime': lastPromotedTime,
      'maxCashbackPerOrder': maxCashbackPerOrder,
      'isCodFree': isCodFree,
      'categoryId': categoryId,
    };
  }
}

// ShippingChart model
class ShippingChart {
  final int for1;

  ShippingChart({required this.for1});

  factory ShippingChart.fromJson(Map<String, dynamic> json) {
    return ShippingChart(
      for1: json['for1'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'for1': for1,
    };
  }
}

// Offer model
class Offer {
  final String couponCode;
  final String couponType;
  final int couponAmount;

  Offer({
    required this.couponCode,
    required this.couponType,
    required this.couponAmount,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      couponCode: json['couponCode'] as String,
      couponType: json['couponType'] as String,
      couponAmount: json['couponAmount'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'couponCode': couponCode,
      'couponType': couponType,
      'couponAmount': couponAmount,
    };
  }
}

// Product model
class Product {
  final int totalQuantity;
  final String productCode;
  final int productId;
  final double salePrice;
  final int coinsPerOrder;
  final double price;
  final double whatsAppPrice;
  final int cashbackPerOrder;
  final String imageUrl;
  final double mrp;
  final double suggestedCustomerPrice;
  final double customerPrice;

  Product({
    required this.totalQuantity,
    required this.productCode,
    required this.productId,
    required this.salePrice,
    required this.coinsPerOrder,
    required this.price,
    required this.whatsAppPrice,
    required this.cashbackPerOrder,
    required this.imageUrl,
    required this.mrp,
    required this.suggestedCustomerPrice,
    required this.customerPrice,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      totalQuantity: json['totalQuantity'] as int,
      productCode: json['productCode'] as String,
      productId: json['productId'] as int,
      salePrice: (json['salePrice'] as num).toDouble(),
      coinsPerOrder: json['coinsPerOrder'] as int,
      price: (json['price'] as num).toDouble(),
      whatsAppPrice: (json['whatsAppPrice'] as num).toDouble(),
      cashbackPerOrder: json['cashbackPerOrder'] as int,
      imageUrl: json['imageUrl'] as String,
      mrp: (json['mrp'] as num).toDouble(),
      suggestedCustomerPrice: (json['suggestedCustomerPrice'] as num).toDouble(),
      customerPrice: (json['customerPrice'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalQuantity': totalQuantity,
      'productCode': productCode,
      'productId': productId,
      'salePrice': salePrice,
      'coinsPerOrder': coinsPerOrder,
      'price': price,
      'whatsAppPrice': whatsAppPrice,
      'cashbackPerOrder': cashbackPerOrder,
      'imageUrl': imageUrl,
      'mrp': mrp,
      'suggestedCustomerPrice': suggestedCustomerPrice,
      'customerPrice': customerPrice,
    };
  }
}

// Root response model (unchanged)
class ResponseModel3 {
  final bool error;
  final int errorType;
  final int amountToAdd;
  final int statusCode;
  final String message;
  final GroupData data;

  ResponseModel3({
    required this.error,
    required this.errorType,
    required this.amountToAdd,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  factory ResponseModel3.fromJson(Map<String, dynamic> json) {
    return ResponseModel3(
      error: json['error'] as bool,
      errorType: json['errorType'] as int,
      amountToAdd: json['amountToAdd'] as int,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: GroupData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'errorType': errorType,
      'amountToAdd': amountToAdd,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

// Updated GroupData model with nullable fields
class GroupData {
  final String? groupCatalogCreativeUrl;
  final int? ownerStatus;
  final String? city;
  final int? salePer;
  final String? lastCatalogTime;
  final List<Offer2>? offerJson;
  final int? groupId;
  final int? ownerId;
  final String? categoryName;
  final String? participantInviteLink;
  final int? groupPlan;
  final String? shortInfo;
  final String? ownerName;
  final bool? isOwner;
  final int? chatNumber;
  final bool? isPublic;
  final String? ownerInviteLink;
  final bool? isShippingFree;
  final String? lastCatalogName;
  final String? groupVideoId;
  final int? maxMargin;
  final bool? isCodAvailable;
  final bool? isPinned;
  final int? maxCoinsPerOrder;
  final bool? isVisitor;
  final int? returnPolicy;
  final String? ownerDpUrl;
  final int? promotionScore;
  final int? counter;
  final String? groupName;
  final String? createdDate;
  final String? dpUrl;
  final bool? isShipsafeEnabled;
  final int? verificationType;
  final int? maxCashbackPerOrder;

  GroupData({
    this.groupCatalogCreativeUrl = "",
    this.ownerStatus,
    this.city = "",
    this.salePer,
    this.lastCatalogTime = "",
    this.offerJson,
    this.groupId,
    this.ownerId,
    this.categoryName = "",
    this.participantInviteLink = "",
    this.groupPlan,
    this.shortInfo = "",
    this.ownerName = "",
    this.isOwner,
    this.chatNumber = 0,
    this.isPublic,
    this.ownerInviteLink = "",
    this.isShippingFree,
    this.lastCatalogName = "",
    this.groupVideoId = "",
    this.maxMargin,
    this.isCodAvailable,
    this.isPinned,
    this.maxCoinsPerOrder,
    this.isVisitor,
    this.returnPolicy,
    this.ownerDpUrl = "",
    this.promotionScore,
    this.counter,
    this.groupName = "",
    this.createdDate = "",
    this.dpUrl = "",
    this.isShipsafeEnabled,
    this.verificationType,
    this.maxCashbackPerOrder,
  });

  factory GroupData.fromJson(Map<String, dynamic> json) {
    return GroupData(
      groupCatalogCreativeUrl: json['groupCatalogCreativeUrl'] as String? ?? "",
      ownerStatus: json['ownerStatus'] as int?,
      city: json['city'] as String? ?? "",
      salePer: json['salePer'] as int?,
      lastCatalogTime: json['lastCatalogTime'] as String? ?? "",
      offerJson: (json['offerJson'] as List<dynamic>?)?.map((e) => Offer2.fromJson(e as Map<String, dynamic>)).toList(),
      groupId: json['groupId'] as int?,
      ownerId: json['ownerId'] as int?,
      categoryName: json['categoryName'] as String? ?? "",
      participantInviteLink: json['participantInviteLink'] as String? ?? "",
      groupPlan: json['groupPlan'] as int?,
      shortInfo: json['shortInfo'] as String? ?? "",
      ownerName: json['ownerName'] as String? ?? "",
      isOwner: json['isOwner'] as bool?,
      chatNumber: json['chatNumber'] as int? ?? 0,
      isPublic: json['isPublic'] as bool?,
      ownerInviteLink: json['ownerInviteLink'] as String? ?? "",
      isShippingFree: json['isShippingFree'] as bool?,
      lastCatalogName: json['lastCatalogName'] as String? ?? "",
      groupVideoId: json['groupVideoId'] as String? ?? "",
      maxMargin: json['maxMargin'] as int?,
      isCodAvailable: json['isCodAvailable'] as bool?,
      isPinned: json['isPinned'] as bool?,
      maxCoinsPerOrder: json['maxCoinsPerOrder'] as int?,
      isVisitor: json['isVisitor'] as bool?,
      returnPolicy: json['returnPolicy'] as int?,
      ownerDpUrl: json['ownerDpUrl'] as String? ?? "",
      promotionScore: json['promotionScore'] as int?,
      counter: json['counter'] as int?,
      groupName: json['groupName'] as String? ?? "",
      createdDate: json['createdDate'] as String? ?? "",
      dpUrl: json['dpUrl'] as String? ?? "",
      isShipsafeEnabled: json['isShipsafeEnabled'] as bool?,
      verificationType: json['verificationType'] as int?,
      maxCashbackPerOrder: json['maxCashbackPerOrder'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'groupCatalogCreativeUrl': groupCatalogCreativeUrl,
      'ownerStatus': ownerStatus,
      'city': city,
      'salePer': salePer,
      'lastCatalogTime': lastCatalogTime,
      'offerJson': offerJson?.map((e) => e.toJson()).toList(),
      'groupId': groupId,
      'ownerId': ownerId,
      'categoryName': categoryName,
      'participantInviteLink': participantInviteLink,
      'groupPlan': groupPlan,
      'shortInfo': shortInfo,
      'ownerName': ownerName,
      'isOwner': isOwner,
      'chatNumber': chatNumber,
      'isPublic': isPublic,
      'ownerInviteLink': ownerInviteLink,
      'isShippingFree': isShippingFree,
      'lastCatalogName': lastCatalogName,
      'groupVideoId': groupVideoId,
      'maxMargin': maxMargin,
      'isCodAvailable': isCodAvailable,
      'isPinned': isPinned,
      'maxCoinsPerOrder': maxCoinsPerOrder,
      'isVisitor': isVisitor,
      'returnPolicy': returnPolicy,
      'ownerDpUrl': ownerDpUrl,
      'promotionScore': promotionScore,
      'counter': counter,
      'groupName': groupName,
      'createdDate': createdDate,
      'dpUrl': dpUrl,
      'isShipsafeEnabled': isShipsafeEnabled,
      'verificationType': verificationType,
      'maxCashbackPerOrder': maxCashbackPerOrder,
    };
  }
}

// Offer model (unchanged)
class Offer2 {
  final String? couponCode;
  final String? couponType;
  final int? couponAmount;

  Offer2({
    this.couponCode = "",
    this.couponType = "",
    this.couponAmount,
  });

  factory Offer2.fromJson(Map<String, dynamic> json) {
    return Offer2(
      couponCode: json['couponCode'] as String? ?? "",
      couponType: json['couponType'] as String? ?? "",
      couponAmount: json['couponAmount'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'couponCode': couponCode,
      'couponType': couponType,
      'couponAmount': couponAmount,
    };
  }
}

/// Represents the root response object for the group profile.
class GroupProfileResponse {
  final bool error;
  final int errorType;
  final int amountToAdd;
  final int statusCode;
  final String message;
  final GroupProfileData data;

  GroupProfileResponse({
    required this.error,
    required this.errorType,
    required this.amountToAdd,
    required this.statusCode,
    required this.message,
    required this.data,
  });

  /// Factory method to create a [GroupProfileResponse] from JSON.
  factory GroupProfileResponse.fromJson(Map<String, dynamic> json) {
    return GroupProfileResponse(
      error: json['error'] as bool,
      errorType: json['errorType'] as int,
      amountToAdd: json['amountToAdd'] as int,
      statusCode: json['statusCode'] as int,
      message: json['message'] as String,
      data: GroupProfileData.fromJson(json['data'] as Map<String, dynamic>),
    );
  }

  /// Converts the [GroupProfileResponse] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'error': error,
      'errorType': errorType,
      'amountToAdd': amountToAdd,
      'statusCode': statusCode,
      'message': message,
      'data': data.toJson(),
    };
  }
}

/// Represents the nested data object in the group profile response.
class GroupProfileData {
  final double? rating; // Average rating of the group (nullable)
  final int? numRatings; // Number of ratings received (nullable)
  final int? connections; // Number of connections/followers (nullable)

  GroupProfileData({
    this.rating = 0.0, // Default to 0.0 if null
    this.numRatings = 0, // Default to 0 if null
    this.connections = 0, // Default to 0 if null
  });

  /// Factory method to create a [GroupProfileData] from JSON.
  factory GroupProfileData.fromJson(Map<String, dynamic> json) {
    print('Parsing JSON: $json'); // Debug log
    return GroupProfileData(
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      numRatings: json['numRatings'] as int? ?? 0,
      connections: json['connections'] as int? ?? 0,
    );
  }

  /// Converts the [GroupProfileData] object to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'rating': rating,
      'numRatings': numRatings,
      'connections': connections,
    };
  }

  @override
  String toString() {
    return 'GroupProfileData{rating: $rating, numRatings: $numRatings, connections: $connections}';
  } // Custom toString for better debugging
}