import 'dart:js';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:tut_app/app/shared_button.dart';
import 'package:tut_app/presentation/resources/assetsManager.dart';
import 'package:tut_app/presentation/resources/colorManager.dart';
import 'package:tut_app/presentation/resources/fontManager.dart';
import 'package:tut_app/presentation/resources/stringManager.dart';
import 'package:tut_app/presentation/resources/styleManager.dart';
import 'package:tut_app/presentation/resources/valuesManager.dart';

enum StateRendererType{
  POPUP_LOADING_STATE,
  POPUP_ERROR_STATE,

  FULL_SCREEN_LOADING_STATE,
  FULL_SCREEN_ERROR_STATE,
  FULL_SCREEN_EMPTY_STATE,

  CONTENT_STATE
}

class StateRenderer extends StatelessWidget {
  StateRenderer({super.key,required this.stateRendererType,this.message = "", this.title = "",required this.retryActionFunction});

  StateRendererType stateRendererType;
  String message;
  String title;
  Function retryActionFunction;

  @override
  Widget build(BuildContext context) {
    return _getStateWidget(context);
  }

  Widget _getStateWidget(BuildContext context){
    switch (stateRendererType){

      case StateRendererType.POPUP_LOADING_STATE:
       return _getPopupDialog(context,[
          _getAnimatedImage(JsonAssets.loading)
        ]);
      case StateRendererType.POPUP_ERROR_STATE:
        return _getPopupDialog(context,[
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.ok,context)
        ]);
      case StateRendererType.FULL_SCREEN_LOADING_STATE:
        return _getItemsColum([
          _getAnimatedImage(JsonAssets.loading),
          _getMessage(message)
        ]);
      case StateRendererType.FULL_SCREEN_ERROR_STATE:
        return _getItemsColum([
          _getAnimatedImage(JsonAssets.error),
          _getMessage(message),
          _getRetryButton(AppStrings.retryAgain,context)
        ]);
      case StateRendererType.FULL_SCREEN_EMPTY_STATE:
        return _getItemsColum([
          _getAnimatedImage(JsonAssets.empty),
          _getMessage(message)
        ]);
      case StateRendererType.CONTENT_STATE:
        return Container();
      default: return Container();
    }
  }

  Widget _getPopupDialog(BuildContext context,List<Widget> children){
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppSize.s14),
      ),
      elevation: AppSize.s1_5,
      backgroundColor: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(color: ColorManager.white,shape: BoxShape.rectangle,borderRadius:BorderRadius.circular(AppSize.s14),
        boxShadow: const [BoxShadow(
          color: Colors.black26
        )]),
        child: _getDialogContent(context,children),
      ),
    );
  }

  Widget _getDialogContent(BuildContext context,List<Widget> children){
   return  Column(
     mainAxisSize: MainAxisSize.min,
     mainAxisAlignment: MainAxisAlignment.center,
     crossAxisAlignment: CrossAxisAlignment.center,
     children: [

     ],
   );
  }

  Widget _getItemsColum(List<Widget> children){
    return Column(
  mainAxisAlignment: MainAxisAlignment.center,
  crossAxisAlignment: CrossAxisAlignment.center,
      children: [

  ],
      );
}

 Widget _getAnimatedImage(String animationName){
    return SizedBox(
      height: AppSize.s100,
      width: AppSize.s100,
      child: Lottie.asset(animationName),
    );
 }

  Widget _getMessage(String message){
    return Text(message,
    style: getRegularStyle(color: ColorManager.black,fontSize: FontSize.size18),);
  }


  Widget _getRetryButton(String buttonTitle, BuildContext context){
    return MyButton(color: ColorManager.primary, buttonText: buttonTitle, fun: (){
      if(stateRendererType == StateRendererType.FULL_SCREEN_EMPTY_STATE) {
        retryActionFunction.call();
      }else{
        Navigator.of(context).pop();
      }
    });
  }
}
