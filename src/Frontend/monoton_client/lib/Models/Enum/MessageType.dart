import 'package:json_annotation/json_annotation.dart';

enum MessageType {
  @JsonValue(0)
  TEXT,
  @JsonValue(1)
  IMAGE,
  @JsonValue(2)
  VIDEO,
  @JsonValue(3)
  FILE,
  @JsonValue(4)
  VOICE,
  @JsonValue(5)
  DELETED,
  @JsonValue(6)
  NULL
}