import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';

class MeetingListPage extends StatelessWidget {
  const MeetingListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final meetings = [...context.watch<AppState>().meetings]..sort((a, b) => a.dateTime.compareTo(b.dateTime));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Align(
          alignment: Alignment.centerRight,
          child: PrimaryButton(
            label: 'Create Meeting',
            icon: Icons.add,
            onPressed: () => context.go('/meetings/new'),
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: ListView.separated(
            itemCount: meetings.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final meeting = meetings[index];
              return AppCard(
                child: ListTile(
                  title: Text(meeting.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                  subtitle: Text('${meeting.dateTime.toLocal()}\nParticipants: ${meeting.participants.join(', ')}'),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: const Icon(Icons.arrow_forward_ios, size: 16),
                    onPressed: () => context.go('/meetings/${meeting.id}'),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
