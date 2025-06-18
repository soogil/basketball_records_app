import 'dart:convert';

import 'package:basketball_records/data/model/player_model.dart';
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
      await playersRef.doc(player['name']).set(player);
    }
  }

  Future<List<PlayerModel>> getPlayers() async {
    final querySnapshot = await FirebaseFirestore.instance
        .collection('players')
        .get();

    return querySnapshot.docs
        .map((doc) => PlayerModel.fromFireStore(doc.id, doc.data()))
        .toList();
  }
}