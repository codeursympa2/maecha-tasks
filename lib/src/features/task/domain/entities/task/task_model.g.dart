// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'task_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TaskModel _$TaskModelFromJson(Map<String, dynamic> json) => TaskModel(
      id: json['id'] as String?,
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      dateTime: json['dateTime'] == null
          ? null
          : DateTime.parse(json['dateTime'] as String),
      user: json['user'] == null
          ? null
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      priority: $enumDecodeNullable(_$TaskPriorityEnumMap, json['priority']),
      notify: json['notify'] as bool?,
      done: json['done'] as bool?,
    );

Map<String, dynamic> _$TaskModelToJson(TaskModel instance) => <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'desc': instance.desc,
      'dateTime': instance.dateTime?.toIso8601String(),
      'priority': _$TaskPriorityEnumMap[instance.priority],
      'user': instance.user,
      'notify': instance.notify,
      'done': instance.done,
    };

const _$TaskPriorityEnumMap = {
  TaskPriority.high: 'high',
  TaskPriority.medium: 'medium',
  TaskPriority.low: 'low',
};
