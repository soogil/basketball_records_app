import 'package:basketball_records/data/model/player_model.dart';
import 'package:basketball_records/data/repository/fire_store_repository_impl.dart';
import 'package:basketball_records/domain/repository/fire_store_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_page_view_model.g.dart';


class MainState {
  MainState({
    required this.players,
  });

  final List<PlayerModel> players;
}

@riverpod
class MainPageViewModel extends _$MainPageViewModel {
  late final FireStoreRepository _fireStoreRepository = ref.read(fireStoreImpl);

  PlayerColumn? _sortColumn;
  bool _sortAscending = true;

  PlayerColumn? get sortColumn => _sortColumn;
  bool get sortAscending => _sortAscending;

  @override
  Future<MainState> build() async {
    final List<PlayerModel> players = await _fireStoreRepository.getPlayers();

    return MainState(players: players);
  }

  /// 정렬 함수
  void sortPlayers(PlayerColumn column) {
    final List<PlayerModel> players = [...state.value!.players]; // 깊은 복사

    if (_sortColumn == column) {
      _sortAscending = !_sortAscending;
    } else {
      _sortColumn = column;
      _sortAscending = true;
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
        case PlayerColumn.attendanceScore:
          compare = a.attendanceScore.compareTo(b.attendanceScore);
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

    // 상태를 갱신합니다.
    state = AsyncData(MainState(players: players));
  }
}