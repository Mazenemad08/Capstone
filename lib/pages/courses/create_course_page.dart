import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/fake_data.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/text_field.dart';

const List<String> _collegeOptions = ['Engineering', 'Business', 'Multimedia'];

class CreateCoursePage extends StatefulWidget {
  const CreateCoursePage({super.key, this.existingCourse});

  final Course? existingCourse;

  @override
  State<CreateCoursePage> createState() => _CreateCoursePageState();
}

class _CreateCoursePageState extends State<CreateCoursePage> {
  final collegeCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final titleCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final creditsCtrl = TextEditingController(text: '3');
  final prereqCtrl = TextEditingController();
  final hoursCtrl = TextEditingController();
  final nqfLevelCtrl = TextEditingController(text: '7');
  final notionalHoursCtrl = TextEditingController();
  final nqfDescriptorCtrl = TextEditingController();
  final coreTextsCtrl = TextEditingController();
  final recommendedCtrl = TextEditingController();
  final notesCtrl = TextEditingController();
  final specialReqCtrl = TextEditingController();
  final communityCtrl = TextEditingController();
  final policiesCtrl = TextEditingController();

  final Set<String> selectedColleges = {};
  final Set<String> selectedModes = {};
  final List<_CloDefinitionRow> cloDefinitions = [];
  final List<_CloRowData> clos = [];
  final List<_AssessmentRowData> assessments = [];

  final List<String> modeOptions = const [
    'Full Time',
    'Part Time',
    'Evening',
    'Weekend',
    'Online',
    'Hybrid',
    'In-person',
  ];

  @override
  void initState() {
    super.initState();
    selectedColleges.add(_collegeOptions.first);
    _addCloDefinitionRow();
    _addCloDefinitionRow();
    _addCloRow();
    _addCloRow();
    _addAssessmentRow();
    _prefillIfEditing();
  }

  @override
  void dispose() {
    collegeCtrl.dispose();
    codeCtrl.dispose();
    titleCtrl.dispose();
    descCtrl.dispose();
    creditsCtrl.dispose();
    prereqCtrl.dispose();
    hoursCtrl.dispose();
    nqfLevelCtrl.dispose();
    notionalHoursCtrl.dispose();
    nqfDescriptorCtrl.dispose();
    coreTextsCtrl.dispose();
    recommendedCtrl.dispose();
    notesCtrl.dispose();
    specialReqCtrl.dispose();
    communityCtrl.dispose();
    policiesCtrl.dispose();
    for (final def in cloDefinitions) {
      def.dispose();
    }
    for (final clo in clos) {
      clo.dispose();
    }
    for (final assessment in assessments) {
      assessment.dispose();
    }
    super.dispose();
  }

  void _addCloRow() {
    if (clos.length >= 15) return;
    setState(() {
      clos.add(_CloRowData());
    });
  }

  void _removeCloRow(int index) {
    if (clos.length == 1) return;
    setState(() {
      clos[index].dispose();
      clos.removeAt(index);
    });
  }

  void _addAssessmentRow() {
    setState(() {
      assessments.add(_AssessmentRowData());
    });
  }

  void _prefillIfEditing() {
    final course = widget.existingCourse;
    if (course == null) return;
    collegeCtrl.text = course.programId;
    codeCtrl.text = course.code;
    titleCtrl.text = course.title;
    descCtrl.text = course.description;
    creditsCtrl.text = course.credits.toString();
    selectedColleges
      ..clear()
      ..add(course.programId);

    cloDefinitions
      ..clear()
      ..addAll(course.clos.map((c) {
        final row = _CloDefinitionRow();
        row.codeCtrl.text = c.code;
        row.categoryCtrl.text = c.category;
        row.descriptionCtrl.text = c.description;
        row.descriptorCtrl.text = c.descriptor;
        return row;
      }));
    if (cloDefinitions.isEmpty) _addCloDefinitionRow();

    clos
      ..clear()
      ..addAll(course.topics.map((t) {
        final row = _CloRowData();
        row.titleCtrl.text = t.title;
        row.descriptorCtrl.text = t.closCovered;
        row.teachingCtrl.text = t.teachingMethods;
        row.assessmentCtrl.text = t.assessmentMethods;
        return row;
      }));
    if (clos.isEmpty) {
      _addCloRow();
      _addCloRow();
    }

    assessments
      ..clear()
      ..addAll(course.assessments.map((a) {
        final row = _AssessmentRowData();
        row.nameCtrl.text = a.name;
        row.methodCtrl.text = a.method;
        row.type = a.type;
        row.closCtrl.text = a.closAssessed;
        row.descriptionCtrl.text = a.description;
        row.nqfLevelCtrl.text = a.nqfLevel;
        row.weightCtrl.text = a.weight;
        return row;
      }));
    if (assessments.isEmpty) _addAssessmentRow();
  }

