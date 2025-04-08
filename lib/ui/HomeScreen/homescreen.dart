import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shootbook/ui/HomeScreen/Tabs/Options/options.dart';

import 'Tabs/Result/results.dart';
import 'Tabs/Scanner/scanner.dart';

class TabIndex {
  static const int scanner = 0;
  static const int results = 1;
  static const int options = 2;
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<StatefulWidget> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late CupertinoTabController _tabController;

  @override
  void initState() {
    super.initState();
    // Create TabController for getting the index of current tab
    _tabController = CupertinoTabController(initialIndex: 1);
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
        controller: _tabController,
        tabBar: CupertinoTabBar(backgroundColor: Color.fromRGBO(20, 20, 26, 1.0), items: [
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.qrcode_viewfinder)),
          BottomNavigationBarItem(icon: Icon(CupertinoIcons.scope)),
          BottomNavigationBarItem(icon: Icon(Icons.settings))
        ]),
        tabBuilder: (BuildContext context, int index) {
          return CupertinoTabView(builder: (BuildContext context) {
            return Padding(
                padding: index == 0
                    ? EdgeInsets.zero
                    : const EdgeInsets.fromLTRB(5, 50, 5, 0),
                child: _buildTabs(index));
          });
        });
  }

  Widget _buildTabs(int index) {
    switch (index) {
      case TabIndex.scanner:
        return Scanner(tabController: _tabController, myIndex: index);

      case TabIndex.options:
        return Options(tabController: _tabController, myIndex: index);

      default:
        return Results(tabController: _tabController, myIndex: index);
    }
  }
}
