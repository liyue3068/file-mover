import 'package:json_annotation/json_annotation.dart';

part 'global-settings.g.dart';

@JsonSerializable()
class GlobalSettings extends Object {
  List<String> paths;
  String serverPort;

  GlobalSettings(
    this.paths,
  );

  factory GlobalSettings.fromJson(Map<String, dynamic> srcJson) =>
      _$GlobalSettingsFromJson(srcJson);

  Map<String, dynamic> toJson() => _$GlobalSettingsToJson(this);
}
