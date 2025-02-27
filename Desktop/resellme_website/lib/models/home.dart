import 'Cart.dart'; // Assuming this is correct; ensure Cart.dart exists if needed

class ResponseModel {
  final bool error;
  final int errorType;
  final int amountToAdd;
  final int statusCode;
  final String? message;
  final List<DataSection> data;

  ResponseModel({
    required this.error,
    required this.errorType,
    required this.amountToAdd,
    required this.statusCode,
    this.message,
    required this.data,
  });

  factory ResponseModel.fromJson(Map<String, dynamic> json) {
    return ResponseModel(
      error: json['error'] as bool? ?? false,
      errorType: json['errorType'] as int? ?? 0,
      amountToAdd: json['amountToAdd'] as int? ?? 0,
      statusCode: json['statusCode'] as int? ?? 0,
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>? ?? [])
          .map((item) => DataSection.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }
}

class DataSection {
  final List<dynamic> data;
  final String? imageUrl;
  final String? tag;
  final int sectionId;
  final String? title;
  final String? type;

  DataSection({
    required this.data,
    this.imageUrl,
    this.tag,
    required this.sectionId,
    this.title,
    this.type,
  });

  factory DataSection.fromJson(Map<String, dynamic> json) {
    final type = json['type'] as String?;
    switch (type) {
      case 'banner':
        return BannerSection.fromJson(json);
      case 'reelsNew':
        return ReelsSection.fromJson(json);
      case 'singleCatalog':
        return SingleCatalogSection.fromJson(json);
      case 'newGroups':
        return NewGroupsSection.fromJson(json);
      default:
        return DataSection(
          data: json['data'] as List<dynamic>? ?? [],
          imageUrl: json['imageUrl'] as String?,
          tag: json['tag'] as String?,
          sectionId: json['sectionId'] as int? ?? 0,
          title: json['title'] as String?,
          type: type,
        );
    }
  }
}

class BannerSection extends DataSection {
  final List<Banner> banners;

  BannerSection({
    required this.banners,
    String? imageUrl,
    String? tag,
    required int sectionId,
    String? title,
    String? type,
  }) : super(data: banners, imageUrl: imageUrl, tag: tag, sectionId: sectionId, title: title, type: type);

