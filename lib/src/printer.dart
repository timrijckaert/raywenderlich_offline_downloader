import 'dart:convert';
import 'dart:io';

import 'models.dart';

const _outputDirectory = 'raywenderlich-downloader';

mixin Printer {
  Future<void> print(
    final Metadata metadata,
    final bool canExportMaterials,
  );
}

class _FileSystemNameSanitizer {
  _FileSystemNameSanitizer._();

  static String sanitizedForFileSystemUse(final String s) =>
      s.toLowerCase().replaceAll(' ', '_');
}

mixin _FileExportPrinter {
  String get fileExtension;

  String fileNameForMetadata(final Metadata metadata) => metadata.map(
        learningPath: (learningPath) => learningPath.name,
        lesson: (lesson) => lesson.title,
        course: (course) => course.title,
      );

  String stringifiedMetadata(
    final Metadata metadata,
    final bool canExportMaterials,
  );

  Future<void> print(
    final Metadata metadata,
    final bool canExportMaterials,
  ) async {
    final filename = _FileSystemNameSanitizer.sanitizedForFileSystemUse(
        fileNameForMetadata(metadata));
    final outputFile = File('$_outputDirectory/$filename.$fileExtension');
    IOSink sink;
    try {
      if (await outputFile.exists()) {
        await outputFile.delete();
      }
      await outputFile.create(recursive: true);

      sink = outputFile.openWrite();
      sink.write(await stringifiedMetadata(metadata, canExportMaterials));
      await sink.flush();
    } catch (e) {
      rethrow;
    } finally {
      await sink?.close();
    }
  }
}

class JsonPrinter with _FileExportPrinter implements Printer {
  JsonPrinter._();

  static JsonPrinter _instance;

  @override
  String get fileExtension => 'json';

  factory JsonPrinter() {
    _instance ??= JsonPrinter._();
    return _instance;
  }

  @override
  String stringifiedMetadata(
    Metadata metadata,
    bool canExportMaterials,
  ) =>
      JsonEncoder.withIndent(' ').convert(metadata.toJson());
}

class YoutubeDlPrinter with _FileExportPrinter implements Printer {
  static YoutubeDlPrinter _instance;

  YoutubeDlPrinter._();

  factory YoutubeDlPrinter() {
    _instance ??= YoutubeDlPrinter._();
    return _instance;
  }

  @override
  String get fileExtension => 'sh';

  String _createYoutubeDlCommand(
    final String directory,
    final String filename,
    final String streamUrl,
  ) =>
      "youtube-dl -o '${directory}/$filename.%(ext)s' ${streamUrl}";

  String _downloadMaterialCommand(
    final String directory,
    final String filename,
    final String downloadLink,
  ) =>
      'curl --create-dirs ${downloadLink} -L -o ${directory}/${filename}.zip';

  String _heading(final int episode, final String title) =>
      '# $episode: $title';

  String _learningPathOutput(
    final LearningPath learningPath,
    final bool canExportMaterials,
  ) {
    //TODO improve output for learning path
    throw 'Exporting learning paths are not implemented yet.';
  }

  String _lessonOutput(
    final Lesson lesson,
    final bool canExportMaterials,
  ) {
    final strBuffer = StringBuffer();

    final directory =
        _FileSystemNameSanitizer.sanitizedForFileSystemUse(lesson.title);
    final filename = _FileSystemNameSanitizer.sanitizedForFileSystemUse(
        '${lesson.episode} ${lesson.title}');

    strBuffer.writeln(_heading(lesson.episode, lesson.title));
    strBuffer.writeln(
        _createYoutubeDlCommand(directory, filename, lesson.streamUrl));
    if (canExportMaterials && lesson.hasMaterials) {
      strBuffer.writeln(
        _downloadMaterialCommand(
          directory,
          filename,
          lesson.materialDownloadLink,
        ),
      );
    }
    return strBuffer.toString();
  }

  String _courseOutput(
    final Course course,
    final bool canExportMaterials,
  ) =>
      course.lessons
          .map((lesson) => _lessonOutput(lesson, canExportMaterials))
          .join('\n');

  @override
  String stringifiedMetadata(
    final Metadata metadata,
    final bool canExportMaterials,
  ) {
    final strBuffer = StringBuffer();
    strBuffer.writeln('#!/bin/sh');
    strBuffer.writeln(
      metadata.map(
        learningPath: (it) => _learningPathOutput(it, canExportMaterials),
        lesson: (it) => _lessonOutput(it, canExportMaterials),
        course: (it) => _courseOutput(it, canExportMaterials),
      ),
    );
    return strBuffer.toString();
  }
}
