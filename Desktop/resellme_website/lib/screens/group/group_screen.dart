import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:convert';

import '../../models/Group.dart';
import '../../models/home.dart';
import '../../network/api_service.dart';
import '../product/views/product_responsive.dart';

class BrandProfileScreen extends StatefulWidget {
  final NewGroup profile;

  const BrandProfileScreen({super.key, required this.profile});

  @override
  _BrandProfileScreenState createState() => _BrandProfileScreenState();
}

class _BrandProfileScreenState extends State<BrandProfileScreen> {
  bool isFollowing = false;
  bool isLoading = false;
  bool isLoadingMore = false;
  String? errorMessage;
  int offset = 0;
  ResponseModel2? responses;
  GroupData? responsesGroup; // Made nullable to avoid late initialization issues
  GroupProfileData?  groupProfileData;
  late ApiService _apiService;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _apiService = ApiService(dio);

    SystemNavigator.routeInformationUpdated(
      uri:  Uri(path: "/group"),
    );

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchGroupRatings(1, "token");
      fetchGroup(1, "token");
      fetchGroupData(1, "token");
    });
  }

  Future<void> fetchGroupData(int userId, String token) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await _apiService.getGroupData(userId, widget.profile.groupId, token, offset);
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      setState(() {
        if (responses == null) {
          responses = ResponseModel2.fromJson(responseData);
        } else {
          final newData = ResponseModel2.fromJson(responseData).data;
          responses!.data.addAll(newData);
        }
        isLoading = false;
        offset = responses!.data.length;
        print('Response data (catalogs): $offset');
      });
    } catch (e, stackTrace) {
      print('Failed to fetch products: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load product data: $e';
      });
    }
  }

  Future<void> fetchGroupRatings(int userId, String token) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await _apiService.getGroupRatings(userId, widget.profile.groupId, token);
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      print('Response data (group): $responseData');

      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        final dataMap = responseData['data'] as Map<String, dynamic>; // Extract the nested data object
        print('Nested data: $dataMap'); // Debug the nested data
        setState(() {
          groupProfileData = GroupProfileData.fromJson(dataMap); // Parse the nested data
          print('Response data (group): rating=${groupProfileData?.rating}, numRatings=${groupProfileData?.numRatings}, connections=${groupProfileData?.connections}');
          isLoading = false; // Move isLoading = false inside setState
        });
      } else {
        throw Exception('Invalid response format: Missing "data" field or invalid JSON');
      }
    } catch (e, stackTrace) {
      print('Failed to fetch group data: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load group data: $e';
      });
    }
  }

  Future<void> fetchGroup(int userId, String token) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response = await _apiService.getGroup(userId, widget.profile.groupId, token);
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      if (responseData is Map<String, dynamic> && responseData.containsKey('data')) {
        setState(() {
          responsesGroup = ResponseModel3.fromJson(responseData).data;
          print('Response data (group): $responsesGroup');
        });
      } else {
        throw Exception('Invalid response format: Missing "data" field or invalid JSON');
      }
    } catch (e, stackTrace) {
      print('Failed to fetch group data: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        errorMessage = 'Failed to load group data: $e';
      });
    }
  }

  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 50 && !isLoadingMore) {
      fetchMoreData(1, "token");
    }
  }

  Future<void> fetchMoreData(int userId, String token) async {
    if (isLoadingMore) return;

    try {
      setState(() {
        isLoadingMore = true;
      });

      final response = await _apiService.getGroupData(userId, widget.profile.groupId, token, offset);
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      setState(() {
        final newData = ResponseModel2.fromJson(responseData).data;
        responses!.data.addAll(newData);
        offset = responses!.data.length;
        isLoadingMore = false;
        print('Loaded more data: $offset');
      });
    } catch (e) {
      print('Failed to fetch more products: $e');
      setState(() {
        isLoadingMore = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to load more products')),
      );
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Calculate the number of columns based on screen width
  int _calculateCrossAxisCount(double screenWidth) {
    const double minItemWidth = 150.0; // Minimum width for each grid item
    return (screenWidth / minItemWidth).floor().clamp(2, 4); // Between 2 and 4 columns
  }

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final int crossAxisCount = _calculateCrossAxisCount(screenWidth);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Text(
              responsesGroup?.groupName ?? widget.profile.groupName ?? 'SD Collection',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.verified, color: Colors.blue, size: 16),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              // Handle menu actions
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: CachedNetworkImageProvider(responsesGroup?.dpUrl ?? widget.profile.groupLogo ?? ''),
                    onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.error),
                    child: (responsesGroup?.dpUrl ?? widget.profile.groupLogo) == null || (responsesGroup?.dpUrl ?? widget.profile.groupLogo)!.isEmpty
                        ? Text(
                      responsesGroup?.groupName?.substring(0, 1) ?? widget.profile.groupName?.substring(0, 1) ?? 'S',
                      style: const TextStyle(color: Colors.black, fontSize: 20),
                    )
                        : null,
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              '${groupProfileData?.rating??'5'} ★',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                             Text(
                              '${groupProfileData?.numRatings??'5'} ratings',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                             Text(
                              '${groupProfileData?.connections??'5'} Followers',
                              style: TextStyle(fontSize: 12),
                            ),
                             Text(
                              '${responses?.data.length??'8'} Products',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                responsesGroup?.shortInfo ?? widget.profile.groupName ?? 'Where fashion meets function for the modern, stylish woman.',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Chip(
                    avatar: const Icon(Icons.label, size: 16),
                    label: Text(responsesGroup?.categoryName ?? 'Women Wears (Brand)'),
                    backgroundColor: Colors.grey[200],
                  ),
                  const SizedBox(width: 8),
                  Chip(
                    avatar: const Icon(Icons.location_on, size: 16, color: Colors.blue),
                    label: Text(responsesGroup?.city ?? 'Agartala (Tripura)'),
                    backgroundColor: Colors.grey[200],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            // Follow Button
            Center(
              child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    isFollowing = !isFollowing;
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(isFollowing ? 'Followed!' : 'Unfollowed!'),
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  minimumSize: const Size(200, 40),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.add, color: Colors.white),
                    const SizedBox(width: 8),
                    Text(
                      isFollowing ? 'Following' : 'Follow',
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Owner Bio
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(responsesGroup?.ownerDpUrl ?? widget.profile.groupLogo ?? ''),
                    onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.error),
                    child: (responsesGroup?.ownerDpUrl ?? widget.profile.groupLogo) == null || (responsesGroup?.ownerDpUrl ?? widget.profile.groupLogo)!.isEmpty
                        ? Text(
                      responsesGroup?.ownerName?.substring(0, 1) ?? widget.profile.groupName?.substring(0, 1) ?? 'S',
                      style: const TextStyle(color: Colors.black),
                    )
                        : null,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Hi, this is ${responsesGroup?.ownerName ?? widget.profile.subTitle ?? 'Sudip Das'} running ${responsesGroup?.groupName ?? widget.profile.groupName ?? 'SD Collection'} since ${responsesGroup?.createdDate?.split(' ')[0] ?? '2020'}.',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            // Coupon Notification
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Card(
                color: Colors.teal[100],
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.local_offer, color: Colors.green),
                      const SizedBox(width: 8),
                      Text(
                        '₹${responsesGroup?.offerJson?.isNotEmpty == true ? responsesGroup!.offerJson![0].couponAmount ?? 50 : 50} coupon available from this brand.',
                        style: const TextStyle(fontSize: 14, color: Colors.green),
                      ),
                      const Icon(Icons.chevron_right, color: Colors.green),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Product Grid
            if (isLoading && responses == null)
              const Center(child: CircularProgressIndicator(color: Colors.pink))
            else if (errorMessage != null)
              Center(
                child: Column(
                  children: [
                    Text(errorMessage!, style: const TextStyle(color: Colors.red)),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: () {
                        fetchGroup(1, "token");
                        fetchGroupData(1, "token");
                      },
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              )
            else if (responses == null || responses!.data.isEmpty)
                const Center(child: Text('No products available'))
              else
                LayoutBuilder(
                  builder: (context, constraints) {
                    final crossAxisCount = constraints.maxWidth < 600 ? 2 : 4;
                    return GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(8.0),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: crossAxisCount,
                        childAspectRatio: 16 / 12,
                        crossAxisSpacing: 8.0,
                        mainAxisSpacing: 8.0,
                      ),
                      itemCount: responses!.data.length,
                      itemBuilder: (context, index) {
                        final catalog = responses!.data[index];
                        return InkWell(
                          onTap: () {
                            navigateToCatalog(context, catalog.catalogId);
                          },
                          child: Card(
                            elevation: 4,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                  child: AspectRatio(
                                    aspectRatio: 19 / 9,
                                    child: CachedNetworkImage(
                                      imageUrl: catalog.products.isNotEmpty ? catalog.products.first.imageUrl : '',
                                      width: double.infinity,
                                      fit: BoxFit.cover,
                                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                      errorWidget: (context, url, error) => const Icon(Icons.error),
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        catalog.catalogTitle,
                                        style: const TextStyle(fontSize: 14),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      const SizedBox(height: 4),
                                      Row(
                                        children: [
                                          Text(
                                            '₹${catalog.startingPrice}',
                                            style: const TextStyle(fontSize: 14, color: Colors.blue),
                                          ),
                                          const SizedBox(width: 8),
                                          if (catalog.maxMrp != catalog.startingPrice)
                                            Text(
                                              '₹${catalog.maxMrp}',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Colors.grey,
                                                decoration: TextDecoration.lineThrough,
                                              ),
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
            if (isLoadingMore)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: Center(child: CircularProgressIndicator(color: Colors.pink)),
              ),
          ],
        ),
      ),
    );
  }
}