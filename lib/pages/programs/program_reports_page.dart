import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_table.dart';
import '../../widgets/ui/status_badge.dart';

class ProgramReportsPage extends StatelessWidget {
  const ProgramReportsPage({super.key, required this.programId});

  final String programId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final reports = state.reportsForProgram(programId);

    if (reports.isEmpty) return const Center(child: Text('No reports yet'));

    return SingleChildScrollView(
      child: AppTable(
        columns: const ['Name', 'Date', 'Status', 'Open'],
        rows: reports
            .map(
              (r) => [
                Text(r.name),
                Text(r.date),
                StatusBadge(label: r.status),
                TextButton(
                  onPressed: () => context.go('/reports/${r.id}'),
                  child: const Text('Open'),
                ),
              ],
            )
            .toList(),
      ),
    );
  }
}
