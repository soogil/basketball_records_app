import 'package:iggys_point/core/api/fire_store_api.dart';
import 'package:iggys_point/data/model/player_model.dart';
import 'package:iggys_point/data/model/record_model.dart';
import 'package:iggys_point/domain/repository/fire_store_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:iggys_point/presentation/view/record_add_page.dart';

final fireStoreImpl = Provider<FireStoreRepository>((ref) {
  final api = ref.read(fireStoreApiProvider);
  return FireStoreRepositoryImpl(api);
});

class FireStoreRepositoryImpl extends FireStoreRepository {
  FireStoreRepositoryImpl(this._fireStoreApi);

  final FireStoreApi _fireStoreApi;

  @override
  Future<dynamic> uploadPlayers() async {
    return _fireStoreApi.uploadPlayersToFireStore();
  }

  @override
  Future<List<PlayerModel>> getPlayers() async {
    final result = await _fireStoreApi.getPlayers();
    return result.docs.map((doc) {
      return PlayerModel.fromFireStore(doc.id, doc.data());
    }).toList();
  }

  @override
  Future<List<RecordModel>> getPlayerRecords(String playerId) async {
    final result = await _fireStoreApi.getPlayerRecords(playerId);

    final records = result.map((e) => RecordModel.fromJson(Map<String, dynamic>.from(e))).toList();

    records.sort((a, b) => b.date.compareTo(a.date));
    return records;
  }

  @override
  Future<void> updatePlayerRecords(String recordDate, List<PlayerGameInput> playerInputs) async {
    await _fireStoreApi.updatePlayerRecords(recordDate, playerInputs);
  }

  @override
  Future<void> removeRecordFromDate(String date) async {
    await _fireStoreApi.removeRecordFromDate(date);
  }

  @override
  Future<bool> hasAnyRealRecordOnDate(String date) async {
    return await _fireStoreApi.hasAnyRealRecordOnDate(date);
  }
}

