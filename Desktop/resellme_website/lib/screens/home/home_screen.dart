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
import '../group/group_screen.dart';
import '../product/views/product_responsive.dart';
import '../video/video_play_screen.dart';

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
  // final ScrollController _scrollController = ScrollController();
  bool isFetchingMore = false;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _apiService = ApiService(dio);

    SystemNavigator.routeInformationUpdated(
      uri: Uri(path: "/home"),
    );

    // _scrollController.addListener(_onScroll);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchHome(1, -1, "token", true, 12);
    });
  }

  @override
  void dispose() {
    // _scrollController.dispose();
    super.dispose();
  }


  // void _onScroll() {
  //   if (_scrollController.position.pixels >=
  //       _scrollController.position.maxScrollExtent * 0.7 &&
  //       !isFetchingMore &&
  //       !isLoading &&
  //       responses != null) {
  //     setState(() {
  //       isFetchingMore = true;
  //     });
  //     fetchMoreData();
  //   }
  // }

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
    // final double currentPosition = _scrollController.position.pixels;

    await fetchHome(1, -1, "token", true, 12);

    // Restore the scroll position after new data is loaded
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (_scrollController.hasClients) {
    //     _scrollController.jumpTo(currentPosition);
    //   }
    // });

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
        // controller: _scrollController,
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
          }else if (section is ReelsSection) {
            return ReelsSectionOldWidget(section: section);
          } else if (section is ReelsSectionNew) {
            return ReelsSectionWidget(section: section);
          } else if (section is NewGroupsSection) {
            return NewGroupsSectionWidget(section: section);
          } else if (section is CategorySection) {
            return CategorySectionWidget(section: section);
          } else if (section is CatalogsSection) {
            return CatalogsSectionWidget(section: section);
          } else if (section is LowestPriceSection) {
            return LowestPriceSectionWidget(section: section);
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
                                    top: 80,
                                    left: 80,
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
                                    unescapeJava(catalog.catalogDesc?.split('\n').first ?? ''),
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
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          const SizedBox(height: 16), // Add some spacing at the bottom
        ],
      ),
    );
  }
}



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
                child: InkWell(
                  onTap: () {
                    // Navigate to a screen for the new group
                    navigateToNewGroup(context, group);
                  },
                  borderRadius: BorderRadius.circular(10), // Matches card radius for ripple effect
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
                      Text(
                        group.groupName ?? 'No Name',
                        style: const TextStyle(fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                      Text(
                        group.subTitle ?? '',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // Helper function to navigate to a new group screen
  void navigateToNewGroup(BuildContext context, NewGroup group, ) {
    // For now, navigate to BrandProfileScreen as an example

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => BrandProfileScreen(profile: group),
      ),
    );
  }
}



class ReelsSectionWidget extends StatelessWidget {
  final ReelsSectionNew section;

  const ReelsSectionWidget({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.video_library, color: Colors.pink),
                  const SizedBox(width: 8),
                  Text(
                    section.title ?? 'Reels & Videos',
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              TextButton(
                onPressed: () {
                  // Navigate to a "See All" screen (implement as needed)
                  print('See All tapped');
                },
                child: const Text(
                  'SEE ALL',
                  style: TextStyle(color: Colors.pink, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 280,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: section.reels.length,
            itemBuilder: (context, index) {
              final reel = section.reels[index];
              final catalog = reel.catalog;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    // Show VideoPlayScreen in a dialog
                    if (catalog?.products?.isNotEmpty == true) {
                      for (var product in catalog!.products!) {
                        if (product.isVideo == true && product.videoUrl != null) {
                          print('Video URL: ${product.videoUrl}');
                          showDialog(
                            context: context,
                            barrierDismissible: true, // Allows dismissal by tapping outside
                            builder: (BuildContext context) {
                              return Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: VideoDialogContent(videoUrl: product.videoUrl!),
                              );
                            },
                          );
                          // If you only want to show one dialog for the first video, break out of the loop.
                          break;
                        }
                      }
                    }

                  },
                  borderRadius: BorderRadius.circular(10),
                  splashColor: Colors.pink.withOpacity(0.3),
                  child: SizedBox(
                    width: 150,
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
                                  imageUrl: catalog?.products?.isNotEmpty == true
                                      ? catalog!.products![0].imageUrl ?? ''
                                      : '',
                                  height: 180,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.all(40.0),
                                  child: Icon(
                                    Icons.play_circle_fill,
                                    color: Colors.white,
                                    size: 40,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reel.groupName ?? 'Unknown Group',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (catalog != null)
                                  Text(
                                    catalog.catalogName ?? '',
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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
      ],
    );
  }
}





class CategorySectionWidget extends StatelessWidget {
  final CategorySection section;

  const CategorySectionWidget({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            section.title ?? 'Categories',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 150,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: section.categories.length,
            itemBuilder: (context, index) {
              final category = section.categories[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: CachedNetworkImage(
                        imageUrl: category.imageUrl ?? '',
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => const Icon(Icons.error),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      category.categoryName ?? 'Unknown Category',
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
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

class CatalogsSectionWidget extends StatelessWidget {
  final CatalogsSection section;

  const CatalogsSectionWidget({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            section.title ?? 'Catalogs',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 250,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: section.catalogGroups.length,
            itemBuilder: (context, index) {
              final catalogGroup = section.catalogGroups[index];
              final catalog = catalogGroup.catalog;
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: InkWell(
                  onTap: () {
                    if (catalog != null) {
                      navigateToCatalog(context, catalog.catalogId);
                    }
                  },
                  child: SizedBox(
                    width: 150,
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: catalog?.products?.isNotEmpty == true
                                  ? catalog!.products![0].imageUrl ?? ''
                                  : '',
                              height: 150,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  catalogGroup.groupName ?? 'Unknown Group',
                                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (catalog != null)
                                  Text(
                                    catalog.catalogName ?? '',
                                    style: const TextStyle(fontSize: 12),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                Text(
                                  '₹${catalog?.customerPrice?.toStringAsFixed(0) ?? 'N/A'}',
                                  style: TextStyle(fontSize: 14, color: Colors.red[700]),
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
      ],
    );
  }
}


class LowestPriceSectionWidget extends StatelessWidget {
  final LowestPriceSection section;

  const LowestPriceSectionWidget({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            section.title ?? 'Lowest Prices',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 260, // Adjusted height for compact display
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: section.lowestPrices.length,
            itemBuilder: (context, index) {
              final lowestPrice = section.lowestPrices[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 200,
                  child: InkWell(
                    onTap: () {
                      // Navigate to a screen based on the lowest price item
                      navigateToCatalog(
                        context,
                        lowestPrice.id,
                      );
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
                            child: CachedNetworkImage(
                              imageUrl: lowestPrice.imageUrl ?? '',
                              height: 180,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  lowestPrice.title ?? 'Unknown Item',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  unescapeJava(lowestPrice.bottomText ?? '₹${lowestPrice.maxPrice}'),
                                  style: TextStyle(fontSize: 12, color: Colors.red[700]),
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
      ],
    );
  }
}



// Assuming unescapeJava is defined elsewhere; if not, here's a simple implementation
String unescapeJava(String text) {
  return text.replaceAll('\\u20B9', '₹'); // Replace Unicode rupee symbol
}


class ReelsSectionOldWidget extends StatelessWidget {
  final ReelsSection section;

  const ReelsSectionOldWidget({required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            section.title ?? 'Reels & Videos',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(
          height: 200, // Adjusted height for reels
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: section.reels.length,
            itemBuilder: (context, index) {
              final reel = section.reels[index];
              final totalReels = int.tryParse(reel.totalReels ?? '0') ?? 0;
              final watchedReels = int.tryParse(reel.watchedReels ?? '0') ?? 0;
              final progress = totalReels > 0 ? watchedReels / totalReels : 0.0;

              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  width: 120,
                  child: InkWell(
                    onTap: () {
                      // Add navigation to a reels viewer screen if needed
                      print('Tapped on reel for group: ${reel.groupName}');
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
                                  imageUrl: reel.thumbUrl ?? '',
                                  height: 140,
                                  width: double.infinity,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(child: CircularProgressIndicator()),
                                  errorWidget: (context, url, error) => const Icon(Icons.error),
                                ),
                              ),
                              const Positioned(
                                top: 60,
                                left: 45,
                                child: Icon(
                                  Icons.play_circle_fill,
                                  color: Colors.white,
                                  size: 30,
                                ),
                              ),
                            ],
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  reel.groupName ?? 'Unknown Group',
                                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Expanded(
                                      child: LinearProgressIndicator(
                                        value: progress,
                                        backgroundColor: Colors.grey[300],
                                        valueColor: const AlwaysStoppedAnimation<Color>(Colors.pink),
                                      ),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '$watchedReels/$totalReels',
                                      style: const TextStyle(fontSize: 10, color: Colors.grey),
                                    ),
                                  ],
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
