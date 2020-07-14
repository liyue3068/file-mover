// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'global-settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GlobalSettings _$GlobalSettingsFromJson(Map<String, dynamic> json) {
  return GlobalSettings(
    (json['paths'] as List)?.map((e) => e as String)?.toList(),
  );
}

Map<String, dynamic> _$GlobalSettingsToJson(GlobalSettings instance) =>
    <String, dynamic>{
      'paths': instance.paths,
    };
