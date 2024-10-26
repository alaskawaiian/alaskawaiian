import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

DateTime? _lastAnsweredAtFromJson(Timestamp? timestamp) => timestamp?.toDate();

@freezed
class User with _$User {
  const factory User({
    required String id,
    required int miles,
    required int streak,
    @JsonKey(name: 'lastAnsweredAt', fromJson: _lastAnsweredAtFromJson) DateTime? lastAnsweredAt
  }) = _User;

  const User._();

  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);

  factory User.fromFirebase(Map<String, dynamic> json, String documentId) =>
    _$UserFromJson({"id": documentId, ...json});


  bool hasAnswered() {
    if (lastAnsweredAt == null) return false;

    DateTime now = DateTime.now();
    DateTime currentDateAtMidnight = DateTime(now.year, now.month, now.day);
    
    return lastAnsweredAt!.isAfter(currentDateAtMidnight);
  }
}
