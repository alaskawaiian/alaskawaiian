/// Defines the domain model path strings for [FirestoreService].
class FirestorePath {
  static String user(String uid) => 'users/$uid';
  static String question(String questionId) => 'questions/$questionId';
  static String questions() => 'questions';
  static String job(String uid, String jobId) => 'users/$uid/jobs/$jobId';
  static String jobs(String uid) => 'users/$uid/jobs';
  static String entry(String uid, String entryId) =>
      'users/$uid/entries/$entryId';
  static String entries(String uid) => 'users/$uid/entries';
}
