import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/fake_data.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/status_badge.dart';

class IssueListPage extends StatelessWidget {
  const IssueListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final issues = context.watch<AppState>().issues;
    final courseIssues = issues.where((i) => i.relatedCourseId != null).toList();
    final programIssues = issues.where((i) => i.relatedProgramId != null && i.relatedCourseId == null).toList();
    final generalIssues =
        issues.where((i) => i.relatedCourseId == null && i.relatedProgramId == null).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Align(
            alignment: Alignment.centerRight,
            child: PrimaryButton(
              label: 'Create Issue',
              icon: Icons.add,
              onPressed: () => context.go('/issues/new'),
            ),
          ),
          const SizedBox(height: 16),
          _IssueSection(title: 'Course Issues', issues: courseIssues),
          const SizedBox(height: 16),
          _IssueSection(title: 'Program Issues', issues: programIssues),
          const SizedBox(height: 16),
          _IssueSection(title: 'General Issues', issues: generalIssues),
        ],
      ),
    );
  }
}

class _IssueSection extends StatelessWidget {
  const _IssueSection({required this.title, required this.issues});

  final String title;
  final List<Issue> issues;

  @override
  Widget build(BuildContext context) {
    if (issues.isEmpty) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          const Text('No issues in this category.'),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = constraints.maxWidth > 1100
                ? 3
                : constraints.maxWidth > 800
                    ? 2
                    : 1;
            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: issues.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: 14,
                mainAxisSpacing: 14,
                childAspectRatio: 1.4,
              ),
              itemBuilder: (context, index) {
                final issue = issues[index];
                return _IssueCard(issue: issue);
              },
            );
          },
        ),
      ],
    );
  }
}

class _IssueCard extends StatelessWidget {
  const _IssueCard({required this.issue});

  final Issue issue;

  @override
  Widget build(BuildContext context) {
    final related = issue.relatedCourseId != null
        ? 'Course ${issue.relatedCourseId}'
        : issue.relatedProgramId != null
            ? 'Program ${issue.relatedProgramId}'
            : 'General';
    final descPreview = issue.description.split('\n').first;

    return InkWell(
      onTap: () => context.go('/issues/${issue.id}'),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade300),
          color: Colors.white,
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(issue.title,
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis),
                ),
                StatusBadge(label: issue.status),
              ],
            ),
            const SizedBox(height: 6),
            Text(descPreview, maxLines: 2, overflow: TextOverflow.ellipsis),
            const Spacer(),
            const Divider(),
            const SizedBox(height: 6),
            Text('Priority: ${issue.priority}', style: const TextStyle(fontWeight: FontWeight.w600)),
            Text('Owner: ${issue.owner}', style: const TextStyle(color: Colors.black87)),
            Text('Related: $related', style: const TextStyle(color: Colors.black54)),
          ],
        ),
      ),
    );
  }
}
