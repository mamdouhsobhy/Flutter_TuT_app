
//onboarding models
class SliderObject {
  String title;
  String subTitle;
  String image;

  SliderObject(this.title, this.subTitle, this.image);
}

class SliderViewObject {
  SliderObject sliderObject;
  int numOfSliders;
  int currentIndex;

  SliderViewObject(this.sliderObject, this.numOfSliders, this.currentIndex);
}
