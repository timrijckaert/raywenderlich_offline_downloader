import 'models.dart';
import 'package:puppeteer/puppeteer.dart';
import 'package:pedantic/pedantic.dart';

import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';

class _Attachment {
  final String url;
  final String kind;
  final String fileName;

  _Attachment({
    this.url,
    this.kind,
    this.fileName,
  });
}

class _Clip {
  final String clipType;
  final List<_Attachment> attachments;

  _Clip({
    this.clipType,
    this.attachments,
  });
}

class _VideoResponse {
  final int id;
  final int episode;
  final String name;
  final String description;
  final List<_Attachment> attachments;
  final List<_Clip> clips;

  _VideoResponse({
    this.id,
    this.episode,
    this.name,
    this.description,
    this.attachments,
    this.clips,
  });
}

class _Mapper {
  const _Mapper._();
  static Lesson lessonFromVideoResponse({
    final String lessonUrl,
    final String videoId,
    final _VideoResponse response,
  }) {
    String _streamUrlFromClips(final List<_Clip> clips) => clips
        .firstWhere((element) => element.clipType == 'primary_content')
        .attachments
        .firstWhere((element) => element.kind == 'stream')
        .url;

    String _materialDownloadLinkFromAttachments(
        final List<_Attachment> attachments) {
      final materialsAttachment = attachments.firstWhere(
        (attachment) => attachment.kind == 'materials',
        orElse: () => null,
      );
      return materialsAttachment == null ? '' : materialsAttachment.url;
    }

    return Lesson(
      episode: response.episode,
      title: response.name,
      lessonUrl: lessonUrl,
      videoId: videoId,
      streamUrl: _streamUrlFromClips(response.clips),
      materialDownloadLink:
          _materialDownloadLinkFromAttachments(response.attachments),
    );
  }
}

class _RaywenderlichApi {
  _RaywenderlichApi._();

  static Future<_VideoResponse> _getVideoResponseFromVideoId(
    final String lessonUrl,
    final String userToken,
  ) async {
    List<_Attachment> _attachmentFromDynamicObject(
            final List<dynamic> attachments) =>
        attachments
            .map(
              (attachment) => _Attachment(
                url: attachment['url'],
                kind: attachment['kind'],
                fileName: attachment['filename'],
              ),
            )
            .toList();

    List<_Clip> _clipsFromVideoObj(final dynamic videoObj) {
      final List<dynamic> clipsObj = videoObj['clips'];
      return clipsObj.map((clip) {
        final clipType = clip['clip_type'];
        final attachments = _attachmentFromDynamicObject(clip['attachments']);
        return _Clip(clipType: clipType, attachments: attachments);
      }).toList();
    }

    final completer = Completer<_VideoResponse>();
    final response =
        await get(lessonUrl, headers: {'Authorization': 'Token $userToken'});

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final videoObj = jsonResponse['video'];

      final id = videoObj['id'];
      final episode = videoObj['episode'];
      final name = videoObj['name'];
      final description = videoObj['description'];
      final attachments = _attachmentFromDynamicObject(videoObj['attachments']);
      final videoResponse = _VideoResponse(
        id: id,
        episode: episode,
        name: name,
        description: description,
        attachments: attachments,
        clips: _clipsFromVideoObj(videoObj),
      );
      completer.complete(videoResponse);
    } else {
      throw '';
    }
    return completer.future;
  }

  static Future<Lesson> getLessonFromVideoId(
    final String videoId,
    final String userToken,
  ) async {
    String _constructUrl(final String videoId) =>
        'https://videos.raywenderlich.com/api/v1/videos/$videoId.json';

    final lessonUrl = _constructUrl(videoId);
    final response = await _getVideoResponseFromVideoId(lessonUrl, userToken);
    return _Mapper.lessonFromVideoResponse(
      lessonUrl: lessonUrl,
      videoId: videoId,
      response: response,
    );
  }
}

class LessonService {
  static final RegExp lessonUrlRegex = RegExp(r'\/(\d+)\/');

  LessonService._();

  static Future<String> _videoIdFromPage(final Page page) async => await page
      .$("meta[name='twitter:image']")
      .then((e) => e.propertyValue('content'))
      .then((content) => lessonUrlRegex.firstMatch(content as String).group(1));

  static Future<Lesson> getLesson({
    final Browser browser,
    final String userToken,
    final String lessonUrl,
  }) async {
    final lessonPage = await browser.newPage();
    await lessonPage.goto(lessonUrl, wait: Until.domContentLoaded);

    final videoId = await _videoIdFromPage(lessonPage);
    unawaited(lessonPage.close());

    final lesson = await _RaywenderlichApi.getLessonFromVideoId(
      videoId,
      userToken,
    );
    print(lesson);
    return lesson;
  }

  static Future<List<Lesson>> getLessons(
    final Browser browser,
    final String userToken,
    final Page courseOverviewPage,
    final String courseUrl,
  ) async {
    final amountOfLessons = await courseOverviewPage
        .$$('.c-tutorial-episode')
        .then((e) => e.length);
    print('Found $amountOfLessons lessons');
    unawaited(courseOverviewPage.close());
    return await Future.wait(
      List.generate(
        amountOfLessons,
        (index) => getLesson(
          browser: browser,
          userToken: userToken,
          lessonUrl: '$courseUrl/lessons/${index + 1}',
        ),
      ),
    );
  }
}
