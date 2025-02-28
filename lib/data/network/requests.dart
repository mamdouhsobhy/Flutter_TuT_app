//login request
class LoginRequest {
  String email;
  String password;

  LoginRequest(this.email, this.password);

}

//register request
class RegisterRequest {
  String username;
  String countryCode;
  String mobileNumber;
  String email;
  String password;
  String profilePhoto;

  RegisterRequest(this.username, this.countryCode,this.mobileNumber,this.email,this.password,this.profilePhoto);

}