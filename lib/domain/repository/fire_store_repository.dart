import 'package:iggys_point/data/model/player_model.dart';
import 'package:iggys_point/data/model/record_model.dart';
import 'package:iggys_point/presentation/view/record_add_page.dart';


abstract class FireStoreRepository {
  Future<void> uploadPlayers();
  Future<List<PlayerModel>> getPlayers();
  Future<List<RecordModel>> getPlayerRecords(String playerId);
  Future<void> updatePlayerRecords(String recordDate, List<PlayerGameInput> player);
  Future<void> removeRecordFromDate(String date);
  Future<bool> hasAnyRealRecordOnDate(String date);
}