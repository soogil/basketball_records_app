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
  final int attendance;
  @override
  final int score;
  @override
  final int win;
  @override
  final int games;

  factory RecordModel.fromJson(Map<String, dynamic> json) => _$RecordModelFromJson(json);

  Map<String, Object?> toJson() => _$RecordModelToJson(this);
}

extension RecordModelPresentation on RecordModel {
  String valueByColumn(PlayerRecordColumn column) {
    switch (column) {
      case PlayerRecordColumn.date:
        return date;
      case PlayerRecordColumn.attendance:
        return '$attendance점';
      case PlayerRecordColumn.games:
        return '$games경기';
      case PlayerRecordColumn.win:
        return '$win경기';
      case PlayerRecordColumn.score:
        return '$score점';
    }
  }
}

extension PlayerRecordColumnExtension on PlayerRecordColumn {
  String get label {
    switch (this) {
      case PlayerRecordColumn.date: return '날짜';
      case PlayerRecordColumn.attendance: return '출석 점수';
      case PlayerRecordColumn.games: return '경기 수';
      case PlayerRecordColumn.win: return '승리';
      case PlayerRecordColumn.score: return '승점';
    }
  }
}


enum PlayerRecordColumn {
  date,
  attendance,
  games,
  win,
  score,
}