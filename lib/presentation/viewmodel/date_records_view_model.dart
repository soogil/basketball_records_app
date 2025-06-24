import 'package:iggys_point/data/model/record_model.dart';
import 'package:iggys_point/data/repository/fire_store_repository_impl.dart';
import 'package:iggys_point/domain/repository/fire_store_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'date_records_view_model.g.dart';

class DateRecords {
  DateRecords({required this.records});

  final List<RecordModel> records;
}

@riverpod
class DateRecordsViewModel extends _$DateRecordsViewModel {
  late final FireStoreRepository _fireStoreRepository = ref.read(fireStoreImpl);

  @override
  Future<DateRecords> build(String playerId) async {
    final List<RecordModel> records = await _fireStoreRepository.getPlayerRecords(playerId);

    return DateRecords(records: records);
  }
}