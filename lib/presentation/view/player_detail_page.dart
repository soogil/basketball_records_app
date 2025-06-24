import 'package:iggys_point/core/theme/br_color.dart';
import 'package:iggys_point/data/model/record_model.dart';
import 'package:iggys_point/presentation/view/main_page.dart';
import 'package:iggys_point/presentation/viewmodel/date_records_view_model.dart';
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
      appBar: _appBar(context),
      body: recordsState.when(
          data: (data) => _body(context, data, ref),
          error: (_, e) => Text(e.toString()),
          loading: () => Center(child: CircularProgressIndicator(
            color: BRColors.greyDa,
          ))),
    );
  }

  PreferredSizeWidget _appBar(BuildContext context) {
    return AppBar(
      toolbarHeight: 70,
      centerTitle: true,
      backgroundColor: BRColors.greenB2,
      title: Text(
        '$playerName 기록',
        style: TextStyle(
            fontSize: 24.0.responsiveFontSize(context, minFontSize: 18),
            color: BRColors.white
        ),
      ),
    );
  }

  Widget _body(BuildContext context, DateRecords state, WidgetRef ref) {
    return CustomScrollView(
      slivers: [
        SliverStickyHeader(
          header: _buildHeader(context, ref),
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

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Row(
      children: PlayerRecordColumn.values.map((col) {
        // final isSorted = viewModel.sortColumn == col;
        return Expanded(
          flex: col.flex,
          child: Container(
            color: BRColors.greenCf,
            height: 50,
            child: InkWell(
              // onTap: () => viewModel.sortPlayersOnTable(col),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(col.label,
                    style: TextStyle(
                      fontSize: 16.0.responsiveFontSize(context, minFontSize: 12),
                    ),),
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
                    flex: col.flex,
                    child: Text(
                      record.valueByColumn(col),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 18.0.responsiveFontSize(context, minFontSize: 15),
                      ),
                    )))
                .toList()
        ));
  }
}
