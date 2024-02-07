import 'package:flutter/material.dart';

import '../../account/presentation/account_page.dart';
import '../../entry/presentation/entries_page.dart';
import '../../job/presentation/jobs_page.dart';
import 'cupertino_home_scaffold.dart';
import 'tab_item.dart';

/// Builds a [CupertinoHomeScaffold] that provides a page with three tabs at
/// the bottom for Jobs, Entries, and Account, and displays the appropriate
/// page depending upon which tab has been pressed.
/// Uses [WillPopScope] to disable the back button.
class HomePage extends StatefulWidget {
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.jobs;

  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.jobs: GlobalKey<NavigatorState>(),
    TabItem.entries: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.jobs: (_) => JobsPage(),
      TabItem.entries: (_) => EntriesPage(),
      TabItem.account: (_) => AccountPage(),
    };
  }

  void _select(TabItem tabItem) {
    if (tabItem == _currentTab) {
      // pop to first route
      navigatorKeys[tabItem]!.currentState?.popUntil((route) => route.isFirst);
    } else {
      setState(() => _currentTab = tabItem);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async =>
          !(await navigatorKeys[_currentTab]!.currentState?.maybePop() ??
              false),
      child: CupertinoHomeScaffold(
        currentTab: _currentTab,
        onSelectTab: _select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
