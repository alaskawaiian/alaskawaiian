// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserImpl _$$UserImplFromJson(Map<String, dynamic> json) => _$UserImpl(
      id: json['id'] as String,
      miles: (json['miles'] as num).toInt(),
      streak: (json['streak'] as num).toInt(),
      lastAnsweredAt:
          _lastAnsweredAtFromJson(json['lastAnsweredAt'] as Timestamp?),
    );

Map<String, dynamic> _$$UserImplToJson(_$UserImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'miles': instance.miles,
      'streak': instance.streak,
      'lastAnsweredAt': instance.lastAnsweredAt?.toIso8601String(),
    };
