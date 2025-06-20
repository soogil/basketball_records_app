import 'package:basketball_records/data/model/player_model.dart';
import 'package:basketball_records/data/repository/fire_store_repository_impl.dart';
import 'package:basketball_records/domain/repository/fire_store_repository.dart';
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

    // 이름이면 오름차순, 나머지는 내림차순이 기본
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
        case PlayerColumn.wins:
          compare = a.wins.compareTo(b.wins);
          break;
        case PlayerColumn.totalAttendanceScore:
          compare = a.totalAttendanceScore.compareTo(b.totalAttendanceScore);
          break;
        case PlayerColumn.totalScore:
          compare = a.totalScore.compareTo(b.totalScore);
          break;
        case PlayerColumn.appearances:
          compare = a.appearances.compareTo(b.appearances);
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

  void setHover({String? id}) {
    state = AsyncData(
      PlayerListState(players: state.value!.players, hoveredId: id),
    );
  }

  Future save(DateTime dateTime) async {
    // await _fireStoreRepository.updatePlayerRecords(dateTime);
    // await _fireStoreRepository.updatePlayerStats(dateTime);
  }

  Future deleteDateFromAllPlayerRecords(DateTime dateTime) async {
    await _fireStoreRepository.deleteDateFromAllPlayerRecords(dateTime);
  }
}