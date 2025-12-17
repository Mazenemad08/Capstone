import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/fake_data.dart';
import '../../widgets/ui/app_tabs.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/status_badge.dart';
import '../../widgets/ui/text_field.dart';

class ProgramDetailPage extends StatelessWidget {
  const ProgramDetailPage({super.key, required this.programId});

  final String programId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final program = state.findProgram(programId);
    final profile = state.findProgramProfile(programId);
    if (program == null) return const Center(child: Text('Program not found'));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(program.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 6),
                    Text(program.description),
                    const SizedBox(height: 10),
                    StatusBadge(label: program.accreditationStatus),
                  ],
                ),
              ),
              Wrap(
                spacing: 10,
                children: [
                  PrimaryButton(
                    label: 'See Previous Versions',
                    icon: Icons.history,
                    onPressed: () => context.go('/programs/${program.id}/versions'),
                  ),
                  PrimaryButton(
                    label: 'Download Program Report',
                    icon: Icons.download,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Downloading program report (fake action)...')),
                    ),
                  ),
                  PrimaryButton(
                    label: 'Edit Program',
                    icon: Icons.edit,
                    onPressed: () => context.go('/programs/${program.id}/edit'),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 10,
            children: [
              PrimaryButton(
                label: 'Add Evaluation',
                onPressed: () => _showAddEvaluationDialog(context, program.id),
              ),
              PrimaryButton(
                label: 'View Evaluations',
                icon: Icons.list_alt,
                onPressed: () => context.go('/programs/${program.id}/evaluations'),
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppTabs(
            tabs: [
              AppTab(label: 'Overview', content: _Overview(program: program, profile: profile)),
              AppTab(label: 'Objectives', content: _ObjectivesTab(profile: profile)),
              AppTab(label: 'Outcomes', content: _OutcomesTab(profile: profile)),
              AppTab(label: 'Structure', content: _StructureTab(profile: profile)),
              AppTab(label: 'Files', content: _LinkList(label: 'View program files', onTap: () => context.go('/programs/${program.id}/files'))),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _showAddEvaluationDialog(BuildContext context, String programId) async {
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

class _LinkList extends StatelessWidget {
  const _LinkList({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: ListTile(
        title: Text(label),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}

class _Overview extends StatelessWidget {
  const _Overview({required this.program, required this.profile});

  final Program program;
  final ProgramProfile? profile;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Code: ${program.code}'),
          Text('Department: ${program.department}'),
          Text('College: ${program.college}'),
          Text('Level: ${program.level}'),
          const SizedBox(height: 10),
          Text('Graduate profile:',
              style: const TextStyle(fontWeight: FontWeight.w700)),
          Text(profile?.graduateProfile ?? 'N/A'),
        ],
      ),
    );
  }
}

class _ObjectivesTab extends StatelessWidget {
  const _ObjectivesTab({required this.profile});
  final ProgramProfile? profile;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Objectives', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          if (profile?.objectives.isEmpty ?? true) const Text('No objectives captured.')
          else
            ...profile!.objectives.map((o) => Text('• $o')),
          const SizedBox(height: 12),
          const Text('Why take this program?', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(profile?.whyTake ?? 'N/A'),
          const SizedBox(height: 12),
          const Text('Destinations of graduates', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          if (profile?.destinations.isEmpty ?? true) const Text('No destinations listed.')
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: profile!.destinations.map((d) => Chip(label: Text(d))).toList(),
            ),
        ],
      ),
    );
  }
}

class _OutcomesTab extends StatelessWidget {
  const _OutcomesTab({required this.profile});
  final ProgramProfile? profile;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Program Learning Outcomes (PLOs)', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          if (profile?.plos.isEmpty ?? true) const Text('No PLOs captured.')
          else
            ...profile!.plos.map((p) => Text('${p.code}: ${p.description}')),
          const Divider(height: 24),
          const Text('Program Indicators (PIs)', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          if (profile?.pis.isEmpty ?? true) const Text('No PIs captured.')
          else
            ...profile!.pis.map((p) => Text('${p.code}: ${p.description}')),
          const Divider(height: 24),
          const Text('Institutional Learning Outcomes (ILOs)', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          if (profile?.ilos.isEmpty ?? true) const Text('No ILOs captured.')
          else
            ...profile!.ilos.map((i) => Text('• $i')),
        ],
      ),
    );
  }
}

class _StructureTab extends StatelessWidget {
  const _StructureTab({required this.profile});
  final ProgramProfile? profile;

  @override
  Widget build(BuildContext context) {
    if (profile == null || profile!.structures.isEmpty) {
      return const AppCard(child: Text('No structure captured.'));
    }
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Program Structure', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          ...profile!.structures.map((s) => ListTile(
                title: Text('${s.category}'),
                subtitle: Text('Credits: ${s.credits}'),
                trailing: s.graduatePortfolio ? const Text('Portfolio') : null,
              )),
        ],
      ),
    );
  }
}
