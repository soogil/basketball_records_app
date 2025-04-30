import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show SystemChrome, SystemUiMode, SystemUiOverlay;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'presentation/view/main_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(
      ProviderScope(child: const BasketballRecordsApp())
  );
}

class BasketballRecordsApp extends StatelessWidget {
  const BasketballRecordsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MainPage(),
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

    // 첫 번째 행을 헤더로 사용
    final List<String> headers = sheetData.first;
    if (headers.isEmpty) {
      return const Center(child: Text('헤더가 없습니다.'));
    }

    // 디버깅을 위한 로그 추가
    debugPrint('Headers length: ${headers.length}');
    debugPrint('Headers: $headers');

    // 나머지 행은 데이터로 사용
    final List<List<String>> rows = sheetData.sublist(1);

    // 모든 행이 헤더의 열 수와 동일하도록 보장
    final List<List<String>> normalizedRows = rows.map((row) {
      debugPrint('Original row length: ${row.length}, Row: $row');
      
      // 행의 열 수가 헤더보다 적으면 빈 문자열로 채움
      if (row.length < headers.length) {
        final normalizedRow = [...row, ...List.filled(headers.length - row.length, '')];
        debugPrint('Normalized row (filled): $normalizedRow');
        return normalizedRow;
      }
      // 행의 열 수가 헤더보다 많으면 잘라냄
      final normalizedRow = row.sublist(0, headers.length);
      debugPrint('Normalized row (sliced): $normalizedRow');
      return normalizedRow;
    }).toList();

    // 정규화된 행의 길이 확인
    for (var i = 0; i < normalizedRows.length; i++) {
      debugPrint('Normalized row $i length: ${normalizedRows[i].length}');
      if (normalizedRows[i].length != headers.length) {
        debugPrint('ERROR: Row $i length (${normalizedRows[i].length}) does not match headers length (${headers.length})');
      }
    }

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: SingleChildScrollView(
        child: DataTable(
          columns: headers
              .map((header) => DataColumn(
                    label: Text(
                      header,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ))
              .toList(),
          rows: normalizedRows
              .map(
                (row) => DataRow(
                  cells: row
                      .map((cell) => DataCell(Text(cell)))
                      .toList(),
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
