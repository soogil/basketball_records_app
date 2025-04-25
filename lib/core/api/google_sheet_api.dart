import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gsheets/gsheets.dart';

final gsCredentialsProvider = Provider<Future<String>>((ref) async {
  try {
    final String jsonString = await rootBundle.loadString('assets/credentials.json');
    return jsonString;
  } catch (e) {
    debugPrint('Error loading credentials: $e');
    rethrow;
  }
});

final spreadSheetIdProvider = Provider<String>((ref) => '1GTYQfdBewT0QYRLzLMZT01TX6fS2tprTm56a0CgAbMU');

final googleSheetsProvider = Provider<Future<GSheets>>((ref) async {
  final credentials = await ref.read(gsCredentialsProvider);
  return GSheets(credentials);
});

final googleSheetsApiProvider = Provider<Future<GoogleSheetsApi>>((ref) async {
  final gSheets = await ref.read(googleSheetsProvider);
  final spreadsheetId = ref.read(spreadSheetIdProvider);
  return GoogleSheetsApi(gSheets, spreadsheetId);
});

class GoogleSheetsApi {
  GoogleSheetsApi(this._gSheets, this._spreadsheetId);

  final GSheets _gSheets;
  final String _spreadsheetId;

  Future<Spreadsheet> fetchSheetsData() async {
    final result = await _gSheets.spreadsheet(_spreadsheetId);

    for (var sheet in result.sheets) {
      debugPrint('\nSheet: ${sheet.title}');

      // 시트의 전체 행 수를 가져옵니다
      final rowCount = await sheet.rowCount;
      debugPrint('Total rows: $rowCount');

      // 값이 있는 행만 가져오기 위해 각 행을 확인
      for (int i = 1; i <= rowCount; i++) {
        final row = await sheet.cells.row(i);
        // 행이 비어있지 않은 경우에만 출력
        if (row.isNotEmpty && row.any((cell) => cell.toString().trim().isNotEmpty)) {
          debugPrint('Row $i: $row');
        }
      }
    }

    // final result = await _gSheets.spreadsheet(_spreadsheetId);
    //
    // // 특정 시트에 접근
    // final targetSheet = result.worksheetById(950839361);
    // if (targetSheet == null) {
    //   throw Exception('Target sheet not found');
    // }
    //
    // // 시트 데이터 읽기
    // final values = await targetSheet.values.allRows();
    // debugPrint('Sheet data: $values');

    return result;
  }

  // // 수식 추가/수정 메서드
  // Future<void> updateFormula({
  //   required String sheetTitle,
  //   required String cell,
  //   required String formula,
  // }) async {
  //   final spreadsheet = await _gSheets.spreadsheet(_spreadsheetId);
  //   final sheet = spreadsheet.worksheetByTitle(sheetTitle);
  //
  //   if (sheet == null) {
  //     throw Exception('Sheet not found: $sheetTitle');
  //   }
  //
  //   await sheet.values.insertValue(formula, cell: cell);
  //   debugPrint('Formula updated in $sheetTitle at $cell: $formula');
  // }
  //
  // // 셀 범위에 수식 적용
  // Future<void> updateFormulaRange({
  //   required String sheetTitle,
  //   required String startCell,
  //   required String endCell,
  //   required String formula,
  // }) async {
  //   final spreadsheet = await _gSheets.spreadsheet(_spreadsheetId);
  //   final sheet = spreadsheet.worksheetByTitle(sheetTitle);
  //
  //   if (sheet == null) {
  //     throw Exception('Sheet not found: $sheetTitle');
  //   }
  //
  //   await sheet.values.insertValue(formula, range: '$startCell:$endCell');
  //   debugPrint('Formula updated in $sheetTitle from $startCell to $endCell: $formula');
  // }
}