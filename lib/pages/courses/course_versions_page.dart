import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/fake_data.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';

class CourseVersionsPage extends StatelessWidget {
  const CourseVersionsPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final course = state.findCourse(courseId);
    final evaluations = state.courseEvaluationsFor(courseId);

    if (course == null) {
      return const Center(child: Text('Course not found'));
    }

    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Course Versions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Browse historical versions of this course.'),
            const SizedBox(height: 12),
            if (evaluations.isEmpty)
              const Text(
                'No versions captured yet. Add a course reflection to start tracking versions.',
                style: TextStyle(color: Colors.black54),
              )
            else
              Column(
                children: evaluations
                    .map(
                      (e) => _VersionCard(
                        evaluation: e,
                        courseSnapshot: course,
                        program: state.findProgram(course.programId),
                      ),
                    )
                    .toList(),
              ),
          ],
        ),
      ),
    );
  }
}

class _VersionCard extends StatefulWidget {
  const _VersionCard({
    required this.evaluation,
    required this.courseSnapshot,
    this.program,
  });

  final CourseEvaluation evaluation;
  final Course courseSnapshot;
  final Program? program;

  @override
  State<_VersionCard> createState() => _VersionCardState();
}

class _VersionCardState extends State<_VersionCard> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.grey.shade50,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.blue.shade100),
                ),
                child: Text(
                  'Version ${widget.evaluation.version}',
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.evaluation.date,
                style: const TextStyle(color: Colors.black54),
              ),
              const Spacer(),
              PrimaryButton(
                label: expanded ? 'Hide details' : 'View details',
                onPressed: () => setState(() => expanded = !expanded),
              ),
            ],
          ),
          if (widget.evaluation.notes.isNotEmpty) ...[
            const SizedBox(height: 8),
            Text(
              widget.evaluation.notes,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
          AnimatedCrossFade(
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _CourseSnapshotView(
                course: widget.courseSnapshot,
                programName: widget.program?.name ?? widget.courseSnapshot.programId,
              ),
            ),
            crossFadeState: expanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            duration: const Duration(milliseconds: 200),
          ),
        ],
      ),
    );
  }
}

class _CourseSnapshotView extends StatelessWidget {
  const _CourseSnapshotView({
    required this.course,
    required this.programName,
  });

  final Course course;
  final String programName;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _Section(
          title: 'Identity',
          child: Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _InfoChip(label: 'Code', value: course.code),
              _InfoChip(label: 'Title', value: course.title),
              _InfoChip(label: 'Program', value: programName),
              _InfoChip(label: 'Instructor', value: course.instructor),
              _InfoChip(label: 'Semester', value: course.semester),
              _InfoChip(label: 'Credits', value: course.credits.toString()),
            ],
          ),
        ),
        if (course.description.isNotEmpty)
          _Section(
            title: 'Description',
            child: Text(
              course.description,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ),
        if (course.clos.isNotEmpty)
          _Section(
            title: 'Course Learning Outcomes',
            child: Column(
              children: course.clos
                  .map(
                    (c) => _InfoTile(
                      title: c.code,
                      subtitle: c.description,
                      trailing: c.nqfLevel.isNotEmpty ? 'NQF ${c.nqfLevel}' : null,
                      footer: c.descriptor,
                    ),
                  )
                  .toList(),
            ),
          ),
        if (course.topics.isNotEmpty)
          _Section(
            title: 'Weekly Topics',
            child: Column(
              children: course.topics
                  .map(
                    (t) => _InfoTile(
                      title: t.title,
                      subtitle: 'CLOs: ${t.closCovered.isEmpty ? '—' : t.closCovered}',
                      footer:
                          'Teaching: ${t.teachingMethods.isEmpty ? '—' : t.teachingMethods}\nAssessment: ${t.assessmentMethods.isEmpty ? '—' : t.assessmentMethods}',
                    ),
                  )
                  .toList(),
            ),
          ),
        if (course.assessments.isNotEmpty)
          _Section(
            title: 'Assessments',
            child: Column(
              children: course.assessments
                  .map(
                    (a) => _InfoTile(
                      title: a.name,
                      subtitle: '${a.type} • ${a.method}',
                      trailing: a.weight.isNotEmpty ? '${a.weight}%' : null,
                      footer:
                          'CLOs: ${a.closAssessed.isEmpty ? '—' : a.closAssessed}\nNQF: ${a.nqfLevel.isEmpty ? '—' : a.nqfLevel}\n${a.description}',
                    ),
                  )
                  .toList(),
            ),
          ),
      ],
    );
  }
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.black54)),
          const SizedBox(height: 4),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        ],
      ),
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.title,
    required this.subtitle,
    this.trailing,
    this.footer,
  });

  final String title;
  final String subtitle;
  final String? trailing;
  final String? footer;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade300),
        color: Colors.white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 4),
                    Text(subtitle),
                  ],
                ),
              ),
              if (trailing != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey.shade100,
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(trailing!),
                ),
            ],
          ),
          if (footer != null) ...[
            const SizedBox(height: 8),
            Text(
              footer!,
              style: const TextStyle(color: Colors.black87),
            ),
          ],
        ],
      ),
    );
  }
}
