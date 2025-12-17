import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';

class ProgramVersionsPage extends StatelessWidget {
  const ProgramVersionsPage({super.key, required this.programId});

  final String programId;

  @override
  Widget build(BuildContext context) {
    final versions = context.watch<AppState>().versionsForProgram(programId);
    if (versions.isEmpty) return const Center(child: Text('No versions available'));

    return ListView.separated(
      itemCount: versions.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final v = versions[index];
        return AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(v.version, style: const TextStyle(fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text('Effective: ${v.effectiveDate}'),
              const SizedBox(height: 8),
              Text(v.summary),
            ],
          ),
        );
      },
    );
  }
}
