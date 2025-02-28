
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:image_picker/image_picker.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tut_app/app/app_prefs.dart';
import 'package:tut_app/data/data_source/remote_data_source.dart';
import 'package:tut_app/data/network/app_api.dart';
import 'package:tut_app/data/network/dio_factory.dart';
import 'package:tut_app/data/network/network_info.dart';
import 'package:tut_app/data/repositoryImp/repository_impl.dart';
import 'package:tut_app/domain/repository/repository.dart';
import 'package:tut_app/domain/usecase/forgotPassword_usecase.dart';
import 'package:tut_app/domain/usecase/login_usecase.dart';
import 'package:tut_app/presentation/forgotPasswordScreen/viewmodel/forgotPassword_viewmodel.dart';
import 'package:tut_app/presentation/loginScreen/viewmodel/login_viewmodel.dart';
import 'package:tut_app/presentation/registerScreen/viewmodel/register_viewmodel.dart';

import '../domain/usecase/Register_usecase.dart';

final instance = GetIt.instance;

Future<void> initAppModule() async{

  final sharedPrefs = await SharedPreferences.getInstance();
  
  instance.registerLazySingleton<SharedPreferences>(()=>sharedPrefs);

  instance.registerLazySingleton<AppPreferences>(() => AppPreferences(instance()));

  instance.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(InternetConnectionChecker()));

  instance.registerLazySingleton<DioFactory>(() => DioFactory(instance()));

  Dio dio = await instance<DioFactory>().getDio();
  instance.registerLazySingleton<AppServiceClient>(() => AppServiceClient(dio));

  instance.registerLazySingleton<RemoteDataSource>(() => RemoteDataSourceImpl(instance()));

  instance.registerLazySingleton<Repository>(() => RepositoryImpl(instance(), instance()));
}

initLoginModule(){

  if(!GetIt.I.isRegistered<LoginUseCase>()) {
    instance.registerFactory<LoginUseCase>(() => LoginUseCase(instance()));
    instance.registerFactory<LoginViewModel>(() => LoginViewModel(instance()));
  }

}

initForgotPasswordModule(){

  if(!GetIt.I.isRegistered<ForgotPasswordUseCase>()) {
    instance.registerFactory<ForgotPasswordUseCase>(() => ForgotPasswordUseCase(instance()));
    instance.registerFactory<ForgotPasswordViewModel>(() => ForgotPasswordViewModel(instance()));
  }

}

initRegisterModule(){

  if(!GetIt.I.isRegistered<RegisterUserCase>()) {
    instance.registerFactory<RegisterUserCase>(() => RegisterUserCase(instance()));
    instance.registerFactory<RegisterViewModel>(() => RegisterViewModel(instance()));

    instance.registerFactory<ImagePicker>(() => ImagePicker());
  }

}
