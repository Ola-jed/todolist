import 'package:flutter/material.dart';
import 'package:todolist/api/auth_service.dart';
import 'package:todolist/api/token_handler.dart';

/// Our bottom menu bar
class BottomMenuBar extends StatelessWidget {
  static const int _HOME_INDEX = 0;
  static const int _ACCOUNT_INDEX = 1;
  static const int _ABOUT_INDEX = 2;
  static const int _LOGOUT_INDEX = 3;

  final int currentIndex;

  const BottomMenuBar({Key? key, required this.currentIndex}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      currentIndex: currentIndex,
      items: <BottomNavigationBarItem>[
        const BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: 'Home',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle),
          label: 'Account',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.help),
          label: 'About',
        ),
        const BottomNavigationBarItem(
          icon: const Icon(Icons.logout),
          label: 'Logout',
        ),
      ],
      onTap: (int index) async {
        if (index == currentIndex) {
          return;
        }
        switch (index) {
          case _HOME_INDEX:
            {
              Navigator.pushNamed(context, '/');
              break;
            }
          case _ACCOUNT_INDEX:
            {
              Navigator.pushNamed(context, '/account');
              break;
            }
          case _ABOUT_INDEX:
            {
              showAboutDialog(
                context: context,
                applicationName: 'Todolist',
                applicationVersion: '1.0',
                applicationIcon: const Image(
                  image: AssetImage('assets/icon.png'),
                ),
              );
              break;
            }
          case _LOGOUT_INDEX:
            {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text('Logout ?'),
                    content: const Text('Do you really want to logout ?'),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final hasLogout =
                              await AuthService().makeLogout(await getToken());
                          if (!hasLogout) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return const AlertDialog(
                                  title: const Text('Logout'),
                                  content: const Text('Could not logout'),
                                );
                              },
                            );
                          } else {
                            Navigator.of(context).pushNamedAndRemoveUntil(
                              '/signin',
                              (Route<dynamic> route) => false,
                            );
                          }
                        },
                        child: const Text('Yes'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: const Text('No'),
                      ),
                    ],
                  );
                },
              );
              break;
            }
        }
      },
    );
  }
}
