import 'package:flutter/cupertino.dart';

import 'job/domain/job.dart';
import 'job/presentation/job_entry/job_entries_page.dart';

class CupertinoTabViewRoutes {
  static const jobEntriesPage = '/job-entries-page';
}

/// Routes to the [JobEntriesPage] using a [CupertinoPageRoute].
class CupertinoTabViewRouter {
  static Route? generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case CupertinoTabViewRoutes.jobEntriesPage:
        final job = settings.arguments as Job;
        return CupertinoPageRoute(
          builder: (_) => JobEntriesPage(job: job),
          settings: settings,
          fullscreenDialog: false,
        );
    }
    return null;
  }
}
