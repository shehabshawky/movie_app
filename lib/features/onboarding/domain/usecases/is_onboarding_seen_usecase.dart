import '../repositories/onboarding_repository.dart';

class IsOnboardingSeenUseCase {
  final OnboardingRepository repository;

  IsOnboardingSeenUseCase(this.repository);

  Future<bool> call() async {
    return await repository.isOnboardingSeen();
  }
}