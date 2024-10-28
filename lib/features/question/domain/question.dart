import 'package:freezed_annotation/freezed_annotation.dart';

part 'question.freezed.dart';
part 'question.g.dart';

@freezed
class Question with _$Question {
  const factory Question({
    required String id,
    required String question,
    required List<String> choices,
    required int answer
  }) = _Question;

  factory Question.fromJson(Map<String, dynamic> json) => _$QuestionFromJson(json);

  factory Question.fromFirebase(Map<String, dynamic> json, String documentId) {
    return Question(
      id: documentId,
      question: json['question'] as String,
      choices: List<String>.from(json['choices'] as List),
      answer: json['answer'] as int
    );
  }
}
