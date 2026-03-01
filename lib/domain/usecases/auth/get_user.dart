import 'package:dartz/dartz.dart';
import 'package:spotifyy/core/usecase/usecase.dart';
import 'package:spotifyy/domain/repository/auth/auth.dart';

import '../../../service_locator.dart';

class GetUserUseCase implements UseCase<Either,dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<AuthRepository>().getUser();
  }

}