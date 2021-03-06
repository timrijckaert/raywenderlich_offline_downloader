// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$Lesson _$_$LessonFromJson(Map<String, dynamic> json) {
  return _$Lesson(
    episode: json['episode'] as int,
    title: json['title'] as String,
    lessonUrl: json['lessonUrl'] as String,
    videoId: json['videoId'] as String,
    streamUrl: json['streamUrl'] as String,
    materialDownloadLink: json['materialDownloadLink'] as String,
  );
}

Map<String, dynamic> _$_$LessonToJson(_$Lesson instance) => <String, dynamic>{
      'episode': instance.episode,
      'title': instance.title,
      'lessonUrl': instance.lessonUrl,
      'videoId': instance.videoId,
      'streamUrl': instance.streamUrl,
      'materialDownloadLink': instance.materialDownloadLink,
    };

_$Course _$_$CourseFromJson(Map<String, dynamic> json) {
  return _$Course(
    title: json['title'] as String,
    lessons: (json['lessons'] as List)
        ?.map((e) =>
            e == null ? null : Lesson.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$_$CourseToJson(_$Course instance) => <String, dynamic>{
      'title': instance.title,
      'lessons': instance.lessons,
    };
