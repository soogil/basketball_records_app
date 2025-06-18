// import 'package:boilerplate/core/api/google_sheet_api.dart';
// import 'package:boilerplate/domain/repository/google_sheet_repository.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
//
// final googleSheetsRepository = Provider<Future<GoogleSheetsRepository>>((ref) async {
//   final api = await ref.read(googleSheetsApiProvider);
//   return GoogleSheetsRepositoryImpl(api);
// });
//
// class GoogleSheetsRepositoryImpl extends GoogleSheetsRepository {
//   GoogleSheetsRepositoryImpl(this._googleSheetsApi);
//
//   final GoogleSheetsApi _googleSheetsApi;
//
//   @override
//   Future<dynamic> fetchSheetsData() {
//     return _googleSheetsApi.fetchSheetsData();
//   }
//
//   // Future<void> updateFormula({
//   //   required String sheetTitle,
//   //   required String cell,
//   //   required String formula,
//   // }) async {
//   //   await _googleSheetsApi.updateFormula(
//   //     sheetTitle: sheetTitle,
//   //     cell: cell,
//   //     formula: formula,
//   //   );
//   // }
//   //
//   // Future<void> updateFormulaRange({
//   //   required String sheetTitle,
//   //   required String startCell,
//   //   required String endCell,
//   //   required String formula,
//   // }) async {
//   //   await _googleSheetsApi.updateFormulaRange(
//   //     sheetTitle: sheetTitle,
//   //     startCell: startCell,
//   //     endCell: endCell,
//   //     formula: formula,
//   //   );
//   // }
// }
//
