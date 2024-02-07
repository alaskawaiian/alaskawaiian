import 'package:flutter/material.dart';
import 'package:starter_architecture_flutter_firebase/features/keys.dart';
import 'package:starter_architecture_flutter_firebase/features/strings.dart';

enum TabItem { jobs, entries, account }

/// Implements the key, title, and icon associated with the Jobs, Entrys, and
/// Account pages.
class TabItemData {
  const TabItemData(
      {required this.key, required this.title, required this.icon});

  final String key;
  final String title;
  final IconData icon;

  static const Map<TabItem, TabItemData> allTabs = {
    TabItem.jobs: TabItemData(
      key: Keys.jobsTab,
      title: Strings.jobs,
      icon: Icons.work,
    ),
    TabItem.entries: TabItemData(
      key: Keys.entriesTab,
      title: Strings.entries,
      icon: Icons.view_headline,
    ),
    TabItem.account: TabItemData(
      key: Keys.accountTab,
      title: Strings.account,
      icon: Icons.person,
    ),
  };
}
