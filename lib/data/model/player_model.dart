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
    required this.totalAttendanceScore,
    required this.wins,
    required this.seasonAppearances,
    required this.seasonWins,
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
  final int wins;
  @override
  final int seasonAppearances;
  @override
  final int totalAttendanceScore;
  @override
  final double seasonWins;

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
        totalAttendanceScore: json['totalAttendanceScore'] as int,
        wins: json['wins'] as int,
        seasonWins: (json['seasonWins'] as num).toDouble(),
        seasonAppearances: json['seasonAppearances'] as int,
      );
}

extension PlayerModelPresentation on PlayerModel {
  String valueByColumn(PlayerColumn column) {
    switch (column) {
      case PlayerColumn.name:
        return name;
      case PlayerColumn.wins:
        return '$wins점';
      case PlayerColumn.totalAttendanceScore:
        return '$totalAttendanceScore점';
      case PlayerColumn.totalScore:
        return '$totalScore점';
      case PlayerColumn.appearances:
        return '$appearances점';
      case PlayerColumn.winRate:
        return seasonAppearances == 0
            ? '0%'
            : '${((seasonWins / seasonAppearances) * 100).toStringAsFixed(0)}%';
    }
  }

  double get winRate =>
      seasonAppearances == 0
          ? 0
          : (seasonWins/seasonAppearances) * 100;
}

extension PlayerColumnExtension on PlayerColumn {
  String get label {
    switch (this) {
      case PlayerColumn.name: return '이름';
      case PlayerColumn.wins: return '승점';
      case PlayerColumn.totalAttendanceScore: return '24년~25년\n누적 합계';
      case PlayerColumn.totalScore: return '총점';
      case PlayerColumn.appearances: return '출석 점수';
      case PlayerColumn.winRate: return '승률';
    }
  }
}

enum PlayerColumn {
  name,
  totalScore,
  appearances,
  wins,
  winRate,
  totalAttendanceScore,
}