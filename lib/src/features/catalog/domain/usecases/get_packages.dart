import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/package.dart';
import '../repositories/package_repository.dart';

class GetPackages implements UseCase<List<Package>, NoParams> {
  final PackageRepository repository;

  GetPackages(this.repository);

  @override
  Future<Either<Failure, List<Package>>> call(NoParams params) {
    return repository.getPackages();
  }
}
