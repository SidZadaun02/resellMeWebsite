import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ResellMe/route/route_constants.dart';
import 'package:ResellMe/route/router.dart' as router;
import 'package:ResellMe/theme/app_theme.dart';

import 'helper/cart_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => CartProvider(), // Provide CartProvider globally
      child: const MyApp(),
    ),
  );
}




class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'ResellMe',
      theme: AppTheme.lightTheme(context),
      themeMode: ThemeMode.light,
      onGenerateRoute: router.generateRoute,
      initialRoute: productResponsive,
      onGenerateInitialRoutes: (String initialRouteName) {
        return [router.generateRoute(RouteSettings(name: initialRouteName))];
      },
    );

  }



}
