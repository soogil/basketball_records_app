import 'package:basketball_records/data/model/player_model.dart';
import 'package:basketball_records/presentation/viewmodel/main_page_view_model.dart';
import 'package:data_table_2/data_table_2.dart' show ColumnSize, DataColumn2, DataRow2, DataTable2;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class MainPage extends ConsumerWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      // appBar: _appBar(),
      body: _body(ref),
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () =>
      //       ref.read(mainPageViewModelProvider.notifier).uploadPlayers(),
      //   child: const Icon(Icons.refresh),
      // ),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      backgroundColor: Colors.red,
      title: const Text('Basketball Records'),
    );
  }

  Widget _body(WidgetRef ref) {
    final mainViewModel = ref.watch(mainPageViewModelProvider);

    return mainViewModel.when(
      data: (data) {
        return _playerList(data.players);
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) => Center(child: Text('에러 발생: $error')),
    );
  }

  Widget _playerList(List<PlayerModel> players) {
    return Consumer(
        builder: (context, ref, __) {
          final viewModel = ref.watch(mainPageViewModelProvider.notifier);
          final mainState = ref.watch(mainPageViewModelProvider);

          return DataTable2(
            sortColumnIndex: viewModel.sortColumn?.index,
            sortAscending: viewModel.sortAscending,
            columnSpacing: 0,
            showCheckboxColumn: false,
            columns: PlayerColumn.values.map((col) {
              final isSorted = viewModel.sortColumn == col;
              return DataColumn(
                label: InkWell(
                  onTap: () => viewModel.sortPlayers(col),
                  child: Center(
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
            rows: mainState.maybeWhen(
              data: (state) =>
                  state.players.map((player) =>
                      DataRow(
                        onSelectChanged: (selected) {

                        },
                        cells: PlayerColumn.values
                            .map((col) => DataCell(Center(
                            child: Text(player.valueByColumn(col))))).toList(),
                      )).toList(),
              orElse: () => [],
            ),
          );
        }
    );
  }
}

class SheetDataTable extends StatelessWidget {
  final List<List<String>> sheetData;

  const SheetDataTable({
    super.key,
    required this.sheetData,
  });

  @override
  Widget build(BuildContext context) {
    if (sheetData.isEmpty) {
      return const Center(child: Text('데이터가 없습니다.'));
    }

    List<String> headers = sheetData.first;

    // 데이터 행 중 가장 긴 행의 길이 구하기
    final int maxColumnCount = sheetData.fold<int>(
      headers.length,
          (prev, row) => row.length > prev ? row.length : prev,
    );

    // 헤더가 부족하면 자동으로 채우기
    if (headers.length < maxColumnCount) {
      headers = [
        ...headers,
        ...List.generate(
          maxColumnCount - headers.length,
              (index) => 'Column ${headers.length + index + 1}',
        ),
      ];
    }

    // 나머지 행은 데이터로 사용
    final List<List<String>> rows = sheetData.sublist(1);

    final List<List<String>> normalizedRows = rows.map((row) {
      if (row.length < maxColumnCount) {
        return [...row, ...List.filled(maxColumnCount - row.length, '')];
      }
      return row;
    }).toList();

// 모든 셀이 빈 행은 제외
    final List<List<String>> filteredRows = normalizedRows.where(
            (row) => row.any((cell) => cell.trim().isNotEmpty)
    ).toList();

    return DataTable2(
      headingRowHeight: 0,
      columnSpacing: 0,
      fixedLeftColumns: 2,
      fixedTopRows: 3,
      minWidth: 8000,
      columns: headers.map((header) => DataColumn2(
        label: Text(
          header,
          style: Theme.of(context).textTheme.titleMedium,
        ),
      )).toList(),
      rows: List.generate(
        filteredRows.length,
            (rowIdx) => DataRow2(
          cells: List.generate(
            filteredRows[rowIdx].length,
                (colIdx) => DataCell(
              Text(
                _formatCell(filteredRows[rowIdx][colIdx], rowIdx, colIdx),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    fontSize: 15
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatCell(String cell, int rowIdx, int colIdx) {
    if (colIdx == 5) {
      num? numValue = num.tryParse(cell);
      if (numValue != null && cell.contains('.')) {
        return '${(numValue * 100).round()}%';
      }
    }
    return cell;
  }
}