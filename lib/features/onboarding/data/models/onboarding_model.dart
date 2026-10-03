import '../../domain/entities/onboarding_entity.dart';

class OnboardingModel extends OnboardingEntity {
  const OnboardingModel({
    required super.id,
    required super.imagePath,
    required super.title,
    required super.description,
    super.titleKey,
    super.subtitleKey,
    super.isLastPage,
  });

  factory OnboardingModel.fromJson(Map<String, dynamic> json) {
    return OnboardingModel(
      id: json['id'] as int,
      imagePath: json['imagePath'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      titleKey: json['titleKey'] as String?,
      subtitleKey: json['subtitleKey'] as String?,
      isLastPage: json['isLastPage'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'imagePath': imagePath,
      'title': title,
      'description': description,
      'titleKey': titleKey,
      'subtitleKey': subtitleKey,
      'isLastPage': isLastPage,
    };
  }
}