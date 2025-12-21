import 'package:curriculum_prototype/data/fake_data.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_tabs.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../widgets/ui/text_field.dart';
import 'course_report_page.dart' show GeneratedReportPayload;

class CourseDetailPage extends StatelessWidget {
  const CourseDetailPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final course = state.findCourse(courseId);
    if (course == null) {
      return const Center(child: Text('Course not found'));
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course.title,
            style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            course.description,
            style: const TextStyle(fontSize: 16, color: Colors.black87),
          ),
          const SizedBox(height: 14),
          Wrap(
            spacing: 12,
            children: [
              PrimaryButton(
                label: 'Create Course Report',
                icon: Icons.add,
                onPressed: () => _showCreateReportDialog(context, course),
              ),
              PrimaryButton(
                label: 'View Versions',
                onPressed: () => context.go('/courses/${course.id}/versions'),
                icon: Icons.history,
              ),
              PrimaryButton(
                label: 'Edit Course',
                onPressed: () => context.go('/courses/${course.id}/edit'),
                icon: Icons.edit,
              ),
              PrimaryButton(
                label: 'Add Course Reflection',
                onPressed: () => _showAddEvaluationDialog(context, course.id),
              ),
              PrimaryButton(
                label: 'View Course Reflections',
                onPressed: () => context.go('/courses/${course.id}/evaluations'),
                icon: Icons.list_alt,
              ),
            ],
          ),
          const SizedBox(height: 20),
          AppTabs(
            tabs: [
              AppTab(
                label: 'Overview',
                content: _OverviewTab(course: course),
              ),
              AppTab(
                label: 'CLOs',
                content: _CloDefinitionList(clos: course.clos),
              ),
              AppTab(
                label: 'Curriculum',
                content: _TopicsList(topics: course.topics),
              ),
              AppTab(
                label: 'Assessment & LO Mapping',
                content: _AssessmentsList(items: course.assessments),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showCreateReportDialog(BuildContext context, Course course) {
    final semesterCtrl = TextEditingController(text: 'Fall');
    final yearCtrl = TextEditingController(text: DateTime.now().year.toString());
    final instructorCtrl = TextEditingController(text: course.instructor == 'TBD' ? '' : course.instructor);

    showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Generate Course Report'),
          content: SizedBox(
            width: 460,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(label: 'Semester', controller: semesterCtrl, hint: 'Fall'),
                const SizedBox(height: 12),
                AppTextField(label: 'Year', controller: yearCtrl, hint: '2025'),
                const SizedBox(height: 12),
                AppTextField(label: 'Instructor Name', controller: instructorCtrl, hint: 'Dr. Jane Doe'),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Cancel')),
            PrimaryButton(
              label: 'Generate Report',
              onPressed: () {
                final payload = GeneratedReportPayload(
                  semester: semesterCtrl.text,
                  year: yearCtrl.text,
                  instructor: instructorCtrl.text,
                );
                Navigator.of(dialogCtx).pop();
                context.go('/courses/${course.id}/report', extra: payload);
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddEvaluationDialog(BuildContext context, String courseId) async {
    final versionCtrl = TextEditingController();
    final notesCtrl = TextEditingController();
    final dateCtrl = TextEditingController(text: DateTime.now().toIso8601String().substring(0, 10));
    await showDialog(
      context: context,
      builder: (dialogCtx) {
        return AlertDialog(
          title: const Text('Add Course Evaluation'),
          content: SizedBox(
            width: 420,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppTextField(label: 'Version', controller: versionCtrl, hint: 'v1.1'),
                const SizedBox(height: 12),
                AppTextField(label: 'Date', controller: dateCtrl, hint: '2024-12-01'),
                const SizedBox(height: 12),
                AppTextField(label: 'Notes', controller: notesCtrl, maxLines: 3),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(dialogCtx).pop(), child: const Text('Cancel')),
            PrimaryButton(
              label: 'Save',
              onPressed: () {
                context.read<AppState>().addCourseEvaluation(
                      courseId: courseId,
                      version: versionCtrl.text,
                      notes: notesCtrl.text,
                      date: dateCtrl.text,
                    );
                Navigator.of(dialogCtx).pop();
              },
            ),
          ],
        );
      },
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.course});

  final Course course;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AppCard(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                course.code,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              Text(course.description),
              const SizedBox(height: 10),
              Text('College: ${course.programId}'),
              Text('Credits: ${course.credits}'),
            ],
          ),
        ),
      ],
    );
  }
}

class _TopicsList extends StatelessWidget {
  const _TopicsList({required this.topics});

  final List<WeeklyTopic> topics;

  @override
  Widget build(BuildContext context) {
    if (topics.isEmpty) return const Text('No topics captured yet.');
    return ListView.builder(
      itemCount: topics.length,
      itemBuilder: (context, index) {
        final t = topics[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('CLOs covered: ${t.closCovered.isEmpty ? '—' : t.closCovered}'),
                Text('Teaching: ${t.teachingMethods.isEmpty ? '—' : t.teachingMethods}'),
                Text('Assessment: ${t.assessmentMethods.isEmpty ? '—' : t.assessmentMethods}'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AssessmentsList extends StatelessWidget {
  const _AssessmentsList({required this.items});

  final List<AssessmentItem> items;

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) return const Text('No assessments captured yet.');
    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final a = items[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(a.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text('Method: ${a.method}'),
                Text('Type: ${a.type}'),
                Text('CLOs assessed: ${a.closAssessed}'),
                Text('Description: ${a.description}'),
                Text('NQF Level: ${a.nqfLevel}'),
                Text('Weight: ${a.weight}%'),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CloDefinitionList extends StatelessWidget {
  const _CloDefinitionList({required this.clos});

  final List<CourseClo> clos;

  @override
  Widget build(BuildContext context) {
    if (clos.isEmpty) return const Text('No CLOs captured yet.');
    return ListView.builder(
      itemCount: clos.length,
      itemBuilder: (context, index) {
        final clo = clos[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${clo.category.isNotEmpty ? '${clo.category} – ' : ''}${clo.code}',
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(clo.description),
                Text('NQF Descriptor: ${clo.descriptor}'),
              ],
            ),
          ),
        );
      },
    );
  }
}
