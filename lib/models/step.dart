import 'package:todolist/models/serializable.dart';

/// Steps : task portions
class Step extends Serializable {
  String title;
  int priority;
  bool isFinished = false;

  Step(this.title, this.priority);

  @override
  Step.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        priority = json['priority'] as int,
        isFinished = json['is_finished'] as bool;

  @override
  Map<String, dynamic> toJson() => {'title': title, 'priority': priority};
}