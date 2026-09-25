import 'package:movie_app/core/app_Assets.dart';
import 'package:movie_app/features/onboarding/data/models/onboarding_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class OnboardingLocalDataSource {
  Future<List<OnboardingModel>> getOnboardingPages();
  Future<bool> completeOnboarding();
  Future<bool> isOnboardingSeen();
}

class OnboardingLocalDataSourceImpl implements OnboardingLocalDataSource {
  static const String _onboardingSeenKey = 'is_onboarding_seen';
  final SharedPreferences? sharedPreferences;

  OnboardingLocalDataSourceImpl({this.sharedPreferences});

  @override
  Future<List<OnboardingModel>> getOnboardingPages() async {
    return const [
      OnboardingModel(
        id: 1,
        imagePath: AppAssets.onboardingPG2,
        title: 'Discover Movies',
        description:
            'Explore a vast collection of movies in all genres and languages.',
        titleKey: 'onboardingTitle2',
        subtitleKey: 'onboardingSubtitle2',
        isLastPage: false,
      ),
      OnboardingModel(
        id: 2,
        imagePath: AppAssets.onboardingPG3,
        title: 'Explore All Genres',
        description: 'Discover movies from every genre, matching every mood.',
        titleKey: 'onboardingTitle3',
        subtitleKey: 'onboardingSubtitle3',
        isLastPage: false,
      ),
      OnboardingModel(
        id: 3,
        imagePath: AppAssets.onboardingPG4,
        title: 'Create Watchlists',
        description:
            'Save movies to watch later and track what you\'ve watched.',
        titleKey: 'onboardingTitle4',
        subtitleKey: 'onboardingSubtitle4',
        isLastPage: false,
      ),
      OnboardingModel(
        id: 4,
        imagePath: AppAssets.onboardingPG5,
        title: 'Rate, Review, and Learn',
        description: 'Share your thoughts and read reviews from other fans.',
        titleKey: 'onboardingTitle5',
        subtitleKey: 'onboardingSubtitle5',
        isLastPage: true,
      ),
    ];
  }

  @override
  Future<bool> completeOnboarding() async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
    return await prefs.setBool(_onboardingSeenKey, true);
  }

  @override
  Future<bool> isOnboardingSeen() async {
    final prefs = sharedPreferences ?? await SharedPreferences.getInstance();
    return prefs.getBool(_onboardingSeenKey) ?? false;
  }
}