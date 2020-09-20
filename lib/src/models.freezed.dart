// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;
Metadata _$MetadataFromJson(Map<String, dynamic> json) {
  switch (json['runtimeType'] as String) {
    case 'learningPath':
      return LearningPath.fromJson(json);
    case 'lesson':
      return Lesson.fromJson(json);
    case 'course':
      return Course.fromJson(json);

    default:
      throw FallThroughError();
  }
}

class _$MetadataTearOff {
  const _$MetadataTearOff();

// ignore: unused_element
  LearningPath learningPath(
      {String name, String description, List<LearningSection> sections}) {
    return LearningPath(
      name: name,
      description: description,
      sections: sections,
    );
  }

// ignore: unused_element
  Lesson lesson(
      {int episode,
      String title,
      String lessonUrl,
      String videoId,
      String streamUrl,
      String materialDownloadLink}) {
    return Lesson(
      episode: episode,
      title: title,
      lessonUrl: lessonUrl,
      videoId: videoId,
      streamUrl: streamUrl,
      materialDownloadLink: materialDownloadLink,
    );
  }

// ignore: unused_element
  Course course({String title, List<Lesson> lessons}) {
    return Course(
      title: title,
      lessons: lessons,
    );
  }
}

// ignore: unused_element
const $Metadata = _$MetadataTearOff();

mixin _$Metadata {
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required
        Result learningPath(
            String name, String description, List<LearningSection> sections),
    @required
        Result lesson(int episode, String title, String lessonUrl,
            String videoId, String streamUrl, String materialDownloadLink),
    @required Result course(String title, List<Lesson> lessons),
  });
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result learningPath(
        String name, String description, List<LearningSection> sections),
    Result lesson(int episode, String title, String lessonUrl, String videoId,
        String streamUrl, String materialDownloadLink),
    Result course(String title, List<Lesson> lessons),
    @required Result orElse(),
  });
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result learningPath(LearningPath value),
    @required Result lesson(Lesson value),
    @required Result course(Course value),
  });
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result learningPath(LearningPath value),
    Result lesson(Lesson value),
    Result course(Course value),
    @required Result orElse(),
  });
  Map<String, dynamic> toJson();
}

abstract class $MetadataCopyWith<$Res> {
  factory $MetadataCopyWith(Metadata value, $Res Function(Metadata) then) =
      _$MetadataCopyWithImpl<$Res>;
}

class _$MetadataCopyWithImpl<$Res> implements $MetadataCopyWith<$Res> {
  _$MetadataCopyWithImpl(this._value, this._then);

  final Metadata _value;
  // ignore: unused_field
  final $Res Function(Metadata) _then;
}

abstract class $LearningPathCopyWith<$Res> {
  factory $LearningPathCopyWith(
          LearningPath value, $Res Function(LearningPath) then) =
      _$LearningPathCopyWithImpl<$Res>;
  $Res call({String name, String description, List<LearningSection> sections});
}

class _$LearningPathCopyWithImpl<$Res> extends _$MetadataCopyWithImpl<$Res>
    implements $LearningPathCopyWith<$Res> {
  _$LearningPathCopyWithImpl(
      LearningPath _value, $Res Function(LearningPath) _then)
      : super(_value, (v) => _then(v as LearningPath));

  @override
  LearningPath get _value => super._value as LearningPath;

  @override
  $Res call({
    Object name = freezed,
    Object description = freezed,
    Object sections = freezed,
  }) {
    return _then(LearningPath(
      name: name == freezed ? _value.name : name as String,
      description:
          description == freezed ? _value.description : description as String,
      sections: sections == freezed
          ? _value.sections
          : sections as List<LearningSection>,
    ));
  }
}

@JsonSerializable()
class _$LearningPath implements LearningPath {
  const _$LearningPath({this.name, this.description, this.sections});

  factory _$LearningPath.fromJson(Map<String, dynamic> json) =>
      _$_$LearningPathFromJson(json);

  @override
  final String name;
  @override
  final String description;
  @override
  final List<LearningSection> sections;

