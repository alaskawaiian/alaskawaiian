import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/features/tiers/presentation/tiers.dart';

import '../../account/presentation/account_page.dart';
import '../../question/presentation/questions_page.dart';
import 'cupertino_home_scaffold.dart';
import 'tab_item.dart';

/// Builds a [CupertinoHomeScaffold] that provides a page with three tabs at
/// the bottom for Jobs, Entries, and Account, and displays the appropriate
/// page depending upon which tab has been pressed.
/// Uses [WillPopScope] to disable the back button.
class HomePage extends StatefulWidget {
  static const routeName = '/home-page';
  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  TabItem _currentTab = TabItem.questions;

  final Map<TabItem,  GlobalKey<NavigatorState>> navigatorKeys = {
    TabItem.questions: GlobalKey<NavigatorState>(),
    TabItem.account: GlobalKey<NavigatorState>(),
    TabItem.tiers: GlobalKey<NavigatorState>(),
  };

  Map<TabItem, WidgetBuilder> get widgetBuilders {
    return {
      TabItem.questions: (_) => QuestionsPage(),
      TabItem.account: (_) => AccountPage(),
      TabItem.tiers: (_) => Tiers(),
    };
  }

  void select(TabItem tabItem) {
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
        onSelectTab: select,
        widgetBuilders: widgetBuilders,
        navigatorKeys: navigatorKeys,
      ),
    );
  }
}
