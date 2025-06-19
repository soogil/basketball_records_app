import 'dart:convert';

import 'package:basketball_records/data/model/player_model.dart';
import 'package:basketball_records/data/model/record_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


final fireStoreApiProvider = Provider<FireStoreApi>((ref) => FireStoreApi());

class FireStoreApi {
  FireStoreApi();

  Future<void> uploadPlayersToFireStore() async {
    final String jsonString = await rootBundle.loadString('assets/players.json');
    final List<dynamic> players = json.decode(jsonString);

    final CollectionReference playersRef = FirebaseFirestore.instance.collection('players');

    for (var player in players) {
      await playersRef.add(player);
    }
  }

  Future<List<PlayerModel>> getPlayers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('players')
        .get();

    return querySnapshot.docs
        .map((doc) {
          print('${doc.id} ${doc.data()}');
          return PlayerModel.fromFireStore(doc.id, doc.data());
    })
        .toList();
  }

  Future<List<RecordModel>> getPlayerRecords(String playerId) async {
    final datesSnapshot = await FirebaseFirestore.instance.collection('dates').get();

    List<RecordModel> records = [];
    for (var dateDoc in datesSnapshot.docs) {
      final playerRecordDoc = await dateDoc.reference
          .collection('playerRecords')
          .doc(playerId)
          .get();

      if (playerRecordDoc.exists) {
        final data = playerRecordDoc.data();
        // records.add(
        //   RecordModel(
        //     date: dateDoc.id,
        //     attendance: data['attendance'],
        //     win: data['win'],
        //     score: data['score'],
        //     games: data['games'],
        //   ),
        // );
      }
    }
    return records;
  }
}