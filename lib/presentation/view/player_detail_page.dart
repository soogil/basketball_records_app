import 'package:basketball_records/core/theme/br_color.dart';
import 'package:basketball_records/data/model/record_model.dart';
import 'package:basketball_records/presentation/viewmodel/date_records_view_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';


class PlayerDetailPage extends ConsumerWidget {
  const PlayerDetailPage({super.key,
    required this.playerId,
    required this.playerName,
  });

  final String playerId;
  final String playerName;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recordsState = ref.watch(dateRecordsViewModelProvider(playerId));

    return Scaffold(
      appBar: _appBar(),
      body: recordsState.when(
          data: (data) => _body(data, ref),
          error: (_, e) => Text(e.toString()),
          loading: () => Center(child: CircularProgressIndicator(
            color: BRColors.greyDa,
          ))),
    );
  }

  PreferredSizeWidget _appBar() {
    return AppBar(
      toolbarHeight: 70,
      backgroundColor: BRColors.greenB2,
      title: Text(
          '$playerName 기록',
        style: TextStyle(
          fontSize: 25,
          color: BRColors.white,
        ),
      ),
    );
  }

  Widget _body(DateRecords state, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverStickyHeader(
          header: _buildHeader(ref),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
                  (context, index) {
                final record = state.records[index];
                return _buildTableRow(record, index, context);
              },
              childCount: state.records.length,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildHeader(WidgetRef ref) {
    final viewModel = ref.watch(dateRecordsViewModelProvider(playerId).notifier);

    return Row(
      children: PlayerRecordColumn.values.map((col) {
        // final isSorted = viewModel.sortColumn == col;
        return Expanded(
          flex: 1,
          child: Container(
            color: BRColors.greenCf,
            height: 50,
            child: InkWell(
              // onTap: () => viewModel.sortPlayersOnTable(col),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(col.label),
                  // if (isSorted)
                  //   Row(
                  //     children: [
                  //       const SizedBox(width: 5),
                  //       Icon(
                  //         viewModel.sortAscending
                  //             ? Icons.arrow_upward
                  //             : Icons.arrow_downward,
                  //         size: 20,
                  //         color: Colors.black,
                  //       ),
                  //     ],
                  //   ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // 데이터 Row
  Widget _buildTableRow(RecordModel record, int index, BuildContext context) {
    final isEven = index.isEven;

    return ListTile(
        contentPadding: EdgeInsets.all(0),
        minTileHeight: 50,
        // onTap: () {
        //   context.pushNamed(AppPage.playerDetail.path, extra: record.id);
        // },
        tileColor: isEven ? BRColors.greyDa : BRColors.whiteE8,
        title: Row(
            mainAxisSize: MainAxisSize.max,
            children: PlayerRecordColumn.values
                .map((col) =>
                Expanded(
                    flex: 1,
                    child: Text(
                      record.valueByColumn(col),
                      textAlign: TextAlign.center,
                    )))
                .toList()
        ));
  }
}
