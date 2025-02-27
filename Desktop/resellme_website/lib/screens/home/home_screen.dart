import 'dart:async';
import 'dart:convert';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

import '../../models/home.dart'; // Assuming this contains your ResponseModel and related classes
import '../../network/api_service.dart';
import '../comment/comment_and_review_sheet.dart';
import '../product/views/product_responsive.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();

}

class _HomeScreenState extends State<HomeScreen> {
  ResponseModel? responses;
  late ApiService _apiService;
  bool isLoading = true;
  String? errorMessage;
  int offset = 0;
  final ScrollController _scrollController = ScrollController();
  bool isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _apiService = ApiService(dio);

    SystemNavigator.routeInformationUpdated(
      uri: Uri(path: "/home"),
    );

    _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHome(1, -1, "token", true, 12);
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }


  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent * 0.7 &&
        !isFetchingMore &&
        !isLoading &&
        responses != null) {
      setState(() {
        isFetchingMore = true;
      });
      fetchMoreData();
    }
  }

  Future<void> fetchHome(
      int userId, int catalogId, String token, bool editPrice, int categoryId) async {
    try {
      setState(() {
        isLoading = true;
        errorMessage = null;
      });

      final response =
      await _apiService.getHomeScreenData(userId, catalogId, token, offset);
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;



      setState(() {

        if (responses == null) {
          responses = ResponseModel.fromJson(responseData);
        } else {
          // Append new data to existing responses
          final newData = ResponseModel.fromJson(responseData).data;
          responses!.data.addAll(newData);
        }
        isLoading = false;
        offset += responses!.data.length; // Update offset based on new data length
        print('Response data: $offset');
      });
    } catch (e, stackTrace) {
      print('Failed to fetch products: $e');
      print('Stack trace: $stackTrace');
      setState(() {
        isLoading = false;
        errorMessage = 'Failed to load data: $e';
      });
    }
  }

  Future<void> fetchMoreData() async {
    // Store the current scroll position before fetching new data
    final double currentPosition = _scrollController.position.pixels;

    await fetchHome(1, -1, "token", true, 12);

    // Restore the scroll position after new data is loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(currentPosition);
      }
    });

    setState(() {
      isFetchingMore = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:   Text(
         'ResellMe', // Display the group name
          style: GoogleFonts.poppins(
            fontSize: 28,
            color: Colors.pink,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading && responses == null
          ? const Center(child: CircularProgressIndicator())
          : errorMessage != null
          ? Center(child: Text(errorMessage!))
          : responses == null
          ? const Center(child: Text('No data available'))
          : ListView.builder(
        controller: _scrollController,
        itemCount: responses!.data.length + (isFetchingMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index == responses!.data.length && isFetchingMore) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final section = responses!.data[index];
          if (section is BannerSection) {
            return BannerSectionWidget(section: section);
          } else if (section is SingleCatalogSection) {
            return SingleCatalogSectionWidget(section: section);
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}

class BannerSectionWidget extends StatefulWidget {
  final BannerSection section;

  const BannerSectionWidget({required this.section, super.key});

  @override
  _BannerSectionWidgetState createState() => _BannerSectionWidgetState();
}

class _BannerSectionWidgetState extends State<BannerSectionWidget> {
  int _currentIndex = 0;
  late Timer _timer;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.7, // Shows 70% of the current banner, leaving 15% on each side
    );
    _startAutoScroll();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancel the timer to prevent memory leaks
    _pageController.dispose(); // Dispose of the PageController
    super.dispose();
  }

  void _startAutoScroll() {
    _timer = Timer.periodic(const Duration(seconds: 2), (Timer timer) {
      if (mounted) {
        setState(() {
          _currentIndex = (_currentIndex + 1) % widget.section.banners.length;
          _pageController.animateToPage(
            _currentIndex,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final banners = widget.section.banners;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (banners.isNotEmpty)
          SizedBox(
            height: MediaQuery.of(context).size.width * 0.3, // Adjusted height
            child: Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width, // Full screen width
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: banners.length,
                  onPageChanged: (index) {
                    if (mounted) {
                      setState(() {
                        _currentIndex = index;
                      });
                    }
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16.0), // 16dp corner radius
                        child: CachedNetworkImage(
                          imageUrl: banners[index].imageUrl ?? '',
                          fit: BoxFit.cover,
                          placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => const Icon(Icons.error),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        const SizedBox(height: 16),
        // Dynamic Dot Indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(banners.length, (index) {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Icon(
                Icons.circle,
                size: 8,
                color: _currentIndex == index ? Colors.pink : Colors.grey,
              ),
            );
          }),
        ),
      ],
    );
  }
}

class SingleCatalogSectionWidget extends StatelessWidget {
  final SingleCatalogSection section;

  const SingleCatalogSectionWidget({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    final catalogData = section.catalogData;
    final catalog = catalogData.catalog;
    final products = catalog.products;

    return Card(
      elevation: 1, // Add elevation for shadow
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16), // Rounded corners
      ),
      margin: const EdgeInsets.all(16), // Add margin around the card
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundImage: CachedNetworkImageProvider(
                    catalogData.dpUrl ?? '',
                  ),
                  onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.error),
                  child: catalogData.dpUrl == null || catalogData.dpUrl!.isEmpty
                      ? Text(
                    catalogData.groupName?.substring(0, 1) ?? 'T',
                    style: const TextStyle(color: Colors.black),
                  )
                      : null,
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      catalogData.groupName ?? 'Test Jewellery',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      convertDate(catalog.promotedTime.toString()),
                      style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ],
            ),
          ),
          // Product Horizontal List
          SizedBox(
            height: 300,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: 200,
                    child: InkWell(
                      onTap: () {
                        navigateToCatalog(context, catalog.catalogId);
                      },
                      borderRadius: BorderRadius.circular(10),
                      child: Card(
                        elevation: 4,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Stack(
                              children: [
                                ClipRRect(
                                  borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                                  child: CachedNetworkImage(
                                    imageUrl: product.imageUrl ?? '',
                                    height: 200,
                                    width: double.infinity,
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) => const Icon(Icons.error),
                                  ),
                                ),
                                if (product.videoUrl != null)
                                  const Positioned(
                                    top: 40,
                                    left: 60,
                                    child: Icon(Icons.play_circle_fill, color: Colors.white, size: 40),
                                  ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 4),
                                  Text(
                                    unescapeJava(catalog.catalogDesc?.split('\n').first ?? 'Something testing'),
                                    style: const TextStyle(fontSize: 14),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '₹${catalog.customerPrice?.toStringAsFixed(0) ?? '1049'}',
                                    style: TextStyle(fontSize: 16, color: Colors.red[700], fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // About the Brand
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundImage: CachedNetworkImageProvider(
                        catalogData.ownerDpUrl ?? '',
                      ),
                      onBackgroundImageError: (exception, stackTrace) => const Icon(Icons.error),
                      child: catalogData.ownerDpUrl == null || catalogData.ownerDpUrl!.isEmpty
                          ? Text(
                        catalogData.groupName?.substring(0, 1) ?? 'T',
                        style: const TextStyle(color: Colors.black),
                      )
                          : null,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About the brand',
                            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            'Owner: ${catalogData.ownerName ?? ''}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Deals in: ${catalogData.categoryName ?? ''}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          Text(
                            'Location: ${catalogData.city ?? ''}',
                            style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Colors.teal[100],
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              'Moto: ${catalogData.shortInfo ?? ''}',
                              style: const TextStyle(fontSize: 12),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Comments & Reviews
          const SizedBox(height: 16), // Add some spacing at the bottom
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: GestureDetector(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (BuildContext context) {
                    return CommentsReviewsBottomSheet(
                      token: 'YOUR_TOKEN', // Replace with the actual token
                      groupId: catalog.catalogId,
                      groupLogo: "widget.groupLogo",
                      groupName: "widget.groupName",
                      userId: 1,
                    );
                  },
                );
              },
              child: Text(
                'Comments & Reviews',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16), // Add some spacing at the bottom
        ],
      ),
    );
  }
}

// New Groups Section Widget
class NewGroupsSectionWidget extends StatelessWidget {
  final NewGroupsSection section;

  const NewGroupsSectionWidget({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            section.title ?? 'New Groups',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: section.newGroups.length,
            itemBuilder: (context, index) {
              final group = section.newGroups[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      imageUrl: group.catalogImage ?? '',
                      width: 120,
                      height: 120,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                    const SizedBox(height: 4),
                    Text(group.groupName ?? 'No Name', style: const TextStyle(fontSize: 14)),
                    Text(group.subTitle ?? '', style: const TextStyle(fontSize: 12, color: Colors.grey)),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

String convertDate(String originalDate) {
  // Parse the original date string to a DateTime object
  DateTime dateTime = DateTime.parse(originalDate);

  // Format the DateTime object to the desired format
  String formattedDate = DateFormat('d MMM yyyy').format(dateTime);

  // Return the formatted date
  return formattedDate;
}
