import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:image_picker/image_picker.dart';

import '../../../app/di.dart';
import '../../../app/shared_button.dart';
import '../../../app/shared_text_field.dart';
import '../../common/state_renderer/state_renderer_impl.dart';
import '../../resources/assetsManager.dart';
import '../../resources/colorManager.dart';
import '../../resources/valuesManager.dart';
import '../viewmodel/register_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final RegisterViewModel _registerViewModel = instance<RegisterViewModel>();
  final ImagePicker _imagePicker = instance<ImagePicker>();

  final TextEditingController _userNameController = TextEditingController();
  final TextEditingController _mobileNumberController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();


  _bind(){
    _registerViewModel.start();
    _userNameController.addListener(() =>_registerViewModel.setUserName(_userNameController.text));
    _mobileNumberController.addListener(() =>_registerViewModel.setMobileNumber(_mobileNumberController.text));
    _emailController.addListener(() =>_registerViewModel.setEmail(_emailController.text));
    _passwordController.addListener(() =>_registerViewModel.setPassword(_passwordController.text));

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
              stream: _registerViewModel.outputState,
              builder: (context,snapshot) {
                return snapshot.data?.getScreenWidget(context,_getContentWidget(context),_registerViewModel,(){
                  _registerViewModel.register();
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
              stream: _registerViewModel.outputIsUserNameValid,
              builder: (ctx,snapshot){
                return MyTextField(
                    hint: "Enter user name",
                    obscureText: false,
                    inputType: TextInputType.emailAddress,
                    controller: _userNameController,
                    takeValue: (value) {
                      _registerViewModel.setUserName(value);
                    });
              }),
          SizedBox(height: AppPadding.p20,),
            Center(
              child: Padding(padding: EdgeInsets.only(left: AppPadding.p28)
              ,child: Row(
                  children: [
                    Expanded(flex:1,child: CountryCodePicker(
                      onChanged: (country){
                        //viewModel.setCountryCode(country.code)
                      },
                      initialSelection: "+02",
                      favorite: ["39","FR","+966"],
                      showCountryOnly: true,
                      showOnlyCountryWhenClosed: true,
                      hideMainText: true,
                    )),
                Expanded(flex:3,child:StreamBuilder(
                    stream: _registerViewModel.outputIsMobileNumberValid,
                    builder: (ctx,snapshot){
                      return MyTextField(
                          hint: "Enter your phone",
                          obscureText: false,
                          inputType: TextInputType.phone,
                          controller: _mobileNumberController,
                          takeValue: (value) {
                            _registerViewModel.setMobileNumber(value);
                          });
                    }))
                  ],
                ),),
            ),
          SizedBox(height: AppPadding.p20,),
          StreamBuilder(
              stream: _registerViewModel.outputIsEmailValid,
              builder: (ctx,snapshot){
                return MyTextField(
                    hint: "Enter your Email",
                    obscureText: false,
                    inputType: TextInputType.emailAddress,
                    controller: _emailController,
                    takeValue: (value) {
                      _registerViewModel.setEmail(value);
                    });
              }),
          SizedBox(height: AppPadding.p20,),
          StreamBuilder(
              stream: _registerViewModel.outputIsPasswordValid,
              builder: (ctx,snapshot){
                return MyTextField(
                    hint: "Enter your password",
                    obscureText: true,
                    inputType: TextInputType.visiblePassword,
                    controller: _passwordController,
                    takeValue: (value) {
                      _registerViewModel.setPassword(value);
                    });
              }),
          SizedBox(height: AppPadding.p28,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppPadding.p28),
            child: InkWell(
              onTap: (){
                _showImagePicker(context);
              },
              child: Container(
                height: AppSize.s48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  border: Border.all(color: ColorManager.grey)
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20 , vertical: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Flexible(child: Text("Profile Photo",style: TextStyle(color: Colors.grey,fontSize: AppSize.s12),)),
                      Flexible(
                        child: StreamBuilder(
                            stream: _registerViewModel.outputIsProfilePhotoValid,
                            builder: (ctx,snapshot){
                              return _widgetImageUser(snapshot.data);
                            }),
                      ),
                      Flexible(child: Icon(Icons.photo_camera))
                    ],
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: AppPadding.p28,),
          StreamBuilder(
              stream: _registerViewModel.outputIsRegisterButtonEnabled,
              builder: (ctx,snapshot){
                return MyButton(color: snapshot.data == true ? Colors.orange : Colors.grey, buttonText: "Register", fun: (){
                  if(snapshot.data == true) {
                    _registerViewModel.register();
                  }
                });
              }),
          SizedBox(height: AppPadding.p12,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal:AppPadding.p12),
            child:  TextButton(
                onPressed: () {
                 Navigator.of(context).pop();
                },
                child: Text(
                  "Already have account? Sign In",
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.labelSmall,
                )),
          ),
          SizedBox(height: 50,)
        ],
      ),
    );
  }

  Widget _widgetImageUser(File? image){
      if(image!=null && image.path.isNotEmpty){
        return Image.file(image);
      }else{
        return Container();
      }
  }

  _showImagePicker(BuildContext context){
    showModalBottomSheet(context: context, builder: (BuildContext ctx){
      return SafeArea(child:
      Wrap(children: [
        ListTile(
          leading: Icon(Icons.arrow_forward),
          trailing: Icon(Icons.camera),
          title: Text("Photo From Gallery"),
          onTap: (){
            _imageFromGallery();
            Navigator.of(context).pop();
          },
        ),
        ListTile(
          leading: Icon(Icons.arrow_forward),
          trailing: Icon(Icons.camera_alt_outlined),
          title: Text("Photo From Camera"),
          onTap: (){
            _imageFromCamera();
            Navigator.of(context).pop();
          },
        )
      ],
      ));
    });
  }

  _imageFromGallery() async{
    var image = await _imagePicker.pickImage(source: ImageSource.gallery);
    _registerViewModel.setProfilePhoto(File(image?.path ?? ""));
  }

  _imageFromCamera() async{
    var image = await _imagePicker.pickImage(source: ImageSource.camera);
    _registerViewModel.setProfilePhoto(File(image?.path ?? ""));
  }

  @override
  void dispose() {
    _userNameController.dispose();
    _mobileNumberController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _registerViewModel.dispose();
    super.dispose();
  }
}
