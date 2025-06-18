import 'package:basketball_records/data/model/player_model.dart';


abstract class FireStoreRepository {
  Future<void> uploadPlayers();
  Future<List<PlayerModel>> getPlayers();
}