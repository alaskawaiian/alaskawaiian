import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../keys.dart';
import 'tab_item.dart';

@immutable
class CupertinoHomeScaffold extends StatelessWidget {
  const CupertinoHomeScaffold({
    Key? key,
    required this.currentTab,
    required this.onSelectTab,
    required this.widgetBuilders,
    required this.navigatorKeys,
  }) : super(key: key);

  final TabItem currentTab;
  final ValueChanged<TabItem> onSelectTab;
  final Map<TabItem, WidgetBuilder> widgetBuilders;
  final Map<TabItem, GlobalKey<NavigatorState>> navigatorKeys;

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      tabBar: CupertinoTabBar(
        key: const Key(Keys.tabBar),
        currentIndex: currentTab.index,
        items: [
          _buildItem(TabItem.questions),
          _buildItem(TabItem.tiers),
          _buildItem(TabItem.account),
        ],
        onTap: (index) => onSelectTab(TabItem.values[index]),
        activeColor: Colors.indigo,
      ),
      tabBuilder: (context, index) {
        final item = TabItem.values[index];
        return CupertinoTabView(
          navigatorKey: navigatorKeys[item],
          builder: (context) => widgetBuilders[item]!(context)
        );
      },
    );
  }

  BottomNavigationBarItem _buildItem(TabItem tabItem) {
    final itemData = TabItemData.allTabs[tabItem]!;
    return BottomNavigationBarItem(
      icon: Icon(itemData.icon),
      label: itemData.title,
    );
  }
}
