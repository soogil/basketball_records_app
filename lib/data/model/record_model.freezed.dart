// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'record_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecordModel {
  String get date;
  bool get attendance;
  int get score;
  int get win;
  int get games;

  /// Create a copy of RecordModel
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecordModelCopyWith<RecordModel> get copyWith =>
      _$RecordModelCopyWithImpl<RecordModel>(this as RecordModel, _$identity);

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecordModel &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.attendance, attendance) ||
                other.attendance == attendance) &&
            (identical(other.score, score) || other.score == score) &&
            (identical(other.win, win) || other.win == win) &&
            (identical(other.games, games) || other.games == games));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, date, attendance, score, win, games);

  @override
  String toString() {
    return 'RecordModel(date: $date, attendance: $attendance, score: $score, win: $win, games: $games)';
  }
}

/// @nodoc
abstract mixin class $RecordModelCopyWith<$Res> {
  factory $RecordModelCopyWith(
          RecordModel value, $Res Function(RecordModel) _then) =
      _$RecordModelCopyWithImpl;
  @useResult
  $Res call({String date, bool attendance, int score, int win, int games});
}

/// @nodoc
class _$RecordModelCopyWithImpl<$Res> implements $RecordModelCopyWith<$Res> {
  _$RecordModelCopyWithImpl(this._self, this._then);

  final RecordModel _self;
  final $Res Function(RecordModel) _then;

  /// Create a copy of RecordModel
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? date = null,
    Object? attendance = null,
    Object? score = null,
    Object? win = null,
    Object? games = null,
  }) {
    return _then(RecordModel(
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      attendance: null == attendance
          ? _self.attendance
          : attendance // ignore: cast_nullable_to_non_nullable
              as bool,
      score: null == score
          ? _self.score
          : score // ignore: cast_nullable_to_non_nullable
              as int,
      win: null == win
          ? _self.win
          : win // ignore: cast_nullable_to_non_nullable
              as int,
      games: null == games
          ? _self.games
          : games // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
