
import 'package:ResellMe/screens/home/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:ResellMe/screens/product/views/product_responsive.dart';

import 'screen_export.dart';

Route<dynamic> generateRoute(RouteSettings settings) {
  // Use Uri.base to capture the full URL with query parameters
  final uri = Uri.base;

  // Logging the URI and query parameters for debugging
  print('URI: $uri');  // Should print the full URI (e.g. http://localhost:60638/product/1234)
  print('Query Parameters: ${uri.queryParameters}');  // Prints query parameters if any
  print('Path: ${uri.path}');  // Should print something like /product/1234

  // Checking if we have a valid product ID in the path
  if (uri.pathSegments.isNotEmpty && uri.pathSegments[0] == 'product') {
    final catalogId = int.tryParse(uri.pathSegments[1]) ?? 3865399;  // Safely parse the ID or use a default
    return MaterialPageRoute(
      builder: (context) => HomeScreen(),
    );
  }

  // Handle other routes like the onboarding screen or product responsive
  switch (uri.path) {
    case '/productResponsive':
      final id = uri.queryParameters['id'] != null
          ? int.tryParse(uri.queryParameters['id']!)
          : 3865399;
      return MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );
    default:
      return MaterialPageRoute(
        builder: (context) => HomeScreen(),
      );
  }
}
