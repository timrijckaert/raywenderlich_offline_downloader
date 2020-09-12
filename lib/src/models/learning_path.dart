import 'output.dart';
import 'course.dart';

class LearningSection {
  final String name;
  final List<Course> courses;

  LearningSection({this.name, this.courses});
}

class LearningPath with Metadata {
  final String name;
  final List<LearningSection> sections;

  LearningPath({this.name, this.sections});
}
