// For demo only
import 'package:ResellMe/constants.dart';



class CatalogData {
  int prepaidDiscount;
  int groupType;
  ShippingChart shippingChart;
  int groupId;
  String catalogTitle;
  double startingPrice;
  int numLikes;
  List<Product> products;
  int catalogId;
  int reviewCount;
  double whatsAppPrice;
  double startingPriceWOSale;
  bool isOnSale;
  double maxMargin;
  int groupOwnerId;
  int sourceCatalogId;
  bool isCodAvailable;
  double maxMrp;
  bool isBrandCat;
  double customerPrice;
  bool isHidden;
  int commentCount;
  String groupName;
  int planNo;
  int numShares;
  double salePercent;
  String catalogDesc;
  String lastPromotedTime;
  double maxCashbackPerOrder;
  bool isCodFree;

  CatalogData({
    required this.prepaidDiscount,
    required this.groupType,
    required this.shippingChart,
    required this.groupId,
    required this.catalogTitle,
    required this.startingPrice,
    required this.numLikes,
    required this.products,
    required this.catalogId,
    required this.reviewCount,
    required this.whatsAppPrice,
    required this.startingPriceWOSale,
    required this.isOnSale,
    required this.maxMargin,
    required this.groupOwnerId,
    required this.sourceCatalogId,
    required this.isCodAvailable,
    required this.maxMrp,
    required this.isBrandCat,
    required this.customerPrice,
    required this.isHidden,
    required this.commentCount,
    required this.groupName,
    required this.planNo,
    required this.numShares,
    required this.salePercent,
    required this.catalogDesc,
    required this.lastPromotedTime,
    required this.maxCashbackPerOrder,
    required this.isCodFree,
  });

