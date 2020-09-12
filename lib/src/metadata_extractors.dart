import 'package:puppeteer/puppeteer.dart';
import 'models/models.dart';
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

/// Extracts metadate from urls like 'https://www.raywenderlich.com/4919757-your-first-ios-and-swiftui-app'
class CourseMetadataExtractor with MetadataExtractor<Course> {
  static final RegExp _courseUrlRegex =
      RegExp(r'https:\/\/www\.raywenderlich\.com\/\d{7,}-[^\d]+$');

  CourseMetadataExtractor._();

  static CourseMetadataExtractor _instance;

  factory CourseMetadataExtractor() {
    _instance ??= CourseMetadataExtractor._();
    return _instance;
  }

  @override
  bool canExtractMetadataFromUrl(final String url) =>
      _courseUrlRegex.hasMatch(url);

  static Future<String> _courseTitle(final Page page) async =>
      page.$eval('h1', 'el => el.innerText');

  @override
  Future<Course> metadataOutputForUrl(
    final Browser browser,
    final String userToken,
    final String courseUrl,
  ) async {
    final coursePage = await browser.newPage();
    await coursePage.goto(courseUrl, wait: Until.domContentLoaded);
    final courseTitle = await _courseTitle(coursePage);

    print('Downloading meta data information for: $courseTitle');
    final lessons = await LessonService.getLessons(
      browser,
      userToken,
      coursePage,
      courseUrl,
    );

    return Course(title: courseTitle, lessons: lessons);
  }
}

/// Matches following urls:
/// https://www.raywenderlich.com/ios/paths/learn
/// https://www.raywenderlich.com/android/paths/learn
/// https://www.raywenderlich.com/unity/paths/learn
class LearningPathMetadatExtractor with MetadataExtractor<LearningPath> {
  static final RegExp _pathUrlRegex = RegExp(
      r'https:\/\/www\.raywenderlich\.com\/\s*(ios|android|unity)\/paths\/learn$');

  LearningPathMetadatExtractor._();

  static LearningPathMetadatExtractor _instance;

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
    String courseUrl,
  ) {
    throw 'Downloading full learning path is not yet implemented.';
  }
}

/// https://www.raywenderlich.com/4919757-your-first-ios-and-swiftui-app/lessons/2
class LessonExtractor with MetadataExtractor<Lesson> {
  static final RegExp _singleLessonUrlRegex = RegExp(
      r'https:\/\/www\.raywenderlich\.com\/\d{7,}-[\w\W]+\/lessons\/\d$');

  LessonExtractor._();

  static LessonExtractor _instance;

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