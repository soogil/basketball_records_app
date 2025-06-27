import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:iggys_point/data/model/player_model.dart';
import 'package:iggys_point/data/model/record_model.dart';
import 'package:iggys_point/data/repository/fire_store_repository_impl.dart';
import 'package:iggys_point/domain/repository/fire_store_repository.dart';
import 'package:iggys_point/presentation/view/record_add_page.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'player_list_view_model.g.dart';

class PlayerListState {
  PlayerListState({
    required this.players,
    this.hoveredId,
  });

  final List<PlayerModel> players;
  final String? hoveredId;
}

@riverpod
class PlayerListViewModel extends _$PlayerListViewModel {
  late final FireStoreRepository _fireStoreRepository = ref.read(fireStoreImpl);

  PlayerColumn? _sortColumn = PlayerColumn.totalScore;
  bool _sortAscending = false;

  PlayerColumn? get sortColumn => _sortColumn;
  bool get sortAscending => _sortAscending;


  @override
  Future<PlayerListState> build() async {
    final List<PlayerModel> players = await _fireStoreRepository.getPlayers();

    final sorted = sortPlayers(players, PlayerColumn.totalScore, ascending: false);

    return PlayerListState(players: sorted);
  }

  Future uploadPlayers() async {
    await _fireStoreRepository.uploadPlayers();
  }

  List<PlayerModel> sortPlayers(List<PlayerModel> input, PlayerColumn column, {bool? ascending}) {
    final players = [...input];

    bool defaultAscending = (column == PlayerColumn.name);

    if (_sortColumn == column) {
      _sortAscending = ascending ?? !_sortAscending;
    } else {
      _sortColumn = column;
      _sortAscending = ascending ?? defaultAscending;
    }

    players.sort((a, b) {
      int compare;
      switch (column) {
        case PlayerColumn.name:
          compare = a.name.compareTo(b.name);
          break;
        case PlayerColumn.winScore:
          compare = a.winScore.compareTo(b.winScore);
          break;
        case PlayerColumn.accumulatedScore:
          compare = a.accumulatedScore.compareTo(b.accumulatedScore);
          break;
        case PlayerColumn.totalScore:
          compare = a.totalScore.compareTo(b.totalScore);
          break;
        case PlayerColumn.attendanceScore:
          compare = a.attendanceScore.compareTo(b.attendanceScore);
          break;
        case PlayerColumn.winRate:
          compare = a.winRate.compareTo(b.winRate);
          break;
      }
      return _sortAscending ? compare : -compare;
    });

    return players;
  }

  void sortPlayersOnTable(PlayerColumn column) {
    final sorted = sortPlayers(state.value!.players, column);
    state = AsyncData(PlayerListState(players: sorted));
  }

  Future savePlayerRecords({
    required String recordDate,
    required List<PlayerGameInput> playerInputs,
  }) async {
    await _fireStoreRepository.updatePlayerRecords(recordDate, playerInputs);
  }

  Future<bool> removeRecordFromDate(String date) async {
    try {
      await _fireStoreRepository.removeRecordFromDate(date);
    } catch(e) {
      debugPrint(e.toString());
      return false;
    }
    return true;
  }

  Future<bool> hasAnyRealRecordOnDate(String date) async {
    try {
      return await _fireStoreRepository.hasAnyRealRecordOnDate(date);
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}