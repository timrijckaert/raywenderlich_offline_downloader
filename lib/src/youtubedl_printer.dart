import 'dart:io';

import 'models/models.dart';

/// TODO refactor to allow for different types of [Metadata].
class YoutubeDlPrinter {
  YoutubeDlPrinter._();

  static void printCourse(
    final bool canExtractMaterials,
    final Course course,
  ) async {
    String outputLessonTitle(final Lesson lesson) {
      final sanitizedLessonTitle =
          lesson.title.toLowerCase().replaceAll(' ', '_');
      return '${lesson.episode}_$sanitizedLessonTitle';
    }

    String sanitizedCourseTitle(final Course course) =>
        course.title.toLowerCase().replaceAll(' ', '_');

    final courseTitle = sanitizedCourseTitle(course);
    final bashFilename = '${courseTitle}.sh';

    final outputFile = File(bashFilename);
    try {
      outputFile.deleteSync();
    } catch (_) {}

    final sink = outputFile.openWrite();

    sink.writeln('#!/bin/sh');
    course.lessons.forEach((lesson) {
      final sanitizedLessonTitle = outputLessonTitle(lesson);
      sink.writeln('# ${lesson.episode}: ${lesson.title}');
      sink.writeln(
          "youtube-dl -o '${courseTitle}/$sanitizedLessonTitle.%(ext)s' ${lesson.streamUrl}");

      if (canExtractMaterials && lesson.hasMaterials) {
        sink.writeln(
            'curl --create-dirs ${lesson.materialDownloadLink} -L -o ${courseTitle}/${sanitizedLessonTitle}.zip');
      }
      sink.writeln();
    });

    await sink.flush();
    await sink.close();

    print('Run: `sh $bashFilename` in your terminal.');
  }

  static void printBashFile(
    final bool canExtractMaterials,
    final Metadata metadata,
  ) async {
    if (metadata.runtimeType == Course) {
      printCourse(canExtractMaterials, metadata);
    }
  }
}
