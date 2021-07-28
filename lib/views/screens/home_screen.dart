import 'package:flutter/material.dart';
import 'package:todolist/api/task_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/utils/tasks_csv_export.dart';
import 'package:todolist/views/forms/task_form.dart';
import 'package:todolist/views/ui/bottom_menubar.dart';
import 'package:todolist/views/ui/tasks_list.dart';

/// All actions of our menu
class Actions{
  static const String AllTasks = 'All tasks';
  static const String FinishedTasks = 'Finished tasks';
  static const String UnfinishedTasks = 'Unfinished tasks';
  static const String ExpiredTasks = 'Expired tasks';
  static const String SaveAll = 'Save all';
  static const String Signin = 'Signin';
  static const String About = 'About';
  static const List<String> choices = <String>[
    AllTasks,
    FinishedTasks,
    UnfinishedTasks,
    ExpiredTasks,
    SaveAll,
    Signin,
    About
  ];
}

/// The home screen
/// We have all the tasks and an appbar
/// When an action is triggered, we handle the event
class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var searchContent = '';
  var taskFillType = TasksFillType.All;

  /// Handle the action triggered on the menu
  ///
  /// ### Params
  /// - choice : The menu item chosen
  /// - context : The handler to locate the widget
  Future<void> choiceAction(String choice,BuildContext context) async {
    switch (choice){
      case Actions.AllTasks : {
        setState(() {
          taskFillType = TasksFillType.All;
        });
        break;
      }
      case Actions.FinishedTasks: {
        setState(() {
          taskFillType = TasksFillType.Finished;
        });
        break;
      }
      case Actions.UnfinishedTasks: {
        setState(() {
          taskFillType = TasksFillType.Unfinished;
        });
        break;
      }
      case Actions.ExpiredTasks: {
        setState(() {
          taskFillType = TasksFillType.Expired;
        });
        break;
      }
      case Actions.SaveAll : {
        final token = await getToken();
        final tasks = await TaskService(token).getTasks();
        await saveTasksToCsv(tasks);
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(
            content: const Text(
              'Tasks exported in Android/data/com.ola.todolist/files/todolist.csv'
            )
        ));
        break;
      }
      case Actions.Signin: {
        Navigator.pushNamed(context, '/signin');
        break;
      }
      case Actions.About : {
        showAboutDialog(
          context: context,
          applicationName: 'Todolist',
          applicationVersion: '1.0',
          applicationIcon: const Image(
            image: AssetImage('assets/icon.png')
          )
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        automaticallyImplyLeading: false,
        title: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: TextField(
                  autofocus: false,
                  decoration: const InputDecoration(
                    hintText: 'Home'
                  ),
                  onChanged: (value) {
                    setState(() {
                      searchContent = value;
                      taskFillType = TasksFillType.Search;
                    });
                  }
                )
              ),
              const Icon(
                Icons.search,
                color: Colors.white
              )
            ]
          )
        ),
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: (String val) async {
              await choiceAction(val,context);
            },
            itemBuilder: (BuildContext context){
              return Actions.choices.map((String choice){
                return PopupMenuItem<String>(
                  value: choice,
                  child: Text(choice)
                );
              }).toList();
            }
          )
        ]
      ),
      body: TasksList(
        tasksFillType: taskFillType,
        searchContent: searchContent
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return Scaffold(
                body: TaskForm()
              );
            }
          );
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add)
      ),
      bottomNavigationBar: BottomMenuBar(currentIndex: 0)
    );
  }
}
