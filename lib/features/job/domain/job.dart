import 'package:freezed_annotation/freezed_annotation.dart';

part 'job.freezed.dart';
part 'job.g.dart';

@freezed
class Job with _$Job {
  const factory Job({
    required String id,
    required String name,
    required int ratePerHour,
  }) = _Job;
  const Job._();

  factory Job.fromJson(Map<String, Object?> json) => _$JobFromJson(json);

  factory Job.fromFirestore(Map<String, dynamic> json, String documentId) =>
      _$JobFromJson({"id": documentId, ...json});
}

// THIS IS THE ORIGINAL CODE
// /// Implements an immutable Job document.
// @immutable
// class Job extends Equatable {
//   const Job({required this.id, required this.name, required this.ratePerHour});
//   final String id;
//   final String name;
//   final int ratePerHour;
//
//   @override
//   List<Object> get props => [id, name, ratePerHour];
//
//   @override
//   bool get stringify => true;
//
//   factory Job.fromMap(Map<String, dynamic>? data, String documentId) {
//     if (data == null) {
//       throw StateError('missing data for jobId: $documentId');
//     }
//     final name = data['name'] as String?;
//     if (name == null) {
//       throw StateError('missing name for jobId: $documentId');
//     }
//     final ratePerHour = data['ratePerHour'] as int;
//     return Job(id: documentId, name: name, ratePerHour: ratePerHour);
//   }
//
//   Map<String, dynamic> toMap() {
//     return {
//       'name': name,
//       'ratePerHour': ratePerHour,
//     };
//   }
// }