  void _removeAssessmentRow(int index) {
    if (assessments.length == 1) return;
    setState(() {
      assessments[index].dispose();
      assessments.removeAt(index);
    });
  }

  void _addCloDefinitionRow() {
    setState(() {
      cloDefinitions.add(_CloDefinitionRow());
    });
  }

  void _removeCloDefinitionRow(int index) {
    if (cloDefinitions.length == 1) return;
    setState(() {
      cloDefinitions[index].dispose();
      cloDefinitions.removeAt(index);
    });
  }

  void _showSnack(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  void _handleSave() {
    if (codeCtrl.text.isEmpty || titleCtrl.text.isEmpty) {
      _showSnack('Please add at least a code and title.');
      return;
    }
    if (selectedColleges.isEmpty) {
      _showSnack('Select at least one college.');
      return;
    }

    final credits = int.tryParse(creditsCtrl.text) ?? 3;
    final programId = selectedColleges.first;
    final closDefined = cloDefinitions
        .where((c) => c.codeCtrl.text.isNotEmpty || c.descriptionCtrl.text.isNotEmpty)
        .map(
          (c) => CourseClo(
            code: c.codeCtrl.text,
            description: c.descriptionCtrl.text,
            descriptor: c.descriptorCtrl.text,
            category: c.categoryCtrl.text,
          ),
        )
        .toList();
    final topics = clos
        .where((c) => c.titleCtrl.text.isNotEmpty)
        .map(
          (c) => WeeklyTopic(
            title: c.titleCtrl.text,
            closCovered: c.descriptorCtrl.text,
            teachingMethods: c.teachingCtrl.text,
            assessmentMethods: c.assessmentCtrl.text,
          ),
        )
        .toList();
    final assessmentItems = assessments
        .where((a) => a.nameCtrl.text.isNotEmpty)
        .map(
          (a) => AssessmentItem(
            name: a.nameCtrl.text,
            method: a.methodCtrl.text,
            type: a.type,
            closAssessed: a.closCtrl.text,
            description: a.descriptionCtrl.text,
            nqfLevel: a.nqfLevelCtrl.text,
            weight: a.weightCtrl.text,
          ),
        )
        .toList();

    final state = context.read<AppState>();
    if (widget.existingCourse != null) {
      final original = widget.existingCourse!;
      state.updateCourse(
        id: original.id,
        code: codeCtrl.text,
        title: titleCtrl.text,
        description: descCtrl.text,
        programId: programId,
        instructor: original.instructor,
        semester: original.semester,
        credits: credits,
        clos: closDefined,
        topics: topics,
        assessments: assessmentItems,
      );
      state.addIssue(
        title: 'Course change: ${original.code}',
        description:
            'Course updated.\nOld: ${original.code} ${original.title}, credits ${original.credits}.\nNew: ${codeCtrl.text} ${titleCtrl.text}, credits $credits.\nChanges include syllabus fields; review and accept/reject in moderation.',
        relatedCourseId: original.id,
        relatedProgramId: null,
        status: 'Open',
        priority: 'High',
        owner: 'University Success Committee',
      );
      _showSnack('Course updated and issue created for moderation.');
      context.go('/courses/${original.id}');
    } else {
      state.addCourse(
        code: codeCtrl.text,
        title: titleCtrl.text,
        description: descCtrl.text,
        programId: programId,
        instructor: 'TBD',
        semester: 'TBD',
        credits: credits,
        clos: closDefined,
        topics: topics,
        assessments: assessmentItems,
      );

      _showSnack('Course created with syllabus details captured.');
      context.go('/courses');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(widget.existingCourse == null ? 'Create Course' : 'Edit Course',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Identity & Logistics',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: 320,
                      child: AppTextField(
                        label: 'College / Division',
                        controller: collegeCtrl,
                        hint: 'Engineering and Computing',
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: AppTextField(
                        label: 'Course Code',
                        controller: codeCtrl,
                        hint: 'CYBR 310',
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: AppTextField(
                        label: 'Course Title',
                        controller: titleCtrl,
                        hint: 'Introduction to Cybersecurity',
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: AppTextField(
                        label: 'Credits',
                        controller: creditsCtrl,
                        hint: '3',
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: AppTextField(
                        label: 'Pre-requisites',
                        controller: prereqCtrl,
                        hint: 'CMPE 215',
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: AppTextField(
                        label: 'Number of Hours (contact)',
                        controller: hoursCtrl,
                        hint: '45',
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: AppTextField(
                        label: 'NQF Level',
                        controller: nqfLevelCtrl,
                        hint: '7',
                      ),
                    ),
                    SizedBox(
                      width: 320,
                      child: AppTextField(
                        label: 'Notional Hours',
                        controller: notionalHoursCtrl,
                        hint: '120',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text('Colleges', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _collegeOptions
                      .map((college) => ChoiceChip(
                            label: Text(college),
                            selected: selectedColleges.contains(college),
                            onSelected: (selected) {
                              setState(() {
                                if (selected) {
                                  selectedColleges.add(college);
                                } else {
                                  selectedColleges.remove(college);
                                }
                              });
                            },
                          ))
                      .toList(),
                ),
                const SizedBox(height: 12),
                Text('Modes of Attendance', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey[800])),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: modeOptions
                      .map(
                        (mode) => FilterChip(
                          label: Text(mode),
                          selected: selectedModes.contains(mode),
                          onSelected: (selected) {
                            setState(() {
                              selected ? selectedModes.add(mode) : selectedModes.remove(mode);
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Course Description',
                  controller: descCtrl,
                  maxLines: 4,
                  hint:
                      'Overview, aims, and the importance of the course. Example: cybersecurity concepts, policies, and practices.',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'CLO - NQF Descriptor (summary)',
                  controller: nqfDescriptorCtrl,
                  maxLines: 2,
                  hint: 'Knowledge – Theoretical Understanding (Level 7), Applied Knowledge, Skills.',
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                const Text('Course Learning Outcomes',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'Capture CLO codes (A1, B1, etc.), their descriptions, and NQF descriptors.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                ...List.generate(cloDefinitions.length, (index) {
                  final def = cloDefinitions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('CLO ${index + 1}',
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: cloDefinitions.length == 1 ? null : () => _removeCloDefinitionRow(index),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: 160,
                              child: AppTextField(
                                label: 'Code',
                                controller: def.codeCtrl,
                                hint: 'A1',
                              ),
                            ),
                            SizedBox(
                              width: 220,
                              child: AppTextField(
                                label: 'Category (optional)',
                                controller: def.categoryCtrl,
                                hint: 'A. Knowledge',
                              ),
                            ),
                            SizedBox(
                              width: 320,
                              child: AppTextField(
                                label: 'Description',
                                controller: def.descriptionCtrl,
                                hint: 'Demonstrate advanced knowledge of ...',
                              ),
                            ),
                            SizedBox(
                              width: 320,
                              child: AppTextField(
                                label: 'NQF Descriptor / Level',
                                controller: def.descriptorCtrl,
                                hint: 'Knowledge – Theoretical Understanding (Level 7)',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addCloDefinitionRow,
                    icon: const Icon(Icons.add),
                    label: const Text('Add CLO'),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 12),
                const Text('Weekly Topics & CLO Mapping',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'Capture up to 15 weekly topics and map which CLOs they address.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                ...List.generate(clos.length, (index) {
                  final clo = clos[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Topic ${index + 1}',
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: clos.length == 1 ? null : () => _removeCloRow(index),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: 320,
                              child: AppTextField(
                                label: 'Topic Title',
                                controller: clo.titleCtrl,
                                hint: 'Risk Management, Cryptography, Network Security',
                              ),
                            ),
                            SizedBox(
                              width: 320,
                              child: AppTextField(
                                label: 'CLOs covered',
                                controller: clo.descriptorCtrl,
                                hint: 'A1, A2, B1, B2',
                              ),
                            ),
                            SizedBox(
                              width: 320,
                              child: AppTextField(
                                label: 'Teaching Methods',
                                controller: clo.teachingCtrl,
                                hint: 'Lecture, Discussion, Lab exercises',
                              ),
                            ),
                            SizedBox(
                              width: 320,
                              child: AppTextField(
                                label: 'Assessment Methods',
                                controller: clo.assessmentCtrl,
                                hint: 'In-class exercises, Tutorial, Midterm',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: clos.length >= 15 ? null : _addCloRow,
                    icon: const Icon(Icons.add),
                    label: Text('Add Topic (${clos.length}/15)'),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 12),
                const Text('Assessment & Weighting',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(
                  'Map each assessment to its method, CLOs assessed, NQF level, and weight.',
                  style: TextStyle(color: Colors.grey[700]),
                ),
                const SizedBox(height: 12),
                ...List.generate(assessments.length, (index) {
                  final assessment = assessments[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.grey.shade50,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Text('Assessment ${index + 1}',
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            const Spacer(),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: assessments.length == 1 ? null : () => _removeAssessmentRow(index),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 12,
                          runSpacing: 12,
                          children: [
                            SizedBox(
                              width: 280,
                              child: AppTextField(
                                label: 'Name / Amount',
                                controller: assessment.nameCtrl,
                                hint: 'Lab Exercises',
                              ),
                            ),
                            SizedBox(
                              width: 280,
                              child: AppTextField(
                                label: 'Method',
                                controller: assessment.methodCtrl,
                                hint: 'Practical lab tasks',
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: DropdownButtonFormField<String>(
                                value: assessment.type,
                                decoration: const InputDecoration(labelText: 'Formative / Summative'),
                                items: const [
                                  DropdownMenuItem(value: 'Formative', child: Text('Formative')),
                                  DropdownMenuItem(value: 'Summative', child: Text('Summative')),
                                ],
                                onChanged: (val) => setState(() => assessment.type = val ?? 'Summative'),
                              ),
                            ),
                            SizedBox(
                              width: 200,
                              child: AppTextField(
                                label: 'CLOs assessed',
                                controller: assessment.closCtrl,
                                hint: 'A1, A2, B1',
                              ),
                            ),
                            SizedBox(
                              width: 320,
                              child: AppTextField(
                                label: 'Description',
                                controller: assessment.descriptionCtrl,
                                hint: 'Hands-on labs to apply network security controls',
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: AppTextField(
                                label: 'NQF Level',
                                controller: assessment.nqfLevelCtrl,
                                hint: '7',
                              ),
                            ),
                            SizedBox(
                              width: 150,
                              child: AppTextField(
                                label: 'Weight (%)',
                                controller: assessment.weightCtrl,
                                hint: '15',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                }),
                Align(
                  alignment: Alignment.centerLeft,
                  child: TextButton.icon(
                    onPressed: _addAssessmentRow,
                    icon: const Icon(Icons.add),
                    label: const Text('Add assessment item'),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 12),
                const Text('Resources & Policies',
                    style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Core texts',
                  controller: coreTextsCtrl,
                  maxLines: 3,
                  hint: 'Intro to Cybersecurity: A Multidisciplinary Challenge, 2024',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Recommended books',
                  controller: recommendedCtrl,
                  maxLines: 3,
                  hint: 'Whitman & Mattord: Principles of Information Security, 7th Ed.',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Course notes',
                  controller: notesCtrl,
                  maxLines: 3,
                  hint: 'Shared through Canvas and Microsoft Teams',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Special requirements (software, periodicals, etc.)',
                  controller: specialReqCtrl,
                  maxLines: 2,
                  hint: 'Wireshark, Ubuntu, Netcat, Open Source tools',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Community-based facilities (guests, field visits)',
                  controller: communityCtrl,
                  maxLines: 2,
                  hint: 'None or list of labs/partners',
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Course Policies',
                  controller: policiesCtrl,
                  maxLines: 4,
                  hint:
                      'Attendance, credit hours policy, submission requirements, expectations, makeup rules.',
                ),
                const SizedBox(height: 20),
                PrimaryButton(label: 'Create Course', onPressed: _handleSave),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CloRowData {
  final TextEditingController titleCtrl = TextEditingController();
  final TextEditingController descriptorCtrl = TextEditingController();
  final TextEditingController teachingCtrl = TextEditingController();
  final TextEditingController assessmentCtrl = TextEditingController();

  void dispose() {
    titleCtrl.dispose();
    descriptorCtrl.dispose();
    teachingCtrl.dispose();
    assessmentCtrl.dispose();
  }
}

class _AssessmentRowData {
  final TextEditingController nameCtrl = TextEditingController();
  final TextEditingController methodCtrl = TextEditingController();
  final TextEditingController closCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController nqfLevelCtrl = TextEditingController();
  final TextEditingController weightCtrl = TextEditingController();
  String type = 'Summative';

  void dispose() {
    nameCtrl.dispose();
    methodCtrl.dispose();
    closCtrl.dispose();
    descriptionCtrl.dispose();
    nqfLevelCtrl.dispose();
    weightCtrl.dispose();
  }
}

class _CloDefinitionRow {
  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController categoryCtrl = TextEditingController();
  final TextEditingController descriptionCtrl = TextEditingController();
  final TextEditingController descriptorCtrl = TextEditingController();

  void dispose() {
    codeCtrl.dispose();
    categoryCtrl.dispose();
    descriptionCtrl.dispose();
    descriptorCtrl.dispose();
  }
}
