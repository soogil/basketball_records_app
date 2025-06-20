import 'package:basketball_records/data/model/player_model.dart';
import 'package:basketball_records/data/model/record_model.dart';


abstract class FireStoreRepository {
  Future<void> uploadPlayers();
  Future<List<PlayerModel>> getPlayers();
  Future<List<RecordModel>> getPlayerRecords(String playerId);
  Future<void> updatePlayerRecords(RecordModel record, String playerId);
  Future<void> updatePlayerStats({
    required String playerId,
    required int attendance,
    required int score,
    required int win,
    required int games,
  });
  Future<void> deleteDateFromAllPlayerRecords(DateTime dateTime);
}