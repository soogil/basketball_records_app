import 'package:basketball_records/core/theme/br_color.dart';
import 'package:basketball_records/data/model/player_model.dart';
import 'package:basketball_records/presentation/viewmodel/player_list_view_model.dart';
import 'package:basketball_records/presentation/widget/player_dialog.dart';
// import 'package:data_table_2/data_table_2.dart' show ColumnSize, DataColumn2, DataRow2, DataTable2;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';


class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: _appBar(context, ref),
      body: _body(ref),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     // ref.read(playerListViewModelProvider.notifier).uploadPlayers();
      //
      //
      //   },
      //   child: const Icon(Icons.refresh),
      // ),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context, WidgetRef ref) {
    return AppBar(
      toolbarHeight: 50,
      backgroundColor: BRColors.greenB2,
      // title: const Text('Basketball Records'),
      actions: [
        OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black)
            ),
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (_) {
                    final players = ref.read(playerListViewModelProvider).value?.players ?? [];
                    return Dialog(
                      backgroundColor: BRColors.white,
                      child: PlayerDialog(
                        allPlayers: players,
                        onSave: (List<TeamInput> teams) async {
                          // 저장 콜백 - 여기에 Firestore 저장 로직
                          // 예: await saveTeamRecordsToFirestore(teams);
                          Navigator.pop(context);
                        },
                      ),
                    );
                  }
              );
            },
            child: Text(
              '기록 추가',
              style: TextStyle(
                  fontSize: 15,
                  color: Colors.black
              ),
            )
        ),
        const SizedBox(width: 50,),
      ],
    );
  }

  Widget _body(WidgetRef ref) {
    final mainViewModel = ref.watch(playerListViewModelProvider);

    return mainViewModel.when(
      data: (data) {
        return _body2(ref, data.players);
        // return _playerList(data.players);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('에러 발생: $error')),
    );
  }

  Widget _body2(WidgetRef ref, List<PlayerModel> players) {
    return CustomScrollView(
      slivers: [
        SliverStickyHeader(
          header: _buildHeader(ref),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final player = players[index];
                return _buildTableRow(player, index, context);
              },
              childCount: players.length,
            ),
          ),
        ),
      ],
    );
  }

  // 컬럼 헤더 UI (고정)
  Widget _buildHeader(WidgetRef ref) {
    final viewModel = ref.watch(playerListViewModelProvider.notifier);

    return Row(
      children: PlayerColumn.values.map((col) {
        final isSorted = viewModel.sortColumn == col;
        return Expanded(
          flex: 1,
          child: Container(
            color: BRColors.greenCf,
            height: 50,
            child: InkWell(
              onTap: () => viewModel.sortPlayersOnTable(col),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(col.label),
                  if (isSorted)
                    Row(
                      children: [
                        const SizedBox(width: 5),
                        Icon(
                          viewModel.sortAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 20,
                          color: Colors.black,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 데이터 Row
  Widget _buildTableRow(PlayerModel player, int index, BuildContext context) {
    final isEven = index.isEven;

    return ListTile(
      contentPadding: EdgeInsets.all(0),
        minTileHeight: 50,
        onTap: () {

        },
        tileColor: isEven ? BRColors.greyDa : BRColors.whiteE8,
        title: Row(
            mainAxisSize: MainAxisSize.max,
            children: PlayerColumn.values
                .map((col) =>
                Expanded(
                    flex: 1,
                    child: Text(
                      player.valueByColumn(col),
                      textAlign: TextAlign.center,
                    )))
                .toList()
        ));
  }

//   Widget _playerList(List<PlayerModel> players) {
//     return Consumer(
//         builder: (context, ref, __) {
//           final viewModel = ref.watch(playerListViewModelProvider.notifier);
//           final mainState = ref.watch(playerListViewModelProvider);
//
//           return DataTable2(
//             sortColumnIndex: viewModel.sortColumn?.index,
//             sortAscending: viewModel.sortAscending,
//             columnSpacing: 0,
//             horizontalMargin: 0,
//             showCheckboxColumn: false,
//             dividerThickness: 1.5,
//             dataRowHeight: 40,
//             columns: PlayerColumn.values.map((col) {
//               final isSorted = viewModel.sortColumn == col;
//               return DataColumn(
//                 label: InkWell(
//                   onTap: () => viewModel.sortPlayersOnTable(col),
//                   child: Container(
//                     color: Color(0xFF89A8B2),
//                     child: Center(
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         mainAxisSize: MainAxisSize.max,
//                         children: [
//                           Text(col.label),
//                           if (isSorted)
//                             Row(
//                               children: [
//                                 const SizedBox(width: 5),
//                                 Icon(
//                                   viewModel.sortAscending
//                                       ? Icons.arrow_upward
//                                       : Icons.arrow_downward,
//                                   size: 20,
//                                   color: Colors.black,
//                                 ),
//                               ],
//                             ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               );
//             }).toList(),
//             rows: List.generate(players.length, (index) {
//                 final player = players[index];
//
//                 return DataRow2(
//                   // color: WidgetStateProperty.resolveWith<Color?>(
//                   //       (Set<WidgetState> states) {
//                   //
//                   //         final Color color =  index.isEven
//                   //             ? Color(0xFFF1F0E8)
//                   //             : Color(0xFFE5E1DA);
//                   //         if (states.contains(WidgetState.hovered)) {
//                   //           return null;
//                   //         }
//                   //
//                   //     return color;
//                   //   },
//                   // ),
//                   onSelectChanged: (selected) {
//                   },
//                   cells: PlayerColumn.values
//                       .map((col) => DataCell(
//                       Center(child: Text(player.valueByColumn(col)))))
//                       .toList(),
//                 );}).toList(),
//           );
//         }
//     );
//   }
}