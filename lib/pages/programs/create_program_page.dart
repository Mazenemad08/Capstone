import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/fake_data.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/text_field.dart';

class CreateProgramPage extends StatefulWidget {
  const CreateProgramPage({
    super.key,
    this.existingProgram,
    this.existingProfile,
  });

  final Program? existingProgram;
  final ProgramProfile? existingProfile;

  @override
  State<CreateProgramPage> createState() => _CreateProgramPageState();
}

class _CreateProgramPageState extends State<CreateProgramPage> {
  final nameCtrl = TextEditingController();
  final codeCtrl = TextEditingController();
  final deptCtrl = TextEditingController();
  final descCtrl = TextEditingController();
  final whyCtrl = TextEditingController();
  final graduateProfileCtrl = TextEditingController();
  String level = 'Undergraduate';
  String accreditation = 'Pending';
  String college = 'Engineering';
  bool graduatePortfolio = true;

  final List<TextEditingController> objectiveCtrls = [];
  final List<TextEditingController> destinationCtrls = [];
  final List<TextEditingController> iloCtrls = [];
  final List<_OutcomeRow> ploRows = [];
  final List<_OutcomeRow> piRows = [];

  final Map<String, _StructureCategory> structures = {
    'General Education': _StructureCategory(),
    'Computing Requirements': _StructureCategory(),
    'Major Requirements': _StructureCategory(),
    'Major Electives': _StructureCategory(),
    'Professional Electives': _StructureCategory(),
  };

  @override
  void dispose() {
    nameCtrl.dispose();
    codeCtrl.dispose();
    deptCtrl.dispose();
    descCtrl.dispose();
    whyCtrl.dispose();
    graduateProfileCtrl.dispose();
    for (final c in objectiveCtrls) c.dispose();
    for (final c in destinationCtrls) c.dispose();
    for (final c in iloCtrls) c.dispose();
    for (final p in ploRows) {
      p.dispose();
    }
    for (final p in piRows) {
      p.dispose();
    }
    for (final s in structures.values) {
      s.dispose();
    }
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    // Initialize credits fields to 0 for all structure categories
    for (final category in structures.values) {
      category.creditsCtrl.text = '0';
    }

    if (widget.existingProgram != null) {
      _prefillIfEditing();
    } else {
      _addObjective();
      _addObjective();
      _addDestination();
      _addPlo();
      _addPlo();
      _addPi();
      _addIlo();
    }
  }

  void _addObjective() =>
      setState(() => objectiveCtrls.add(TextEditingController()));
  void _removeObjective(int index) {
    if (objectiveCtrls.length == 1) return;
    setState(() {
      objectiveCtrls[index].dispose();
      objectiveCtrls.removeAt(index);
    });
  }

  void _addDestination() =>
      setState(() => destinationCtrls.add(TextEditingController()));
  void _removeDestination(int index) {
    if (destinationCtrls.length == 1) return;
    setState(() {
      destinationCtrls[index].dispose();
      destinationCtrls.removeAt(index);
    });
  }

  void _addIlo() => setState(() => iloCtrls.add(TextEditingController()));
  void _removeIlo(int index) {
    if (iloCtrls.length == 1) return;
    setState(() {
      iloCtrls[index].dispose();
      iloCtrls.removeAt(index);
    });
  }

  void _addPlo() => setState(() => ploRows.add(_OutcomeRow()));
  void _removePlo(int index) {
    if (ploRows.length == 1) return;
    setState(() {
      ploRows[index].dispose();
      ploRows.removeAt(index);
    });
  }

  void _addPi() => setState(() => piRows.add(_OutcomeRow()));
  void _removePi(int index) {
    if (piRows.length == 1) return;
    setState(() {
      piRows[index].dispose();
      piRows.removeAt(index);
    });
  }

  List<String> _ploCodes() =>
      ploRows.map((p) => p.codeCtrl.text).where((e) => e.isNotEmpty).toList();

  int _calculateTotalCredits(String category) {
    final categoryData = structures[category];
    if (categoryData == null) return 0;

    final courses = context.read<AppState>().courses;
    int total = 0;

    for (final selection in categoryData.selections) {
      final course = courses.firstWhere(
        (c) => c.id == selection.courseId,
        orElse: () => const Course(
          id: '',
          code: '',
          title: '',
          description: '',
          programId: '',
          instructor: '',
          semester: '',
          credits: 0,
          topics: [],
          assessments: [],
          clos: [],
        ),
      );
      total += course.credits;
    }

    return total;
  }

