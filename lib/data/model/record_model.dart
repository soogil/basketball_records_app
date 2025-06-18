import 'package:freezed_annotation/freezed_annotation.dart';

part 'record_model.freezed.dart';
part 'record_model.g.dart';

@freezed
@JsonSerializable()
class RecordModel with _$RecordModel {
  RecordModel({
    required this.date,
    required this.attendance,
    required this.score,
    required this.win,
    required this.games,
  });

  @override
  final String date;
  @override
  final bool attendance;
  @override
  final int score;
  @override
  final int win;
  @override
  final int games;

  factory RecordModel.fromJson(Map<String, dynamic> json) => _$RecordModelFromJson(json);

  Map<String, Object?> toJson() => _$RecordModelToJson(this);
}