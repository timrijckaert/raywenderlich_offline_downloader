import 'dart:convert';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:http/http.dart';

import 'models.dart';

part 'api.g.dart';

class Api {
  static final idRegex = RegExp(r'\d+');

  Api._();

  static String _extractIdFromUrl(final String url) =>
      idRegex.firstMatch(url).group(0);

  static String _constructApiUrl(final String id) =>
      'https://api.raywenderlich.com/api/contents/$id';

  static Map<String, String> _constructHeaders(final String userToken) =>
      {'Authorization': 'Bearer $userToken'};

  static Future<_ApiResponse> _apiResponseFromUrl(
    final String apiUrl,
    final String userToken,
  ) async {
    final rawResponse = await get(
      apiUrl,
      headers: _constructHeaders(userToken),
    );
    return _ApiResponse.fromJson(jsonDecode(rawResponse.body));
  }

  static Future<Metadata> _apiResponseToMetadata(
    final _ApiResponse apiResponse,
    final String userToken,
  ) async {
    bool contentIncludedPredicate(final _Included included) =>
        included.type == 'contents';
    final isSingleVideo =
        apiResponse.included.indexWhere(contentIncludedPredicate) == -1;

    Future<String> streamUrlForApiResponse(
      final String videoId,
      final String userToken,
    ) async {
      var responseBody = await get(
        'https://api.raywenderlich.com/api/videos/$videoId/stream',
        headers: _constructHeaders(userToken),
      );
      final json = jsonDecode(responseBody.body);
      return _ApiResponse.fromJson(json).data.attributes.url;
    }

    Future<String> materialsForApiResponse(
      final String videoId,
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

      final apiUrl =
          'https://videos.raywenderlich.com/api/v1/videos/$videoId.json';
      final rawResponse =
          await get(apiUrl, headers: _constructHeaders(userToken));
      final jsonResponse = jsonDecode(rawResponse.body);
      final videoObj = jsonResponse['video'];

      final attachments = _attachmentFromDynamicObject(videoObj['attachments']);
      final materialsAttachment = attachments.firstWhere(
        (attachment) => attachment.kind == 'materials',
        orElse: () => null,
      );
      return materialsAttachment == null ? '' : materialsAttachment.url;
    }

    Future<Lesson> lessonFromIncluded(
      final String uri,
      final int ordinal,
      final String name,
      final String lessonUrl,
      final String userToken,
    ) async {
      final videoId = _extractIdFromUrl(uri);
      return Metadata.lesson(
          episode: ordinal,
          title: name,
          lessonUrl: lessonUrl,
          videoId: videoId,
          streamUrl: await streamUrlForApiResponse(videoId, userToken),
          materialDownloadLink:
              await materialsForApiResponse(videoId, userToken));
    }

    Future<List<Lesson>> lessonsFromListOfIncluded(
      final List<_Included> included,
      final String userToken,
    ) =>
        Future.wait(
          included
              .map(
                (included) => lessonFromIncluded(
                  included.attributes.uri,
                  included.attributes.ordinal,
                  included.attributes.name,
                  included.links.self,
                  userToken,
                ),
              )
              .toList(),
        );

    if (isSingleVideo) {
      return lessonFromIncluded(
        apiResponse.data.attributes.uri,
        apiResponse.data.attributes.ordinal,
        apiResponse.data.attributes.name,
        apiResponse.data.links.self,
        userToken,
      );
    } else {
      return Metadata.course(
        title: apiResponse.data.attributes.name,
        lessons: await lessonsFromListOfIncluded(
          apiResponse.included.where(contentIncludedPredicate).toList(),
          userToken,
        ),
      );
    }
  }

  static Future<Metadata> metadataOutputForUrl(
    final String url,
    final String userToken,
  ) async {
    final id = _extractIdFromUrl(url);
    final apiUrl = _constructApiUrl(id);
    final apiResponse = await _apiResponseFromUrl(apiUrl, userToken);
    return _apiResponseToMetadata(apiResponse, userToken);
  }
}

@JsonSerializable()
class _ApiResponse {
  final _Data data;
  final List<_Included> included;

  _ApiResponse({this.data, this.included});

  factory _ApiResponse.fromJson(Map<String, dynamic> json) =>
      _$_ApiResponseFromJson(json);
}

@JsonSerializable()
class _Data {
  final String id;
  final String type;
  final _Attributes attributes;
  //final RelationShips relationShips;
  final _Links links;

  _Data({this.id, this.type, this.attributes, this.links});

  factory _Data.fromJson(Map<String, dynamic> json) => _$_DataFromJson(json);
}

@JsonSerializable()
class _Attributes {
  final String uri;
  final String name;
  final String description;
  final String released_at;
  final bool free;
  final String difficulty;
  final String content_type;
  final int duration;
  final double popularity;
  final String technology_triple_string;
  final String contributor_string;
  final int ordinal;
  final bool professional;
  final String description_plain_text;
  final int video_identifier;
  final String parent_name;
  final bool accessible;
  final String card_artwork_url;
  final String body;
  final String slug;
  final String level;
  final String kind;
  final String url;

  _Attributes(
    this.uri,
    this.name,
    this.description,
    this.released_at,
    this.free,
    this.difficulty,
    this.content_type,
    this.duration,
    this.popularity,
    this.technology_triple_string,
    this.contributor_string,
    this.ordinal,
    this.professional,
    this.description_plain_text,
    this.video_identifier,
    this.parent_name,
    this.accessible,
    this.card_artwork_url,
    this.body,
    this.slug,
    this.level,
    this.kind,
    this.url,
  );

  factory _Attributes.fromJson(Map<String, dynamic> json) =>
      _$_AttributesFromJson(json);
}

@JsonSerializable()
class _Links {
  final String self;

  _Links({this.self});

  factory _Links.fromJson(Map<String, dynamic> json) => _$_LinksFromJson(json);
}

@JsonSerializable()
class _Included {
  final String id;
  final String type;
  final _Attributes attributes;
  final _Links links;

  _Included({this.id, this.type, this.attributes, this.links});

  factory _Included.fromJson(Map<String, dynamic> json) =>
      _$_IncludedFromJson(json);
}

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
