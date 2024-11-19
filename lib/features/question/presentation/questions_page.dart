import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../user/domain/user.dart';
import '../../user/data/user_database_provider.dart';
import '../data/question_database_providers.dart';
import '../domain/question.dart';
import '/features/custom_colors.dart';

class QuestionsPage extends ConsumerStatefulWidget {
  @override
  ConsumerState<QuestionsPage> createState() => _QuestionsPageState();
}

class _QuestionsPageState extends ConsumerState<QuestionsPage> {
  @override
  Widget build(BuildContext context) {
    final userDatabase = ref.watch(userDatabaseProvider)!;
    final AsyncValue<User> user = ref.watch(userStreamProvider);
    final AsyncValue<Question> question = ref.watch(randomQuestionProvider);

    Future<void> answerQuestion(int index) async {
      if (question.requireValue.answer == index) {
        await userDatabase.addMiles(1);
        await userDatabase.incrementStreak();
      } else {
        await userDatabase.resetStreak();
      }
      await userDatabase.updateLastAnsweredAt();

      await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            surfaceTintColor: Colors.white,
            title: Text(question.requireValue.answer == index ? 'Correct!' : 'Incorrect'),
            content: Text(question.requireValue.answer == index
                ? 'You answered correctly and earned 1 mile!'
                : 'Oops, that was not the right answer. The correct answer is "${question.requireValue.choices[question.requireValue.answer]}"'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text('OK'),
              ),
            ],
          );
        },
      );
    }

    return question.when(
      data: (question) {
        return Scaffold(
          body: Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [hawaiianPink, alaskaBlue],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.2),
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
                      'Current Streak: ${user.requireValue.streak} days',
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
                    Card(
                      color: Colors.white,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.0),
                      ),
                      elevation: 4.0,
                      child: Container(
                        padding: const EdgeInsets.all(16.0),
                        height: 630,
                        width: double.infinity,
                        child:
                        user.requireValue.hasAnswered() ?
                          Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'You have already answered today\'s question!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 25.0, color: Colors.black),
                                ),
                                SizedBox(height: 20.0),
                                Text(
                                  'Come back tomorrow for a new question!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontSize: 16.0, color: Colors.black87),
                                ),
                              ],
                            ),
                          ) :
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                question.question,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                  fontFamily: 'Jomolhari',
                                  color: Colors.black,
                                ),
                              ),
                              const SizedBox(height: 20.0),

                              Expanded(
                                child: GridView.builder(
                                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    childAspectRatio: 1,
                                    crossAxisSpacing: 10.0,
                                    mainAxisSpacing: 10.0,
                                  ),
                                  itemCount: 4,
                                  itemBuilder: (context, index) {
                                    return Card(
                                      color: Colors.grey[200],
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12.0),
                                      ),
                                      elevation: 3.0,
                                      child: InkWell(
                                        onTap: () {
                                          answerQuestion(index);
                                        },
                                        child: Center(
                                          child: Text(
                                            question.choices[index],
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 15.0,
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
      },
      loading: () => CircularProgressIndicator(),
      error: (error, stack) => Text('Oops, something unexpected happened')
    );
  }
}
