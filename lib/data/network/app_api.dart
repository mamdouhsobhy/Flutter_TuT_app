

import 'package:dio/dio.dart';
import 'package:retrofit/http.dart';
import 'package:tut_app/app/Constants.dart';
import 'package:tut_app/data/response/responses.dart';
part 'app_api.g.dart';

@RestApi(baseUrl: Constants.baseUrl)
abstract class AppServiceClient{
  factory AppServiceClient(Dio dio,{String baseUrl}) = _AppServiceClient;

  @POST("customer/login")
  Future<AuthenticationResponse> login(
      @Field("email") String email,
      @Field("password") String password,
      );

  @POST("customer/forgotPassword")
  Future<ForgotPasswordResponse> forgotPassword(
      @Field("email") String email);

  @POST("customer/register")
  Future<AuthenticationResponse> register(
      @Field("username") String username,
      @Field("countryCode") String countryCode,
      @Field("mobileNumber") String mobileNumber,
      @Field("email") String email,
      @Field("password") String password,
      @Field("profilePhoto") String profilePhoto
      );
}