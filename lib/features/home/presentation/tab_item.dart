import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/features/keys.dart';
import 'package:starter_architecture_flutter_firebase/features/strings.dart';

enum TabItem {
  explore,
  questions,
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
    TabItem.explore: TabItemData(
      key: Keys.exploreTab,
      title: Strings.explorePage,
      icon: Icons.explore,
    ),
    TabItem.questions: TabItemData(
      key: Keys.questionsTab,
      title: Strings.questions,
      icon: Icons.quiz,
    ),
    TabItem.account: TabItemData(
      key: Keys.accountTab,
      title: Strings.account,
      icon: Icons.person,
    ),
  };
}
