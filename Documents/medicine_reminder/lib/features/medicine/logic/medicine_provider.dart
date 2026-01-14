import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_reminder/core/notification/notification_service.dart';

import '../data/medicine_hive_service.dart';
import '../data/medicine_model.dart';

final medicineProvider =
    AsyncNotifierProvider<MedicineNotifier, List<MedicineModel>>(
      MedicineNotifier.new,
    );

class MedicineNotifier extends AsyncNotifier<List<MedicineModel>> {
  late final MedicineHiveService _hive;

  @override
  Future<List<MedicineModel>> build() async {
    _hive = MedicineHiveService();
    final medicines = await _hive.getMedicines();
    medicines.sort(_sortByTime);
    return medicines;
  }

  Future<void> reload() async {
    state = const AsyncLoading();
    state = AsyncData(await build());
  }

  Future<void> addMedicine(MedicineModel medicine) async {
    final current = state.value ?? [];
    final updated = [...current, medicine]..sort(_sortByTime);

    state = AsyncData(updated);
    await _hive.saveMedicines(updated);

    await NotificationService.scheduleDailyNotification(
      id: medicine.id,
      title: "Medicine Reminder",
      body: "${medicine.name} - ${medicine.dose} at ${medicine.timeLabel}",
      hour: medicine.hour,
      minute: medicine.minute,
    );
  }

  Future<void> deleteMedicine(int id) async {
    final current = state.value ?? [];
    final updated = current.where((m) => m.id != id).toList()
      ..sort(_sortByTime);

    state = AsyncData(updated);
    await _hive.saveMedicines(updated);
    await NotificationService.cancelNotification(id);
  }

  Future<void> updateMedicine(MedicineModel updatedMedicine) async {
    final current = state.value ?? [];

    final updated = current.map((m) {
      if (m.id == updatedMedicine.id) return updatedMedicine;
      return m;
    }).toList()..sort(_sortByTime);

    state = AsyncData(updated);
    await _hive.saveMedicines(updated);

    await NotificationService.cancelNotification(updatedMedicine.id);
    await NotificationService.scheduleDailyNotification(
      id: updatedMedicine.id,
      title: "Medicine Reminder",
      body:
          "${updatedMedicine.name} - ${updatedMedicine.dose} at ${updatedMedicine.timeLabel}",
      hour: updatedMedicine.hour,
      minute: updatedMedicine.minute,
    );
  }

  static int _sortByTime(MedicineModel a, MedicineModel b) {
    if (a.hour != b.hour) return a.hour.compareTo(b.hour);
    return a.minute.compareTo(b.minute);
  }
}
