
import 'package:dartz/dartz.dart';
import 'package:tut_app/data/network/failure.dart';
import 'package:tut_app/domain/usecase/base_usecase.dart';

import '../repository/repository.dart';

class ForgotPasswordUseCase implements BaseUseCase<ForgotPasswordUseCaseInput,String>{
  final Repository _repository;

  ForgotPasswordUseCase(this._repository);

  @override
  Future<Either<Failure, String>> execute(ForgotPasswordUseCaseInput input) async{
    return await _repository.forgotPassword(input.email);
  }

}

class ForgotPasswordUseCaseInput{
  String email;

  ForgotPasswordUseCaseInput(this.email);
}