
import 'package:dio/dio.dart';
import '../models/Address.dart';


class ApiService {
  final Dio _dio;
  String baseUrl;

  ApiService(this._dio, {this.baseUrl = 'https://resellme.tech/'}) {
    _dio.options = BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: 10000, // 10 seconds (old Dio versions)
      receiveTimeout: 10000, // 10 seconds (old Dio versions)
      headers: {
        'Cache-Control': 'no-cache',
      },
    );
  }



  Future<Response> createOrder(int userId,String orderInfo,int orderType,String token) async {
    try {
      final response = await _dio.post(
        'https://resellme.work/OrderEngine/CreateOrderServlet',
        queryParameters: {
          'userId': userId,
          'orderInfo': orderInfo,
          'orderType': orderType,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> getUserAddress(int userId, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}UserEngine/UserAddressServlet',
        queryParameters: {
          'userId': userId,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }




  Future<Response> postUserAddress(int userId, String token, Address address ) async {
    try {
      final response = await _dio.post(
        '${baseUrl}UserEngine/UserAddressServlet',
        queryParameters: {
          'userId': userId,
          'userAddressId':address.userAddressId,
          'customerName':address.customerName,
          'customerNumber':address.customerNumber,
          'fullAddress':address.fullAddress,
          'cityOrTown':address.cityOrTown,
          'nearestLandmark':address.nearestLandmark,
          'state':address.state,
          'pincode':address.pincode,
          'senderName':address.senderName,
          'senderNumber':address.senderNumber
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> getAvailableCoupons(int userId, int groupId,String filterType,String productJson, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}OrderEngine/GroupCouponsServlet',
        queryParameters: {
          'userId': userId,
          'groupId': groupId,
          'filterType': filterType,
          'productJson': productJson,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> verifyCoupons(int userId,int groupId,String couponCode,String actionType,String productJson, String token) async {
    try {
      final response = await _dio.post(
        '${baseUrl}OrderEngine/GroupCouponsServlet',
        queryParameters: {
          'userId': userId,
          'groupId': groupId,
          'couponCode': couponCode,
          'actionType': actionType,
          'productJson': productJson,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }


  Future<Response> getAllCollectionProducts(int userId, int catalogId, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}CatalogEngine/FetchProductsCatalogServlet',
        queryParameters: {
          'userId': userId,
          'catalogId': catalogId,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> getHomeScreenData(int userId, int catalogId, String token, int offset) async {
    try {
      final response = await _dio.get(
        '${baseUrl}GroupEngine/SearchSectionWVideoServlet',
        queryParameters: {
          'userId': userId,
          'onlyVideo': false
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
            'version': 795,
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> getSizesOfProduct(int userId, int catalogId, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}CatalogEngine/FetchProductsServlet',
        queryParameters: {
          'userId': userId,
          'catalogId': catalogId,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> getSuggestedCollectionProducts(int userId, int catalogId, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}GroupEngine/CatalogRecommendServlet',
        queryParameters: {
          'userId': userId,
          'catalogId': catalogId,
          'offset': 0,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> getWalletBalance(int userId, String balance, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}AccountEngine/ResellMeWalletServlet',
        queryParameters: {
          'userId': userId,
          'infoType': balance,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }


  Future<Response> getWalletHistory(int offset,int userId, String txns, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}AccountEngine/ResellMeWalletServlet',
        queryParameters: {
          'userId': userId,
          'infoType': txns,
          'startPosition':offset
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> getBankTransferHistory(int offset,int userId, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}AccountEngine/TransferRequestsServlet',
        queryParameters: {
          'userId': userId,
          'startPosition':offset
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }


  Future<Response> postRequestTransfer(int transferAmount,int userId, String accountDetails, String token) async {
    try {
      final response = await _dio.post(
        '${baseUrl}AccountEngine/TransferRequestsServlet',
        queryParameters: {
          'userId': userId,
          'transferAmount': transferAmount,
          'accountDetails': accountDetails,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to transfer: $e');
    }
  }

  Future<Response> postCatalogComments(int groupId,int userId, int catalogId,int catalogCommentId, String replyComment, String commentType,int rating, String token) async {
    try {
      final response = await _dio.post(
        '${baseUrl}CatalogEngine/PostCommentReplyServlet',
        queryParameters: {
          'userId': userId,
          'catalogId': catalogId,
          'catalogCommentId': catalogCommentId,
          'replyComment': replyComment,
          'commentType': commentType,
          'rating' : rating
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }

  Future<Response> getCatalogComments(int userId, int catalogId, String actionType, String showType, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}CatalogEngine/PostCommentServlet',
        queryParameters: {
          'userId': userId,
          'catalogId': catalogId,
          'actionType': actionType,
          'showType': showType,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }


  Future<Response?> updateOrder({
    required int orderId,
    required int userId,
    required String actionType,
    required String actionInfo,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        '${baseUrl}OrderEngine/UpdateOrderServlet',
        queryParameters: {
          'userId': userId,
          'orderId': orderId,
          'actionType': actionType,
          'actionInfo': actionInfo,
        },
        options: Options(
          headers: {
            'Authorization': token, // Set Authorization header
            'Cache-Control': 'no-cache',
          },
        ),
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        print('Request successful: ${response.data}');
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response data: ${response.data}');
      }

      return response;
    } catch (e) {
      // Handle error here
      print('Error: $e');
      throw e; // Re-throwing to be handled by the calling code
    }
  }

  Future<Response> getAllOrdersData(int offset,int userId, String filterCriteria, String filter, String orderId, String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}OrderEngine/FetchOrdersServlet',
        queryParameters: {
          'startPosition':offset,
          'userId': userId,
          'criteria': filterCriteria,
          'filter': filter,
          'orderId': orderId,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }


  Future<Response> getUnRepliedNotificationCounter(int groupId, String actionType,String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}GroupEngine/GetNotificationServlet',
        queryParameters: {
          'groupId': groupId,
          'actionType': actionType,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }




  Future<Response> getUnRepliedNotificationData(int groupId,int offset,int limit, String notificationType,String actionType,String token) async {
    try {
      final response = await _dio.get(
        '${baseUrl}GroupEngine/GetNotificationServlet',
        queryParameters: {
          'groupId': groupId,
          'offset': offset,
          'limit': limit,
          'notificationType': notificationType,
          'actionType': actionType,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'Cache-Control': 'no-cache',
          },
        ),
      );
      return response;
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }
  }


  Future<Response?> updateCatalog({
    required int catalogId,
    required int groupId,
    required int userId,
    required String updateType,
    required String updateInfo,
    required String token,
  }) async {
    try {
      final response = await _dio.post(
        '${baseUrl}CatalogEngine/UpdateCatalogServlet',
        queryParameters: {
          'catalogId': catalogId,
          'groupId': groupId,
          'userId': userId,
          'updateType': updateType,
          'updateInfo': updateInfo,
        },
        options: Options(
          headers: {
            'Authorization': token, // Set Authorization header
            'Cache-Control': 'no-cache',
          },
        ),
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        print('Request successful: ${response.data}');
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response data: ${response.data}');
      }

      return response;
    } catch (e) {
      // Handle error here
      print('Error: $e');
      throw e; // Re-throwing to be handled by the calling code
    }
  }

  Future<Response> uploadProduct(FormData formData, String token) async {
    final response = await _dio.post('${baseUrl}CatalogEngine/PostCatalogServlet', data: formData,  options: Options(
      headers: {
        'Authorization': token,
        'Cache-Control': 'no-cache',
      },
    ));
    return response;
  }


  Future<Response?> sendOTP(String phoneNumber) async {
    try {
      final queryParameters = {'actionType':"sendOTP",'phoneNumber': phoneNumber};
      final response = await _dio.post('${baseUrl}UserEngine/GroupLogin',queryParameters:queryParameters);
      return response;
    } on DioError catch (err) {
      print(err.error);
      rethrow;
    } catch (e) {
       print(e);
      throw e.toString();
    }
  }




  Future<Response?> fetchImageInfo(String token) async {
    const url = 'https://ResellMe.tech/CatalogEngine/SaveCatalogImagesOfAGroupServlet';

    try {
      final response = await Dio().get(
        url,
        options: Options(
          headers: {
            'Authorization': token,
          },
        ),
      );

      if (response.statusCode == 200) {
        return response; // You might need to adjust the return type
      } else {
        print('Failed to fetch image info: ${response.statusCode}');
        return null; // Return null on failure
      }
    } catch (e) {
      print('Error fetching image info: $e');
      return null; // Return null on error
    }
  }



  Future<Response?> getAllCollections({
    required int userId,
    required int groupId,
    required int offset,
    required int versionCode,
    required String token, // Authorization token
  }) async {
    const String url = 'https://ResellMe.tech/CatalogEngine/FetchCatalogsServlet';

    try {
      final response = await Dio().get(
        url,
        queryParameters: {
          'userId': userId,
          'groupId': groupId,
          'startPosition': offset,
          'versionCode': versionCode,
        },
        options: Options(
          headers: {
            'Authorization': token,
            'version': versionCode,
            'Cache-Control': 'no-cache',
          },
        ),
      );

      if (response.statusCode == 200) {
        return response; // You might need to parse the response based on your model
      } else {
        print('Failed to fetch collections: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching collections: $e');
      return null;
    }
  }






  // Future<Response?> uploadCsvFile(String token) async {
  //   try {
  //     // Step 1: Pick the CSV file
  //     final result = await FilePicker.platform.pickFiles(
  //       type: FileType.custom,
  //       allowedExtensions: ['xlsx'],
  //     );
  //
  //     if (result != null && result.files.isNotEmpty) {
  //       final file = result.files.first;
  //
  //       // Step 2: Prepare the file for upload based on platform
  //       FormData formData;
  //       if (file.bytes != null) {
  //         // For web
  //         formData = FormData.fromMap({
  //           'file': MultipartFile.fromBytes(file.bytes!, filename: file.name),
  //         });
  //       } else if (file.path != null) {
  //         // For mobile
  //         formData = FormData.fromMap({
  //           'file': await MultipartFile.fromFile(file.path!, filename: file.name),
  //         });
  //       } else {
  //         print('No valid file to upload.');
  //         return null;
  //       }
  //
  //
  //       // Step 4: Make the upload request
  //       final response = await _dio.post(
  //         'https://ResellMe.tech/CatalogEngine/PostBulkCatalogsFromExcelServlet',
  //         data: formData,
  //           options: Options(
  //             headers: {
  //               'Authorization': token,
  //             },
  //           )
  //           );
  //
  //       // Check for successful upload
  //       if (response.statusCode == 200) {
  //         return response; // Return the response on success
  //       } else {
  //         print('Failed to upload: ${response.statusCode}');
  //         return null; // Return null on failure
  //       }
  //     } else {
  //       print('No file selected.');
  //     }
  //   } catch (e) {
  //     print('Error uploading file: $e');
  //   }
  //   return null; // Return null if an error occurs
  // }

  // Future<Response> uploadFiles(
  //     List<Map<String, dynamic>> files,
  //     String token,
  //     int groupId,
  //     ) async {
  //   final formData = FormData();
  //
  //   // Add additional fields to the form data
  //   formData.fields.add(const MapEntry('thumbnail', 'No'));
  //   formData.fields.add(MapEntry('groupId', groupId.toString()));
  //
  //   for (var file in files) {
  //     final filePath = file['link'];
  //     final fileBytes = file['bytes'] as Uint8List?;
  //     final fileName = file['name'];
  //
  //     try {
  //       if (kIsWeb) {
  //         if (fileBytes != null) {
  //           formData.files.add(
  //             MapEntry(
  //               'fileObj',
  //               MultipartFile.fromBytes(fileBytes, filename: fileName),
  //             ),
  //           );
  //         }
  //       } else {
  //         if (filePath != null && filePath.isNotEmpty) {
  //           formData.files.add(
  //             MapEntry(
  //               'fileObj',
  //               await MultipartFile.fromFile(filePath, filename: fileName),
  //             ),
  //           );
  //         }
  //       }
  //     } catch (e) {
  //       print('Error processing file $fileName: $e');
  //     }
  //   }
  //
  //   const url = 'https://ResellMe.tech/CatalogEngine/SaveCatalogImagesOfAGroupServlet';
  //
  //   try {
  //     final response = await Dio().post(
  //       url,
  //       data: formData,
  //       options: Options(
  //         headers: {
  //           'Authorization': token,
  //         },
  //       ),
  //     );
  //
  //     if (response.statusCode == 200) {
  //       print('Files uploaded successfully: ${response.data}');
  //       return response; // Return the successful response
  //     } else {
  //       print('Failed to upload files: ${response.statusCode}');
  //       print('Response data: ${response.data}');
  //       return response;
  //     }
  //   } catch (e) {
  //     print('Error uploading files: $e');
  //     rethrow; // Rethrow to handle in a higher-level function if needed
  //   }
  // }






  // Future<void> downloadFile() async {
  //   try {
  //     const url = "https://ResellMe.tech/CatalogEngine/DownloadExcelFileServlet";
  //     final dio = Dio();
  //
  //     if ( !kIsWeb ) {
  //
  //       final response = await Dio().get<Uint8List>(
  //         url,
  //               options: Options(responseType: ResponseType.bytes),
  //             );
  //
  //             if (response.statusCode == 200) {
  //               final directory = await getApplicationDocumentsDirectory();
  //               final filePath = '${directory.path}/sample_ResellMe.xlsx';
  //               final file = File(filePath);
  //               await file.writeAsBytes(response.data!);
  //
  //               print('File downloaded and saved locally at $filePath');
  //             } else {
  //               print('Failed to download file: ${response.statusCode}');
  //             }
  //
  //     }else{
  //
  //
  //       // Fetch file data
  //       final response = await dio.get<List<int>>(
  //         url,
  //         options: Options(responseType: ResponseType.bytes),
  //       );
  //
  //       final bytes = response.data;
  //       if (bytes != null && bytes.isNotEmpty) {
  //         // Create a Blob from the file data
  //         final blob = html.Blob([Uint8List.fromList(bytes)]);
  //         // Create a URL for the Blob
  //         final objectUrl = html.Url.createObjectUrlFromBlob(blob);
  //
  //         // Create an anchor element and trigger download
  //         final anchor = html.AnchorElement(href: objectUrl)
  //           ..setAttribute('download', 'sample_ResellMe.xlsx') // Specify filename
  //           ..click(); // Programmatically click the anchor to start download
  //
  //         // Revoke the Blob URL to release resources
  //         html.Url.revokeObjectUrl(objectUrl);
  //       } else {
  //         print('No data received or data is empty.');
  //       }
  //     } }catch (e) {
  //     print('Error downloading file: $e');
  //   }
  // }





  Future<Response?> loginUser({
    required String phoneNumber,
    required int otp,
    required String actionType,
  }) async {
    try {
      final response = await _dio.post(
        'https://ResellMe.tech/UserEngine/GroupLogin',
        queryParameters: {
          'actionType': actionType,
          'phoneNumber': phoneNumber,
          'otp': otp
        },
      );

      // Check if the response status code is 200 (OK)
      if (response.statusCode == 200) {
        print('Request successful: ${response.data}');
      } else {
        print('Request failed with status: ${response.statusCode}');
        print('Response data: ${response.data}');
      }

      return response;
    } catch (e) {
      // Handle error here
      print('Error: $e');
      throw e; // Re-throwing to be handled by the calling code
    }
  }




  //
  // Future<List<Category>> fetchCategories() async {
  //   // Simulate a network delay
  //   await Future.delayed(Duration(seconds: 1));
  //
  //   // Hardcoded JSON response
  //   const jsonResponse = '''
  // {
  //   "error": false,
  //   "errorType": 1,
  //   "amountToAdd": -1,
  //   "statusCode": 200,
  //   "message": "OK",
  //   "data": [
  //     {
  //       "categoryId": 1,
  //       "categoryName": "Women Wears",
  //       "childCategories": [
  //         {"categoryId": 10, "categoryName": "Sarees"},
  //         {"categoryId": 11, "categoryName": "Kurtis & Kurtas"},
  //         {"categoryId": 12, "categoryName": "Kurta Sets"},
  //         {"categoryId": 13, "categoryName": "Suits & Dress Materials"},
  //         {"categoryId": 14, "categoryName": "Lehengas & Shararas"},
  //         {"categoryId": 15, "categoryName": "Tops, Tunics & Shirts"},
  //         {"categoryId": 16, "categoryName": "Dresses & Gowns"},
  //         {"categoryId": 17, "categoryName": "Blouses & Dupattas"},
  //         {
  //           "categoryId": 18,
  //           "categoryName": "Bottomwears",
  //           "childCategories": [
  //             {"categoryId": 64, "categoryName": "Pants"},
  //             {"categoryId": 65, "categoryName": "Jeans & Jeggings"},
  //             {"categoryId": 66, "categoryName": "Skirts & Shorts"},
  //             {"categoryId": 67, "categoryName": "Palazzos"},
  //             {"categoryId": 68, "categoryName": "Leggings"}
  //           ]
  //         },
  //         {
  //           "categoryId": 19,
  //           "categoryName": "Activewears",
  //           "childCategories": [
  //             {"categoryId": 69, "categoryName": "Joggers"},
  //             {"categoryId": 70, "categoryName": "Sports Bras"},
  //             {"categoryId": 71, "categoryName": "T-shirts"},
  //             {"categoryId": 72, "categoryName": "Leggings & Tights"}
  //           ]
  //         },
  //         {"categoryId": 20, "categoryName": "Innerwears & Nightwears"}
  //       ],
  //       "imageUrl": "https://d2t9awf6302wht.cloudfront.net/Categories/Skirt_Icon2.png"
  //     },
  //     {
  //       "categoryId": 2,
  //       "categoryName": "Men Wears",
  //       "childCategories": [
  //         {"categoryId": 21, "categoryName": "Shirts"},
  //         {"categoryId": 22, "categoryName": "T-shirts"},
  //         {
  //           "categoryId": 23,
  //           "categoryName": "Bottomwears",
  //           "childCategories": [
  //             {"categoryId": 73, "categoryName": "Shorts"},
  //             {"categoryId": 74, "categoryName": "Pants & Trousers"},
  //             {"categoryId": 75, "categoryName": "Jeans"},
  //             {"categoryId": 76, "categoryName": "Chinos"}
  //           ]
  //         },
  //         {
  //           "categoryId": 24,
  //           "categoryName": "Activewears",
  //           "childCategories": [
  //             {"categoryId": 77, "categoryName": "Joggers"},
  //             {"categoryId": 78, "categoryName": "Vests"},
  //             {"categoryId": 79, "categoryName": "Shorts"}
  //           ]
  //         },
  //         {"categoryId": 25, "categoryName": "Ethnic Wears"},
  //         {"categoryId": 26, "categoryName": "Innerwears & Nightwears"}
  //       ],
  //       "imageUrl": "https://d2t9awf6302wht.cloudfront.net/Categories/Shirt_Icon2.png"
  //     },
  //     {
  //       "categoryId": 3,
  //       "categoryName": "Kids Wears",
  //       "childCategories": [
  //         {"categoryId": 27, "categoryName": "Girls"},
  //         {"categoryId": 28, "categoryName": "Boys"},
  //         {"categoryId": 29, "categoryName": "Infants"},
  //         {"categoryId": 30, "categoryName": "Toys & Games"},
  //         {"categoryId": 31, "categoryName": "Bags & School Items"}
  //       ],
  //       "imageUrl": "https://d2t9awf6302wht.cloudfront.net/Categories/Diaper_Icon2.png"
  //     },
  //     {
  //       "categoryId": 4,
  //       "categoryName": "Jewelleries & Accessories",
  //       "childCategories": [
  //         {"categoryId": 32, "categoryName": "Chains & Necklaces"},
  //         {"categoryId": 33, "categoryName": "Pendant Sets"},
  //         {"categoryId": 34, "categoryName": "Mangalsutras"},
  //         {"categoryId": 35, "categoryName": "Rings"},
  //         {"categoryId": 36, "categoryName": "Bangles & Bracelets"},
  //         {"categoryId": 37, "categoryName": "Earrings & Studs"},
  //         {"categoryId": 38, "categoryName": "Sunglasses & Watches"},
  //         {"categoryId": 39, "categoryName": "Others"}
  //       ],
  //       "imageUrl": "https://d2t9awf6302wht.cloudfront.net/Categories/Ring_Icon2.png"
  //     },
  //     {
  //       "categoryId": 5,
  //       "categoryName": "Home & Living",
  //       "childCategories": [
  //         {"categoryId": 40, "categoryName": "Bedsheets"},
  //         {"categoryId": 41, "categoryName": "Diwan Sets"},
  //         {"categoryId": 42, "categoryName": "Cushions & Pillows"},
  //         {"categoryId": 43, "categoryName": "Carpets & Rugs"},
  //         {"categoryId": 44, "categoryName": "Door & Table Mats"},
  //         {"categoryId": 45, "categoryName": "Curtains & Sheers"},
  //         {"categoryId": 46, "categoryName": "Wall Decors"},
  //         {"categoryId": 47, "categoryName": "Towels & Blankets"},
  //         {"categoryId": 48, "categoryName": "Kitchen Utilities"}
  //       ],
  //       "imageUrl": "https://d2t9awf6302wht.cloudfront.net/Categories/Sofa_Icon2.png"
  //     },
  //     {
  //       "categoryId": 6,
  //       "categoryName": "Bags & Purses",
  //       "childCategories": [
  //         {"categoryId": 49, "categoryName": "Handbags"},
  //         {"categoryId": 50, "categoryName": "Clutches"},
  //         {"categoryId": 51, "categoryName": "Slingbags"},
  //         {"categoryId": 52, "categoryName": "Wallets"},
  //         {"categoryId": 53, "categoryName": "Travel Bags"},
  //         {"categoryId": 54, "categoryName": "Organizers"}
  //       ],
  //       "imageUrl": "https://d2t9awf6302wht.cloudfront.net/Categories/Bag_Icon2.png"
  //     },
  //     {
  //       "categoryId": 7,
  //       "categoryName": "Footwears",
  //       "childCategories": [
  //         {"categoryId": 55, "categoryName": "Women Sandals"},
  //         {"categoryId": 56, "categoryName": "Jutties & Bellies"},
  //         {"categoryId": 57, "categoryName": "Women Shoes"},
  //         {"categoryId": 58, "categoryName": "Men Shoes"}
  //       ],
  //       "imageUrl": "https://d2t9awf6302wht.cloudfront.net/Categories/Sandal_Icon2.png"
  //     },
  //     {
  //       "categoryId": 8,
  //       "categoryName": "Beauty & Health",
  //       "childCategories": [
  //         {"categoryId": 59, "categoryName": "Skincare & Cosmetics"},
  //         {"categoryId": 60, "categoryName": "Makeup"},
  //         {"categoryId": 61, "categoryName": "Perfumes & Deodrants"},
  //         {"categoryId": 62, "categoryName": "Health Products"}
  //       ],
  //       "imageUrl": "https://d2t9awf6302wht.cloudfront.net/Categories/Lips_Icon2.png"
  //     },
  //     {
  //       "categoryId": 9,
  //       "categoryName": "Others",
  //       "childCategories": [
  //         {"categoryId": 63, "categoryName": "Customized Items"}
  //       ],
  //       "imageUrl": "https://d2t9awf6302wht.cloudfront.net/Categories/More_Icon2.png"
  //     }
  //   ]
  // }
  // ''';
  //
  //   final jsonData = jsonDecode(jsonResponse);
  //   if (jsonData['error']) {
  //     throw Exception('Failed to load categories');
  //   }
  //
  //   List<Category> categories = (jsonData['data'] as List)
  //       .map((json) => Category.fromJson(json))
  //       .toList();
  //
  //   return categories;
  // }


}
