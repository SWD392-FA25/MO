import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/usecases/usecase.dart';
import '../entities/package.dart';
import '../repositories/package_repository.dart';

class GetPackageDetail implements UseCase<Package, String> {
  final PackageRepository repository;

  GetPackageDetail(this.repository);

  @override
  Future<Either<Failure, Package>> call(String packageId) {
    return repository.getPackageById(packageId);
  }
}
