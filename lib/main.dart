import 'package:file_mover/connection-test.page.dart';
import 'package:file_mover/index-page.dart';
import 'package:file_mover/server-config.widget.dart';
import 'package:file_mover/settings-page.dart';
import 'package:file_mover/state/settings-state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuple/tuple.dart';

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

  List<Tuple3<String, Widget, IconData>> _pages;
  _CustomTabBarState() {
    _pages = [
      Tuple3<String, Widget, IconData>('首页', IndexPage(), Icons.home),
      Tuple3<String, Widget, IconData>(
          '连接测试', ConnectionTestPage(), Icons.network_wifi),
      Tuple3<String, Widget, IconData>('配置', SettingsPage(), Icons.settings),
    ];
  }

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _pages.length, vsync: this);
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
        items: _pages
            .map(
              (e) => BottomNavigationBarItem(
                icon: Icon(e.item3),
                title: Text(e.item1),
              ),
            )
            .toList(),
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
        children: _pages
            .map(
              (e) => e.item2,
            )
            .toList(),
        controller: _tabController,
      ),
    );
  }
}

void main() {
  runApp(new MultiProvider(
    providers: [
      ListenableProvider(
        create: (context) {
          print('Created SettingsState');
          var settingsState = SettingsState();
          settingsState.Load();
          return settingsState;
        },
      ),
      FutureProvider<StateNetworkInfo>(
        create: (context) {
          var result = StateNetworkInfo();
          return result.init();
        },
      ),
    ],
    child: MainWidget(),
  ));
}
