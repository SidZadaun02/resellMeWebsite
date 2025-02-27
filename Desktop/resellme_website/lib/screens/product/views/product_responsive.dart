import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:ResellMe/route/screen_export.dart';
import '../../../components/skleton/app_bar.dart';
import '../../../helper/cart_provider.dart';
import '../../../models/product_model.dart';
import '../../../models/suggested_catalogs.dart';
import '../../../network/api_service.dart';
import '../../comment/comment_and_review_sheet.dart';
import 'components/retrun_option_bottomsheet.dart';
import 'components/size_list.dart';

class ProductPage extends StatefulWidget {
  final int productId;
  static String routeName = "/product";
  const ProductPage({super.key, required this.productId});


  @override
  State<ProductPage> createState() => _ProductPageState();
}

class _ProductPageState extends State<ProductPage> {
  late ApiService _apiService;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    final dio = Dio();
    _apiService = ApiService(dio);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchProducts(1, widget.productId, "token", true, 12);
    });
  }



  Future<void> fetchProducts(
      int userId, int catalogId, String token, bool editPrice, int categoryId) async {
    try {

      final response = await _apiService.getAllCollectionProducts(userId, catalogId, token);


      // Parse the response
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      final data = responseData['data'] as List<dynamic>;
      setState(() {
        catalogData = data.map((item) => CatalogData.fromJson(item as Map<String, dynamic>)).toList();
        selectedImageUrl = catalogData.first.products.first.imageUrl;
        selectedIndex = 0;
        fetchSuggestedProducts(1, widget.productId, "token", true, 12);
        fetchProductSizes(1, widget.productId, "token", true, 12);
      });
    } catch (e) {
      print('Failed to fetch products: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProductSizes(
      int userId, int catalogId, String token, bool editPrice, int categoryId) async {
    try {
      final response = await _apiService.getSizesOfProduct(userId, catalogId, token);

      // Parse the response
      final responseData = response.data is String
          ? jsonDecode(response.data) as Map<String, dynamic>
          : response.data as Map<String, dynamic>;

      final data = responseData['data'] as List<dynamic>;
      setState(() {
        productSize = data.map((item) => ProductSize.fromJson(item as Map<String, dynamic>)).toList();
        print('Fetch products Sizes: ${productSize.first.stockInfo.first.sizeString}');
      });
    } catch (e) {
      print('Failed to fetch products sizes: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchSuggestedProducts(
      int userId, int catalogId, String token, bool editPrice, int categoryId) async {
    try {
      // Make the API call to fetch suggested products
      final response = await _apiService.getSuggestedCollectionProducts(userId, catalogId, token);
      final responseData = jsonDecode(response.data) as Map<String, dynamic>;
      final data = responseData['data'] as List<dynamic>?;
      print('Fetched first pros code: ${data}');


      if (data != null) {
        setState(() {
          // Map the data to CatalogDataThing objects
          catalogSuggestedData = data
              .map((item) => Section.fromJson(item as Map<String, dynamic>))
              .toList();
          isLoading = false;

          // Optionally print out something about the fetched data
          if (catalogSuggestedData.isNotEmpty) {
            print('Fetched first product status code: ${catalogSuggestedData.first.imageUrl}');
          }
        });
      } else {
        // Handle case where 'data' is null or not present in the response
        print('No data found in the response');
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      print('Failed to fetch products sizes22: $e');
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (catalogData.isEmpty) {
      return const Center(child: Text('No products available'));
    }
    if (catalogSuggestedData.isEmpty) {
      return const Center(child: Text('No products available'));
    }

    if (MediaQuery.of(context).size.width > 800) {
      return ProductPageDesktop(
          catalogData: catalogData,
          catalogSuggestedData:catalogSuggestedData,
          productSize:productSize
      );
    } else {
      return ProductPageMobile(
          catalogData: catalogData,
          catalogSuggestedData:catalogSuggestedData,
          productSize:productSize

      );
    }
  }



}



String selectedImageUrl = 'https://i.imgur.com/JfyZlnO.png';
int selectedIndex = 0;
StockInfo selectedSizeIndex = [] as StockInfo;
List<CatalogData> catalogData = [];
List<Section> catalogSuggestedData = [];
List<ProductSize> productSize = [];





class ProductPageDesktop extends StatefulWidget {
  final String? productId;

  const ProductPageDesktop({super.key,  required List<CatalogData> catalogData, required List<Section>catalogSuggestedData, this.productId, required List<ProductSize> productSize});

  @override
  State<ProductPageDesktop> createState() => _ProductPageDesktopState();
}
class _ProductPageDesktopState extends State<ProductPageDesktop> {



  @override
  Widget build(BuildContext context) {

    final cartItems = Provider.of<CartProvider>(context).cartItems;

    return Scaffold(
      appBar: buildAppBar(
        unescapeJava(catalogData.first.catalogTitle), // Replace with your catalog title
        cartItems.length,
            () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 80,
                    height: MediaQuery.of(context).size.height * 0.61 ,
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: catalogData.first.products.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              selectedImageUrl = catalogData.first.products[index].imageUrl;
                              selectedIndex = index;
                            });
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: selectedImageUrl == catalogData.first.products[index].imageUrl ? Colors.red : Colors.transparent,
                                  width: 2,
                                ),
                              ),
                              child: Image.network(catalogData.first.products[index].imageUrl, width: 120, height: 100),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(width: 36),
                  Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(16),  // Rounded corners
                        child: Image.network(
                          selectedImageUrl,
                          width: MediaQuery.of(context).size.width * 0.30,
                          height: MediaQuery.of(context).size.height * 0.61,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          ElevatedButton(
                            onPressed: () {returnSheet(context,selectedSizeIndex,catalogData.first,selectedIndex);},
                            style: ElevatedButton.styleFrom(minimumSize:  Size(MediaQuery.of(context).size.width * 0.30, 50),backgroundColor: Colors.pink),
                            child: const Text('Buy Now'),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(width: 36),
                  // Product Details
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         Text(catalogData.first.catalogTitle, style: TextStyle(fontSize: 28, color: Colors.black, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                         Text('By ${unescapeJava(catalogData.first.groupName)}', style: TextStyle(fontSize: 20, color: Colors.blueAccent)),
                        const SizedBox(height: 8),
                         Text('\₹${catalogData.first.customerPrice}', style: TextStyle(fontSize: 24, color: Colors.pink, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 16),
                         Text(
                           unescapeJava(catalogData.first.catalogDesc),
                          style: TextStyle(fontSize: 16,color: Colors.black87),
                        ),
                        const SizedBox(height: 16),
                        const Text('Select Size', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        SizedBox(
                          child: SizeSelectionWidget(
                            stockInfo: productSize[selectedIndex].stockInfo, canOrder: catalogData.first.products[selectedIndex].isOrderable!,  onSizeSelected: (StockInfo size) {
                            selectedSizeIndex = size;  // Update the ValueNotifier
                          }, // Pass your StockInfo list here
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 64),
              Text(catalogSuggestedData.first.title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 8),
              SizedBox(
                height: 380,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catalogSuggestedData.first.data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                      setState(() {
                        navigateToCatalog( context, catalogSuggestedData.first.data[index].catalog.catalogId);
                      });
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),  // Rounded corners of 8dp
                            child: Image.network(
                              catalogSuggestedData.first.data[index].catalog.products.first.imageUrl,
                              width: 240,
                              height: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 4),
                           Text(unescapeJava(makeEllipsis(catalogSuggestedData.first.data[index].catalog.catalogName,32)), style: TextStyle(fontSize: 14,color: Colors.black)),
                           Text('\₹${catalogSuggestedData.first.data[index].catalog.startingPrice}', style: TextStyle(fontSize: 24, color: Colors.pink,fontWeight: FontWeight.bold)),
                        ],

                      ),
                    ));
                  },
                ),
              ),
              const SizedBox(height: 16),
              Text(catalogSuggestedData.last.title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 8),
              SizedBox(
                height: 380,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catalogSuggestedData.last.data.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                        onTap: () {
                      setState(() {
                        navigateToCatalog( context, catalogSuggestedData.last.data[index].catalog.catalogId);
                      });
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),  // Rounded corners of 8dp
                            child: Image.network(
                              catalogSuggestedData.last.data[index].catalog.products.first.imageUrl,
                              width: 240,
                              height: 280,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(unescapeJava(makeEllipsis(catalogSuggestedData.last.data[index].catalog.catalogName,32)), style: TextStyle(fontSize: 14,color: Colors.black)),
                           Text('\₹${catalogSuggestedData.last.data[index].catalog.startingPrice}', style: TextStyle(fontSize: 24, color: Colors.pink,fontWeight: FontWeight.bold)),
                        ],

                      ),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class ProductPageMobile extends StatefulWidget {
  final String? productId;

  const ProductPageMobile({super.key, required List<CatalogData> catalogData, required List<Section> catalogSuggestedData, this.productId, required List<ProductSize> productSize});

  @override
  State<ProductPageMobile> createState() => _ProductPageMobileState();


}



class _ProductPageMobileState extends State<ProductPageMobile> {


  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<CartProvider>(context).cartItems;

    return Scaffold(
      appBar: buildAppBar(
        unescapeJava(catalogData.first.catalogTitle), // Replace with your catalog title
        cartItems.length,
            () {
          // Define what happens when the cart button is pressed
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CartScreen()),
          );
        },
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          ClipRRect(
          borderRadius: BorderRadius.circular(16),  // Rounded corners
          child: Image.network(
                selectedImageUrl,
                width: double.infinity,
                height: MediaQuery.of(context).size.width * 1.2,
                fit: BoxFit.cover,
              ),),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catalogData.first.products.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          selectedImageUrl = catalogData.first.products[index].imageUrl;
                          selectedIndex = index;
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4.0),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: selectedImageUrl == catalogData.first.products[index].imageUrl ? Colors.red : Colors.transparent,
                              width: 2,
                            ),
                          ),
                          child: Image.network(catalogData.first.products[index].imageUrl, width: 80, height: 100),
                        ),
                      ),
                    );
                  },
                ),
              ),
              const Text('Select Size', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                child: SizeSelectionWidget(
                  stockInfo: productSize[selectedIndex].stockInfo,
                    canOrder: catalogData.first.products[selectedIndex].isOrderable!,// Pass your StockInfo list here
                    onSizeSelected: (StockInfo size) {
                     selectedSizeIndex = size;  // Update the ValueNotifier
                    }
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {returnSheet(context,selectedSizeIndex,catalogData.first,selectedIndex);},
                    style: ElevatedButton.styleFrom(minimumSize:  Size(MediaQuery.of(context).size.width * 0.95, 50),backgroundColor: Colors.pink),
                    child: const Text('Buy Now'),
                  ),
                ],
              ),
              const SizedBox(height: 24),
               Text(catalogData.first.catalogTitle, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.black)),
              const SizedBox(height: 8),
               Text('By ${unescapeJava(catalogData.first.groupName)}', style: TextStyle(fontSize: 18, color: Colors.blueAccent)),
              const SizedBox(height: 8),
               Text('\₹${catalogData.first.customerPrice}', style: TextStyle(fontSize: 22, color: Colors.pink,fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
               Text(unescapeJava(catalogData.first.catalogDesc), style: TextStyle(fontSize: 16,color: Colors.black87)),
              const SizedBox(height: 24),
               Text(catalogSuggestedData.first.title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catalogSuggestedData.first.data.length,
                  itemBuilder: (context, index) {
                    return
                      GestureDetector(
                        onTap: () {
                      setState(() {
                        navigateToCatalog( context, catalogSuggestedData.first.data[index].catalog.catalogId);
                      });
                    },
                    child:Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),  // Rounded corners of 8dp
                            child: Image.network(
                              catalogSuggestedData.first.data[index].catalog.products.first.imageUrl,
                              width: 120,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 4),
                           Text(unescapeJava(makeEllipsis(catalogSuggestedData.first.data[index].catalog.catalogName,16)), style: TextStyle(fontSize: 14,color: Colors.black)),
                           Text('\₹${catalogSuggestedData.first.data[index].catalog.startingPrice}', style: TextStyle(fontSize: 24, color: Colors.pink,fontWeight: FontWeight.bold)),
                        ],

                      ),
                    ));
                  },
                ),
              ),
              const SizedBox(height: 16),
               Text(catalogSuggestedData.last.title, style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.black87)),
              const SizedBox(height: 8),
              SizedBox(
                height: 250,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: catalogSuggestedData.last.data.length,
                  itemBuilder: (context, index) {
                    return  GestureDetector(
                        onTap: () {
                      setState(() {
                        navigateToCatalog( context, catalogSuggestedData.last.data[index].catalog.catalogId);
                      });
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),  // Rounded corners of 8dp
                            child: Image.network(
                              catalogSuggestedData.last.data[index].catalog.products.first.imageUrl,
                              width: 120,
                              height: 150,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(unescapeJava(makeEllipsis(catalogSuggestedData.last.data[index].catalog.catalogName,16)), style: TextStyle(fontSize: 14,color: Colors.black)),
                          Text('\₹${catalogSuggestedData.last.data[index].catalog.startingPrice}', style: TextStyle(fontSize: 24, color: Colors.pink,fontWeight: FontWeight.bold)),
                        ],

                      ),
                    ));
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}



