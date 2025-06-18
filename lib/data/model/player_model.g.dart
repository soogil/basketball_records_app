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
      attendanceScore: (json['attendanceScore'] as num).toInt(),
      wins: (json['wins'] as num).toInt(),
      winRate: (json['winRate'] as num).toDouble(),
    );

Map<String, dynamic> _$PlayerModelToJson(PlayerModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'totalScore': instance.totalScore,
      'appearances': instance.appearances,
      'attendanceScore': instance.attendanceScore,
      'wins': instance.wins,
      'winRate': instance.winRate,
    };
