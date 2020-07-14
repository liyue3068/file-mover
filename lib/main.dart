import 'package:file_mover/index-page.dart';
import 'package:file_mover/settings-page.dart';
import 'package:file_mover/state/settings-state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MainWidget extends StatelessWidget {
  static const String _title = '文件传输器';
  @override
  Widget build(BuildContext context) {
    return HomeWidget();
  }
}

class HomeWidget extends StatefulWidget {
  @override
  _HomeWidgetState createState() => _HomeWidgetState();
}

class _HomeWidgetState extends State<HomeWidget> {
  int _currentSelectedPageIndex = 0;

  @override
  Widget build(BuildContext context) {
    print('build _HomeWidgetState');
    return MaterialApp(
      home: CustomTabBar(),
    );
  }
}

class CustomTabBar extends StatefulWidget {
  @override
  _CustomTabBarState createState() => _CustomTabBarState();
}

class _CustomTabBarState extends State<CustomTabBar>
    with SingleTickerProviderStateMixin {
  int _currentSelectedPageIndex = 0;
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.addListener(() {
      if (_currentSelectedPageIndex == _tabController.index) return;
      setState(() {
        _currentSelectedPageIndex = _tabController.index;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('2333'),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text('首页'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            title: Text('设置'),
          )
        ],
        onTap: (value) {
          if (value == _currentSelectedPageIndex) return;
          setState(() {
            _currentSelectedPageIndex = value;
          });
          _tabController.animateTo(value);
        },
        currentIndex: _currentSelectedPageIndex,
      ),
      body: TabBarView(
        children: [
          IndexPage(),
          SettingsPage(),
        ],
        controller: _tabController,
      ),
    );
  }
}

void main() {
  runApp(new MultiProvider(
    providers: [
      Provider(
        create: (_) => CustomTabBarState(),
      ),
      ListenableProvider(
        create: (context) {
          print('Created SettingsState');
          var settingsState = SettingsState();
          settingsState.Load();
          return settingsState;
        },
      ),
    ],
    child: MainWidget(),
  ));
}

class CustomTabBarState extends ChangeNotifier {}