  void _prefillIfEditing() {
    final program = widget.existingProgram;
    final profile = widget.existingProfile;
    if (program == null) return;
    nameCtrl.text = program.name;
    codeCtrl.text = program.code;
    deptCtrl.text = program.department;
    descCtrl.text = program.description;
    level = program.level;
    accreditation = program.accreditationStatus;
    college = program.college;
    if (profile != null) {
      graduatePortfolio = profile.structures.any((s) => s.graduatePortfolio);
      whyCtrl.text = profile.whyTake;
      graduateProfileCtrl.text = profile.graduateProfile;
      objectiveCtrls
        ..clear()
        ..addAll(profile.objectives.map((o) => TextEditingController(text: o)));
      if (objectiveCtrls.isEmpty) _addObjective();
      destinationCtrls
        ..clear()
        ..addAll(
          profile.destinations.map((d) => TextEditingController(text: d)),
        );
      if (destinationCtrls.isEmpty) _addDestination();
      iloCtrls
        ..clear()
        ..addAll(profile.ilos.map((i) => TextEditingController(text: i)));
      if (iloCtrls.isEmpty) _addIlo();
      ploRows
        ..clear()
        ..addAll(
          profile.plos.map((p) {
            final row = _OutcomeRow();
            row.codeCtrl.text = p.code;
            row.descCtrl.text = p.description;
            return row;
          }),
        );
      if (ploRows.isEmpty) _addPlo();
      piRows
        ..clear()
        ..addAll(
          profile.pis.map((p) {
            final row = _OutcomeRow();
            row.codeCtrl.text = p.code;
            row.descCtrl.text = p.description;
            return row;
          }),
        );
      if (piRows.isEmpty) _addPi();
      structures.forEach((key, value) => value.creditsCtrl.clear());
      for (final s in profile.structures) {
        final structureData = structures[s.category];
        if (structureData != null) {
          // Load course selections
          structureData.selections.clear();
          structureData.selections.addAll(
            s.courses.map(
              (cs) => _CourseSelection(
                courseId: cs.courseId,
                mappings: cs.mappings
                    .map(
                      (m) => _MappingPair()
                        ..clo = m.cloCode
                        ..plo = m.ploCode,
                    )
                    .toList(),
              ),
            ),
          );
          // Auto-calculate credits based on courses
          final totalCredits = _calculateTotalCredits(s.category);
          structureData.creditsCtrl.text = totalCredits.toString();
        }
      }
    }
  }

