// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RecordModel _$RecordModelFromJson(Map<String, dynamic> json) => RecordModel(
      date: json['date'] as String,
      attendance: json['attendance'] as bool,
      score: (json['score'] as num).toInt(),
      win: (json['win'] as num).toInt(),
      games: (json['games'] as num).toInt(),
    );

Map<String, dynamic> _$RecordModelToJson(RecordModel instance) =>
    <String, dynamic>{
      'date': instance.date,
      'attendance': instance.attendance,
      'score': instance.score,
      'win': instance.win,
      'games': instance.games,
    };
