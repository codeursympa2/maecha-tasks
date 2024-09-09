import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:maecha_tasks/src/features/authentification/domain/entities/user_model/user_model.dart';
import 'package:maecha_tasks/src/features/task/domain/value_objects/task_priority.dart';

part 'task_model.g.dart';

@JsonSerializable()
class TaskModel extends Equatable{
  final String? id;
  final String? title;
  final String? desc;
  final DateTime? dateTime;
  final TaskPriority? priority;
  final UserModel? user;
  final bool? notify;
  final bool? done;
  final bool? favorite;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const TaskModel.nullConst({this.id, this.title, this.desc, this.dateTime,this.user, this.priority, this.notify, this.done,this.favorite,this.createdAt,this.updatedAt});
  const TaskModel({this.id, required this.title, required this.desc, required this.dateTime,required this.user, required this.priority,required this.notify,required this.done,this.favorite,this.createdAt,this.updatedAt});
  const TaskModel.addTask({this.id, required this.title, required this.desc, required this.dateTime,this.user, required this.priority,required this.notify,required this.done,this.favorite,this.createdAt,this.updatedAt});


  const TaskModel.getTasks(
      {
      required this.user,
      this.id,
      this.title,
      this.desc,
      this.dateTime,
      this.priority,
      this.done,
      this.notify,
      this.favorite,
      this.createdAt,this.updatedAt
      });

  const TaskModel.updateTask(
      {
        required this.user,
        required this.id,
        this.title,
        this.desc,
        this.dateTime,
        this.priority,
        this.done,
        this.notify,this.favorite,this.createdAt,this.updatedAt
      });

  const TaskModel.getTitle(
      {
        required this.user,
        this.id,
        required this.title,
        this.desc,
        this.dateTime,
        this.priority,
        this.done,
        this.notify,this.favorite,this.createdAt,this.updatedAt
      });

  const TaskModel.geTaskById({
    required this.user,
    required this.id,
    this.title,
    this.desc,
    this.dateTime,
    this.priority,
    this.done,
    this.notify,this.favorite,this.createdAt,this.updatedAt
  });

  factory TaskModel.fromJson(Map<String,dynamic> json) => _$TaskModelFromJson(json);
  Map<String,dynamic> toJson() => _$TaskModelToJson(this);


  Map<String,dynamic> toJsonLocal() {
    final Map<String,dynamic> json=<String,dynamic>{};
    json['title']=title;
    json['desc']=desc;
    json['dateTime']=dateTime!.toIso8601String();
    json['priority']=_getPriorityToJsonLocal(priority!);
    json['done']=_getValueToJsonLocal(done!);
    json['notify']=_getValueToJsonLocal(notify!);
    return json;
  }

  factory TaskModel.fromJsonLocal(Map<String, dynamic> json) {
    return TaskModel(
      title: json['title'] as String?,
      desc: json['desc'] as String?,
      dateTime: DateTime.parse(json['dateTime'] as String),
      priority: _getPriorityFromJsonLocal(json['priority']),
      notify: _getValueFromJsonLocal(json['notify'] as int),
      done:  _getValueFromJsonLocal(json['done'] as int),
      user: null,
    );
  }

  @override
  List<Object?> get props => [id,title,desc,dateTime,priority,user];

  //Pour une mise à jour fléxible
  TaskModel copyWith({
    String? id,
    String? title,
    String? desc,
    DateTime? dateTime,
    HourFormat? hour,
    TaskPriority? priority,
    UserModel? user,
    bool? done,
    bool? notify,
    bool? favorite
  }) {
    return TaskModel(
      id: id ?? this.id,
      title: title ?? this.title,
      desc: desc ?? this.desc,
      dateTime: dateTime ?? this.dateTime,
      priority: priority ?? this.priority,
      user: user ?? this.user,
      notify: notify ?? this.notify,
      done: done ?? this.done,
      favorite: favorite ??this.favorite,
      updatedAt: updatedAt ?? updatedAt
    );
  }


  String _getPriorityToJsonLocal(TaskPriority priority){
    switch (priority){
      case TaskPriority.high:
        return TaskPriority.high.name;
      case TaskPriority.medium:
        return TaskPriority.medium.name;
      default:
        return TaskPriority.low.name;
    }
  }

  static TaskPriority  _getPriorityFromJsonLocal(String priority) {
    switch (priority) {
      case 'high':
        return TaskPriority.high;
      case 'medium':
        return TaskPriority.medium;
      default:
        return TaskPriority.low;
    }
  }

  int _getValueToJsonLocal(bool val){
    return val ? 1 : 0;
  }

  static bool _getValueFromJsonLocal(int val){
    return val==1 ? true : false;
  }

}