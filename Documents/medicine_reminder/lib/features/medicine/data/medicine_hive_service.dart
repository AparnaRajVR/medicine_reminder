import 'package:hive/hive.dart';
import 'medicine_model.dart';

class MedicineHiveService {
  static const String _boxName = "medicine_box";
  static const String _key = "medicines";

  Future<Box> _openBox() async {
    return await Hive.openBox(_boxName);
  }

  Future<List<MedicineModel>> getMedicines() async {
    final box = await _openBox();
    final List list = box.get(_key, defaultValue: []) as List;

    return list.map((e) => MedicineModel.fromMap(Map.from(e))).toList();
  }

  Future<void> saveMedicines(List<MedicineModel> medicines) async {
    final box = await _openBox();
    final data = medicines.map((e) => e.toMap()).toList();
    await box.put(_key, data);
  }
}
