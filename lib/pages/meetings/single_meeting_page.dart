import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';

class SingleMeetingPage extends StatelessWidget {
  const SingleMeetingPage({super.key, required this.meetingId});

  final String meetingId;

  @override
  Widget build(BuildContext context) {
    final meeting = context.watch<AppState>().findMeeting(meetingId);
    if (meeting == null) return const Center(child: Text('Meeting not found'));

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(meeting.title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text('Date: ${meeting.dateTime.toLocal()}'),
          Text('Participants: ${meeting.participants.join(', ')}'),
          if (meeting.relatedCourseId != null) Text('Related course: ${meeting.relatedCourseId}'),
          if (meeting.relatedProgramId != null) Text('Related program: ${meeting.relatedProgramId}'),
          if (meeting.relatedIssueIds.isNotEmpty) Text('Related issues: ${meeting.relatedIssueIds.join(', ')}'),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Meeting Minutes', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                ...meeting.minutes.map((m) => Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: Text('• $m'),
                    )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
