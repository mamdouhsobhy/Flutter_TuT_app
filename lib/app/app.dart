import 'package:flutter/material.dart';
import 'package:tut_app/presentation/resources/routesManager.dart';
import '../presentation/resources/themeManager.dart';

class MyApp extends StatefulWidget {
  //named constructor
  MyApp._internal();

  static final MyApp _instance =
      MyApp._internal(); //singleton or single instance

  factory MyApp() => _instance; //factory

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.splashRoute,
      theme: getApplicationTheme(),
    );
  }
}
