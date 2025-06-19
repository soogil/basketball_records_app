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

  Future<void> uploadPlayersRecords() async {
    final String jsonString = await rootBundle.loadString('assets/player_season_records.json');
    final CollectionReference playersRef = FirebaseFirestore
        .instance
        .collection('playerRecords');

    final Map<String, dynamic> data = json.decode(jsonString);
    for (final playerId in data.keys) {
      final List<dynamic> records = data[playerId];
      await playersRef.doc(playerId).set({"records": records});
    }
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
}