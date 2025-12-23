import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/text_field.dart';

class CreateIssuePage extends StatefulWidget {
  const CreateIssuePage({super.key});

  @override
  State<CreateIssuePage> createState() => _CreateIssuePageState();
}

class _CreateIssuePageState extends State<CreateIssuePage> {
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final ownerCtrl = TextEditingController(text: 'Quality Office');
  final involvedCtrl = TextEditingController();
  final List<TextEditingController> partyCtrls = [];
  final Set<String> selectedCommittees = {};
  String severity = 'Major';
  String status = 'Open';

  final List<String> committeeOptions = const [
    'Curriculum Committee',
    'Quality Assurance Committee',
    'Academic Council',
    'Assessment Committee',
    'Advisory Board',
  ];

  @override
  void initState() {
    super.initState();
    _addParty();
  }

  @override
  void dispose() {
    titleCtrl.dispose();
    descCtrl.dispose();
    ownerCtrl.dispose();
    involvedCtrl.dispose();
    for (final c in partyCtrls) {
      c.dispose();
    }
    super.dispose();
  }

  void _addParty() => setState(() => partyCtrls.add(TextEditingController()));

  void _removeParty(int index) {
    if (partyCtrls.length == 1) return;
    setState(() {
      partyCtrls[index].dispose();
      partyCtrls.removeAt(index);
    });
  }

  void _submit(AppState state) {
    if (titleCtrl.text.isEmpty || descCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Please fill in title and description')));
      return;
    }
    final parties =
        partyCtrls.map((c) => c.text).where((e) => e.isNotEmpty).toList();
    final committees = selectedCommittees.toList();
    final extraDetails = StringBuffer()
      ..writeln(descCtrl.text)
      ..writeln()
      ..writeln('Involved parties: ${parties.isEmpty ? 'N/A' : parties.join(', ')}')
      ..writeln('Committees: ${committees.isEmpty ? 'N/A' : committees.join(', ')}')
      ..writeln('Owner: ${ownerCtrl.text}');

    state.addIssue(
      title: titleCtrl.text,
      description: extraDetails.toString(),
      relatedCourseId: null,
      relatedProgramId: null,
      status: status,
      severity: severity,
      owner: ownerCtrl.text.isEmpty ? 'Quality Office' : ownerCtrl.text,
    );
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Issue created (in-memory)')));
    context.go('/issues');
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Create Issue', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                AppTextField(label: 'Title', controller: titleCtrl, hint: 'Capstone prerequisite gap'),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Description',
                  controller: descCtrl,
                  maxLines: 3,
                  hint: 'Describe the issue, impact, and context.',
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: severity,
                        decoration: const InputDecoration(labelText: 'Severity'),
                        items: const [
                          DropdownMenuItem(value: 'Major', child: Text('Major')),
                          DropdownMenuItem(value: 'Minor', child: Text('Minor')),
                        ],
                        onChanged: (val) => setState(() => severity = val ?? severity),
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: status,
                        decoration: const InputDecoration(labelText: 'Status'),
                        items: const [
                          DropdownMenuItem(value: 'Open', child: Text('Open')),
                          DropdownMenuItem(value: 'In Progress', child: Text('In Progress')),
                          DropdownMenuItem(value: 'Closed', child: Text('Closed')),
                        ],
                        onChanged: (val) => setState(() => status = val ?? status),
                      ),
                    ),
                    SizedBox(
                      width: 240,
                      child: AppTextField(label: 'Owner', controller: ownerCtrl, hint: 'Quality Office'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Stakeholders & Committees', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Primary involved parties',
                  controller: involvedCtrl,
                  hint: 'e.g., QA Office, Program Chair, Registrar',
                ),
                const SizedBox(height: 12),
                const Text('Additional parties'),
                const SizedBox(height: 8),
                ...List.generate(partyCtrls.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Row(
                      children: [
                        Expanded(
                          child: AppTextField(
                            label: 'Party ${index + 1}',
                            controller: partyCtrls[index],
                            hint: 'Accreditation lead',
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: partyCtrls.length == 1 ? null : () => _removeParty(index),
                        ),
                      ],
                    ),
                  );
                }),
                TextButton.icon(onPressed: _addParty, icon: const Icon(Icons.add), label: const Text('Add party')),
                const SizedBox(height: 8),
                Text('Committees involved', style: TextStyle(color: Colors.grey[800], fontWeight: FontWeight.w600)),
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
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Create Issue',
            onPressed: () => _submit(state),
          ),
        ],
      ),
    );
  }
}
