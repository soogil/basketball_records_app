import 'package:basketball_records/core/api/fire_store_api.dart';
import 'package:basketball_records/data/model/player_model.dart';
import 'package:basketball_records/domain/repository/fire_store_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return await _fireStoreApi.getPlayers();
  }
}

