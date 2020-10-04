import 'package:freezed_annotation/freezed_annotation.dart';

part 'models.freezed.dart';
part 'models.g.dart';

@freezed
abstract class Metadata with _$Metadata {
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
