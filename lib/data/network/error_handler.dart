
import 'package:dio/dio.dart';
import 'package:tut_app/data/network/failure.dart';

class ErrorHandler implements Exception{
  late Failure failure;
  ErrorHandler.handle(dynamic error){
    if(error is DioError){
      failure = _handleError(error);
    }else{
      failure = DataSource.DEFAULT.getFailure();
    }
  }
}

Failure _handleError(DioError dioError){
  switch(dioError.type){
    case DioExceptionType.connectionTimeout:
      return DataSource.CONNECT_TIMEOUT.getFailure();
    case DioExceptionType.sendTimeout:
      return DataSource.SEND_TIMEOUT.getFailure();
    case DioExceptionType.receiveTimeout:
      return DataSource.RECIEVE_TIMEOUT.getFailure();
    case DioExceptionType.badCertificate:
      if(dioError.response?.statusCode!=null && dioError.response?.statusMessage!=null){
        return Failure(dioError.response?.statusCode?? 0, dioError.response?.statusMessage ?? "");
      }else{
        return DataSource.DEFAULT.getFailure();
      }
    case DioExceptionType.badResponse:
      if(dioError.response?.statusCode!=null && dioError.response?.statusMessage!=null){
        return Failure(dioError.response?.statusCode?? 0, dioError.response?.statusMessage ?? "");
      }else{
        return DataSource.DEFAULT.getFailure();
      }
    case DioExceptionType.cancel:
    return DataSource.CANCEL.getFailure();
    case DioExceptionType.connectionError:
      if(dioError.response?.statusCode!=null && dioError.response?.statusMessage!=null){
        return Failure(dioError.response?.statusCode?? 0, dioError.response?.statusMessage ?? "");
      }else{
        return DataSource.CONNECT_TIMEOUT.getFailure();
      }
    case DioExceptionType.unknown:
    return DataSource.DEFAULT.getFailure();
  }
}
enum DataSource{
  SUCCESS,
  NO_CONTENT,
  BAD_REQUEST,
  FORBIDDEN,
  UNAUTORISED,
  NOT_FOUND,
  INTERNET_SERVER_ERROR,
  CONNECT_TIMEOUT,
  CANCEL,
  RECIEVE_TIMEOUT,
  SEND_TIMEOUT,
  CACHE_ERROR,
  NO_INTERNET_CONNECTION,
  DEFAULT
}

extension DataSourceExtension on DataSource{
  Failure getFailure(){
    switch(this){
      case DataSource.SUCCESS:
        return Failure(ResponseCode.SUCCESS,ResponseMessage.SUCCESS);
      case DataSource.NO_CONTENT:
        return Failure(ResponseCode.NO_CONTENT,ResponseMessage.NO_CONTENT);
      case DataSource.BAD_REQUEST:
        return Failure(ResponseCode.BAD_REQUEST,ResponseMessage.BAD_REQUEST);
      case DataSource.FORBIDDEN:
        return Failure(ResponseCode.FORBIDDEN,ResponseMessage.FORBIDDEN);
      case DataSource.UNAUTORISED:
        return Failure(ResponseCode.UNAUTORISED,ResponseMessage.UNAUTORISED);
      case DataSource.NOT_FOUND:
        return Failure(ResponseCode.NOT_FOUND,ResponseMessage.NOT_FOUND);
      case DataSource.INTERNET_SERVER_ERROR:
        return Failure(ResponseCode.INTERNET_SERVER_ERROR,ResponseMessage.INTERNET_SERVER_ERROR);
      case DataSource.CONNECT_TIMEOUT:
        return Failure(ResponseCode.CONNECT_TIMEOUT,ResponseMessage.CONNECT_TIMEOUT);
      case DataSource.CANCEL:
        return Failure(ResponseCode.CANCEL,ResponseMessage.CANCEL);
      case DataSource.RECIEVE_TIMEOUT:
        return Failure(ResponseCode.RECIEVE_TIMEOUT,ResponseMessage.RECIEVE_TIMEOUT);
      case DataSource.SEND_TIMEOUT:
        return Failure(ResponseCode.SEND_TIMEOUT,ResponseMessage.SEND_TIMEOUT);
      case DataSource.CACHE_ERROR:
        return Failure(ResponseCode.CACHE_ERROR,ResponseMessage.CACHE_ERROR);
      case DataSource.NO_INTERNET_CONNECTION:
        return Failure(ResponseCode.NO_INTERNET_CONNECTION,ResponseMessage.NO_INTERNET_CONNECTION);
      case DataSource.DEFAULT:
        return Failure(ResponseCode.DEFAULT,ResponseMessage.DEFAULT);
    }
  }
}

class ResponseCode{
  static const SUCCESS = 200;
  static const NO_CONTENT = 201;
  static const BAD_REQUEST = 400;
  static const UNAUTORISED = 401;
  static const FORBIDDEN = 403;
  static const INTERNET_SERVER_ERROR = 500;
  static const NOT_FOUND = 404;



  static const CONNECT_TIMEOUT = -1;
  static const CANCEL = -2;
  static const RECIEVE_TIMEOUT = -3;
  static const SEND_TIMEOUT = -4;
  static const CACHE_ERROR = -5;
  static const NO_INTERNET_CONNECTION = -6;
  static const DEFAULT = -7;
}

class ResponseMessage{
  static const SUCCESS = "success";
  static const NO_CONTENT = "success";
  static const BAD_REQUEST = "bad request , try again later";
  static const UNAUTORISED = "user is un authorised, try again later";
  static const FORBIDDEN = "forbidden request , try again later";
  static const INTERNET_SERVER_ERROR = "something went wrong, try again later";
  static const NOT_FOUND = "not found, try again later";



  static const CONNECT_TIMEOUT = "time out request , try again later";
  static const CANCEL = "request cancelled, try again later";
  static const RECIEVE_TIMEOUT = "time out request , try again later";
  static const SEND_TIMEOUT = "time out request , try again later";
  static const CACHE_ERROR = "cache error , try again later";
  static const NO_INTERNET_CONNECTION = "check internet connection";
  static const DEFAULT = "something went wrong, try again later";
}

class ApiInternalStatus{
  static const SUCCESS = 0;
  static const FAILURE = 1;
}