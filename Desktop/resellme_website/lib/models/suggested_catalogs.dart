

class Section {
  String tag;
  int sectionId;
  String type;
  String title;
  String imageUrl;
  List<SectionData> data;

  Section({
    required this.tag,
    required this.sectionId,
    required this.type,
    required this.title,
    required this.imageUrl,
    required this.data,
  });

  factory Section.fromJson(Map<String, dynamic> json) {
    return Section(
      tag: json['tag'] ?? '',
      sectionId: json['sectionId'] ?? 0,
      type: json['type'] ?? '',
      title: json['title'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      data: List<SectionData>.from(json['data']?.map((x) => SectionData.fromJson(x)) ?? []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tag': tag,
      'sectionId': sectionId,
      'type': type,
      'title': title,
      'imageUrl': imageUrl,
      'data': List<dynamic>.from(data.map((x) => x.toJson())),
    };
  }
}

class SectionData {
  int ownerStatus;
  int salePer;
  String city;
  String lastCatalogTime;
  Catalog catalog;
  int groupId;
  int ownerId;
  String categoryName;
  String participantInviteLink;
  int groupPlan;
  String shortInfo;
  String ownerName;
  bool isOwner;
  int chatNumber;
  bool isPublic;
  String ownerInviteLink;
  bool isShippingFree;
  String lastCatalogName;
  String groupVideoId;
  double maxMargin;
  bool isCodAvailable;
  double maxCoinsPerOrder;
  bool isPinned;
  bool isVisitor;
  int returnPolicy;
  String ownerDpUrl;
  int promotionScore;
  int counter;
  String groupName;
  String createdDate;
  String dpUrl;
  bool isShipsafeEnabled;
  int verificationType;
  double maxCashbackPerOrder;
  bool isCodFree;
  int categoryId;
  List<Offer> offerJson;


  SectionData({
    required this.ownerStatus,
    required this.salePer,
    required this.city,
    required this.lastCatalogTime,
    required this.offerJson,
    required this.catalog,
    required this.groupId,
    required this.ownerId,
    required this.categoryName,
    required this.participantInviteLink,
    required this.groupPlan,
    required this.shortInfo,
    required this.ownerName,
    required this.isOwner,
    required this.chatNumber,
    required this.isPublic,
    required this.ownerInviteLink,
    required this.isShippingFree,
    required this.lastCatalogName,
    required this.groupVideoId,
    required this.maxMargin,
    required this.isCodAvailable,
    required this.maxCoinsPerOrder,
    required this.isPinned,
    required this.isVisitor,
    required this.returnPolicy,
    required this.ownerDpUrl,
    required this.promotionScore,
    required this.counter,
    required this.groupName,
    required this.createdDate,
    required this.dpUrl,
    required this.isShipsafeEnabled,
    required this.verificationType,
    required this.maxCashbackPerOrder,
    required this.isCodFree,
    required this.categoryId,
  });

  factory SectionData.fromJson(Map<String, dynamic> json) {
    return SectionData(
      ownerStatus: json['ownerStatus'] ?? 0,
      salePer: json['salePer'] ?? 0,
      city: json['city'] ?? '',
      lastCatalogTime: json['lastCatalogTime'] ?? '',
      offerJson: List<Offer>.from(json['offerJson']?.map((x) => Offer.fromJson(x)) ?? []),
      catalog: Catalog.fromJson(json['catalog'] ?? {}),
      groupId: json['groupId'] ?? 0,
      ownerId: json['ownerId'] ?? 0,
      categoryName: json['categoryName'] ?? '',
      participantInviteLink: json['participantInviteLink'] ?? '',
      groupPlan: json['groupPlan'] ?? 0,
      shortInfo: json['shortInfo'] ?? '',
      ownerName: json['ownerName'] ?? '',
      isOwner: json['isOwner'] ?? false,
      chatNumber: json['chatNumber'] ?? 0,
      isPublic: json['isPublic'] ?? false,
      ownerInviteLink: json['ownerInviteLink'] ?? '',
      isShippingFree: json['isShippingFree'] ?? false,
      lastCatalogName: json['lastCatalogName'] ?? '',
      groupVideoId: json['groupVideoId'] ?? '',
      maxMargin:  (json['maxMargin'] is num) ? (json['maxMargin'] as num).toDouble() : 0.0,
      isCodAvailable: json['isCodAvailable'] ?? false,
      maxCoinsPerOrder:  (json['maxCoinsPerOrder'] is num) ? (json['maxCoinsPerOrder'] as num).toDouble() : 0.0,
      isPinned: json['isPinned'] ?? false,
      isVisitor: json['isVisitor'] ?? false,
      returnPolicy: json['returnPolicy'] ?? 0,
      ownerDpUrl: json['ownerDpUrl'] ?? '',
      promotionScore: json['promotionScore'] ?? 0,
      counter: json['counter'] ?? 0,
      groupName: json['groupName'] ?? '',
      createdDate: json['createdDate'] ?? '',
      dpUrl: json['dpUrl'] ?? '',
      isShipsafeEnabled: json['isShipsafeEnabled'] ?? false,
      verificationType: json['verificationType'] ?? 0,
      maxCashbackPerOrder:  (json['maxCashbackPerOrder'] is num) ? (json['maxCashbackPerOrder'] as num).toDouble() : 0.0,
      isCodFree: json['isCodFree'] ?? false,
      categoryId: json['categoryId'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerStatus': ownerStatus,
      'salePer': salePer,
      'city': city,
      'lastCatalogTime': lastCatalogTime,
      'offerJson': List<dynamic>.from(offerJson.map((x) => x.toJson())),
      'catalog': catalog.toJson(),
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
      'maxCoinsPerOrder': maxCoinsPerOrder,
      'isPinned': isPinned,
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
      'isCodFree': isCodFree,
      'categoryId': categoryId,
    };
  }
}

class Offer {
  String couponCode;
  String couponType;
  int couponAmount;

  Offer({
    required this.couponCode,
    required this.couponType,
    required this.couponAmount,
  });

  factory Offer.fromJson(Map<String, dynamic> json) {
    return Offer(
      couponCode: json['couponCode'] ?? '',
      couponType: json['couponType'] ?? '',
      couponAmount: json['couponAmount'] ?? 0,
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

class Catalog {
  int prepaidDiscount;
  double mrp;
  double startingPrice;
  double customerPrice;
  int commentCount;
  List<Product> products;
  int dealerDiscount;
  String catalogName;
  int shares;
  int couponDiscount;
  int catalogId;
  String promotedTime;
  int couponDiscountApplied;
  int reviewCount;
  double whatsAppPrice;
  int firstOrder;
  String catalogDesc;
  List<String> commentUserDpList;
  int likes;

  Catalog({
    required this.prepaidDiscount,
    required this.mrp,
    required this.startingPrice,
    required this.customerPrice,
    required this.commentCount,
    required this.products,
    required this.dealerDiscount,
    required this.catalogName,
    required this.shares,
    required this.couponDiscount,
    required this.catalogId,
    required this.promotedTime,
    required this.couponDiscountApplied,
    required this.reviewCount,
    required this.whatsAppPrice,
    required this.firstOrder,
    required this.catalogDesc,
    required this.commentUserDpList,
    required this.likes,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) {

    return Catalog(
      prepaidDiscount: (json['prepaidDiscount'] is num) ? (json['prepaidDiscount'] as num).toInt() : 0,
      mrp: (json['mrp'] is num) ? (json['mrp'] as num).toDouble() : 0.0,
      startingPrice: (json['startingPrice'] is num) ? (json['startingPrice'] as num).toDouble() : 0.0,
      customerPrice: (json['customerPrice'] is num) ? (json['customerPrice'] as num).toDouble() : 0.0,
      commentCount: (json['commentCount'] is num) ? (json['commentCount'] as num).toInt() : 0,
      products: List<Product>.from(json['products']?.map((x) => Product.fromJson(x)) ?? []),
      dealerDiscount: (json['dealerDiscount'] is num) ? (json['dealerDiscount'] as num).toInt() : 0,
      catalogName: json['catalogName'] ?? '',
      shares: (json['shares'] is num) ? (json['shares'] as num).toInt() : 0,
      couponDiscount: (json['couponDiscount'] is num) ? (json['couponDiscount'] as num).toInt() : 0,
      catalogId: (json['catalogId'] is num) ? (json['catalogId'] as num).toInt() : 0,
      promotedTime: json['promotedTime'] ?? '',
      couponDiscountApplied: (json['couponDiscountApplied'] is num) ? (json['couponDiscountApplied'] as num).toInt() : 0,
      reviewCount: (json['reviewCount'] is num) ? (json['reviewCount'] as num).toInt() : 0,
      whatsAppPrice: (json['whatsAppPrice'] is num) ? (json['whatsAppPrice'] as num).toDouble() : 0.0,
      firstOrder: (json['firstOrder'] is num) ? (json['firstOrder'] as num).toInt() : 0,
      catalogDesc: json['catalogDesc'] ?? '',
      commentUserDpList: List<String>.from(json['commentUserDpList']?.map((x) => x) ?? []),
      likes: (json['likes'] is num) ? (json['likes'] as num).toInt() : 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prepaidDiscount': prepaidDiscount,
      'mrp': mrp,
      'startingPrice': startingPrice,
      'customerPrice': customerPrice,
      'commentCount': commentCount,
      'products': List<dynamic>.from(products.map((x) => x.toJson())),
      'dealerDiscount': dealerDiscount,
      'catalogName': catalogName,
      'shares': shares,
      'couponDiscount': couponDiscount,
      'catalogId': catalogId,
      'promotedTime': promotedTime,
      'couponDiscountApplied': couponDiscountApplied,
      'reviewCount': reviewCount,
      'whatsAppPrice': whatsAppPrice,
      'firstOrder': firstOrder,
      'catalogDesc': catalogDesc,
      'commentUserDpList': List<dynamic>.from(commentUserDpList.map((x) => x)),
      'likes': likes,
    };
  }
}

class Product {
  String productCode;
  int productId;
  String imageUrl;

  Product({
    required this.productCode,
    required this.productId,
    required this.imageUrl,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      productCode: json['productCode'] ?? '',
      productId: json['productId'] ?? 0,
      imageUrl: json['imageUrl'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'productCode': productCode,
      'productId': productId,
      'imageUrl': imageUrl,
    };
  }
}
