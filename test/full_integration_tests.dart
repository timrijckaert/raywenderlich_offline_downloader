import 'dart:convert';
import 'dart:io';

import 'package:raywenderlich_offline_downloader/raywenderlich_offline_downloader.dart';
import 'package:raywenderlich_offline_downloader/src/models.dart';
import 'package:test/test.dart';

/// These 'tests' here are full integration tests and are brittle by definition.
void main(List<String> args) {
  final credentials =
      jsonDecode(File('test/credentials.json').readAsStringSync());
  final username = credentials['username'];
  final password = credentials['password'];

  group('raywenderlich integration tests', () {
    test('single lesson from a course', () async {
      final metaData = (await RaywenderlichMetaDownloader.metadataFromArguments(
        username,
        password,
        ['https://www.raywenderlich.com/4919757-your-first-ios-and-swiftui-app/lessons/2'],
      ).toList())[0] as Course;
      
      expect(metaData.title, 'Your First iOS and SwiftUI App');
      expect(metaData.lessons.length, 48);
    });

    test('single course', () async {
      final metaData = (await RaywenderlichMetaDownloader.metadataFromArguments(
        username,
        password,
        ['https://www.raywenderlich.com/4289-mastering-git'],
      ).toList())[0] as Course;
      
      expect(metaData.title, 'Mastering Git');
      expect(metaData.lessons.length, 14);
    });

    test('single talk', () async {
      final metaData = (await RaywenderlichMetaDownloader.metadataFromArguments(
        username,
        password,
        ['https://www.raywenderlich.com/10528876-dean-djermanovic-building-uis-in-android-using-jetpack-compose'],
      ).toList())[0] as Lesson;
      
      expect(metaData.title, 'Dean Djermanović - Building UIs in Android using Jetpack Compose');
    });

    test('https://www.raywenderlich.com/11590969-wwdc-2020-widgets', () async {
      final metaData = (await RaywenderlichMetaDownloader.metadataFromArguments(
        username,
        password,
        ['https://www.raywenderlich.com/11590969-wwdc-2020-widgets'],
      ).toList())[0] as Lesson;
      
      expect(metaData.title, 'WWDC 2020: Widgets');
    });

    test('https://www.raywenderlich.com/12920765-wwdc-2020-screencasts', () async {
      final metaData = (await RaywenderlichMetaDownloader.metadataFromArguments(
        username,
        password,
        ['https://www.raywenderlich.com/12920765-wwdc-2020-screencasts'],
      ).toList())[0] as Course;
      
      expect(metaData.title, 'WWDC 2020 Screencasts');
      expect(metaData.lessons.length, 6);
    });
  }, timeout: Timeout.none);
}
