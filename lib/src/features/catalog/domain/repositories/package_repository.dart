import 'package:dartz/dartz.dart';

import '../../../../../core/error/failures.dart';
import '../entities/package.dart';

abstract class PackageRepository {
  Future<Either<Failure, List<Package>>> getPackages();
  
  Future<Either<Failure, Package>> getPackageById(String id);
}
