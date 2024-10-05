import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tut_app/domain/models.dart';
import 'package:tut_app/presentation/onboardingScreen/viewmodel/onBoardingViewModel.dart';
import 'package:tut_app/presentation/resources/assetsManager.dart';
import 'package:tut_app/presentation/resources/colorManager.dart';
import 'package:tut_app/presentation/resources/constantsManager.dart';
import 'package:tut_app/presentation/resources/routesManager.dart';
import 'package:tut_app/presentation/resources/stringManager.dart';
import 'package:tut_app/presentation/resources/valuesManager.dart';

import '../widget/onboarding_pages.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final OnBoardingViewModel _viewModel = OnBoardingViewModel();

  _bind(){
    _viewModel.start();
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: _viewModel.outputSliderViewObject,
        builder: (ctx,snapshot){
          return _getOnboardingContentPage(snapshot.data);
        });
  }

  Widget _getOnboardingContentPage(SliderViewObject? data){
    return Scaffold(
      backgroundColor: ColorManager.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle(
            statusBarColor: ColorManager.white,
            statusBarIconBrightness: Brightness.dark),
      ),
      body: PageView.builder(
        controller: _pageController,
        itemCount: data?.numOfSliders,
        onPageChanged: (index) {
            _viewModel.onPageChanged(index);
        },
        itemBuilder: (ctx, index) {
          return OnBoardingPage(sliderObject: data!.sliderObject);
        },
      ),
      bottomSheet: Container(
        height: AppSize.s100,
        color: ColorManager.white,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                  onPressed: () {
                    Navigator.pushReplacementNamed(context, Routes.loginRoute);
                  },
                  child: Text(
                    AppStrings.skip,
                    textAlign: TextAlign.end,
                    style: Theme.of(context).textTheme.labelSmall,
                  )),
            ),
            _getBottomSheetArrowAndIndicator(data)
          ],
        ),
      ),
    );
  }

  Widget _getBottomSheetArrowAndIndicator(SliderViewObject? data) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(
          vertical: AppPadding.p14, horizontal: AppPadding.p14),
      color: ColorManager.primary,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          InkWell(
            child: SizedBox(
                height: AppSize.s16,
                width: AppSize.s16,
                child: SvgPicture.asset(ImageAssets.leftArrowIc)),
            onTap: () {
              _pageController.animateToPage(_viewModel.goToBackPage(),
                  duration:
                      Duration(milliseconds: AppConstants.sliderAnimationTime),
                  curve: Curves.bounceInOut);
            },
          ),
          Row(
            children: [
              for (int i = 0; i < data!.numOfSliders; i++)
                Padding(
                  padding: const EdgeInsets.all(AppSize.s4),
                  child: SvgPicture.asset(i == data.currentIndex
                      ? ImageAssets.hollowCircleIc
                      : ImageAssets.solidCircleIc),
                )
            ],
          ),
          InkWell(
            child: SizedBox(
                height: AppSize.s16,
                width: AppSize.s16,
                child: SvgPicture.asset(ImageAssets.rightArrowIc)),
            onTap: () {
              _pageController.animateToPage(_viewModel.goToNextPage(),
                  duration:
                      Duration(milliseconds: AppConstants.sliderAnimationTime),
                  curve: Curves.bounceInOut);
            },
          ),
        ],
      ),
    );
  }


  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }
}

