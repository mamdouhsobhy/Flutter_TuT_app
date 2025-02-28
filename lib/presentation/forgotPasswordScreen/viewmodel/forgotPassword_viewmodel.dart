

import 'dart:async';

import 'package:tut_app/presentation/base/baseViewModel.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer_impl.dart';

import '../../../domain/usecase/forgotPassword_usecase.dart';

class ForgotPasswordViewModel extends BaseViewModel implements ForgotPasswordViewModelInputs,
    ForgotPasswordViewModelOutputs{

  final StreamController _userNameStreamController = StreamController<String>.broadcast();
  final StreamController _resetPasswordButtonStreamController = StreamController<void>.broadcast();

  var email = "";

  final ForgotPasswordUseCase _forgotPasswordUseCase;

  ForgotPasswordViewModel(this._forgotPasswordUseCase);

  //inputs
  @override
  void dispose() {
     super.dispose();
    _userNameStreamController.close();
     _resetPasswordButtonStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get enableButton => _resetPasswordButtonStreamController.sink;

  @override
  setUserName(String username) {
    inputUserName.add(username);
    email = username;
    enableButton.add(null);
  }

  @override
  Future<void> resetPassword() async {
    isShowError = false;

    inputState.add(LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));

    (await _forgotPasswordUseCase.execute(ForgotPasswordUseCaseInput(email)))
        .fold(
          (failure) {
        inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message));
      }, (data) {
        inputState.add(SuccessState(data));
      },
    );
  }


  //outputs
  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream.map((username) => _isUserNameValid(username.s));

  @override
  Stream<bool> get outputIsResetPasswordButtonEnabled => _resetPasswordButtonStreamController.stream.map((_) => _isResetPassButtonEnabled());

  bool _isUserNameValid(String username){
    return username.isNotEmpty;
  }

  bool _isResetPassButtonEnabled(){
    return (_isUserNameValid(email));
  }

  @override
  bool isShowError = false;

}

abstract class ForgotPasswordViewModelInputs{
  setUserName(String username);

  resetPassword();

  Sink get inputUserName;
}

abstract class ForgotPasswordViewModelOutputs{
  Stream<bool> get outputIsUserNameValid;
  Stream<bool> get outputIsResetPasswordButtonEnabled;
}