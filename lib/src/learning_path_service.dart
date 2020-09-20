import 'package:puppeteer/puppeteer.dart';
import 'models.dart';
import 'course_service.dart';

class _LearningSectionService {
  static Stream<LearningSection> getLearningSections(
    final Browser browser,
    final String userToken,
    final Page learningPathPage,
  ) async* {
    Future<String> _learningSectionTitle(
            final ElementHandle sectionElement) async =>
        await sectionElement.$eval(
            '.c-tutorial-item__title', 'el => el.innerText') as String;

    Future<String> _learningSectionDescription(
            final ElementHandle sectionElement) async =>
        await sectionElement.$eval(
            '.l-markdown-description p', 'el => el.innerText') as String;

    Future<String> _learningCourseUrl(
            final ElementHandle sectionElement) async =>
        await sectionElement.$eval('a', 'el => el.href') as String;

    final sections = await learningPathPage.$$('.c-tutorial-item');
    for (var i = 0; i < sections.length; i++) {
      final sectionElement = sections[i];

      final learningSectionTitle = await _learningSectionTitle(sectionElement);
      final learningSectionDescription =
          await _learningSectionDescription(sectionElement);
      final learningSectionCourseUrl = await _learningCourseUrl(sectionElement);

      yield LearningSection(
        course: await CourseService.getCourse(
          browser,
          userToken,
          learningSectionCourseUrl,
        ),
        name: learningSectionTitle,
        description: learningSectionDescription,
      );
    }
  }
}

class LearningPathService {
  static Future<String> _learningPathTitle(final Page learningPathPage) async =>
      learningPathPage.$eval('.l-path-hero h1', 'el => el.innerText');

  static Future<String> _learningPathDescription(
    final Page learningPathPage,
  ) async =>
      learningPathPage.$eval(
          '.l-path-hero p:not([class])', 'el => el.innerText');

  static Future<LearningPath> getLearningPath({
    Browser browser,
    String userToken,
    String learningPathUrl,
  }) async {
    final learningPathPage = await browser.newPage();
    await learningPathPage.goto(learningPathUrl, wait: Until.networkIdle);

    final learningPathTitle = await _learningPathTitle(learningPathPage);
    final learningPathDescription =
        await _learningPathDescription(learningPathPage);
    final learningSections = await _LearningSectionService.getLearningSections(
      browser,
      userToken,
      learningPathPage,
    ).toList();

    return LearningPath(
      name: learningPathTitle,
      description: learningPathDescription,
      sections: await learningSections.toList(),
    );
  }
}
