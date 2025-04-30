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

  Future<List<List<String>>> fetchSheetsData() async {
    final spreadsheet = await _gSheets.spreadsheet(_spreadsheetId);
    final sheets = spreadsheet.sheets;
    if (sheets.isEmpty) {
      throw Exception('No sheets found');
    }
    final firstSheet = sheets.first;
    final rows = await firstSheet.values.allRows();

    int startRowIndex = 0;
    for (int i = 0; i < rows.length; i++) {
      if (rows[i].any((cell) => cell.trim().isNotEmpty)) {
        startRowIndex = i;
        break;
      }
    }

    return rows.sublist(startRowIndex);
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