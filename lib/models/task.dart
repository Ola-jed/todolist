import 'package:todolist/models/serializable.dart';

/// Tasks of our application
class Task extends Serializable {
  String title;
  String slug;
  bool hasSteps;
  String description;
  DateTime dateLimit;
  int priority;
  bool isFinished;

  Task(this.title, this.slug, this.hasSteps, this.description, this.dateLimit,
      this.priority, [this.isFinished = false]);

  @override
  Task.fromJson(Map<String, dynamic> json)
      : title = json['title'] as String,
        slug = json['slug'] as String,
        hasSteps = json['has_steps'] as bool,
        description = json['description'] as String,
        dateLimit = DateTime.parse(json['date_limit']),
        priority = json['priority'] as int,
        isFinished = json['is_finished'] as bool;

  /// Custom formatting because i want to limit dependencies
  @override
  Map<String, dynamic> toJson() => {
        'title': title,
        'description': description,
        'has_steps': hasSteps,
        'date_limit': '${dateLimit.year}-${dateLimit.month}-${dateLimit.day}',
        'priority': priority
      };
}
