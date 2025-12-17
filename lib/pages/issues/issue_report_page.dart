import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/text_field.dart';

class IssueReportPage extends StatefulWidget {
  const IssueReportPage({super.key, required this.issueId});

  final String issueId;

  @override
  State<IssueReportPage> createState() => _IssueReportPageState();
}

class _IssueReportPageState extends State<IssueReportPage> {
  final correctiveCtrl = TextEditingController();
  final followUpCtrl = TextEditingController();

  @override
  void dispose() {
    correctiveCtrl.dispose();
    followUpCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final issue = context.watch<AppState>().findIssue(widget.issueId);
    if (issue == null) return const Center(child: Text('Issue not found'));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Maintenance Report for ${issue.title}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Related to: ${issue.relatedCourseId ?? issue.relatedProgramId ?? 'N/A'}'),
                const SizedBox(height: 12),
                AppTextField(label: 'Corrective actions', controller: correctiveCtrl, maxLines: 3),
                const SizedBox(height: 12),
                AppTextField(label: 'Follow-up plan', controller: followUpCtrl, maxLines: 3),
                const SizedBox(height: 14),
                PrimaryButton(
                  label: 'Submit',
                  onPressed: () {
                    context.read<AppState>().addIssueReport(
                          issueId: issue.id,
                          correctiveActions: correctiveCtrl.text,
                          followUp: followUpCtrl.text,
                        );
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Report submitted (in-memory only)')));
                    context.go('/issues/${issue.id}');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
