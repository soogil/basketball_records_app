import 'package:freezed_annotation/freezed_annotation.dart';

part 'player_model.freezed.dart';
part 'player_model.g.dart';

@freezed
@JsonSerializable()
class PlayerModel with _$PlayerModel {
  PlayerModel({
    required this.id,
    required this.name,
    required this.totalScore,
    required this.appearances,
    required this.attendanceScore,
    required this.wins,
    required this.winRate,
  });

  @override
  final String id;
  @override
  final String name;
  @override
  final int totalScore;
  @override
  final int appearances;
  @override
  final int attendanceScore;
  @override
  final int wins;
  @override
  final double winRate;

  factory PlayerModel.fromJson(Map<String, dynamic> json) => _$PlayerModelFromJson(json);

  Map<String, Object?> toJson() => _$PlayerModelToJson(this);

  factory PlayerModel.fromFireStore(
      String id,
      Map<String, dynamic> json,
      ) =>
      PlayerModel(
        id: id,
        name: json['name'] as String,
        totalScore: json['totalScore'] as int,
        appearances: json['appearances'] as int,
        attendanceScore: json['attendanceScore'] as int,
        wins: json['wins'] as int,
        winRate: (json['winRate'] as num).toDouble(),
      );
}

extension PlayerModelPresentation on PlayerModel {
  String valueByColumn(PlayerColumn column) {
    switch (column) {
      case PlayerColumn.name:
        return name;
      case PlayerColumn.wins:
        return wins.toString();
      case PlayerColumn.attendanceScore:
        return attendanceScore.toString();
      case PlayerColumn.totalScore:
        return totalScore.toString();
      case PlayerColumn.appearances:
        return appearances.toString();
      case PlayerColumn.winRate:
        return '${(winRate * 100).toStringAsFixed(1)}%';
    }
  }
}

extension PlayerColumnExtension on PlayerColumn {
  String get label {
    switch (this) {
      case PlayerColumn.name: return '이름';
      case PlayerColumn.wins: return '승점';
      case PlayerColumn.attendanceScore: return '출석점수';
      case PlayerColumn.totalScore: return '총점';
      case PlayerColumn.appearances: return '출석';
      case PlayerColumn.winRate: return '승률';
    }
  }
}

enum PlayerColumn {
  name,
  wins,
  attendanceScore,
  totalScore,
  appearances,
  winRate,
}