// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'player_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PlayerModel {
  String get id;
  String get name;
  int get totalScore;
  int get appearances;
  int get wins;
  int get seasonAppearances;
  int get totalAttendanceScore;
  double get seasonWins;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $PlayerModelCopyWith<PlayerModel> get copyWith =>
      _$PlayerModelCopyWithImpl<PlayerModel>(this as PlayerModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PlayerModel &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.totalScore, totalScore) ||
                other.totalScore == totalScore) &&
            (identical(other.appearances, appearances) ||
                other.appearances == appearances) &&
            (identical(other.wins, wins) || other.wins == wins) &&
            (identical(other.seasonAppearances, seasonAppearances) ||
                other.seasonAppearances == seasonAppearances) &&
            (identical(other.totalAttendanceScore, totalAttendanceScore) ||
                other.totalAttendanceScore == totalAttendanceScore) &&
            (identical(other.seasonWins, seasonWins) ||
                other.seasonWins == seasonWins));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, totalScore,
      appearances, wins, seasonAppearances, totalAttendanceScore, seasonWins);

  @override
  String toString() {
    return 'PlayerModel(id: $id, name: $name, totalScore: $totalScore, appearances: $appearances, wins: $wins, seasonAppearances: $seasonAppearances, totalAttendanceScore: $totalAttendanceScore, seasonWins: $seasonWins)';
  }
}

/// @nodoc
abstract mixin class $PlayerModelCopyWith<$Res> {
  factory $PlayerModelCopyWith(
          PlayerModel value, $Res Function(PlayerModel) _then) =
      _$PlayerModelCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String name,
      int totalScore,
      int appearances,
      int totalAttendanceScore,
      int wins,
      int seasonAppearances,
      double seasonWins});
}

/// @nodoc
class _$PlayerModelCopyWithImpl<$Res> implements $PlayerModelCopyWith<$Res> {
  _$PlayerModelCopyWithImpl(this._self, this._then);

  final PlayerModel _self;
  final $Res Function(PlayerModel) _then;

  /// Create a copy of PlayerModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? totalScore = null,
    Object? appearances = null,
    Object? totalAttendanceScore = null,
    Object? wins = null,
    Object? seasonAppearances = null,
    Object? seasonWins = null,
  }) {
    return _then(PlayerModel(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      totalScore: null == totalScore
          ? _self.totalScore
          : totalScore // ignore: cast_nullable_to_non_nullable
              as int,
      appearances: null == appearances
          ? _self.appearances
          : appearances // ignore: cast_nullable_to_non_nullable
              as int,
      totalAttendanceScore: null == totalAttendanceScore
          ? _self.totalAttendanceScore
          : totalAttendanceScore // ignore: cast_nullable_to_non_nullable
              as int,
      wins: null == wins
          ? _self.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      seasonAppearances: null == seasonAppearances
          ? _self.seasonAppearances
          : seasonAppearances // ignore: cast_nullable_to_non_nullable
              as int,
      seasonWins: null == seasonWins
          ? _self.seasonWins
          : seasonWins // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
