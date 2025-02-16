
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:tut_app/app/Constants.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:tut_app/presentation/resources/stringManager.dart';

abstract class FlowState{
  StateRendererType getStateRendererType();
  String getMessage();
}

//loading state(POPUP || FULL_SCREEN)
class LoadingState extends FlowState{

  StateRendererType stateRendererType;
  String? message ;

  LoadingState({required this.stateRendererType,String message = AppStrings.loading});

  @override
  String getMessage() {
    return message ?? AppStrings.loading;
  }

  @override
  StateRendererType getStateRendererType() => stateRendererType;

}
//error state(POPUP || FULL_SCREEN)
class ErrorState extends FlowState{

  StateRendererType stateRendererType;
  String? message ;

  ErrorState(this.stateRendererType,this.message);

  @override
  String getMessage() {
    return message ?? AppStrings.loading;
  }

  @override
  StateRendererType getStateRendererType() => stateRendererType;

}
//content state(POPUP || FULL_SCREEN)
class ContentState extends FlowState{

  ContentState();

  @override
  String getMessage() {
    return Constants.empty;
  }

  @override
  StateRendererType getStateRendererType() => StateRendererType.CONTENT_STATE;

}
//empty state(POPUP || FULL_SCREEN)
class EmptyState extends FlowState{

  String message;

  EmptyState(this.message);

  @override
  String getMessage() {
    return message;
  }

  @override
  StateRendererType getStateRendererType() => StateRendererType.FULL_SCREEN_EMPTY_STATE;

}

extension FlowStateExtension on FlowState{
  Widget getScreenWidget(BuildContext context, Widget contentScreenWidget,
      Function retryActionFunction) {
    switch (runtimeType) {
      case LoadingState:
        {
          if (getStateRendererType() == StateRendererType.POPUP_LOADING_STATE) {
            showPopup(context, getStateRendererType(), getMessage());

            return contentScreenWidget;
          } else {
            return StateRenderer(message: getMessage(),
                stateRendererType: getStateRendererType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case ErrorState:
        {
          dismissDialog(context);
          if (getStateRendererType() == StateRendererType.POPUP_ERROR_STATE) {
            showPopup(context, getStateRendererType(), getMessage());

            return contentScreenWidget;
          } else {
            return StateRenderer(message: getMessage(),
                stateRendererType: getStateRendererType(),
                retryActionFunction: retryActionFunction);
          }
        }
      case EmptyState:
        {
          return StateRenderer(message: getMessage(),
              stateRendererType: getStateRendererType(),
              retryActionFunction: (){});
        }
      case ContentState:
        {
          dismissDialog(context);
          return contentScreenWidget;
        }
      default: {
        dismissDialog(context);
        return contentScreenWidget;
      }
    }
  }

  _isCurrentDialogShowing(BuildContext context) => ModalRoute.of(context)?.isCurrent != true;

  dismissDialog(BuildContext context){
    if(_isCurrentDialogShowing(context)){
      Navigator.of(context,rootNavigator: true).pop(true);
    }
  }

  showPopup(BuildContext context,StateRendererType stateRendererType,String message){
    WidgetsBinding.instance.addPostFrameCallback((_)=>
      showDialog(context: context, builder: (BuildContext context)=>
        StateRenderer(stateRendererType: stateRendererType,message: message,
            retryActionFunction: (){})));
  }
}