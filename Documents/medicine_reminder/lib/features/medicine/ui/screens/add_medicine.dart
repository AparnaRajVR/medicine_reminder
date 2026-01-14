import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/medicine_model.dart';
import '../../logic/medicine_provider.dart';

class AddMedicineScreen extends ConsumerStatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  ConsumerState<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends ConsumerState<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _doseController = TextEditingController();

  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _saveMedicine() async {
    final isValid = _formKey.currentState?.validate() ?? false;

    if (!isValid) return;

    if (_selectedTime == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Please select a time")));
      return;
    }

    final id = DateTime.now().millisecondsSinceEpoch ~/ 1000;

    final medicine = MedicineModel(
      id: id,
      name: _nameController.text.trim(),
      dose: _doseController.text.trim(),
      hour: _selectedTime!.hour,
      minute: _selectedTime!.minute,
    );

    await ref.read(medicineProvider.notifier).addMedicine(medicine);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Medicine saved ")));

    //  instantly go back
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final timeText = _selectedTime == null
        ? "Select Time"
        : _selectedTime!.format(context);

    return Scaffold(
      appBar: AppBar(title: const Text("Add Medicine")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Medicine Name"),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter medicine name";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(
                  labelText: "Dose (eg: 1 tablet)",
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return "Please enter dose";
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              InkWell(
                onTap: _pickTime,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 16,
                  ),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.grey.shade400),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [Text(timeText), const Icon(Icons.access_time)],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMedicine,
                  child: const Text("Save Medicine"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
