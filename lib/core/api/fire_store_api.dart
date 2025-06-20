import 'dart:convert';

import 'package:basketball_records/data/model/record_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final fireStoreApiProvider = Provider<FireStoreApi>((ref) => FireStoreApi());

class FireStoreApi {

  Future<void> uploadPlayersToFireStore() async {
    final String jsonString = await rootBundle.loadString('assets/4players_by_id_dict.json');

    final Map<String, dynamic> playersById = jsonDecode(jsonString);

    final playersRef = FirebaseFirestore.instance.collection('playerRecords');

    for (final entry in playersById.entries) {
      final id = entry.key;
      final records = entry.value['records'];

      await playersRef.doc(id).set({
        'records': records,
      });
    }
  }

  // Future backupData() async {
  //   final playersRef = FirebaseFirestore.instance.collection('players');
  //   final snapshot = await playersRef.get();
  //
  //   Map<String, dynamic> allRecords = {};
  //   for (final doc in snapshot.docs) {
  //     allRecords[doc.id] = doc.data();
  //   }
  //
  //   String jsonString = jsonEncode(allRecords);
  //
  //   // 웹에서 파일로 다운로드
  //   final bytes = utf8.encode(jsonString);
  //   final blob = html.Blob([bytes]);
  //   final url = html.Url.createObjectUrlFromBlob(blob);
  //   final anchor = html.AnchorElement(href: url)
  //     ..setAttribute("download", "players_backup.json")
  //     ..click();
  //   html.Url.revokeObjectUrl(url);
  // }

  Future<void> uploadPlayersToFireStore2() async {
    final String jsonString = await rootBundle.loadString('assets/players_with.json');
    final List<dynamic> playerList = jsonDecode(jsonString);

    final playersRef = FirebaseFirestore.instance.collection('players');

    for (final player in playerList) {
      final name = player['name'];

      // 2. 이름으로 도큐먼트 찾기
      final querySnapshot = await playersRef.where('name', isEqualTo: name).get();

      if (querySnapshot.docs.isNotEmpty) {
        final docRef = querySnapshot.docs.first.reference;

        // 3. 완전히 덮어쓰기 (기존 필드 전부 삭제, player 객체 전체로 덮어쓰기)
        await docRef.set(player);
      } else {
        print('No document found for name: $name');
      }
    }
  }

  // Future<void> uploadPlayersRecords() async {
  //   final String jsonString = await rootBundle.loadString('assets/player_season_records.json');
  //   final CollectionReference playersRef = FirebaseFirestore
  //       .instance
  //       .collection('playerRecords');
  //
  //   final Map<String, dynamic> data = json.decode(jsonString);
  //   for (final playerId in data.keys) {
  //     final List<dynamic> records = data[playerId];
  //     await playersRef.doc(playerId).set({"records": records});
  //   }
  // }

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

  Future<void> updatePlayerRecords(String playerId, RecordModel record) async {
    final recordRef = FirebaseFirestore.instance.collection('playerRecords').doc(playerId);

    // 1. 기존 기록 가져오기
    final snapshot = await recordRef.get();
    List<dynamic> records = [];
    if (snapshot.exists && snapshot.data() != null) {
      records = List.from(snapshot.data()!['records'] ?? []);
    }

    // 2. 날짜 중복 체크 후 갱신/추가
    final idx = records.indexWhere((r) => r['date'] == record.date);
    if (idx >= 0) {
      records[idx] = record.toJson();
    } else {
      records.add(record.toJson());
    }

    // 3. 저장
    await recordRef.set({'records': records});
  }

  Future<void> updatePlayerStats({
    required String playerId,
    required int attendance,
    required int score,
    required int win,
    required int games,
  }) async {
    final playerRef = FirebaseFirestore.instance.collection('players').doc(playerId);

    await playerRef.update({
      'totalAttendanceScore': FieldValue.increment(attendance),
      'totalScore': FieldValue.increment(score),
      'wins': FieldValue.increment(win),
      'appearances': FieldValue.increment(games),
      // 필요시 다른 필드도
    });
  }

  Future<void> deleteDateFromAllPlayerRecords(String dateToRemove) async {
    final playerRecordsRef = FirebaseFirestore.instance.collection('playerRecords');
    final snapshot = await playerRecordsRef.get();

    for (final doc in snapshot.docs) {
      List<dynamic> records = List.from(doc.data()['records'] ?? []);
      // 해당 날짜의 기록만 제외한 새 리스트
      records.removeWhere((r) => r['date'] == dateToRemove);

      await doc.reference.update({'records': records});
    }
  }
}