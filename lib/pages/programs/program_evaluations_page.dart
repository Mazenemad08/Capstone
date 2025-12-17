import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/text_field.dart';

class ProgramEvaluationsPage extends StatelessWidget {
  const ProgramEvaluationsPage({super.key, required this.programId});

  final String programId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final program = state.findProgram(programId);
    final evaluations = state.programEvaluationsFor(programId);
    if (program == null) return const Center(child: Text('Program not found'));

    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Evaluations for ${program.code} – ${program.name}',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            PrimaryButton(
              label: 'Add Evaluation',
              onPressed: () => _openDialog(context),
            ),
            const SizedBox(height: 12),
            if (evaluations.isEmpty)
              const Text('No evaluations yet.')
            else
              ...evaluations.map(
                (e) => ListTile(
                  title: Text('Version ${e.version}'),
                  subtitle: Text(e.notes),
                  trailing: Text(e.date),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _openDialog(BuildContext context) async {
    final versionCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));

    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Add Program Evaluation'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(label: 'Version', controller: versionCtrl, hint: 'v2.2'),
                const SizedBox(height: 12),
                AppTextField(label: 'Date', controller: dateCtrl, hint: '2024-12-01'),
                const SizedBox(height: 12),
                AppTextField(label: 'Notes', controller: notesCtrl, maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Cancel')),
            PrimaryButton(
              label: 'Save',
              onPressed: () {
                context.read<AppState>().addProgramEvaluation(
                      programId: programId,
                      version: versionCtrl.text,
                      notes: notesCtrl.text,
                      date: dateCtrl.text,
                    );
                Navigator.of(dialogCtx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
