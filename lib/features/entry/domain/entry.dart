import 'package:freezed_annotation/freezed_annotation.dart';

part 'entry.freezed.dart';
part 'entry.g.dart';

@freezed
class Entry with _$Entry {
  const factory Entry({
    required String id,
    required String jobId,
    required DateTime start,
    required DateTime end,
    required String comment,
  }) = _Entry;

  const Entry._();

  factory Entry.fromJson(Map<String, Object?> json) => _$EntryFromJson(json);

  factory Entry.fromFirestore(Map<String, dynamic> json, String documentId) {
    final startMilliseconds = json['start'] as int;
    final endMilliseconds = json['end'] as int;
    return Entry(
      id: documentId,
      jobId: json['jobId'] as String,
      start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
      end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
      comment: json['comment'] as String? ?? '',
    );
  }

  Map<String, dynamic> toFirestore() => {
        'jobId': jobId,
        'start': start.millisecondsSinceEpoch,
        'end': end.millisecondsSinceEpoch,
        'comment': comment,
      };

  double get durationInHours =>
      end.difference(start).inMinutes.toDouble() / 60.0;
}

// THIS IS THE ORIGINAL CODE
// import 'package:equatable/equatable.dart';
//
// /// Implements (a mutable?) Entry document.
// class Entry extends Equatable {
//   const Entry({
//     required this.id,
//     required this.jobId,
//     required this.start,
//     required this.end,
//     required this.comment,
//   });
//
//   final String id;
//   final String jobId;
//   final DateTime start;
//   final DateTime end;
//   final String comment;
//
//   @override
//   List<Object> get props => [id, jobId, start, end, comment];
//
//   @override
//   bool get stringify => true;
//
//   double get durationInHours =>
//       end.difference(start).inMinutes.toDouble() / 60.0;
//
//   factory Entry.fromMap(Map<dynamic, dynamic>? value, String id) {
//     if (value == null) {
//       throw StateError('missing data for entryId: $id');
//     }
//     final startMilliseconds = value['start'] as int;
//     final endMilliseconds = value['end'] as int;
//     return Entry(
//       id: id,
//       jobId: value['jobId'] as String,
//       start: DateTime.fromMillisecondsSinceEpoch(startMilliseconds),
//       end: DateTime.fromMillisecondsSinceEpoch(endMilliseconds),
//       comment: value['comment'] as String? ?? '',
//     );
//   }
//
//   Map<String, dynamic> toMap() {
//     return <String, dynamic>{
//       'jobId': jobId,
//       'start': start.millisecondsSinceEpoch,
//       'end': end.millisecondsSinceEpoch,
//       'comment': comment,
//     };
//   }
// }
