import 'package:flutter/material.dart';
import '../../keys.dart';
import '../../strings.dart';

enum TabItem {
  questions,
  explore,
  account,
}

/// Implements the key, title, and icon associated with the Jobs, Entrys, and
/// Account pages.
class TabItemData {
  const TabItemData(
      {required this.key, required this.title, required this.icon});

  final String key;
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.questions: TabItemData(
      key: Keys.questionsTab,
      title: Strings.questions,
      icon: Icons.quiz,
    ),
    TabItem.explore: TabItemData(
      key: Keys.exploreTab,
      title: Strings.explorePage,
      icon: Icons.explore,
    ),
    TabItem.account: TabItemData(
      key: Keys.accountTab,
      title: Strings.account,
      icon: Icons.person,
    ),
  };
}
