import 'package:flutter/material.dart';
import '../../data/medicine_model.dart';

class MedicineTile extends StatelessWidget {
  final MedicineModel medicine;
  final VoidCallback onEdit;

  const MedicineTile({
    super.key,
    required this.medicine,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        title: Text(
          medicine.name,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Text("Dose: ${medicine.dose}\nTime: ${medicine.timeLabel}"),
        isThreeLine: true,
        trailing: IconButton(
          onPressed: onEdit,
          icon: const Icon(Icons.edit, color: Colors.teal),
        ),
      ),
    );
  }
}
