import '../../../repositories/firestore/firestore_path.dart';
import '../../../repositories/firestore/firestore_service.dart';
import '../domain/question.dart';

class QuestionDatabase {
  final _service = FirestoreService.instance;

  Future<Question> randomQuestion() =>
    _service.fetchRandomDocument<Question>(
      path: FirestorePath.questions(), 
      builder: (data, documentID) => Question.fromFirebase(data!, documentID)
    );
}
