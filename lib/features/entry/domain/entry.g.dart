// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Entry _$$_EntryFromJson(Map<String, dynamic> json) => _$_Entry(
      id: json['id'] as String,
      jobId: json['jobId'] as String,
      start: DateTime.parse(json['start'] as String),
      end: DateTime.parse(json['end'] as String),
      comment: json['comment'] as String,
    );

Map<String, dynamic> _$$_EntryToJson(_$_Entry instance) => <String, dynamic>{
      'id': instance.id,
      'jobId': instance.jobId,
      'start': instance.start.toIso8601String(),
      'end': instance.end.toIso8601String(),
      'comment': instance.comment,
    };
