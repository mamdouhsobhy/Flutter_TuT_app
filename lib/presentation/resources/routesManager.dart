
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tut_app/presentation/forgotPasswordScreen/forgot_password_screen.dart';
import 'package:tut_app/presentation/loginScreen/login_screen.dart';
import 'package:tut_app/presentation/mainScreen/main_screen.dart';
import 'package:tut_app/presentation/onboardingScreen/view/onboarding_screen.dart';
import 'package:tut_app/presentation/registerScreen/register_screen.dart';
import 'package:tut_app/presentation/resources/stringManager.dart';
import 'package:tut_app/presentation/splashScreen/splash_screen.dart';
import 'package:tut_app/presentation/storeDetailsScreen/store_details_screen.dart';

class Routes {
  static const String splashRoute = "/";
  static const String loginRoute = "/login";
  static const String registerRoute = "/register";
  static const String forgotPasswordRoute = "/forgotPassword";
  static const String onBoardingRoute = "/onBoarding";
  static const String mainRoute = "/main";
  static const String storeDetailsRoute = "/storeDetails";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splashRoute:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.loginRoute:
      //initLoginModule();
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.onBoardingRoute:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.registerRoute:
      //initRegisterModule();
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.forgotPasswordRoute:
      //initForgotPasswordModule();
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case Routes.mainRoute:
      //initHomeModule();
        return MaterialPageRoute(builder: (_) => const MainScreen());
      case Routes.storeDetailsRoute:
      //initStoreDetailsModule();
        return MaterialPageRoute(builder: (_) => const StoreDetailsScreen());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(
            title: Text(AppStrings.noRouteFound),
          ),
          body: Center(child: Text(AppStrings.noRouteFound)),
        ));
  }
}