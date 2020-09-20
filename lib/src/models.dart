import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@JsonSerializable()
class LearningSection {
  final String name;
  final String description;
  final Course course;

  LearningSection({this.name, this.description, this.course});

  factory LearningSection.fromJson(Map<String, dynamic> json) =>
      _$LearningSectionFromJson(json);

  Map<String, dynamic> toJson() => _$LearningSectionToJson(this);
}

@freezed
abstract class Metadata with _$Metadata {
  const factory Metadata.learningPath({
    final String name,
    final String description,
    final List<LearningSection> sections,
  }) = LearningPath;

  factory Metadata.lesson({
    final int episode,
    final String title,
    final String lessonUrl,
    final String videoId,
    final String streamUrl,
    final String materialDownloadLink,
  }) = Lesson;

  const factory Metadata.course({
    final String title,
    final List<Lesson> lessons,
  }) = Course;

  factory Metadata.fromJson(Map<String, dynamic> json) =>
      _$MetadataFromJson(json);
}

extension LessonHasMaterials on Lesson {
  bool get hasMaterials => materialDownloadLink.isNotEmpty;
}