  factory BannerSection.fromJson(Map<String, dynamic> json) {
    return BannerSection(
      banners: (json['data'] as List<dynamic>? ?? [])
          .map((item) => Banner.fromJson(item as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      tag: json['tag'] as String?,
      sectionId: json['sectionId'] as int? ?? 0,
      title: json['title'] as String?,
      type: json['type'] as String?,
    );
  }
}

class Banner {
  final String? bannerType;
  final int bannerId;
  final String? imageUrl;
  final String? bannerUrl;
  final String? bannerName;

  Banner({
    this.bannerType,
    required this.bannerId,
    this.imageUrl,
    this.bannerUrl,
    this.bannerName,
  });

  factory Banner.fromJson(Map<String, dynamic> json) {
    return Banner(
      bannerType: json['bannerType'] as String?,
      bannerId: json['bannerId'] as int? ?? 0,
      imageUrl: json['imageUrl'] as String?,
      bannerUrl: json['bannerUrl'] as String?,
      bannerName: json['bannerName'] as String?,
    );
  }
}

class ReelsSection extends DataSection {
  final List<Reel> reels;

  ReelsSection({
    required this.reels,
    String? imageUrl,
    String? tag,
    required int sectionId,
    String? title,
    String? type,
  }) : super(data: reels, imageUrl: imageUrl, tag: tag, sectionId: sectionId, title: title, type: type);

  factory ReelsSection.fromJson(Map<String, dynamic> json) {
    return ReelsSection(
      reels: (json['data'] as List<dynamic>? ?? [])
          .map((item) => Reel.fromJson(item as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      tag: json['tag'] as String?,
      sectionId: json['sectionId'] as int? ?? 0,
      title: json['title'] as String?,
      type: json['type'] as String?,
    );
  }
}

class Reel {
  final String? groupId;
  final String? groupName;
  final String? totalReels;
  final String? watchedReels;
  final String? thumbUrl;

  Reel({
    this.groupId,
    this.groupName,
    this.totalReels,
    this.watchedReels,
    this.thumbUrl,
  });

  factory Reel.fromJson(Map<String, dynamic> json) {
    return Reel(
      groupId: json['groupId'] as String?,
      groupName: json['groupName'] as String?,
      totalReels: json['totalReels'] as String?,
      watchedReels: json['watchedReels'] as String?,
      thumbUrl: json['thumbUrl'] as String?,
    );
  }
}

class SingleCatalogSection extends DataSection {
  final CatalogData catalogData;

  SingleCatalogSection({
    required this.catalogData,
    String? imageUrl,
    String? tag,
    required int sectionId,
    String? title,
    String? type,
  }) : super(data: [catalogData], imageUrl: imageUrl, tag: tag, sectionId: sectionId, title: title, type: type);

  factory SingleCatalogSection.fromJson(Map<String, dynamic> json) {
    return SingleCatalogSection(
      catalogData: CatalogData.fromJson(json['data'] as Map<String, dynamic>),
      imageUrl: json['imageUrl'] as String?,
      tag: json['tag'] as String?,
      sectionId: json['sectionId'] as int? ?? 0,
      title: json['title'] as String?,
      type: json['type'] as String?,
    );
  }
}

class CatalogData {
  final int ownerStatus;
  final int salePer;
  final String? city;
  final String? lastCatalogTime;
  final List<Coupon> offerJson;
  final Catalog catalog;
  final int groupId;
  final int rating;
  final int ownerId;
  final String? categoryName;
  final String? participantInviteLink;
  final int groupPlan;
  final String? shortInfo;
  final String? ownerName;
  final bool isOwner;
  final int chatNumber;
  final bool isPublic;
  final String? ownerInviteLink;
  final bool isShippingFree;
  final String? lastCatalogName;
  final String? groupVideoId;
  final int connections;
  final double maxMargin;
  final bool isCodAvailable;
  final int maxCoinsPerOrder;
  final bool isPinned;
  final bool isVisitor;
  final int returnPolicy;
  final String? ownerDpUrl;
  final int promotionScore;
  final int counter;
  final String? groupName;
  final String? createdDate;
  final String? dpUrl;
  final bool isShipsafeEnabled;
  final String? viewType;
  final int verificationType;
  final int maxCashbackPerOrder;
  final bool isCodFree;
  final int categoryId;

  CatalogData({
    required this.ownerStatus,
    required this.salePer,
    this.city,
    this.lastCatalogTime,
    required this.offerJson,
    required this.catalog,
    required this.groupId,
    required this.rating,
    required this.ownerId,
    this.categoryName,
    this.participantInviteLink,
    required this.groupPlan,
    this.shortInfo,
    this.ownerName,
    required this.isOwner,
    required this.chatNumber,
    required this.isPublic,
    this.ownerInviteLink,
    required this.isShippingFree,
    this.lastCatalogName,
    this.groupVideoId,
    required this.connections,
    required this.maxMargin,
    required this.isCodAvailable,
    required this.maxCoinsPerOrder,
    required this.isPinned,
    required this.isVisitor,
    required this.returnPolicy,
    this.ownerDpUrl,
    required this.promotionScore,
    required this.counter,
    this.groupName,
    this.createdDate,
    this.dpUrl,
    required this.isShipsafeEnabled,
    this.viewType,
    required this.verificationType,
    required this.maxCashbackPerOrder,
    required this.isCodFree,
    required this.categoryId,
  });

  factory CatalogData.fromJson(Map<String, dynamic> json) {
    return CatalogData(
      ownerStatus: json['ownerStatus'] as int? ?? 0,
      salePer: json['salePer'] as int? ?? 0,
      city: json['city'] as String?,
      lastCatalogTime: json['lastCatalogTime'] as String?,
      offerJson: (json['offerJson'] as List<dynamic>? ?? [])
          .map((item) => Coupon.fromJson(item as Map<String, dynamic>))
          .toList(),
      catalog: Catalog.fromJson(json['catalog'] as Map<String, dynamic>),
      groupId: json['groupId'] as int? ?? 0,
      rating: json['rating'] as int? ?? 0,
      ownerId: json['ownerId'] as int? ?? 0,
      categoryName: json['categoryName'] as String?,
      participantInviteLink: json['participantInviteLink'] as String?,
      groupPlan: json['groupPlan'] as int? ?? 0,
      shortInfo: json['shortInfo'] as String?,
      ownerName: json['ownerName'] as String?,
      isOwner: json['isOwner'] as bool? ?? false,
      chatNumber: json['chatNumber'] as int? ?? 0,
      isPublic: json['isPublic'] as bool? ?? false,
      ownerInviteLink: json['ownerInviteLink'] as String?,
      isShippingFree: json['isShippingFree'] as bool? ?? false,
      lastCatalogName: json['lastCatalogName'] as String?,
      groupVideoId: json['groupVideoId'] as String?,
      connections: json['connections'] as int? ?? 0,
      maxMargin: (json['maxMargin'] as num?)?.toDouble() ?? 0.0,
      isCodAvailable: json['isCodAvailable'] as bool? ?? false,
      maxCoinsPerOrder: json['maxCoinsPerOrder'] as int? ?? 0,
      isPinned: json['isPinned'] as bool? ?? false,
      isVisitor: json['isVisitor'] as bool? ?? false,
      returnPolicy: json['returnPolicy'] as int? ?? 0,
      ownerDpUrl: json['ownerDpUrl'] as String?,
      promotionScore: json['promotionScore'] as int? ?? 0,
      counter: json['counter'] as int? ?? 0,
      groupName: json['groupName'] as String?,
      createdDate: json['createdDate'] as String?,
      dpUrl: json['dpUrl'] as String?,
      isShipsafeEnabled: json['isShipsafeEnabled'] as bool? ?? false,
      viewType: json['viewType'] as String?,
      verificationType: json['verificationType'] as int? ?? 0,
      maxCashbackPerOrder: json['maxCashbackPerOrder'] as int? ?? 0,
      isCodFree: json['isCodFree'] as bool? ?? false,
      categoryId: json['categoryId'] as int? ?? 0,
    );
  }
}

class Coupon {
  final String? couponCode;
  final String? couponType;
  final int couponAmount;

  Coupon({
    this.couponCode,
    this.couponType,
    required this.couponAmount,
  });

  factory Coupon.fromJson(Map<String, dynamic> json) {
    return Coupon(
      couponCode: json['couponCode'] as String?,
      couponType: json['couponType'] as String?,
      couponAmount: json['couponAmount'] as int? ?? 0,
    );
  }
}

class Catalog {
  final int prepaidDiscount;
  final double mrp;
  final double startingPrice;
  final double customerPrice;
  final int commentCount;
  final List<Product> products;
  final int dealerDiscount;
  final String? catalogName;
  final int shares;
  final int couponDiscount;
  final int catalogId;
  final String? promotedTime;
  final int couponDiscountApplied;
  final int reviewCount;
  final double whatsAppPrice;
  final int firstOrder;
  final String? catalogDesc;
  final List<String?> commentUserDpList;
  final int likes;

  Catalog({
    required this.prepaidDiscount,
    required this.mrp,
    required this.startingPrice,
    required this.customerPrice,
    required this.commentCount,
    required this.products,
    required this.dealerDiscount,
    this.catalogName,
    required this.shares,
    required this.couponDiscount,
    required this.catalogId,
    this.promotedTime,
    required this.couponDiscountApplied,
    required this.reviewCount,
    required this.whatsAppPrice,
    required this.firstOrder,
    this.catalogDesc,
    required this.commentUserDpList,
    required this.likes,
  });

  factory Catalog.fromJson(Map<String, dynamic> json) {
    return Catalog(
      prepaidDiscount: json['prepaidDiscount'] as int? ?? 0,
      mrp: (json['mrp'] as num?)?.toDouble() ?? 0.0,
      startingPrice: (json['startingPrice'] as num?)?.toDouble() ?? 0.0,
      customerPrice: (json['customerPrice'] as num?)?.toDouble() ?? 0.0,
      commentCount: json['commentCount'] as int? ?? 0,
      products: (json['products'] as List<dynamic>? ?? [])
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
      dealerDiscount: json['dealerDiscount'] as int? ?? 0,
      catalogName: json['catalogName'] as String?,
      shares: json['shares'] as int? ?? 0,
      couponDiscount: json['couponDiscount'] as int? ?? 0,
      catalogId: json['catalogId'] as int? ?? 0,
      promotedTime: json['promotedTime'] as String?,
      couponDiscountApplied: json['couponDiscountApplied'] as int? ?? 0,
      reviewCount: json['reviewCount'] as int? ?? 0,
      whatsAppPrice: (json['whatsAppPrice'] as num?)?.toDouble() ?? 0.0,
      firstOrder: json['firstOrder'] as int? ?? 0,
      catalogDesc: json['catalogDesc'] as String?,
      commentUserDpList: (json['commentUserDpList'] as List<dynamic>? ?? [])
          .map((item) => item as String?)
          .toList(),
      likes: json['likes'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'prepaidDiscount': prepaidDiscount,
      'mrp': mrp,
      'startingPrice': startingPrice,
      'customerPrice': customerPrice,
      'commentCount': commentCount,
      'products': products.map((e) => e.toJson()).toList(),
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
      'commentUserDpList': commentUserDpList,
      'likes': likes,
    };
  }
}

class Product {
  final bool? isOrderable;
  final String? productCode;
  final int productId;
  final String? videoUrl;
  final String? imageUrl;
  final bool? isVideo;

  Product({
    this.isOrderable,
    this.productCode,
    required this.productId,
    this.videoUrl,
    this.imageUrl,
    this.isVideo,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      isOrderable: json['isOrderable'] as bool?,
      productCode: json['productCode'] as String?,
      productId: json['productId'] as int? ?? 0,
      videoUrl: json['videoUrl'] as String?,
      imageUrl: json['imageUrl'] as String?,
      isVideo: json['isVideo'] as bool?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isOrderable': isOrderable,
      'productCode': productCode,
      'productId': productId,
      'videoUrl': videoUrl,
      'imageUrl': imageUrl,
      'isVideo': isVideo,
    };
  }
}

class NewGroupsSection extends DataSection {
  final List<NewGroup> newGroups;

  NewGroupsSection({
    required this.newGroups,
    String? imageUrl, // Made nullable
    String? tag,     // Made nullable
    required int sectionId,
    String? title,   // Made nullable
    String? type,    // Made nullable
  }) : super(
    data: newGroups,
    imageUrl: imageUrl,
    tag: tag,
    sectionId: sectionId,
    title: title,
    type: type,
  );

  factory NewGroupsSection.fromJson(Map<String, dynamic> json) {
    return NewGroupsSection(
      newGroups: (json['data'] as List<dynamic>? ?? [])
          .map((item) => NewGroup.fromJson(item as Map<String, dynamic>))
          .toList(),
      imageUrl: json['imageUrl'] as String?,
      tag: json['tag'] as String?,
      sectionId: json['sectionId'] as int? ?? 0,
      title: json['title'] as String?,
      type: json['type'] as String?,
    );
  }
}

class NewGroup {
  final int groupId;
  final String? subTitle;    // Made nullable
  final String? groupLogo;   // Made nullable
  final String? groupName;   // Made nullable
  final String? catalogImage;// Made nullable

  NewGroup({
    required this.groupId,
    this.subTitle,
    this.groupLogo,
    this.groupName,
    this.catalogImage,
  });

  factory NewGroup.fromJson(Map<String, dynamic> json) {
    return NewGroup(
      groupId: json['groupId'] as int? ?? 0,
      subTitle: json['subTitle'] as String?,
      groupLogo: json['groupLogo'] as String?,
      groupName: json['groupName'] as String?,
      catalogImage: json['catalogImage'] as String?,
    );
  }
}