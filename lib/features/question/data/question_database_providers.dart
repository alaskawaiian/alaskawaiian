import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/question.dart';
import 'question_database.dart';

/// Provides access to a single User's miles, updating it if it changes.
final randomQuestionProvider = FutureProvider.autoDispose<Question>((ref) {
  return QuestionDatabase().randomQuestion();
});