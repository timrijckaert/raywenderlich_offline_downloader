import 'package:puppeteer/puppeteer.dart';
import 'models.dart';
import 'lesson_service.dart';

class CourseService {
  static Future<String> _courseTitle(final Page page) async =>
      page.$eval('h1', 'el => el.innerText');

  static Future<Course> getCourse(
    Browser browser,
    String userToken,
    String courseUrl,
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