void returnSheet(BuildContext context, StockInfo selectedSize, CatalogData catalogData, int selectedIndex) {
  showReturnOptionsBottomSheet(context, selectedSize, catalogData,selectedIndex);
}



void navigateToCatalog(BuildContext context, int catalogId) {
  final newUrl = '/product/$catalogId';  // Update the URL with the catalog ID
  // html.window.location.href = newUrl;
  // Navigator.pushNamed(context, newUrl);  // Navigate to the product page
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductPage(
        key: ValueKey(catalogId),
        productId: catalogId,
      ),
    ),
  );
  SystemNavigator.routeInformationUpdated(
    uri: Uri(path: newUrl),
  );
}



String unescapeJava(String input) {
  // Handle escaped characters
  String decoded = input
      .replaceAll(r'\n', '\n')
      .replaceAll(r'\t', '\t')
      .replaceAll(r'\"', '"')
      .replaceAll(r"\'", "'")
      .replaceAll(r'\\', r'\'); // Handles escaped backslashes

  // Decode Unicode escape sequences (e.g., \uXXXX -> actual character)
  decoded = _decodeUnicode(decoded);
  return decoded;
}

String _decodeUnicode(String input) {
  // This part decodes Unicode sequences, including emojis
  final regex = RegExp(r'\\u([0-9A-Fa-f]{4})');
  return input.replaceAllMapped(regex, (match) {
    // Convert \uXXXX to actual character
    return String.fromCharCode(int.parse(match.group(1)!, radix: 16));
  });
}




String makeEllipsis(String input, int maxLength) {
  if (input.length > maxLength) {
    return '${input.substring(0, maxLength)}...';
  }
  return input;
}

