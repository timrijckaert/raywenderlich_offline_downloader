import 'models/models.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:pedantic/pedantic.dart';

import 'raywenderlich_remote_api.dart';

class LessonService {
  static final RegExp lessonUrlRegex = RegExp(r'\/(\d+)\/');

  LessonService._();

  static Future<String> _videoIdFromPage(final Page page) async => await page
      .$("meta[name='twitter:image']")
      .then((e) => e.propertyValue('content'))
      .then((content) => lessonUrlRegex.firstMatch(content as String).group(1));

  static Future<Lesson> getLesson({
    final Browser browser,
    final String userToken,
    final String lessonUrl,
  }) async {
    final lessonPage = await browser.newPage();
    await lessonPage.goto(lessonUrl, wait: Until.domContentLoaded);

    final videoId = await _videoIdFromPage(lessonPage);
    unawaited(lessonPage.close());

    final lesson = await RaywenderlichApi.getLessonFromVideoId(
      videoId,
      userToken,
    );
    print(lesson);
    return lesson;
  }

  static Future<int> _amountOfLessons(final Page page) async =>
      await page.$$('.c-tutorial-episode').then((e) => e.length);

  static Future<List<Lesson>> getLessons(
    final Browser browser,
    final String userToken,
    final Page courseOverviewPage,
    final String courseUrl,
  ) async {
    final amountOfLessons = await _amountOfLessons(courseOverviewPage);
    print('Found $amountOfLessons lessons');
    unawaited(courseOverviewPage.close());
    return await Future.wait(
      List.generate(
        amountOfLessons,
        (index) => getLesson(
          browser: browser,
          userToken: userToken,
          lessonUrl: '$courseUrl/lessons/${index + 1}',
        ),
      ),
    );
  }
}
