import 'package:json_annotation/json_annotation.dart';

enum TaskPriority {
  @JsonValue('high')
  high,
  @JsonValue('medium')
  medium,
  @JsonValue('low')
  low
}