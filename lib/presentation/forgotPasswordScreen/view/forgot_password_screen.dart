import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';
import 'package:tut_app/presentation/forgotPasswordScreen/viewmodel/forgotPassword_viewmodel.dart';

import '../../../app/di.dart';
import '../../../app/shared_button.dart';
import '../../../app/shared_text_field.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/assetsManager.dart';
import '../../resources/colorManager.dart';
import '../../resources/stringManager.dart';
import '../../resources/valuesManager.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {

  final ForgotPasswordViewModel _forgotPasswordViewModel = instance<ForgotPasswordViewModel>();

  final TextEditingController _userNameController = TextEditingController();


  _bind(){
    _forgotPasswordViewModel.start();
    _userNameController.addListener(() =>_forgotPasswordViewModel.setUserName(_userNameController.text));
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
              stream: _forgotPasswordViewModel.outputState,
              builder: (context,snapshot) {
                return snapshot.data?.getScreenWidget(context,_getContentWidget(context),_forgotPasswordViewModel,(){
                  _forgotPasswordViewModel.resetPassword();
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
              stream: _forgotPasswordViewModel.outputIsUserNameValid,
              builder: (ctx,snapshot){
                return MyTextField(
                    hint: "Enter user name",
                    obscureText: false,
                    inputType: TextInputType.emailAddress,
                    controller: _userNameController,
                    takeValue: (value) {
                      _forgotPasswordViewModel.setUserName(value);
                    });
              }),
          SizedBox(height: AppPadding.p20,),
          SizedBox(height: AppPadding.p28,),
          StreamBuilder(
              stream: _forgotPasswordViewModel.outputIsResetPasswordButtonEnabled,
              builder: (ctx,snapshot){
                return MyButton(color: snapshot.data == true ? Colors.orange : Colors.grey, buttonText: "Reset Password", fun: (){
                  if(snapshot.data == true) {
                    _forgotPasswordViewModel.resetPassword();
                  }
                });
              }),
          SizedBox(height: AppPadding.p12,),
          StreamBuilder(
              stream: _forgotPasswordViewModel.outputIsResetPasswordButtonEnabled,
              builder: (ctx,snapshot){
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal:AppPadding.p28),
                  child:  TextButton(
                      onPressed: () {
                        if(snapshot.data == true) {
                          _forgotPasswordViewModel.resetPassword();
                        }
                      },
                      child: Text(
                        AppStrings.didNotReceiveEmail,
                        textAlign: TextAlign.end,
                        style: Theme.of(context).textTheme.labelSmall,
                      )),
                );
              })
        ],
      ),
    );
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _forgotPasswordViewModel.dispose();
    super.dispose();
  }
}
