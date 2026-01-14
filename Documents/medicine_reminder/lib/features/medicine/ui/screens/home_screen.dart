import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medicine_reminder/features/medicine/logic/medicine_provider.dart';
import 'package:medicine_reminder/features/medicine/ui/screens/add_medicine.dart';
import 'package:medicine_reminder/features/medicine/ui/screens/edit_medicine.dart';
import 'package:medicine_reminder/features/medicine/ui/widgets/medicine_tile.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final medicinesAsync = ref.watch(medicineProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Medicine Reminder")),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const AddMedicineScreen()),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: medicinesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text("Error: $e")),
        data: (medicines) {
          if (medicines.isEmpty) {
            return const Center(
              child: Text(
                "No medicines added yet.\nTap + to add your first medicine.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(12),
            itemCount: medicines.length,
            separatorBuilder: (_, __) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final item = medicines[index];

              return Dismissible(
                key: ValueKey(item.id),
                direction: DismissDirection.endToStart,
                background: Container(
                  alignment: Alignment.centerRight,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                confirmDismiss: (_) async {
                  return await showDialog<bool>(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text("Remove medicine?"),
                      content: Text("Do you want to remove ${item.name}?"),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text("Cancel"),
                        ),
                        ElevatedButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text("Remove"),
                        ),
                      ],
                    ),
                  );
                },
                onDismissed: (_) {
                  ref.read(medicineProvider.notifier).deleteMedicine(item.id);

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("${item.name} removed ")),
                  );
                },
                child: MedicineTile(
                  medicine: item,
                  onEdit: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => EditMedicineScreen(medicine: item),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
