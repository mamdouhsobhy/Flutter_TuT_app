import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/app/shared_button.dart';
import 'package:tut_app/domain/usecase/login_usecase.dart';
import 'package:tut_app/presentation/resources/valuesManager.dart';
import 'package:tut_app/presentation/resources/colorManager.dart';

import '../../../app/shared_text_field.dart';
import '../../resources/assetsManager.dart';
import '../../resources/colorManager.dart';
import '../../resources/routesManager.dart';
import '../../resources/stringManager.dart';
import '../viewmodel/login_viewmodel.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final LoginViewModel _loginViewModel = instance<LoginViewModel>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  
  _bind(){
    _loginViewModel.start();
    _userNameController.addListener(() =>_loginViewModel.setUserName(_userNameController.text));
    _passwordController.addListener(() =>_loginViewModel.setPassword(_passwordController.text));
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return _getContentWidget();
  }

  Widget _getContentWidget(){
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: ColorManager.white,
        statusBarIconBrightness: Brightness.dark,
      ),
      child: Scaffold(
          backgroundColor: ColorManager.white,
          body: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(height: AppPadding.p60,),
                  Image.asset(width: AppSize.s180,height: AppSize.s180,ImageAssets.splashLogo),
                  StreamBuilder(
                      stream: _loginViewModel.outputIsUserNameValid,
                      builder: (ctx,snapshot){
                        return MyTextField(
                            hint: "Enter user name",
                            obscureText: false,
                            inputType: TextInputType.emailAddress,
                            controller: _userNameController,
                            takeValue: (value) {
                              _loginViewModel.setUserName(value);
                            });
                      }),
                  SizedBox(height: AppPadding.p20,),
                  StreamBuilder(
                      stream: _loginViewModel.outputIsPasswordValid,
                      builder: (ctx,snapshot){
                        return MyTextField(
                            hint: "Enter your password",
                            obscureText: true,
                            inputType: TextInputType.visiblePassword,
                            controller: _passwordController,
                            takeValue: (value) {
                              _loginViewModel.setPassword(value);
                            });
                      }),
                  SizedBox(height: AppPadding.p28,),
                  StreamBuilder(
                      stream: _loginViewModel.outputIsLoginButtonEnabled,
                      builder: (ctx,snapshot){
                        return MyButton(color: snapshot.data == true ? Colors.orange : Colors.grey, buttonText: "Login", fun: (){
                          if(snapshot.data == true) {
                            _loginViewModel.login();
                          }
                        });
                      }),
                  SizedBox(height: AppPadding.p12,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal:AppPadding.p28),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, Routes.splashRoute);
                            },
                            child: Text(
                              AppStrings.forgetPassword,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.labelSmall,
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, Routes.splashRoute);
                            },
                            child: Text(
                              "Not a member? Sign Up",
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.labelSmall,
                            ))
                      ],
                    ),
                  )
                ],
              ),
            ),
          )
      )
    );
  }

  @override
  void dispose() {
    _loginViewModel.dispose();
    super.dispose();
  }
}
