import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../job/data/job_database_providers.dart';
import '../../job/presentation/list_items_builder.dart';
import '../../strings.dart';
import '../data/entry_database_providers.dart';
import 'entries_list_tile.dart';
import 'entries_view_model.dart';

final entriesTileModelStreamProvider =
StreamProvider.autoDispose<List<EntriesListTileModel>>(
      (ref) {
    final entryDatabase = ref.watch(entryDatabaseProvider)!;
    final jobDatabase = ref.watch(jobDatabaseProvider)!;
    final vm = EntriesViewModel(
        entryDatabase: entryDatabase, jobDatabase: jobDatabase);
    return vm.entriesTileModelStream;
  },
);

class EntriesPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entriesTileModelStream = ref.watch(entriesTileModelStreamProvider);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[900]!, Colors.black],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned(
            top: 45.0,
            left: 20.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Daily Questions',
                  style: TextStyle(
                    fontSize: 28.0,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Jomolhari',
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'Current Streak: 5 days',
                  style: TextStyle(
                    fontSize: 18.0,
                    color: Colors.white70,
                    fontFamily: 'Jomolhari',
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Card containing the question and answer options
                Card(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(horizontal: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  elevation: 4.0,
                  child: Container(
                    padding: const EdgeInsets.all(16.0),
                    height: 625,
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // Question Text
                        Text(
                          'Electric lights, illuminated for King Kalakaua’s birthday Jubilee in Nov 1886, '
                              'were introduced at Iolani Palace how many years before electricity '
                              'was installed at the White House?',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            fontWeight: FontWeight.w300,
                            fontFamily: 'Jomolhari',
                            color: Colors.black,
                          ),
                        ),
                        const SizedBox(height: 20.0),

                        Expanded(
                          child: GridView.builder(
                            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,  // 2 columns
                              childAspectRatio: 1,  // Makes the grid square
                              crossAxisSpacing: 10.0,  // Horizontal space between cards
                              mainAxisSpacing: 10.0,   // Vertical space between cards
                            ),
                            itemCount: 4,
                            itemBuilder: (context, index) {
                              return Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                                elevation: 3.0,
                                child: InkWell(
                                  onTap: () {
                                    // Handle option selection
                                  },
                                  child: Center(
                                    child: Text(
                                      'Option ${index + 1}',
                                      style: TextStyle(
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ]
      ),
    );
  }
}