  factory CatalogData.fromJson(Map<String, dynamic> json) {
    return CatalogData(
      prepaidDiscount: json['prepaidDiscount'],
      groupType: json['groupType'],
      shippingChart: ShippingChart.fromJson(json['shippingChart']),
      groupId: json['groupId'],
      catalogTitle: json['catalogTitle'],
      startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 0.0,
      numLikes: json['numLikes'],
      products: (json['products'] as List<dynamic>).map((e) => Product.fromJson(e)).toList(),
      catalogId: json['catalogId'],
      reviewCount: json['reviewCount'],
      whatsAppPrice:  (json['whatsAppPrice'] as num?)?.toDouble() ?? 0.0,
      startingPriceWOSale: (json['startingPriceWOSale'] as num?)?.toDouble() ?? 0.0,
      isOnSale: json['isOnSale'] as bool? ?? false,
      maxMargin:(json['maxMargin'] as num?)?.toDouble() ?? 0.0,
      groupOwnerId: json['groupOwnerId'],
      sourceCatalogId: json['sourceCatalogId'],
      isCodAvailable: json['isCodAvailable'] as bool? ?? false,
      maxMrp:  (json['maxMrp'] as num?)?.toDouble() ?? 0.0,
      isBrandCat: json['isBrandCat'] as bool? ?? false,
      customerPrice:  (json['customerPrice'] as num?)?.toDouble() ?? 0.0,
      isHidden: json['isHidden'] as bool? ?? false,
      commentCount: json['commentCount'],
      groupName: json['groupName'],
      planNo: json['planNo'],
      numShares: json['numShares'],
      salePercent: (json['salePercent'] as num?)?.toDouble() ?? 0.0,
      catalogDesc: json['catalogDesc'],
      lastPromotedTime: json['lastPromotedTime'],
      maxCashbackPerOrder: (json['maxCashbackPerOrder'] as num?)?.toDouble() ?? 0.0,
      isCodFree: json['isCodFree'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() => {
    'prepaidDiscount': prepaidDiscount,
    'groupType': groupType,
    'shippingChart': shippingChart.toJson(),
    'groupId': groupId,
    'catalogTitle': catalogTitle,
    'startingPrice': startingPrice,
    'numLikes': numLikes,
    'products': products.map((e) => e.toJson()).toList(),
    'catalogId': catalogId,
    'reviewCount': reviewCount,
    'whatsAppPrice': whatsAppPrice,
    'startingPriceWOSale': startingPriceWOSale,
    'isOnSale': isOnSale,
    'maxMargin': maxMargin,
    'groupOwnerId': groupOwnerId,
    'sourceCatalogId': sourceCatalogId,
    'isCodAvailable': isCodAvailable,
    'maxMrp': maxMrp,
    'isBrandCat': isBrandCat,
    'customerPrice': customerPrice,
    'isHidden': isHidden,
    'commentCount': commentCount,
    'groupName': groupName,
    'planNo': planNo,
    'numShares': numShares,
    'salePercent': salePercent,
    'catalogDesc': catalogDesc,
    'lastPromotedTime': lastPromotedTime,
    'maxCashbackPerOrder': maxCashbackPerOrder,
    'isCodFree': isCodFree,
  };
}

class ShippingChart {
  int for1;

  ShippingChart({
    required this.for1,
  });

  factory ShippingChart.fromJson(Map<String, dynamic> json) {
    return ShippingChart(
      for1: json['for1'],
    );
  }

  Map<String, dynamic> toJson() => {
    'for1': for1,
  };
}

class Product {
  bool? isOrderable;
  String productCode;
  int productId;
  double salePrice;
  int coinsPerOrder;
  double price;
  double whatsAppPrice;
  int cashbackPerOrder;
  String imageUrl;
  double mrp;
  double suggestedCustomerPrice;
  double customerPrice;

  Product({
    this.isOrderable,
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

  // Factory constructor to parse JSON into a Product object
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      isOrderable: json['isOrderable'] as bool? ?? true,
      productCode: json['productCode'] ?? '',
      productId: json['productId'] ?? 0,
      salePrice: (json['salePrice'] as num?)?.toDouble() ?? 0.0,
      coinsPerOrder: json['coinsPerOrder'] ?? 0,
      price: (json['price'] as num?)?.toDouble() ?? 0.0,
      whatsAppPrice: (json['whatsAppPrice'] as num?)?.toDouble() ?? 0.0,
      cashbackPerOrder: json['cashbackPerOrder'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      suggestedCustomerPrice: (json['suggestedCustomerPrice'] as num?)?.toDouble() ?? 0.0,
      customerPrice: (json['customerPrice'] as num?)?.toDouble() ?? 0.0,
    );
  }

  // Converts the Product object back to JSON
  Map<String, dynamic> toJson() {
    return {
      'isOrderable': isOrderable ?? true,
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



class SizeInfo {
  final String size;
  final int quantityAvl;

  SizeInfo({
    required this.size,
    required this.quantityAvl,
  });

  // Implementing fromJson
  factory SizeInfo.fromJson(Map<String, dynamic> json) {
    return SizeInfo(
        quantityAvl: json['sizeQuantity'] as int? ?? 0,
        size: json['sizeText'] as String? ?? ''
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sizeString': size,
      'sizeText': size,  // Assuming sizeText is the same as sizeString
      'sizeQuantity': quantityAvl,
    };
  }
}


class ProductSize {
  final String productCode;
  final int productId;
  final List<StockInfo> stockInfo;
  final double salePrice;
  final double whatsAppPrice;
  final String imageUrl;
  final String largeImageUrl;
  final String additionalInfo;
  final int sourceProductId;
  final double customerPrice;
  final double productPrice;

  ProductSize({
    required this.productCode,
    required this.productId,
    required this.stockInfo,
    required this.salePrice,
    required this.whatsAppPrice,
    required this.imageUrl,
    required this.largeImageUrl,
    required this.additionalInfo,
    required this.sourceProductId,
    required this.customerPrice,
    required this.productPrice,
  });

  factory ProductSize.fromJson(Map<String, dynamic> json) {
    return ProductSize(
      productCode: json['productCode'],
      productId: json['productId'],
      stockInfo: (json['stockInfo'] as List)
          .map((e) => StockInfo.fromJson(e))
          .toList(),
      salePrice: json['salePrice'].toDouble(),
      whatsAppPrice: json['whatsAppPrice'].toDouble(),
      imageUrl: json['imageUrl'],
      largeImageUrl: json['largeImageUrl'],
      additionalInfo: json['additionalInfo'],
      sourceProductId: json['sourceProductId'],
      customerPrice: json['customerPrice'].toDouble(),
      productPrice: json['productPrice'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productCode': productCode,
      'productId': productId,
      'stockInfo': stockInfo.map((e) => e.toJson()).toList(),
      'salePrice': salePrice,
      'whatsAppPrice': whatsAppPrice,
      'imageUrl': imageUrl,
      'largeImageUrl': largeImageUrl,
      'additionalInfo': additionalInfo,
      'sourceProductId': sourceProductId,
      'customerPrice': customerPrice,
      'productPrice': productPrice,
    };
  }
}

class StockInfo {
  final int sizeQuantity;
  final String sizeText;
  final String sizeString;

  StockInfo({
    required this.sizeQuantity,
    required this.sizeText,
    required this.sizeString,
  });

  factory StockInfo.fromJson(Map<String, dynamic> json) {
    return StockInfo(
      sizeQuantity: json['sizeQuantity'],
      sizeText: json['sizeText'],
      sizeString: json['sizeString'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sizeQuantity': sizeQuantity,
      'sizeText': sizeText,
      'sizeString': sizeString,
    };
  }
}


class ProductJsonList {
  final List<ProductJson> productJson;

  ProductJsonList({required this.productJson});

  factory ProductJsonList.fromJson(Map<String, dynamic> json) {
    return ProductJsonList(
      productJson: (json['productJson'] as List)
          .map((item) => ProductJson.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productJson': productJson.map((item) => item.toJson()).toList(),
    };
  }
}

class ProductJson {
  final int? productId;
  final int? quantity;

  ProductJson({this.productId, this.quantity});

  factory ProductJson.fromJson(Map<String, dynamic> json) {
    return ProductJson(
      productId: json['productId'] as int?,
      quantity: json['Quantity'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productId': productId,
      'Quantity': quantity,
    };
  }
}

