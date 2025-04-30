import 'package:boilerplate/data/repository/google_sheet_repository_impl.dart';
import 'package:boilerplate/domain/repository/google_sheet_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'main_page_view_model.g.dart';

@riverpod
class MainPageViewModel extends _$MainPageViewModel {
  late final GoogleSheetsRepository _googleSheetsRepository;
  late final List<List<String>> _sheets;

  @override
  Future<List<List<String>>> build() async {
    _googleSheetsRepository = await ref.read(googleSheetsRepository);
    await fetchSheetData(); // 데이터를 가져와서 _sheets 초기화
    return _sheets;
  }

  Future<void> fetchSheetData() async {
    final result = await _googleSheetsRepository.fetchSheetsData();
    _sheets = result;
  }
}