  @override
  String toString() {
    return 'Metadata.learningPath(name: $name, description: $description, sections: $sections)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is LearningPath &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.sections, sections) ||
                const DeepCollectionEquality()
                    .equals(other.sections, sections)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(sections);

  @override
  $LearningPathCopyWith<LearningPath> get copyWith =>
      _$LearningPathCopyWithImpl<LearningPath>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required
        Result learningPath(
            String name, String description, List<LearningSection> sections),
    @required
        Result lesson(int episode, String title, String lessonUrl,
            String videoId, String streamUrl, String materialDownloadLink),
    @required Result course(String title, List<Lesson> lessons),
  }) {
    assert(learningPath != null);
    assert(lesson != null);
    assert(course != null);
    return learningPath(name, description, sections);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result learningPath(
        String name, String description, List<LearningSection> sections),
    Result lesson(int episode, String title, String lessonUrl, String videoId,
        String streamUrl, String materialDownloadLink),
    Result course(String title, List<Lesson> lessons),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (learningPath != null) {
      return learningPath(name, description, sections);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result learningPath(LearningPath value),
    @required Result lesson(Lesson value),
    @required Result course(Course value),
  }) {
    assert(learningPath != null);
    assert(lesson != null);
    assert(course != null);
    return learningPath(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result learningPath(LearningPath value),
    Result lesson(Lesson value),
    Result course(Course value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (learningPath != null) {
      return learningPath(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$LearningPathToJson(this)..['runtimeType'] = 'learningPath';
  }
}

abstract class LearningPath implements Metadata {
  const factory LearningPath(
      {String name,
      String description,
      List<LearningSection> sections}) = _$LearningPath;

  factory LearningPath.fromJson(Map<String, dynamic> json) =
      _$LearningPath.fromJson;

  String get name;
  String get description;
  List<LearningSection> get sections;
  $LearningPathCopyWith<LearningPath> get copyWith;
}

abstract class $LessonCopyWith<$Res> {
  factory $LessonCopyWith(Lesson value, $Res Function(Lesson) then) =
      _$LessonCopyWithImpl<$Res>;
  $Res call(
      {int episode,
      String title,
      String lessonUrl,
      String videoId,
      String streamUrl,
      String materialDownloadLink});
}

class _$LessonCopyWithImpl<$Res> extends _$MetadataCopyWithImpl<$Res>
    implements $LessonCopyWith<$Res> {
  _$LessonCopyWithImpl(Lesson _value, $Res Function(Lesson) _then)
      : super(_value, (v) => _then(v as Lesson));

  @override
  Lesson get _value => super._value as Lesson;

  @override
  $Res call({
    Object episode = freezed,
    Object title = freezed,
    Object lessonUrl = freezed,
    Object videoId = freezed,
    Object streamUrl = freezed,
    Object materialDownloadLink = freezed,
  }) {
    return _then(Lesson(
      episode: episode == freezed ? _value.episode : episode as int,
      title: title == freezed ? _value.title : title as String,
      lessonUrl: lessonUrl == freezed ? _value.lessonUrl : lessonUrl as String,
      videoId: videoId == freezed ? _value.videoId : videoId as String,
      streamUrl: streamUrl == freezed ? _value.streamUrl : streamUrl as String,
      materialDownloadLink: materialDownloadLink == freezed
          ? _value.materialDownloadLink
          : materialDownloadLink as String,
    ));
  }
}

@JsonSerializable()
class _$Lesson implements Lesson {
  _$Lesson(
      {this.episode,
      this.title,
      this.lessonUrl,
      this.videoId,
      this.streamUrl,
      this.materialDownloadLink});

  factory _$Lesson.fromJson(Map<String, dynamic> json) =>
      _$_$LessonFromJson(json);

  @override
  final int episode;
  @override
  final String title;
  @override
  final String lessonUrl;
  @override
  final String videoId;
  @override
  final String streamUrl;
  @override
  final String materialDownloadLink;

  @override
  String toString() {
    return 'Metadata.lesson(episode: $episode, title: $title, lessonUrl: $lessonUrl, videoId: $videoId, streamUrl: $streamUrl, materialDownloadLink: $materialDownloadLink)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Lesson &&
            (identical(other.episode, episode) ||
                const DeepCollectionEquality()
                    .equals(other.episode, episode)) &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.lessonUrl, lessonUrl) ||
                const DeepCollectionEquality()
                    .equals(other.lessonUrl, lessonUrl)) &&
            (identical(other.videoId, videoId) ||
                const DeepCollectionEquality()
                    .equals(other.videoId, videoId)) &&
            (identical(other.streamUrl, streamUrl) ||
                const DeepCollectionEquality()
                    .equals(other.streamUrl, streamUrl)) &&
            (identical(other.materialDownloadLink, materialDownloadLink) ||
                const DeepCollectionEquality()
                    .equals(other.materialDownloadLink, materialDownloadLink)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(episode) ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(lessonUrl) ^
      const DeepCollectionEquality().hash(videoId) ^
      const DeepCollectionEquality().hash(streamUrl) ^
      const DeepCollectionEquality().hash(materialDownloadLink);

  @override
  $LessonCopyWith<Lesson> get copyWith =>
      _$LessonCopyWithImpl<Lesson>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required
        Result learningPath(
            String name, String description, List<LearningSection> sections),
    @required
        Result lesson(int episode, String title, String lessonUrl,
            String videoId, String streamUrl, String materialDownloadLink),
    @required Result course(String title, List<Lesson> lessons),
  }) {
    assert(learningPath != null);
    assert(lesson != null);
    assert(course != null);
    return lesson(
        episode, title, lessonUrl, videoId, streamUrl, materialDownloadLink);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result learningPath(
        String name, String description, List<LearningSection> sections),
    Result lesson(int episode, String title, String lessonUrl, String videoId,
        String streamUrl, String materialDownloadLink),
    Result course(String title, List<Lesson> lessons),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (lesson != null) {
      return lesson(
          episode, title, lessonUrl, videoId, streamUrl, materialDownloadLink);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result learningPath(LearningPath value),
    @required Result lesson(Lesson value),
    @required Result course(Course value),
  }) {
    assert(learningPath != null);
    assert(lesson != null);
    assert(course != null);
    return lesson(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result learningPath(LearningPath value),
    Result lesson(Lesson value),
    Result course(Course value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (lesson != null) {
      return lesson(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$LessonToJson(this)..['runtimeType'] = 'lesson';
  }
}

abstract class Lesson implements Metadata {
  factory Lesson(
      {int episode,
      String title,
      String lessonUrl,
      String videoId,
      String streamUrl,
      String materialDownloadLink}) = _$Lesson;

  factory Lesson.fromJson(Map<String, dynamic> json) = _$Lesson.fromJson;

  int get episode;
  String get title;
  String get lessonUrl;
  String get videoId;
  String get streamUrl;
  String get materialDownloadLink;
  $LessonCopyWith<Lesson> get copyWith;
}

abstract class $CourseCopyWith<$Res> {
  factory $CourseCopyWith(Course value, $Res Function(Course) then) =
      _$CourseCopyWithImpl<$Res>;
  $Res call({String title, List<Lesson> lessons});
}

class _$CourseCopyWithImpl<$Res> extends _$MetadataCopyWithImpl<$Res>
    implements $CourseCopyWith<$Res> {
  _$CourseCopyWithImpl(Course _value, $Res Function(Course) _then)
      : super(_value, (v) => _then(v as Course));

  @override
  Course get _value => super._value as Course;

  @override
  $Res call({
    Object title = freezed,
    Object lessons = freezed,
  }) {
    return _then(Course(
      title: title == freezed ? _value.title : title as String,
      lessons: lessons == freezed ? _value.lessons : lessons as List<Lesson>,
    ));
  }
}

@JsonSerializable()
class _$Course implements Course {
  const _$Course({this.title, this.lessons});

  factory _$Course.fromJson(Map<String, dynamic> json) =>
      _$_$CourseFromJson(json);

  @override
  final String title;
  @override
  final List<Lesson> lessons;

  @override
  String toString() {
    return 'Metadata.course(title: $title, lessons: $lessons)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is Course &&
            (identical(other.title, title) ||
                const DeepCollectionEquality().equals(other.title, title)) &&
            (identical(other.lessons, lessons) ||
                const DeepCollectionEquality().equals(other.lessons, lessons)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(title) ^
      const DeepCollectionEquality().hash(lessons);

  @override
  $CourseCopyWith<Course> get copyWith =>
      _$CourseCopyWithImpl<Course>(this, _$identity);

  @override
  @optionalTypeArgs
  Result when<Result extends Object>({
    @required
        Result learningPath(
            String name, String description, List<LearningSection> sections),
    @required
        Result lesson(int episode, String title, String lessonUrl,
            String videoId, String streamUrl, String materialDownloadLink),
    @required Result course(String title, List<Lesson> lessons),
  }) {
    assert(learningPath != null);
    assert(lesson != null);
    assert(course != null);
    return course(title, lessons);
  }

  @override
  @optionalTypeArgs
  Result maybeWhen<Result extends Object>({
    Result learningPath(
        String name, String description, List<LearningSection> sections),
    Result lesson(int episode, String title, String lessonUrl, String videoId,
        String streamUrl, String materialDownloadLink),
    Result course(String title, List<Lesson> lessons),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (course != null) {
      return course(title, lessons);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  Result map<Result extends Object>({
    @required Result learningPath(LearningPath value),
    @required Result lesson(Lesson value),
    @required Result course(Course value),
  }) {
    assert(learningPath != null);
    assert(lesson != null);
    assert(course != null);
    return course(this);
  }

  @override
  @optionalTypeArgs
  Result maybeMap<Result extends Object>({
    Result learningPath(LearningPath value),
    Result lesson(Lesson value),
    Result course(Course value),
    @required Result orElse(),
  }) {
    assert(orElse != null);
    if (course != null) {
      return course(this);
    }
    return orElse();
  }

  @override
  Map<String, dynamic> toJson() {
    return _$_$CourseToJson(this)..['runtimeType'] = 'course';
  }
}

abstract class Course implements Metadata {
  const factory Course({String title, List<Lesson> lessons}) = _$Course;

  factory Course.fromJson(Map<String, dynamic> json) = _$Course.fromJson;

  String get title;
  List<Lesson> get lessons;
  $CourseCopyWith<Course> get copyWith;
}
