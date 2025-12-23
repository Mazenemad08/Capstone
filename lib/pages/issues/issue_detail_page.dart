import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/status_badge.dart';

class IssueDetailPage extends StatelessWidget {
  const IssueDetailPage({super.key, required this.issueId});

  final String issueId;

  @override
  Widget build(BuildContext context) {
    final issue = context.watch<AppState>().findIssue(issueId);
    if (issue == null) return const Center(child: Text('Issue not found'));
    final isLinked =
        issue.relatedCourseId != null || issue.relatedProgramId != null;

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
                    Text(
                      issue.title,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(issue.description),
                    const SizedBox(height: 8),
                    StatusBadge(label: issue.status),
                    const SizedBox(height: 6),
                    Text('Severity: ${issue.severity}'),
                    Text('Owner: ${issue.owner}'),
                    if (issue.relatedCourseId != null)
                      Text('Course: ${issue.relatedCourseId}'),
                    if (issue.relatedProgramId != null)
                      Text('Program: ${issue.relatedProgramId}'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (isLinked) ...[
            const Text(
              'Issue Pipeline',
              style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _Pipeline(status: issue.status),
            const SizedBox(height: 16),
          ],
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'History / Comments',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                SizedBox(height: 8),
                Text('• Initial report filed by QA Officer'),
                Text('• Pending prerequisites policy update'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _Pipeline extends StatelessWidget {
  const _Pipeline({required this.status});

  final String status;

  int _currentStage() {
    switch (status.toLowerCase()) {
      case 'open':
        return 1;
      case 'in progress':
        return 2;
      case 'closed':
        return 4;
      default:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = _currentStage();
    final stages = ['Stage 1', 'Stage 2', 'Stage 3', 'Stage 4'];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: List.generate(stages.length, (index) {
        final active = index + 1 <= current;
        return Expanded(
          child: Column(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: active ? Colors.green : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              const SizedBox(height: 6),
              Text(
                stages[index],
                style: TextStyle(
                  color: active ? Colors.green.shade700 : Colors.black54,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
