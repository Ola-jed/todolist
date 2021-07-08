import 'package:todolist/models/serializable.dart';

/// Tasks of our application
class Task extends Serializable {
  String title;
  String slug;
  bool hasSteps;
  String description;
  DateTime endDate;
  int priority;
  bool isFinished;

  Task(this.title, this.slug, this.hasSteps, this.description, this.endDate,
      this.priority, this.isFinished);

  @override
  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        slug = json['slug'] as String,
        hasSteps = json['has_steps'] as bool,
        description = json['description'] as String,
        endDate = DateTime.parse(json['end_date']),
        priority = json['priority'] as int,
        isFinished = json['is_finished'] as bool;

  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'has_steps': hasSteps,
        'end_date': endDate.toString(),
        'priority': priority
      };
}
