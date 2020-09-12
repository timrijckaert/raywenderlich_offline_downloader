import 'output.dart';
import 'lesson.dart';

class Course with Metadata {
  final String title;
  final List<Lesson> lessons;

  Course({this.title, this.lessons});

  @override
  String toString() => title;
}
