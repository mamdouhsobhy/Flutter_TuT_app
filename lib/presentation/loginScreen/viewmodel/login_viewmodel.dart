
import 'dart:async';

import 'package:tut_app/presentation/base/baseViewModel.dart';
import 'package:tut_app/presentation/common/freezed_data_classes.dart';

import '../../../domain/usecase/login_usecase.dart';

class LoginViewModel implements BaseViewModel,LoginViewModelInputs,LoginViewModelOutputs{

  final StreamController _userNameStreamController = StreamController<String>.broadcast();
  final StreamController _passwordStreamController = StreamController<String>.broadcast();
  final StreamController _loginButtonStreamController = StreamController<void>.broadcast();

  var loginObject = LoginObject("", "");

  final LoginUseCase _loginUseCase;

  LoginViewModel(this._loginUseCase);

  //inputs
  @override
  void dispose() {
    _userNameStreamController.close();
    _passwordStreamController.close();
    _loginButtonStreamController.close();
  }

  @override
  void start() {
    // TODO: implement start
  }

  @override
  Sink get inputPassword => _passwordStreamController.sink;

  @override
  Sink get inputUserName => _userNameStreamController.sink;

  @override
  Sink get enableButton => _loginButtonStreamController.sink;

  @override
  setPassword(String password) {
    inputPassword.add(password);
    loginObject = loginObject.copyWith(password: password);
    enableButton.add(null);
  }

  @override
  setUserName(String username) {
    inputUserName.add(username);
    loginObject = loginObject.copyWith(username: username);
    enableButton.add(null);
  }

  @override
  login() async{
    (await _loginUseCase.execute(LoginUseCaseInput(loginObject.username, loginObject.password)))
    .fold((left) => {

    }, (data) => {

    });
  }

  //outputs
  @override
  Stream<bool> get outputIsPasswordValid => _passwordStreamController.stream.map((password) => _isPasswordValid(password));

  @override
  Stream<bool> get outputIsUserNameValid => _userNameStreamController.stream.map((username) => _isUserNameValid(username.s));

  @override
  Stream<bool> get outputIsLoginButtonEnabled => _loginButtonStreamController.stream.map((_) => _isLoginButtonEnabled());

  bool _isPasswordValid(String password){
    return password.isNotEmpty;
  }

  bool _isUserNameValid(String username){
    return username.isNotEmpty;
  }

  bool _isLoginButtonEnabled(){
    return (_isPasswordValid(loginObject.password) && _isUserNameValid(loginObject.username));
  }

}

abstract class LoginViewModelInputs{
  setUserName(String username);
  setPassword(String password);
  login();

  Sink get inputUserName;
  Sink get inputPassword;
  Sink get enableButton;
}

abstract class LoginViewModelOutputs{
  Stream<bool> get outputIsUserNameValid;
  Stream<bool> get outputIsPasswordValid;
  Stream<bool> get outputIsLoginButtonEnabled;
}