

import 'dart:async';
import 'dart:io';

import 'package:tut_app/app/function.dart';
import 'package:tut_app/presentation/base/baseViewModel.dart';
import 'package:tut_app/presentation/common/freezed_data_classes.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer_impl.dart';

import '../../../domain/usecase/Register_usecase.dart';


class RegisterViewModel extends BaseViewModel implements RegisterViewModelInputs,RegisterViewModelOutputs{

  final StreamController _userNameStreamController = StreamController<String>.broadcast();
  final StreamController _mobileNumberStreamController = StreamController<String>.broadcast();
  final StreamController _emailStreamController = StreamController<String>.broadcast();
  final StreamController _passwordStreamController = StreamController<String>.broadcast();
  final StreamController _profilePhotoStreamController = StreamController<File>.broadcast();
  final StreamController _RegisterButtonStreamController = StreamController<void>.broadcast();

  var registerObject = RegisterObject("", "+20","","","","");

  final RegisterUserCase _registerUseCase;

  RegisterViewModel(this._registerUseCase);

  //inputs
  @override
  void dispose() {
     super.dispose();
    _userNameStreamController.close();
    _mobileNumberStreamController.close();
    _emailStreamController.close();
    _passwordStreamController.close();
    _profilePhotoStreamController.close();
    _RegisterButtonStreamController.close();
  }

  @override
  void start() {
    inputState.add(ContentState());
  }

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get inputMobileNumber => _mobileNumberStreamController.sink;

  @override
  Sink get inputEmail => _emailStreamController.sink;

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputProfilePhoto => _profilePhotoStreamController.sink;

  @override
  Sink get enableButton => _RegisterButtonStreamController.sink;

  @override
  setUserName(String userName) {
    inputUserName.add(userName);
    registerObject = registerObject.copyWith(username: userName);
    enableButton.add(null);
  }

  @override
  setMobileNumber(String mobile) {
    inputMobileNumber.add(mobile);
    registerObject = registerObject.copyWith(mobileNumber: mobile);
    enableButton.add(null);
  }

  @override
  setEmail(String email) {
    inputEmail.add(email);
    registerObject = registerObject.copyWith(email: email);
    enableButton.add(null);
  }

  @override
  setPassword(String password) {
    inputPassword.add(password);
    registerObject = registerObject.copyWith(password: password);
    enableButton.add(null);
  }

  @override
  setProfilePhoto(File image) {
    inputProfilePhoto.add(image);
    registerObject = registerObject.copyWith(profilePhoto: image.path);
  }


  @override
  Future<void> register() async {
    isShowError = false;

    inputState.add(LoadingState(stateRendererType: StateRendererType.POPUP_LOADING_STATE));

    (await _registerUseCase.execute(RegisterUserCaseInput(registerObject.username, "+20",registerObject.mobileNumber,registerObject.email,registerObject.password,registerObject.profilePhoto)))
        .fold(
          (failure) {
        inputState.add(ErrorState(StateRendererType.POPUP_ERROR_STATE, failure.message));
      }, (data) {
      inputState.add(ContentState());
      },
    );
  }


  //outputs
  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream.map((username) => _isUserNameValid(username));

  @override
  Stream<bool> get outputIsMobileNumberValid => _mobileNumberStreamController.stream.map((mobile) => _isMobileNumberValid(mobile));

  @override
  Stream<bool> get outputIsEmailValid => _emailStreamController.stream.map((email) => isEmailValid(email));

  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream.map((password) => _isPasswordValid(password));

  @override
  Stream<File> get outputIsProfilePhotoValid => _profilePhotoStreamController.stream.map((file) => file);

  @override
  Stream<bool> get outputIsRegisterButtonEnabled => _RegisterButtonStreamController.stream.map((_) => _isRegisterButtonEnabled());

  bool _isUserNameValid(String username){
    return username.isNotEmpty;
  }

  bool _isMobileNumberValid(String mobile){
    return mobile.isNotEmpty;
  }

  bool _isPasswordValid(String password){
    return password.isNotEmpty;
  }

  bool _isRegisterButtonEnabled(){
    return (_isUserNameValid(registerObject.username) && _isMobileNumberValid(registerObject.mobileNumber) && isEmailValid(registerObject.email) && _isPasswordValid(registerObject.password));
  }

  @override
  bool isShowError = false;

}

abstract class RegisterViewModelInputs{
  setUserName(String username);
  setMobileNumber(String password);
  setEmail(String email);
  setPassword(String password);
  setProfilePhoto(File password);
  register();

  Sink get inputUserName;
  Sink get inputMobileNumber;
  Sink get inputEmail;
  Sink get inputPassword;
  Sink get inputProfilePhoto;
  Sink get enableButton;
}

abstract class RegisterViewModelOutputs{
  Stream<bool> get outputIsUserNameValid;
  Stream<bool> get outputIsMobileNumberValid;
  Stream<bool> get outputIsEmailValid;
  Stream<bool> get outputIsPasswordValid;
  Stream<File> get outputIsProfilePhotoValid;
  Stream<bool> get outputIsRegisterButtonEnabled;
}