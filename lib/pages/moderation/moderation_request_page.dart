import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';

class ModerationRequestPage extends StatelessWidget {
  const ModerationRequestPage({super.key, required this.requestId});

  final String requestId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final request = state.findModerationRequest(requestId);
    if (request == null) return const Center(child: Text('Moderation request not found'));
    final course = state.findCourse(request.courseId);
    final isReceived = request.direction == 'received';

    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(request.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            if (course != null) Text('${course.code} • ${course.title}', style: const TextStyle(color: Colors.black87)),
            Text(request.reportSummary),
            const SizedBox(height: 12),
            Text('Status: ${request.status.toUpperCase()}',
                style: const TextStyle(fontWeight: FontWeight.w700, color: Colors.black87)),
            const SizedBox(height: 12),
            if (isReceived)
              Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      label: 'Accept',
                      icon: Icons.check,
                      onPressed: () {
                        context.read<AppState>().updateModerationStatus(request.id, 'accepted');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Request accepted and sender notified.')));
                        context.go('/');
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: PrimaryButton(
                      label: 'Reject',
                      icon: Icons.close,
                      onPressed: () {
                        context.read<AppState>().updateModerationStatus(request.id, 'rejected');
                        ScaffoldMessenger.of(context)
                            .showSnackBar(const SnackBar(content: Text('Request rejected and sender notified.')));
                        context.go('/');
                      },
                    ),
                  ),
                ],
              )
            else
              PrimaryButton(
                label: request.status == 'accepted' ? 'Download syllabus' : 'Back to dashboard',
                onPressed: () {
                  if (request.status == 'accepted') {
                    ScaffoldMessenger.of(context)
                        .showSnackBar(const SnackBar(content: Text('Downloading syllabus (fake action)...')));
                  } else {
                    context.go('/');
                  }
                },
              ),
          ],
        ),
      ),
    );
  }
}
