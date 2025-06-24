import 'dart:convert';

import 'dart:html' as html;
import 'package:flutter/foundation.dart';
import 'package:iggys_point/data/model/record_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iggys_point/presentation/view/record_add_page.dart';


final fireStoreApiProvider = Provider<FireStoreApi>((ref) => FireStoreApi());

class FireStoreApi {

  Future uploadPlayersToFireStore() async {
    //backup data
    final playersRef = FirebaseFirestore.instance.collection('playerRecords');
    final snapshot = await playersRef.get();

    Map<String, dynamic> allRecords = {};
    for (final doc in snapshot.docs) {
      allRecords[doc.id] = doc.data();
    }

    String jsonString = jsonEncode(allRecords);

    final bytes = utf8.encode(jsonString);
    final blob = html.Blob([bytes]);
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.AnchorElement(href: url)
      ..setAttribute("download", "players_backup.json")
      ..click();
    html.Url.revokeObjectUrl(url);

    //upload backup Data
    //   final playersJson = await rootBundle.loadString('assets/players_backup.json');
    //   final playerRecordsJson = await rootBundle.loadString('assets/player_records_backup.json');
    //   final players = jsonDecode(playersJson) as Map<String, dynamic>;
    //   final records = jsonDecode(playerRecordsJson) as Map<String, dynamic>;
    //
    //   final firestore = FirebaseFirestore.instance;
    //
    //   // players (id = docId, value = fields)
    //   for (final entry in players.entries) {
    //     final id = entry.key;
    //     final data = entry.value as Map<String, dynamic>;
    //     await firestore.collection('players').doc(id).set(data);
    //   }
    //
    //   // playerRecords (id = docId, value = { records: [...] })
    //   for (final entry in records.entries) {
    //     final id = entry.key;
    //     final data = entry.value as Map<String, dynamic>;
    //     await firestore.collection('playerRecords').doc(id).set(data);
    //   }
    //
    //   print('All players and records imported!');
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getPlayers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('players')
        .get();

    return querySnapshot;
  }

  Future<List> getPlayerRecords(String playerId) async {
    final docSnapshot = await FirebaseFirestore.instance
        .collection('playerRecords')
        .doc(playerId)
        .get();

    if (!docSnapshot.exists) return [];


    final data = docSnapshot.data();
    if (data == null || !data.containsKey('records')) return [];

    return data['records'];
  }

  Future<void> updatePlayerRecords(
      List<PlayerGameInput> playerInputs,
      String recordDate) async {
    final firestore = FirebaseFirestore.instance;
    final batch = firestore.batch();

    for (final playerInput in playerInputs) {
      final playerId = playerInput.playerId;
      final recordRef = firestore.collection('playerRecords').doc(playerId);
      final playerRef = firestore.collection('players').doc(playerId);

      // 1. RecordModel 생성 (각 선수의 해당 날짜 기록)
      final recordModel = RecordModel(
        date: recordDate,
        attendanceScore: playerInput.attendanceScore,
        winScore: playerInput.winScore.toInt(),
        winningGames: playerInput.winGames.toDouble(),
        totalGames: playerInput.totalGames.toInt(),
      );

      // 2. 기존 기록 읽기 (해당 선수)
      final snapshot = await recordRef.get();
      List<dynamic> playerRecords = [];
      if (snapshot.exists && snapshot.data() != null) {
        playerRecords = List.from(snapshot.data()!['records'] ?? []);
      }
      final idx = playerRecords.indexWhere((r) => r['date'] == recordDate);
      if (idx >= 0) {
        playerRecords[idx] = recordModel.toJson();
      } else {
        playerRecords.add(recordModel.toJson());
      }

      // 3. batch로 기록/누적치 갱신 추가
      batch.set(recordRef, {'records': playerRecords});
      batch.update(playerRef, {
        'totalScore': FieldValue.increment(playerInput.attendanceScore + playerInput.winScore),
        'attendanceScore': FieldValue.increment(playerInput.attendanceScore),
        'winScore': FieldValue.increment(playerInput.winScore),
        'seasonTotalWins': FieldValue.increment(playerInput.winGames),
        'seasonTotalGames': FieldValue.increment(playerInput.totalGames),
        'accumulatedScore': FieldValue.increment(playerInput.attendanceScore + playerInput.winScore),
      });
    }

    // 4. batch 커밋: 한 명이라도 실패시 모두 롤백
    try {
      await batch.commit();
    } catch (e) {
      debugPrint('Batch update failed: $e');
      rethrow;
    }
  }

  Future<void> removeRecordFromDate(String targetDate) async {
    final firestore = FirebaseFirestore.instance;
    final playerRecordsRef = firestore.collection('playerRecords');
    final playersRef = firestore.collection('players');

    final snapshot = await playerRecordsRef.get();
    final batch = firestore.batch();

    for (final doc in snapshot.docs) {
      final playerId = doc.id;
      final data = doc.data();
      List<dynamic> records = List.from(data['records'] ?? []);

      // 삭제 대상 기록 추출
      final toRemove = records.where((r) => r['date'] == targetDate).toList();

      // 해당 날짜 기록만 삭제
      records.removeWhere((r) => r['date'] == targetDate);

      // batch로 playerRecords 갱신
      batch.set(doc.reference, {'records': records});

      // 만약 해당 날짜 기록이 존재하면 players의 누적값에서 빼기
      if (toRemove.isNotEmpty) {
        final r = toRemove.first; // 한 날짜에 하나만 있다고 가정
        batch.update(playersRef.doc(playerId), {
          'totalScore': FieldValue.increment(-(r['attendanceScore'] ?? 0) - (r['winScore'] ?? 0)),
          'attendanceScore': FieldValue.increment(-(r['attendanceScore'] ?? 0)),
          'winScore': FieldValue.increment(-(r['winScore'] ?? 0)),
          'seasonTotalWins': FieldValue.increment(-(r['winningGames'] ?? 0)),
          'seasonTotalGames': FieldValue.increment(-(r['totalGames'] ?? 0)),
          'accumulatedScore': FieldValue.increment(-(r['attendanceScore'] ?? 0) - (r['winScore'] ?? 0)),
        });
      }
    }

    await batch.commit();
  }

  Future<bool> hasAnyRealRecordOnDate(String date) async {
    final playerRecordsRef = FirebaseFirestore.instance.collection('playerRecords');
    final snapshot = await playerRecordsRef.get();

    for (final doc in snapshot.docs) {
      final records = List.from(doc.data()['records'] ?? []);
      for (final record in records) {
        if (record['date'] == date) {
          // 하나라도 0이 아니면 true
          final attendance = record['attendanceScore'] ?? 0;
          final score = record['winScore'] ?? 0;
          final win = record['winningGames'] ?? 0;
          final games = record['totalGames'] ?? 0;
          if (attendance != 0 || score != 0 || win != 0 || games != 0) {
            return true; // 하나라도 0이 아니면 "기록 있음"
          }
        }
      }
    }
    return false; // 모두 0이거나, date자체가 없는 경우
  }
}