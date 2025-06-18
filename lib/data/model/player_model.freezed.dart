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
  int get attendanceScore;
  int get wins;
  double get winRate;

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
            (identical(other.attendanceScore, attendanceScore) ||
                other.attendanceScore == attendanceScore) &&
            (identical(other.wins, wins) || other.wins == wins) &&
            (identical(other.winRate, winRate) || other.winRate == winRate));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, totalScore,
      appearances, attendanceScore, wins, winRate);

  @override
  String toString() {
    return 'PlayerModel(id: $id, name: $name, totalScore: $totalScore, appearances: $appearances, attendanceScore: $attendanceScore, wins: $wins, winRate: $winRate)';
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
      int attendanceScore,
      int wins,
      double winRate});
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
    Object? attendanceScore = null,
    Object? wins = null,
    Object? winRate = null,
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
      attendanceScore: null == attendanceScore
          ? _self.attendanceScore
          : attendanceScore // ignore: cast_nullable_to_non_nullable
              as int,
      wins: null == wins
          ? _self.wins
          : wins // ignore: cast_nullable_to_non_nullable
              as int,
      winRate: null == winRate
          ? _self.winRate
          : winRate // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
