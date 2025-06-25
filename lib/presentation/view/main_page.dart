import 'package:iggys_point/core/router/app_pages.dart';
import 'package:iggys_point/core/theme/br_color.dart';
import 'package:iggys_point/data/model/player_model.dart';
import 'package:iggys_point/presentation/viewmodel/player_list_view_model.dart';
import 'package:iggys_point/presentation/view/record_add_page.dart';
// import 'package:data_table_2/data_table_2.dart' show ColumnSize, DataColumn2, DataRow2, DataTable2;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:go_router/go_router.dart';
import 'dart:html' as html;

final _tapCountProvider = StateProvider<int>((ref) => 0);

class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  Future<void> deleteAllCookies() async {
    final cookies = html.document.cookie?.split(';') ?? [];
    for (var cookie in cookies) {
      final eqPos = cookie.indexOf('=');
      final name = eqPos > -1 ? cookie.substring(0, eqPos) : cookie;
      html.document.cookie =
      '$name=;expires=Thu, 01 Jan 1970 00:00:00 GMT;path=/';
    }
    html.window.location.reload();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RefreshIndicator(
      onRefresh: deleteAllCookies,
      child: Scaffold(
        body: _body(context, ref),
        // floatingActionButton: FloatingActionButton(
        //   onPressed: () {
        //     final achieve = isMilestonePassed(620,640);
        //     print('achieve isMilestonePassed $achieve');
        //   },
        //   child: const Icon(Icons.refresh),
        // ),
      ),
    );
  }

  SliverAppBar _appBar(BuildContext context, WidgetRef ref) {
    final tapCount = ref.watch(_tapCountProvider);

    return SliverAppBar(
      toolbarHeight: 70,
      backgroundColor: BRColors.greenB2,
      centerTitle: true,
      title: GestureDetector(
        onTap: () {
          if (!isMobile(context)) {
            ref.read(_tapCountProvider.notifier).state++;
          }
        },
        child: Text(
          '이기스 포인트',
          style: TextStyle(
              fontSize: 24.0.responsiveFontSize(context, minFontSize: 18),
              color: BRColors.white
          ),
        ),
      ),
      actions: tapCount < 7 ? [] :[
        OutlinedButton(
            style: OutlinedButton.styleFrom(
                side: BorderSide(color: Colors.black)
            ),
            onPressed: () {
              final players = ref.read(playerListViewModelProvider).value?.players ?? [];

              onSave(DateTime dateTime, List<TeamInput> teams) async {
                final viewModel = ref.read(playerListViewModelProvider.notifier);
                final List<PlayerGameInput> playerInputs = teams
                    .expand((team) => team.players)
                    .toList();

                await viewModel.savePlayerRecords(
                    recordDate: '${dateTime.year}-'
                        '${dateTime.month.toString().padLeft(2, '0')}'
                        '-${dateTime.day.toString().padLeft(2, '0')}',
                    playerInputs: playerInputs);

                if (context.mounted) {
                  Navigator.pop(context);
                }
              }

              onRemove(DateTime dateTime) async {
                final String date = '${dateTime.year}-'
                    '${dateTime.month.toString().padLeft(2, '0')}'
                    '-${dateTime.day.toString().padLeft(2, '0')}';

                final mainViewModel = ref.read(playerListViewModelProvider.notifier);

                final bool result = await mainViewModel.removeRecordFromDate(date);

                if (result) {
                  if (context.mounted) {
                    showDialog(
                        context: context,
                        builder: (_) {
                          return AlertDialog(
                            contentPadding: EdgeInsets.all(30),
                            content: Text(
                              '$date 기록이 삭제 됐습니다.',
                              style: TextStyle(
                                  fontSize: 20
                              ),
                            ),
                            actions: [
                              ElevatedButton(
                                  onPressed: () {
                                    if (context.mounted) {
                                      Navigator.pop(context);
                                    }
                                  },
                                  child: Text('완료'))
                            ],
                          );
                        });
                  }
                }
              }

            context.pushNamed(AppPage.recordAdd.name, extra: {
              'onSave': onSave,
              'onRemove': onRemove,
              'allPlayers': players
              }).then((_) {
                ref.invalidate(playerListViewModelProvider);
              });
            },
            child: Text(
              '기록 추가',
              style: TextStyle(
                  fontSize: 15.0.responsiveFontSize(context, minFontSize: 12),
                  color: Colors.black
              ),
            )
        ),
        const SizedBox(width: 50,),
      ],
    );
  }

  Widget _body(BuildContext context, WidgetRef ref) {
    final mainViewModel = ref.watch(playerListViewModelProvider);

    return mainViewModel.when(
      data: (data) {
        return _body2(context, ref, data.players);
        // return _playerList(data.players);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('에러 발생: $error')),
    );
  }

  Widget _body2(BuildContext context, WidgetRef ref, List<PlayerModel> players) {
    return CustomScrollView(
      slivers: [
        _appBar(context, ref),
        SliverStickyHeader(
          header: _buildHeader(context, ref),
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
  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(playerListViewModelProvider.notifier);

    return Row(
      children: PlayerColumn.values.map((col) {
        final isSorted = viewModel.sortColumn == col;
        return Expanded(
          flex: col.flex,
          child: Container(
            color: BRColors.greenCf,
            height: 50,
            child: InkWell(
              onTap: () => viewModel.sortPlayersOnTable(col),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    col.label,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16.0.responsiveFontSize(context, minFontSize: 12),
                    ),
                  ),
                  if (isSorted)
                    Row(
                      children: [
                        const SizedBox(width: 2),
                        Icon(
                          viewModel.sortAscending
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          size: 20.0.responsiveFontSize(context, minFontSize: 13),
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
        onTap: () => context.pushNamed(AppPage.playerDetail.name, extra: {
          'playerId': player.id,
          'playerName': player.name,
        }),
        tileColor: isEven ? BRColors.greyDa : BRColors.whiteE8,
        title: Row(
            mainAxisSize: MainAxisSize.max,
            children: PlayerColumn.values
                .map((col) => Expanded(
                    flex: col.flex,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          player.valueByColumn(col),
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18.0.responsiveFontSize(context, minFontSize: 13),
                          ),
                        ),
                        if (col == PlayerColumn.accumulatedScore && player.scoreAchieved)
                          Row(
                            children: [
                              const SizedBox(width: 5),
                              Icon(Icons.emoji_events, color: Colors.amber,),
                          ],
                        )
                      ],
                    )))
                .toList()
        ));
  }

  bool isMobile(BuildContext context) {
    return MediaQuery.of(context).size.width < 600;
  }

  bool isTablet(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    return width >= 600 && width < 1200;
  }

  bool isDesktop(BuildContext context) {
    return MediaQuery.of(context).size.width >= 1200;
  }
}

extension ResponsiveFontSize on double {
  double responsiveFontSize(BuildContext context, {double? minFontSize}) {
    final width = MediaQuery.of(context).size.width;
    if (width < 600 && minFontSize != null) {
      return minFontSize;
    }
    return this;
  }
}
