import 'package:flutter/material.dart';
import 'package:todolist/api/auth_service.dart';
import 'package:todolist/api/token_handler.dart';
import 'package:todolist/utils/l10n.dart';

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
        BottomNavigationBarItem(
          icon: const Icon(Icons.home),
          label: $(context).home,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.account_circle),
          label: $(context).account,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.help),
          label: $(context).about,
        ),
        BottomNavigationBarItem(
          icon: const Icon(Icons.logout),
          label: $(context).logout,
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
                builder: (_) {
                  return AlertDialog(
                    title: Text($(context).logout),
                    content: Text($(context).logoutQuestion),
                    actions: [
                      TextButton(
                        onPressed: () async {
                          final hasLogout =
                              await AuthService().makeLogout(await getToken());
                          if (!hasLogout) {
                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text($(context).logout),
                                  content: Text($(context).couldNotLogout),
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
                        child: Text($(context).yes),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true);
                        },
                        child: Text($(context).no),
                      ),
                    ],
                  );
                },
              );
              break;
            }
        }
      },
      selectedItemColor: Theme.of(context).colorScheme.primary,
      selectedFontSize: 16,
      showUnselectedLabels: false,
    );
  }
}
