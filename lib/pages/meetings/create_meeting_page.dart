import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/fake_data.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/text_field.dart';

class CreateMeetingPage extends StatefulWidget {
  const CreateMeetingPage({super.key});

  @override
  State<CreateMeetingPage> createState() => _CreateMeetingPageState();
}

class _CreateMeetingPageState extends State<CreateMeetingPage> {
  final titleCtrl = TextEditingController();
  final dateCtrl = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
  final timeCtrl = TextEditingController(text: '10:00');
  final participantsCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final agendaCtrl = TextEditingController();
  final Set<String> selectedIssues = {};
  final Set<String> selectedCommittees = {};

  final List<String> committeeOptions = const [
    'Curriculum Committee',
    'Quality Assurance Committee',
    'Academic Council',
    'Assessment Committee',
    'Advisory Board',
    'University Success Committee',
  ];

  @override
  void dispose() {
    titleCtrl.dispose();
    dateCtrl.dispose();
    timeCtrl.dispose();
    participantsCtrl.dispose();
    notesCtrl.dispose();
    agendaCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Create Meeting', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            AppTextField(label: 'Title', controller: titleCtrl, hint: 'Curriculum sync'),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: AppTextField(label: 'Date', controller: dateCtrl, hint: '2024-11-01')),
                const SizedBox(width: 12),
                Expanded(child: AppTextField(label: 'Time', controller: timeCtrl, hint: '10:00')),
              ],
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Participants',
              controller: participantsCtrl,
              hint: 'Comma separated names',
            ),
            const SizedBox(height: 12),
            AppTextField(
              label: 'Agenda',
              controller: agendaCtrl,
              maxLines: 3,
              hint: 'Key discussion items',
            ),
            const SizedBox(height: 12),
            const Text('Link issues', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: state.issues
                  .map(
                    (i) => FilterChip(
                      label: Text('${i.id} - ${i.title}'),
                      selected: selectedIssues.contains(i.id),
                      onSelected: (selected) {
                        setState(() {
                          selected ? selectedIssues.add(i.id) : selectedIssues.remove(i.id);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            const Text('Committees to attend', style: TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: committeeOptions
                  .map(
                    (c) => FilterChip(
                      label: Text(c),
                      selected: selectedCommittees.contains(c),
                      onSelected: (selected) {
                        setState(() {
                          selected ? selectedCommittees.add(c) : selectedCommittees.remove(c);
                        });
                      },
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 12),
            AppTextField(label: 'Notes', controller: notesCtrl, maxLines: 3),
            const SizedBox(height: 16),
            PrimaryButton(
              label: 'Save Meeting',
              onPressed: () {
                final date = DateTime.tryParse('${dateCtrl.text}T${timeCtrl.text}') ?? DateTime.now();
                final participants = participantsCtrl.text.isEmpty
                    ? <String>['QA Officer', 'Program Chair']
                    : participantsCtrl.text.split(',').map((e) => e.trim()).toList();
                final meeting = Meeting(
                  id: 'm${state.meetings.length + 1}',
                  title: titleCtrl.text.isEmpty ? 'Untitled meeting' : titleCtrl.text,
                  dateTime: date,
                  participants: participants,
                  relatedCourseId: null,
                  relatedProgramId: null,
                  relatedIssueIds: selectedIssues.toList(),
                  minutes: [
                    if (agendaCtrl.text.isNotEmpty) 'Agenda: ${agendaCtrl.text}',
                    if (selectedCommittees.isNotEmpty)
                      'Committees: ${selectedCommittees.join(', ')}',
                    if (notesCtrl.text.isNotEmpty) 'Notes: ${notesCtrl.text}',
                  ],
                );
                context.read<AppState>().addMeeting(meeting);
                ScaffoldMessenger.of(context)
                    .showSnackBar(const SnackBar(content: Text('Meeting created (in-memory)')));
                context.go('/meetings');
              },
            ),
          ],
        ),
      ),
    );
  }
}
