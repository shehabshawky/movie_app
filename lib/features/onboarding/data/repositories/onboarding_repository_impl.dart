import 'package:movie_app/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:movie_app/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:movie_app/features/onboarding/domain/repositories/onboarding_repository.dart';

class OnboardingRepositoryImpl implements OnboardingRepository {
  final OnboardingLocalDataSource localDataSource;

  OnboardingRepositoryImpl({required this.localDataSource});

  @override
  Future<List<OnboardingEntity>> getOnboardingPages() async {
    return await localDataSource.getOnboardingPages();
  }

  @override
  Future<bool> completeOnboarding() async {
    return await localDataSource.completeOnboarding();
  }

  @override
  Future<bool> isOnboardingSeen() async {
    return await localDataSource.isOnboardingSeen();
  }
}