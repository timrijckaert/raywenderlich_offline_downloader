// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ApiResponse _$_ApiResponseFromJson(Map<String, dynamic> json) {
  return _ApiResponse(
    data: json['data'] == null
        ? null
        : _Data.fromJson(json['data'] as Map<String, dynamic>),
    included: (json['included'] as List)
        ?.map((e) =>
            e == null ? null : _Included.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$_ApiResponseToJson(_ApiResponse instance) =>
    <String, dynamic>{
      'data': instance.data,
      'included': instance.included,
    };

_Data _$_DataFromJson(Map<String, dynamic> json) {
  return _Data(
    id: json['id'] as String,
    type: json['type'] as String,
    attributes: json['attributes'] == null
        ? null
        : _Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
    links: json['links'] == null
        ? null
        : _Links.fromJson(json['links'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_DataToJson(_Data instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributes': instance.attributes,
      'links': instance.links,
    };

_Attributes _$_AttributesFromJson(Map<String, dynamic> json) {
  return _Attributes(
    json['uri'] as String,
    json['name'] as String,
    json['description'] as String,
    json['released_at'] as String,
    json['free'] as bool,
    json['difficulty'] as String,
    json['content_type'] as String,
    json['duration'] as int,
    (json['popularity'] as num)?.toDouble(),
    json['technology_triple_string'] as String,
    json['contributor_string'] as String,
    json['ordinal'] as int,
    json['professional'] as bool,
    json['description_plain_text'] as String,
    json['video_identifier'] as int,
    json['parent_name'] as String,
    json['accessible'] as bool,
    json['card_artwork_url'] as String,
    json['body'] as String,
    json['slug'] as String,
    json['level'] as String,
    json['kind'] as String,
    json['url'] as String,
  );
}

Map<String, dynamic> _$_AttributesToJson(_Attributes instance) =>
    <String, dynamic>{
      'uri': instance.uri,
      'name': instance.name,
      'description': instance.description,
      'released_at': instance.released_at,
      'free': instance.free,
      'difficulty': instance.difficulty,
      'content_type': instance.content_type,
      'duration': instance.duration,
      'popularity': instance.popularity,
      'technology_triple_string': instance.technology_triple_string,
      'contributor_string': instance.contributor_string,
      'ordinal': instance.ordinal,
      'professional': instance.professional,
      'description_plain_text': instance.description_plain_text,
      'video_identifier': instance.video_identifier,
      'parent_name': instance.parent_name,
      'accessible': instance.accessible,
      'card_artwork_url': instance.card_artwork_url,
      'body': instance.body,
      'slug': instance.slug,
      'level': instance.level,
      'kind': instance.kind,
      'url': instance.url,
    };

_Links _$_LinksFromJson(Map<String, dynamic> json) {
  return _Links(
    self: json['self'] as String,
  );
}

Map<String, dynamic> _$_LinksToJson(_Links instance) => <String, dynamic>{
      'self': instance.self,
    };

_Included _$_IncludedFromJson(Map<String, dynamic> json) {
  return _Included(
    id: json['id'] as String,
    type: json['type'] as String,
    attributes: json['attributes'] == null
        ? null
        : _Attributes.fromJson(json['attributes'] as Map<String, dynamic>),
    links: json['links'] == null
        ? null
        : _Links.fromJson(json['links'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$_IncludedToJson(_Included instance) => <String, dynamic>{
      'id': instance.id,
      'type': instance.type,
      'attributes': instance.attributes,
      'links': instance.links,
    };
