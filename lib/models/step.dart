import 'package:todolist/models/serializable.dart';

/// Steps : task portions
class Step extends Serializable {
  int id;
  String title;
  int priority;
  bool isFinished = false;

  Step(this.title, this.priority, [this.isFinished = false, this.id = 0]);

  @override
  Step.fromJson(Map<String, dynamic> json)
      : id = json['id'] as int,
        title = json['title'] as String,
        priority = json['priority'] as int,
        isFinished = json['is_finished'] as bool;

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'priority': priority,
        'is_finished': isFinished,
      };
}
