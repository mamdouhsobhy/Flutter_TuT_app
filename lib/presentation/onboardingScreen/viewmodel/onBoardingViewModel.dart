
import 'dart:async';

import 'package:tut_app/domain/models.dart';
import 'package:tut_app/presentation/base/baseViewModel.dart';

import '../../resources/assetsManager.dart';
import '../../resources/stringManager.dart';

class OnBoardingViewModel implements BaseViewModel,OnBoardingViewModelInputs,OnBoardingViewModelOutputs{

  StreamController _streamController = StreamController<SliderViewObject>();
  late final List<SliderObject> _list;
  int _currentIndex = 0;

  //baseViewModel inputs
  @override
  void dispose() {
    _streamController.close();
  }

  @override
  void start() {
    _list = _getSliderData();
    _postDataToView();
  }

  //onBoardingViewModel Inputs
  @override
  int goToBackPage() {
    if (_currentIndex != 0) {
      _currentIndex--;
    }
    return _currentIndex;
  }

  @override
  int goToNextPage() {
    if (_currentIndex != _list.length - 1) {
      _currentIndex++;
    }
    return _currentIndex;
  }

  @override
  void goToLoginPage() {
    // TODO: implement goToLoginPage
  }

  @override
  void onPageChanged(int index) {
    _currentIndex = index;
    _postDataToView();
  }

  @override
  Sink get inputSliderViewObject => _streamController.sink;

  //onboarding viewModel outputs
  @override
  Stream<SliderViewObject> get outputSliderViewObject => _streamController.stream.map((sliderViewObject) => sliderViewObject);

  //onboarding private functions
  void _postDataToView(){
    inputSliderViewObject.add(SliderViewObject(_list[_currentIndex], _list.length, _currentIndex));
  }
  List<SliderObject> _getSliderData() => [
    SliderObject(AppStrings.onBoardingTitle1,
        AppStrings.onBoardingSubTitle1, ImageAssets.onboardingLogo1),
    SliderObject(AppStrings.onBoardingTitle2,
        AppStrings.onBoardingSubTitle2, ImageAssets.onboardingLogo2),
    SliderObject(AppStrings.onBoardingTitle3,
        AppStrings.onBoardingSubTitle3, ImageAssets.onboardingLogo3),
    SliderObject(AppStrings.onBoardingTitle4,
        AppStrings.onBoardingSubTitle4, ImageAssets.onboardingLogo4),
  ];

}

abstract class OnBoardingViewModelInputs{

  int goToNextPage();

  int goToBackPage();

  void goToLoginPage();

  void onPageChanged(int index);

  Sink get inputSliderViewObject;

}

abstract class OnBoardingViewModelOutputs{
  Stream<SliderViewObject> get outputSliderViewObject;
}