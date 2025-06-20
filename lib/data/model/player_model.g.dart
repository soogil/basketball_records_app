// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PlayerModel _$PlayerModelFromJson(Map<String, dynamic> json) => PlayerModel(
      id: json['id'] as String,
      name: json['name'] as String,
      totalScore: (json['totalScore'] as num).toInt(),
      appearances: (json['appearances'] as num).toInt(),
      totalAttendanceScore: (json['totalAttendanceScore'] as num).toInt(),
      wins: (json['wins'] as num).toInt(),
      seasonAppearances: (json['seasonAppearances'] as num).toInt(),
      seasonWins: (json['seasonWins'] as num).toDouble(),
    );

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'totalScore': instance.totalScore,
      'appearances': instance.appearances,
      'wins': instance.wins,
      'seasonAppearances': instance.seasonAppearances,
      'totalAttendanceScore': instance.totalAttendanceScore,
      'seasonWins': instance.seasonWins,
    };
