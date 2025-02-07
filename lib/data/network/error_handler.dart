
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
  NO_INTERNET_CONNECTION
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
  static const UNKNOWN = -7;
}

class ResponseMessage{
  static const SUCCESS = "success";
  static const NO_CONTENT = "success";
  static const BAD_REQUEST = "bad request , try again later";
  static const UNAUTORISED = "user is un authorised, try again later";
  static const FORBIDDEN = "forbidden request , try again later";
  static const INTERNET_SERVER_ERROR = "something went wrong, try again later";
  static const NOT_FOUND = 404;



  static const CONNECT_TIMEOUT = "time out request , try again later";
  static const CANCEL = "request cancelled, try again later";
  static const RECIEVE_TIMEOUT = "time out request , try again later";
  static const SEND_TIMEOUT = "time out request , try again later";
  static const CACHE_ERROR = "cache error , try again later";
  static const NO_INTERNET_CONNECTION = "check internet connection";
  static const UNKNOWN = "something went wrong, try again later";
}