import '../entities/onboarding_entity.dart';

abstract class OnboardingRepository {
  Future<List<OnboardingEntity>> getOnboardingPages();
  Future<bool> completeOnboarding();
  Future<bool> isOnboardingSeen();
}