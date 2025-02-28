import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:tut_app/app/di.dart';
import 'package:tut_app/app/shared_button.dart';
import 'package:tut_app/presentation/common/state_renderer/state_renderer_impl.dart';
import 'package:tut_app/presentation/resources/valuesManager.dart';
import 'package:tut_app/presentation/resources/colorManager.dart';

import '../../../app/app_prefs.dart';
import '../../../app/shared_text_field.dart';
import '../../resources/assetsManager.dart';
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
  final AppPreferences _appPreferences = instance<AppPreferences>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  
  
  _bind(){
    _loginViewModel.start();
    _userNameController.addListener(() =>_loginViewModel.setUserName(_userNameController.text));
    _passwordController.addListener(() =>_loginViewModel.setPassword(_passwordController.text));

    _loginViewModel.isUserLoggedInSuccessStreamController.stream.listen((isLoggedIn) {
      if(isLoggedIn){
        print("Route login to main");
        SchedulerBinding.instance.addPostFrameCallback((_) {
          _appPreferences.setUserLoggedIn();
          Navigator.of(context).pushReplacementNamed(Routes.mainRoute);
        });
      }
    });
  }

  @override
  void initState() {
    _bind();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
        statusBarColor: ColorManager.white,
        statusBarIconBrightness: Brightness.dark,
    ),
    child:Scaffold(
      backgroundColor: ColorManager.white,
      body: SafeArea(
        child: StreamBuilder<FlowState>(
          stream: _loginViewModel.outputState,
          builder: (context,snapshot) {
            return snapshot.data?.getScreenWidget(context,_getContentWidget(context),_loginViewModel,(){
              _loginViewModel.login();
            })?? _getContentWidget(context);
          },
        ),
      ),
    )
    );
  }

  Widget _getContentWidget(BuildContext context){
    return SingleChildScrollView(
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
                              Navigator.pushNamed(context, Routes.forgotPasswordRoute);
                            },
                            child: Text(
                              AppStrings.forgetPassword,
                              textAlign: TextAlign.end,
                              style: Theme.of(context).textTheme.labelSmall,
                            )),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, Routes.registerRoute);
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
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _passwordController.dispose();
    _loginViewModel.dispose();
    super.dispose();
  }
}
