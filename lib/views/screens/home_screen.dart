import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:todolist/api/auth_service.dart';
import 'package:todolist/views/ui/tasks_list.dart';

/// All actions of our menu
class Actions{
  static const String AllTasks = 'All tasks';
  static const String FinishedTasks = 'Finished tasks';
  static const String UnfinishedTasks = 'Unfinished tasks';
  static const String ExpiredTasks = 'Expired tasks';
  static const String Signin = 'Signin';
  static const String Logout = 'Logout';
  static const List<String> choices = <String>[
    AllTasks,
    FinishedTasks,
    UnfinishedTasks,
    ExpiredTasks,
    Signin,
    Logout
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
      case 'All tasks' : {
        setState(() {
          taskFillType = TasksFillType.All;
        });
        break;
      }
      case 'Finished tasks': {
        setState(() {
          taskFillType = TasksFillType.Finished;
        });
        break;
      }
      case 'Unfinished tasks': {
        setState(() {
          taskFillType = TasksFillType.Unfinished;
        });
        break;
      }
      case 'Expired tasks': {
        setState(() {
          taskFillType = TasksFillType.Expired;
        });
        break;
      }
      case 'Signin': {
        Navigator.pushNamed(context, '/signin');
        break;
      }
      case 'Logout': {
        var preferences = await SharedPreferences.getInstance();
        var hasLogout = preferences.containsKey('token')
          ? await AuthService().makeLogout(preferences.getString('token')!)
          : false;
        if(!hasLogout){
          showDialog(
            context: context,
            builder:(context) {
              return const AlertDialog(
                title: const Text('Logout'),
                content: const Text('Could not logout')
              );
            }
          );
        }
        else{
          Navigator.pushNamed(context, '/signin');
        }
        break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Material(
          color: Colors.transparent,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Expanded(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      searchContent = value;
                      taskFillType = TasksFillType.Search;
                      print(searchContent);
                    });
                  }
                )
              ),
              Icon(
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
      body: TasksList(tasksFillType: taskFillType,searchContent: searchContent),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // TODO : show task form
        },
        backgroundColor: Colors.teal,
        child: const Icon(Icons.add)
      )
    );
  }
}
