class OnboardingEntity {
  final int id;
  final String imagePath;
  final String title;
  final String description;
  final String? titleKey;
  final String? subtitleKey;
  final bool isLastPage;

  const OnboardingEntity({
    required this.id,
    required this.imagePath,
    required this.title,
    required this.description,
    this.titleKey,
    this.subtitleKey,
    this.isLastPage = false,
  });
}