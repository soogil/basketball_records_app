import 'package:boilerplate/data/repository/google_sheet_repository_impl.dart';
import 'package:boilerplate/domain/repository/google_sheet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gsheets/gsheets.dart';

part 'main_page_view_model.g.dart';

@riverpod
class MainPageViewModel extends _$MainPageViewModel {
  late final GoogleSheetsRepository _googleSheetsRepository;
  late final Spreadsheet _sheets;

  @override
  Future<Spreadsheet> build() async {
    _googleSheetsRepository = await ref.read(googleSheetsRepository);
    return _sheets;
  }

  Future<void> fetchSheetData() async {
    final result = await _googleSheetsRepository.fetchSheetsData();
    _sheets = result;
  }
}