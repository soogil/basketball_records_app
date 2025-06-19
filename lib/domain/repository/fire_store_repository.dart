import 'package:basketball_records/data/model/player_model.dart';
import 'package:basketball_records/data/model/record_model.dart';


abstract class FireStoreRepository {
  Future<void> uploadPlayers();
  Future<List<PlayerModel>> getPlayers();
  Future<List<RecordModel>> getPlayerRecords(String playerId);
}