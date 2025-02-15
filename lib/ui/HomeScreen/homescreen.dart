import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/options.dart';

import 'Tabs/Result/results.dart';
import 'Tabs/scanner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        tabBar: CupertinoTabBar(items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.qrcode_viewfinder)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.scope)),
          BottomNavigationBarItem(icon: Icon(Icons.settings))
        ]),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(builder: (BuildContext context) {
            return Padding(
                padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
                child: _buildTabs(index));
          });
        });
  }

  Widget _buildTabs(int index) {
    switch (index) {
      case 0:
        return Scanner();
        
      case 2:
        return Options();

      default:
        return Results();

    }
  }
}