  Future<void> _showCoursePicker(
    BuildContext context, {
    required String category,
    required List<_OutcomeRow> plos,
  }) async {
    final courses = context.read<AppState>().courses;
    if (courses.isEmpty) return;
    String selectedCourseId = courses.first.id;
    List<_MappingPair> mappings = List.generate(3, (_) => _MappingPair());

    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return StatefulBuilder(
          builder: (ctx, setDialogState) {
            final course = courses.firstWhere((c) => c.id == selectedCourseId);
            final cloOptions =
                course.clos.map((c) => c.code).toList().isNotEmpty
                ? course.clos.map((c) => c.code).toList()
                : ['A1', 'A2', 'B1', 'B2', 'C1'];
            const ploOptions = [
              'PLO1',
              'PLO2',
              'PLO3',
              'PLO4',
              'PLO5',
              'PLO6',
              'PLO7',
            ];

            return AlertDialog(
              title: Text('Add course to $category'),
              content: SizedBox(
                width: 520,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: selectedCourseId,
                      decoration: const InputDecoration(
                        labelText: 'Select course',
                      ),
                      items: courses
                          .map(
                            (c) => DropdownMenuItem(
                              value: c.id,
                              child: Text(
                                '${c.code} – ${c.title} (${c.credits} credits)',
                              ),
                            ),
                          )
                          .toList(),
                      onChanged: (val) => setDialogState(
                        () => selectedCourseId = val ?? selectedCourseId,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'CLO ↔ PLO Mapping',
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const SizedBox(height: 8),
                    ...List.generate(mappings.length, (index) {
                      final pair = mappings[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: pair.clo.isEmpty ? null : pair.clo,
                                decoration: const InputDecoration(
                                  labelText: 'CLO',
                                ),
                                items: cloOptions
                                    .map(
                                      (c) => DropdownMenuItem(
                                        value: c,
                                        child: Text(c),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) =>
                                    setDialogState(() => pair.clo = val ?? ''),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: pair.plo.isEmpty ? null : pair.plo,
                                decoration: const InputDecoration(
                                  labelText: 'PLO',
                                ),
                                items: ploOptions
                                    .map(
                                      (p) => DropdownMenuItem(
                                        value: p,
                                        child: Text(p),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (val) =>
                                    setDialogState(() => pair.plo = val ?? ''),
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: TextButton.icon(
                        onPressed: () =>
                            setDialogState(() => mappings.add(_MappingPair())),
                        icon: const Icon(Icons.add),
                        label: const Text('Add mapping row'),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(dialogCtx).pop(),
                  child: const Text('Cancel'),
                ),
                PrimaryButton(
                  label: 'Save',
                  onPressed: () {
                    final selection = _CourseSelection(
                      courseId: selectedCourseId,
                      mappings: mappings
                          .where((m) => m.clo.isNotEmpty && m.plo.isNotEmpty)
                          .toList(),
                    );
                    setState(() {
                      structures[category]?.selections.add(selection);
                      // Update credits automatically
                      final totalCredits = _calculateTotalCredits(category);
                      structures[category]?.creditsCtrl.text = totalCredits
                          .toString();
                    });
                    Navigator.of(dialogCtx).pop();
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _saveProgram(BuildContext context) {
    if (nameCtrl.text.isEmpty || codeCtrl.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Name and code are required')),
      );
      return;
    }

    final objectives = objectiveCtrls
        .map((c) => c.text)
        .where((e) => e.isNotEmpty)
        .toList();
    final destinations = destinationCtrls
        .map((c) => c.text)
        .where((e) => e.isNotEmpty)
        .toList();
    final ilos = iloCtrls
        .map((c) => c.text)
        .where((e) => e.isNotEmpty)
        .toList();
    final plos = ploRows
        .where((p) => p.codeCtrl.text.isNotEmpty || p.descCtrl.text.isNotEmpty)
        .map(
          (p) => ProgramOutcome(
            code: p.codeCtrl.text,
            description: p.descCtrl.text,
          ),
        )
        .toList();
    final pis = piRows
        .where((p) => p.codeCtrl.text.isNotEmpty || p.descCtrl.text.isNotEmpty)
        .map(
          (p) => ProgramOutcome(
            code: p.codeCtrl.text,
            description: p.descCtrl.text,
          ),
        )
        .toList();

    final structureList = structures.entries.map((entry) {
      final credits = int.tryParse(entry.value.creditsCtrl.text) ?? 0;
      final courseSelections = entry.value.selections
          .map(
            (s) => ProgramCourseSelection(
              courseId: s.courseId,
              category: entry.key,
              mappings: s.mappings
                  .map((m) => CloPloMap(cloCode: m.clo, ploCode: m.plo))
                  .toList(),
            ),
          )
          .toList();
      return ProgramStructure(
        category: entry.key,
        credits: credits,
        courses: courseSelections,
        graduatePortfolio: graduatePortfolio,
      );
    }).toList();

    if (widget.existingProgram != null) {
      final original = widget.existingProgram!;
      context.read<AppState>().updateProgramWithProfile(
        id: original.id,
        name: nameCtrl.text,
        code: codeCtrl.text,
        department: deptCtrl.text,
        level: level,
        accreditationStatus: accreditation,
        description: descCtrl.text,
        college: college,
        objectives: objectives,
        whyTake: whyCtrl.text,
        destinations: destinations,
        plos: plos,
        pis: pis,
        ilos: ilos,
        graduateProfile: graduateProfileCtrl.text,
        structures: structureList,
      );
      context.read<AppState>().addIssue(
        title: 'Program change: ${original.code}',
        description:
            'Program updated.\nOld: ${original.code} ${original.name}.\nNew: ${codeCtrl.text} ${nameCtrl.text}.\nDetails captured for moderation.',
        relatedProgramId: original.id,
        relatedCourseId: null,
        owner: 'University Success Committee',
        priority: 'High',
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Program updated and issue created for moderation.'),
        ),
      );
      context.go('/programs/${original.id}');
    } else {
      context.read<AppState>().addProgram(
        name: nameCtrl.text,
        code: codeCtrl.text,
        department: deptCtrl.text,
        level: level,
        accreditationStatus: accreditation,
        description: descCtrl.text,
        college: college,
        objectives: objectives,
        whyTake: whyCtrl.text,
        destinations: destinations,
        plos: plos,
        pis: pis,
        ilos: ilos,
        graduateProfile: graduateProfileCtrl.text,
        structures: structureList,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Program created (in-memory)')),
      );
      context.go('/programs');
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.existingProgram == null ? 'Create Program' : 'Edit Program',
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Identity',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    SizedBox(
                      width: 320,
                      child: AppTextField(
                        label: 'Program Name',
                        controller: nameCtrl,
                        hint: 'BSc Computer Science',
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: AppTextField(
                        label: 'Program Code',
                        controller: codeCtrl,
                        hint: 'BSCS',
                      ),
                    ),
                    SizedBox(
                      width: 240,
                      child: DropdownButtonFormField<String>(
                        value: college,
                        decoration: const InputDecoration(labelText: 'College'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Engineering',
                            child: Text('Engineering'),
                          ),
                          DropdownMenuItem(
                            value: 'Business',
                            child: Text('Business'),
                          ),
                          DropdownMenuItem(
                            value: 'Multimedia',
                            child: Text('Multimedia'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => college = value ?? college),
                      ),
                    ),
                    SizedBox(
                      width: 240,
                      child: AppTextField(
                        label: 'Department',
                        controller: deptCtrl,
                        hint: 'Computing',
                      ),
                    ),
                    SizedBox(
                      width: 200,
                      child: DropdownButtonFormField<String>(
                        value: level,
                        decoration: const InputDecoration(labelText: 'Level'),
                        items: const [
                          DropdownMenuItem(
                            value: 'Undergraduate',
                            child: Text('Undergraduate'),
                          ),
                          DropdownMenuItem(
                            value: 'Graduate',
                            child: Text('Graduate'),
                          ),
                        ],
                        onChanged: (value) =>
                            setState(() => level = value ?? level),
                      ),
                    ),
                    SizedBox(
                      width: 220,
                      child: DropdownButtonFormField<String>(
                        value: accreditation,
                        decoration: const InputDecoration(
                          labelText: 'Accreditation Status',
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Accredited',
                            child: Text('Accredited'),
                          ),
                          DropdownMenuItem(
                            value: 'Pending',
                            child: Text('Pending'),
                          ),
                          DropdownMenuItem(
                            value: 'Draft',
                            child: Text('Draft'),
                          ),
                        ],
                        onChanged: (value) => setState(
                          () => accreditation = value ?? accreditation,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'General Description',
                  controller: descCtrl,
                  maxLines: 3,
                  hint: 'Brief summary of the program focus.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Objectives & Rationale',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _DynamicListSection(
                  title: 'Objectives of the Program',
                  hint: '(1) Provide technical knowledge and skills ...',
                  items: objectiveCtrls,
                  onAdd: _addObjective,
                  onRemove: _removeObjective,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Why a student should take this program',
                  controller: whyCtrl,
                  maxLines: 4,
                  hint: 'Explain the value proposition and career readiness.',
                ),
                const SizedBox(height: 12),
                _DynamicListSection(
                  title: 'Possible destinations of graduates',
                  hint:
                      'Full stack developer, data scientist, cybersecurity analyst',
                  items: destinationCtrls,
                  onAdd: _addDestination,
                  onRemove: _removeDestination,
                ),
                const SizedBox(height: 12),
                AppTextField(
                  label: 'Graduate profile (general description)',
                  controller: graduateProfileCtrl,
                  maxLines: 3,
                  hint:
                      'Adaptive professionals with strong analytical and ethical foundations.',
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Learning Outcomes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                _OutcomeListSection(
                  title: 'Program Learning Outcomes (PLOs)',
                  rows: ploRows,
                  onAdd: _addPlo,
                  onRemove: _removePlo,
                ),
                const Divider(),
                _OutcomeListSection(
                  title: 'Program Indicators (PIs)',
                  rows: piRows,
                  onAdd: _addPi,
                  onRemove: _removePi,
                ),
                const Divider(),
                _DynamicListSection(
                  title: 'Institutional Learning Outcomes (ILOs)',
                  hint: 'Regularly evaluate own strengths and weaknesses...',
                  items: iloCtrls,
                  onAdd: _addIlo,
                  onRemove: _removeIlo,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Program Structure',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Checkbox(
                      value: graduatePortfolio,
                      onChanged: (v) => setState(
                        () => graduatePortfolio = v ?? graduatePortfolio,
                      ),
                    ),
                    const Text('Graduate portfolio required'),
                  ],
                ),
                const SizedBox(height: 8),
                ...structures.entries.map((entry) {
                  final cat = entry.key;
                  final data = entry.value;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: data.creditsCtrl,
                                decoration: InputDecoration(
                                  labelText: '$cat credits (auto-calculated)',
                                  hintText:
                                      'Total: ${_calculateTotalCredits(cat)} credits',
                                  border: const OutlineInputBorder(),
                                  filled: true,
                                  fillColor: Colors.grey.shade100,
                                ),
                                readOnly: true,
                                style: TextStyle(color: Colors.grey.shade700),
                              ),
                            ),
                            const SizedBox(width: 12),
                            PrimaryButton(
                              label: 'Add course',
                              icon: Icons.add,
                              onPressed: () => _showCoursePicker(
                                context,
                                category: cat,
                                plos: ploRows,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        if (data.selections.isEmpty)
                          const Text('No courses added yet.')
                        else
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: data.selections.asMap().entries.map((
                              entry,
                            ) {
                              final index = entry.key;
                              final sel = entry.value;
                              final course = context
                                  .read<AppState>()
                                  .findCourse(sel.courseId);
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 6),
                                child: Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    border: Border.all(
                                      color: Colors.grey.shade300,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                    color: Colors.grey.shade50,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${course?.code ?? sel.courseId} - ${course?.title ?? 'Unknown Course'}',
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            Text(
                                              '${course?.credits ?? 0} credits | ${sel.mappings.isEmpty ? 'No mapping' : sel.mappings.map((m) => '${m.clo}→${m.plo}').join(', ')}',
                                              style: const TextStyle(
                                                color: Colors.black54,
                                                fontSize: 12,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.remove_circle,
                                          color: Colors.red,
                                        ),
                                        onPressed: () {
                                          setState(() {
                                            data.selections.removeAt(index);
                                            // Recalculate credits
                                            final totalCredits =
                                                _calculateTotalCredits(cat);
                                            data.creditsCtrl.text = totalCredits
                                                .toString();
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          PrimaryButton(
            label: 'Create Program',
            onPressed: () => _saveProgram(context),
          ),
        ],
      ),
    );
  }
}

class _DynamicListSection extends StatelessWidget {
  const _DynamicListSection({
    required this.title,
    required this.items,
    required this.onAdd,
    required this.onRemove,
    required this.hint,
  });

  final String title;
  final String hint;
  final List<TextEditingController> items;
  final VoidCallback onAdd;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...List.generate(items.length, (index) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: AppTextField(
                    label: '${title.split(' ').first} ${index + 1}',
                    controller: items[index],
                    hint: hint,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: items.length == 1 ? null : () => onRemove(index),
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Add item'),
        ),
      ],
    );
  }
}

class _OutcomeRow {
  final TextEditingController codeCtrl = TextEditingController();
  final TextEditingController descCtrl = TextEditingController();

  void dispose() {
    codeCtrl.dispose();
    descCtrl.dispose();
  }
}

class _OutcomeListSection extends StatelessWidget {
  const _OutcomeListSection({
    required this.title,
    required this.rows,
    required this.onAdd,
    required this.onRemove,
  });

  final String title;
  final List<_OutcomeRow> rows;
  final VoidCallback onAdd;
  final void Function(int) onRemove;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        ...List.generate(rows.length, (index) {
          final row = rows[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
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
                    Text(
                      'Outcome ${index + 1}',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    const Spacer(),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: rows.length == 1
                          ? null
                          : () => onRemove(index),
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
                      child: DropdownButtonFormField<String>(
                        value: row.codeCtrl.text.isEmpty
                            ? null
                            : row.codeCtrl.text,
                        decoration: const InputDecoration(
                          labelText: 'Code',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 16,
                          ),
                          border: OutlineInputBorder(),
                        ),
                        hint: const Text('PLO1'),
                        items: const [
                          DropdownMenuItem(value: 'PLO1', child: Text('PLO1')),
                          DropdownMenuItem(value: 'PLO2', child: Text('PLO2')),
                          DropdownMenuItem(value: 'PLO3', child: Text('PLO3')),
                          DropdownMenuItem(value: 'PLO4', child: Text('PLO4')),
                          DropdownMenuItem(value: 'PLO5', child: Text('PLO5')),
                          DropdownMenuItem(value: 'PLO6', child: Text('PLO6')),
                          DropdownMenuItem(value: 'PLO7', child: Text('PLO7')),
                        ],
                        onChanged: (value) => row.codeCtrl.text = value ?? '',
                      ),
                    ),
                    SizedBox(
                      width: 380,
                      child: AppTextField(
                        label: 'Description',
                        controller: row.descCtrl,
                        hint:
                            'Demonstrate critical knowledge of computing concepts...',
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
        TextButton.icon(
          onPressed: onAdd,
          icon: const Icon(Icons.add),
          label: const Text('Add outcome'),
        ),
      ],
    );
  }
}

class _MappingPair {
  String clo = '';
  String plo = '';
}

class _CourseSelection {
  _CourseSelection({required this.courseId, required this.mappings});

  final String courseId;
  final List<_MappingPair> mappings;
}

class _StructureCategory {
  final TextEditingController creditsCtrl = TextEditingController();
  final List<_CourseSelection> selections = [];

  void dispose() {
    creditsCtrl.dispose();
  }
}
