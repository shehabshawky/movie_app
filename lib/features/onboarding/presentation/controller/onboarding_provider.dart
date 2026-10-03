import 'package:flutter/material.dart';
import 'package:movie_app/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:movie_app/features/onboarding/data/repositories/onboarding_repository_impl.dart';
import 'package:movie_app/features/onboarding/domain/entities/onboarding_entity.dart';
import 'package:movie_app/features/onboarding/domain/usecases/complete_onboarding_usecase.dart';
import 'package:movie_app/features/onboarding/domain/usecases/get_onboarding_pages_usecase.dart';
import 'package:movie_app/features/onboarding/domain/usecases/is_onboarding_seen_usecase.dart';
import 'package:movie_app/l10n/app_localizations.dart';

class OnboardingProvider extends ChangeNotifier {
  final GetOnboardingPagesUseCase getOnboardingPagesUseCase;
  final CompleteOnboardingUseCase completeOnboardingUseCase;
  final IsOnboardingSeenUseCase isOnboardingSeenUseCase;

  final PageController pageController = PageController();
  int _currentPage = 0;
  List<OnboardingEntity> _pages = [];
  bool _isLoading = false;

  OnboardingProvider({
    GetOnboardingPagesUseCase? getPagesUseCase,
    CompleteOnboardingUseCase? completeUseCase,
    IsOnboardingSeenUseCase? isSeenUseCase,
  })  : getOnboardingPagesUseCase = getPagesUseCase ??
            GetOnboardingPagesUseCase(
              OnboardingRepositoryImpl(
                localDataSource: OnboardingLocalDataSourceImpl(),
              ),
            ),
        completeOnboardingUseCase = completeUseCase ??
            CompleteOnboardingUseCase(
              OnboardingRepositoryImpl(
                localDataSource: OnboardingLocalDataSourceImpl(),
              ),
            ),
        isOnboardingSeenUseCase = isSeenUseCase ??
            IsOnboardingSeenUseCase(
              OnboardingRepositoryImpl(
                localDataSource: OnboardingLocalDataSourceImpl(),
              ),
            ) {
    loadPages();
  }

  int get currentPage => _currentPage;
  List<OnboardingEntity> get pages => _pages;
  bool get isLoading => _isLoading;
  bool get isFirstPage => _currentPage == 0;
  bool get isLastPage => _pages.isNotEmpty && _currentPage == _pages.length - 1;

  Future<void> loadPages() async {
    _isLoading = true;
    notifyListeners();

    try {
      _pages = await getOnboardingPagesUseCase();
    } catch (_) {
      _pages = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void onPageChanged(int index) {
    _currentPage = index;
    notifyListeners();
  }

  void nextPage() {
    if (_currentPage < _pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (_currentPage > 0) {
      pageController.previousPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<bool> finishOnboarding() async {
    return await completeOnboardingUseCase();
  }

  String getLocalizedTitle(OnboardingEntity page, AppLocalizations? l10n) {
    if (l10n != null && page.titleKey != null) {
      switch (page.titleKey) {
        case 'onboardingTitle1':
          return l10n.onboardingTitle1;
        case 'onboardingTitle2':
          return l10n.onboardingTitle2;
        case 'onboardingTitle3':
          return l10n.onboardingTitle3;
        case 'onboardingTitle4':
          return l10n.onboardingTitle4;
        case 'onboardingTitle5':
          return l10n.onboardingTitle5;
        case 'startWatchingNow':
          return l10n.startWatchingNow;
      }
    }
    return page.title;
  }

  String getLocalizedDescription(OnboardingEntity page, AppLocalizations? l10n) {
    if (page.description.isEmpty) return '';
    if (l10n != null && page.subtitleKey != null) {
      switch (page.subtitleKey) {
        case 'onboardingSubtitle1':
          return l10n.onboardingSubtitle1;
        case 'onboardingSubtitle2':
          return l10n.onboardingSubtitle2;
        case 'onboardingSubtitle3':
          return l10n.onboardingSubtitle3;
        case 'onboardingSubtitle4':
          return l10n.onboardingSubtitle4;
        case 'onboardingSubtitle5':
          return l10n.onboardingSubtitle5;
      }
    }
    return page.description;
  }

  @override
  void dispose() {
    pageController.dispose();
    super.dispose();
  }
}