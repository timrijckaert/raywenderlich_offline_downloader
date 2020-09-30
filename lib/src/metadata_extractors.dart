import 'package:puppeteer/puppeteer.dart';
import 'course_service.dart';
import 'learning_path_service.dart';
import 'models.dart';
import 'dart:async';
import 'lesson_service.dart';

mixin MetadataExtractor<Metadata> {
  bool canExtractMetadataFromUrl(final String url);

  Future<Metadata> metadataOutputForUrl(
    final Browser browser,
    final String userToken,
    final String url,
  );
}

/// Extracts metadata from urls like 'https://www.raywenderlich.com/4919757-your-first-ios-and-swiftui-app'
class CourseMetadataExtractor with MetadataExtractor<Course> {
  static final RegExp _courseUrlRegex =
      RegExp(r'https:\/\/www\.raywenderlich\.com\/\d{7,}-[^\d]+$');

  static CourseMetadataExtractor _instance;

  const CourseMetadataExtractor._();

  factory CourseMetadataExtractor() {
    _instance ??= CourseMetadataExtractor._();
    return _instance;
  }

  @override
  bool canExtractMetadataFromUrl(final String url) =>
      _courseUrlRegex.hasMatch(url);

  @override
  Future<Course> metadataOutputForUrl(
    final Browser browser,
    final String userToken,
    final String courseUrl,
  ) async => CourseService.getCourse(browser, userToken, courseUrl);
}

/// Matches following urls:
/// https://www.raywenderlich.com/ios/paths/learn
/// https://www.raywenderlich.com/android/paths/learn
/// https://www.raywenderlich.com/unity/paths/learn
/// https://www.raywenderlich.com/ios/paths/iossoftware
class LearningPathMetadatExtractor with MetadataExtractor<LearningPath> {
  static final RegExp _pathUrlRegex = RegExp(
      r'https:\/\/www\.raywenderlich\.com\/\s*(ios|android|unity)\/paths\/');

  static LearningPathMetadatExtractor _instance;

  const LearningPathMetadatExtractor._();

  factory LearningPathMetadatExtractor() {
    _instance ??= LearningPathMetadatExtractor._();
    return _instance;
  }

  @override
  bool canExtractMetadataFromUrl(String url) => _pathUrlRegex.hasMatch(url);

  @override
  Future<LearningPath> metadataOutputForUrl(
    Browser browser,
    String userToken,
    String learningPathUrl,
  ) async =>
      await LearningPathService.getLearningPath(
        browser: browser,
        userToken: userToken,
        learningPathUrl: learningPathUrl,
      );
}

/// https://www.raywenderlich.com/4919757-your-first-ios-and-swiftui-app/lessons/2
class LessonExtractor with MetadataExtractor<Lesson> {
  static final RegExp _singleLessonUrlRegex = RegExp(
      r'https:\/\/www\.raywenderlich\.com\/\d{7,}-[\w\W]+\/lessons\/\d$');

  static LessonExtractor _instance;

  LessonExtractor._();

  factory LessonExtractor() {
    _instance ??= LessonExtractor._();
    return _instance;
  }

  @override
  bool canExtractMetadataFromUrl(String url) =>
      _singleLessonUrlRegex.hasMatch(url);

  @override
  Future<Lesson> metadataOutputForUrl(
    Browser browser,
    String userToken,
    String courseUrl,
  ) async =>
      await LessonService.getLesson(
        browser: browser,
        userToken: userToken,
        lessonUrl: courseUrl,
      );
}
