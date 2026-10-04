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
        imagePath: AppAssets.onboardingPG1,
        title: 'Find Your Next Favorite Movie Here',
        description:
            'Get access to a huge library of movies to suit all tastes. You will surely like it.',
        titleKey: 'onboardingTitle1',
        subtitleKey: 'onboardingSubtitle1',
        isLastPage: false,
      ),
      OnboardingModel(
        id: 2,
        imagePath: AppAssets.onboardingPG2,
        title: 'Discover Movies',
        description:
            'Explore a vast collection of movies in all qualities and genres. Find your next favorite film with ease.',
        titleKey: 'onboardingTitle2',
        subtitleKey: 'onboardingSubtitle2',
        isLastPage: false,
      ),
      OnboardingModel(
        id: 3,
        imagePath: AppAssets.onboardingPG3,
        title: 'Explore All Genres',
        description:
            'Discover movies from every genre, in all available qualities. Find something new and exciting to watch every day.',
        titleKey: 'onboardingTitle3',
        subtitleKey: 'onboardingSubtitle3',
        isLastPage: false,
      ),
      OnboardingModel(
        id: 4,
        imagePath: AppAssets.onboardingPG4,
        title: 'Create Watchlists',
        description:
            'Save movies to your watchlist to keep track of what you want to watch next. Enjoy films in various qualities and genres.',
        titleKey: 'onboardingTitle4',
        subtitleKey: 'onboardingSubtitle4',
        isLastPage: false,
      ),
      OnboardingModel(
        id: 5,
        imagePath: AppAssets.onboardingPG5,
        title: 'Rate, Review, and Learn',
        description:
            'Share your thoughts on the movies you\'ve watched. Dive deep into film details and help others discover great movies with your reviews.',
        titleKey: 'onboardingTitle5',
        subtitleKey: 'onboardingSubtitle5',
        isLastPage: false,
      ),
      OnboardingModel(
        id: 6,
        imagePath: AppAssets.onboardingPG6,
        title: 'Start Watching Now',
        description: '',
        titleKey: 'startWatchingNow',
        subtitleKey: null,
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