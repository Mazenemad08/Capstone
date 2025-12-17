import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../data/fake_data.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/stat_card.dart';
import '../../widgets/ui/app_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final stats = [
      ('Total Courses', state.totalCourses.toString(), '+2 from last month'),
      ('Total Programs', state.totalPrograms.toString(), '+1 from last month'),
      ('Open Issues', state.openIssues.toString(), 'Monitoring quality actions'),
      ('Upcoming Meetings', state.upcomingMeetings.toString(), 'Next 30 days'),
    ];
    final sent = state.moderationRequests.where((m) => m.direction == 'sent').toList();
    final received = state.moderationRequests.where((m) => m.direction == 'received').toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 2.2,
            ),
            itemCount: stats.length,
            itemBuilder: (context, index) {
              final item = stats[index];
              return StatCard(label: item.$1, value: item.$2, delta: item.$3);
            },
          ),
          const SizedBox(height: 20),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Moderation', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                const SizedBox(height: 8),
                Text(
                  'Track reports you sent for moderation and requests awaiting your action.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _ModerationList(title: 'Sent', items: sent, sentList: true)),
                    const SizedBox(width: 16),
                    Expanded(child: _ModerationList(title: 'Received', items: received, sentList: false)),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Recent activity', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                SizedBox(height: 8),
                Text('All dummy data, showing how a feed could look.'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ModerationList extends StatelessWidget {
  const _ModerationList({required this.title, required this.items, required this.sentList});

  final String title;
  final List<ModerationRequest> items;
  final bool sentList;

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        if (items.isEmpty)
          const Text('No requests.')
        else
          ...items.map((m) {
            final course = context.read<AppState>().findCourse(m.courseId);
            final statusColor = _statusColor(m.status);
            return Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(10),
                color: Colors.grey.shade50,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          m.title,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          m.status.toUpperCase(),
                          style: TextStyle(color: statusColor, fontWeight: FontWeight.w700, fontSize: 12),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  if (course != null) Text('${course.code} • ${course.title}', style: const TextStyle(color: Colors.black87)),
                  Text(m.reportSummary, style: const TextStyle(color: Colors.black54)),
                  const SizedBox(height: 8),
                  if (sentList)
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PrimaryButton(
                        label: m.status == 'accepted' ? 'Download syllabus' : 'View status',
                        onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(m.status == 'accepted' ? 'Downloading syllabus...' : 'Still pending.')),
                        ),
                      ),
                    )
                  else
                    Align(
                      alignment: Alignment.centerLeft,
                      child: PrimaryButton(
                        label: 'View report',
                        onPressed: () => context.go('/moderation/${m.id}'),
                      ),
                    ),
                ],
              ),
            );
          }),
      ],
    );
  }
}
