import 'package:curriculum_prototype/data/fake_data.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/status_badge.dart';

class SingleReportPage extends StatelessWidget {
  const SingleReportPage({super.key, required this.reportId});

  final String reportId;

  @override
  Widget build(BuildContext context) {
    final report = context.watch<AppState>().reports.firstWhere(
      (r) => r.id == reportId,
      orElse: () => const GenericReport(
        id: 'missing',
        title: 'Report not found',
        type: 'N/A',
        related: '-',
        status: 'N/A',
        body: 'No report available',
      ),
    );

    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              report.title,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text('Type: ${report.type}'),
            const SizedBox(height: 4),
            Text('Related: ${report.related}'),
            const SizedBox(height: 8),
            StatusBadge(label: report.status),
            const SizedBox(height: 14),
            Text(report.body),
          ],
        ),
      ),
    );
  }
}
