import 'package:dartz/dartz.dart';
import 'package:tut_app/data/network/failure.dart';
import 'package:tut_app/data/network/requests.dart';
import 'package:tut_app/domain/model/models.dart';
import 'package:tut_app/domain/usecase/base_usecase.dart';

import '../repository/repository.dart';

class RegisterUserCase
    implements BaseUseCase<RegisterUserCaseInput, Authentication> {
  final Repository _repository;

  RegisterUserCase(this._repository);

  @override
  Future<Either<Failure, Authentication>> execute(
      RegisterUserCaseInput input) async {
    return await _repository.register(RegisterRequest(
        input.username,
        input.countryCode,
        input.mobileNumber,
        input.email,
        input.password,
        input.profilePhoto));
  }
}

class RegisterUserCaseInput {
  String username;
  String countryCode;
  String mobileNumber;
  String email;
  String password;
  String profilePhoto;

  RegisterUserCaseInput(this.username, this.countryCode, this.mobileNumber,
      this.email, this.password, this.profilePhoto);
}
