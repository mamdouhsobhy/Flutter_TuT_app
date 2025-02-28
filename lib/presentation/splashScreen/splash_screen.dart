import 'dart:async';

import 'package:flutter/material.dart';
import 'package:tut_app/presentation/resources/assetsManager.dart';
import 'package:tut_app/presentation/resources/colorManager.dart';
import 'package:tut_app/presentation/resources/constantsManager.dart';
import 'package:tut_app/presentation/resources/routesManager.dart';

import '../../app/app_prefs.dart';
import '../../app/di.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Timer? _timer;
  final AppPreferences _appPreferences = instance<AppPreferences>();

  _startDelay(){
    _timer = Timer(const Duration(seconds: AppConstants.splashDelay), () {
      _goNext();
    });
  }

  Future<void> _goNext() async {
    bool isUserLoggedIn = await _appPreferences.isUserLoggedIn();
    print("Routs $isUserLoggedIn");

    if (isUserLoggedIn) {
      // navigate to main screen
      Navigator.pushReplacementNamed(context, Routes.mainRoute);
    } else {
      bool isOnBoardingScreenViewed = await _appPreferences.isOnBoardingScreenViewed();

      if (isOnBoardingScreenViewed) {
        // navigate to login screen
        Navigator.pushReplacementNamed(context, Routes.loginRoute);
      } else {
        // navigate to onboarding screen
        Navigator.pushReplacementNamed(context, Routes.onBoardingRoute);
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _startDelay();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.primary,
      body: SafeArea(
        child: Center(
          child: Image.asset(ImageAssets.splashLogo),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
