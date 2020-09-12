import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart';
import 'models/models.dart';

class Attachment {
  final String url;
  final String kind;
  final String fileName;

  Attachment({
    this.url,
    this.kind,
    this.fileName,
  });
}

class Clip {
  final String clipType;
  final List<Attachment> attachments;

  Clip({
    this.clipType,
    this.attachments,
  });
}

class VideoResponse {
  final int id;
  final int episode;
  final String name;
  final String description;
  final List<Attachment> attachments;
  final List<Clip> clips;

  VideoResponse({
    this.id,
    this.episode,
    this.name,
    this.description,
    this.attachments,
    this.clips,
  });
}

class RaywenderlichApi {
  RaywenderlichApi._();

  static Future<VideoResponse> _getVideoResponseFromVideoId(
    final String lessonUrl,
    final String userToken,
  ) async {
    List<Attachment> _attachmentFromDynamicObject(
            final List<dynamic> attachments) =>
        attachments
            .map(
              (attachment) => Attachment(
                url: attachment['url'],
                kind: attachment['kind'],
                fileName: attachment['filename'],
              ),
            )
            .toList();

    List<Clip> _clipsFromVideoObj(final dynamic videoObj) {
      final List<dynamic> clipsObj = videoObj['clips'];
      return clipsObj.map((clip) {
        final clipType = clip['clip_type'];
        final attachments = _attachmentFromDynamicObject(clip['attachments']);
        return Clip(clipType: clipType, attachments: attachments);
      }).toList();
    }

    final completer = Completer<VideoResponse>();
    final response = await get(
      lessonUrl,
      headers: {'Authorization': 'Token $userToken'},
    ).timeout(Duration(seconds: 30));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      final videoObj = jsonResponse['video'];

      final id = videoObj['id'];
      final episode = videoObj['episode'];
      final name = videoObj['name'];
      final description = videoObj['description'];
      final attachments = _attachmentFromDynamicObject(videoObj['attachments']);
      final videoResponse = VideoResponse(
        id: id,
        episode: episode,
        name: name,
        description: description,
        attachments: attachments,
        clips: _clipsFromVideoObj(videoObj),
      );
      completer.complete(videoResponse);
    }
    return completer.future;
  }

  static Future<Lesson> getLessonFromVideoId(
    final String videoId,
    final String userToken,
  ) async {
    String _streamUrlFromClips(final List<Clip> clips) => clips
        .firstWhere((element) => element.clipType == 'primary_content')
        .attachments
        .firstWhere((element) => element.kind == 'stream')
        .url;

    String _constructUrl(final String videoId) =>
        'https://videos.raywenderlich.com/api/v1/videos/$videoId.json';

    String _materialDownloadLinkFromAttachments(
        final List<Attachment> attachments) {
      final materialsAttachment = attachments.firstWhere(
        (attachment) => attachment.kind == 'materials',
        orElse: () => null,
      );
      return materialsAttachment == null ? '' : materialsAttachment.url;
    }

    final lessonUrl = _constructUrl(videoId);
    final response = await _getVideoResponseFromVideoId(lessonUrl, userToken);
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
