import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';
import '../../data/fake_data.dart';

class GeneratedReportPayload {
  final String semester;
  final String year;
  final String instructor;

  const GeneratedReportPayload({
    required this.semester,
    required this.year,
    required this.instructor,
  });
}

class CourseReportPage extends StatelessWidget {
  const CourseReportPage({super.key, required this.courseId, this.payload});

  final String courseId;
  final GeneratedReportPayload? payload;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final course = state.findCourse(courseId);

    if (course == null) {
      return const Center(child: Text('Report not available'));
    }

    final semester = payload?.semester.isNotEmpty == true ? payload!.semester : course.semester;
    final year = payload?.year.isNotEmpty == true ? payload!.year : '2025';
    final instructor =
        payload?.instructor.isNotEmpty == true ? payload!.instructor : (course.instructor == 'TBD' ? 'Course Instructor' : course.instructor);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${course.code} – ${course.title}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Semester: $semester $year • Instructor: $instructor • Credits: ${course.credits}'),
          const SizedBox(height: 16),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Course Description & Aims', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                Text(course.description),
                const SizedBox(height: 10),
                const Text(
                  'The course provides structured learning aligned to the NQF descriptors, combining theoretical understanding with applied practice and continuous assessment.',
                  style: TextStyle(color: Colors.black87),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Course Learning Outcomes', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (course.clos.isEmpty) const Text('No CLOs captured yet.')
                else
                  ...course.clos.map((c) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${c.category.isNotEmpty ? '${c.category} – ' : ''}${c.code}',
                                style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text(c.description),
                            Text('NQF: ${c.descriptor}'),
                          ],
                        ),
                      )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Weekly Topics & CLO Mapping', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (course.topics.isEmpty) const Text('No topics captured yet.')
                else
                  ...course.topics.map((t) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.title, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text('CLOs: ${t.closCovered.isEmpty ? '—' : t.closCovered}'),
                            Text('Teaching: ${t.teachingMethods.isEmpty ? '—' : t.teachingMethods}'),
                            Text('Assessment: ${t.assessmentMethods.isEmpty ? '—' : t.assessmentMethods}'),
                          ],
                        ),
                      )),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Resources & Policies', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(height: 8),
                Text('Core texts: Intro to Cybersecurity (2024), Principles of Information Security (7th ed.).'),
                Text('Course notes shared via Canvas and Teams; tools: Wireshark, Ubuntu, Netcat.'),
                Text('Policies: attendance tracked weekly; credit hours align to 45 contact hours and 120 notional hours.'),
              ],
            ),
          ),
          const SizedBox(height: 12),
          AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Assessment Plan', style: TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 8),
                if (course.assessments.isEmpty) const Text('No assessments captured yet.')
                else
                  ...course.assessments.map((a) => Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(a.name, style: const TextStyle(fontWeight: FontWeight.w700)),
                            Text('Type: ${a.type} • Weight: ${a.weight}% • NQF: ${a.nqfLevel}'),
                            Text('Method: ${a.method}'),
                            Text('CLOs assessed: ${a.closAssessed}'),
                            Text('Description: ${a.description}'),
                          ],
                        ),
                      )),
                const SizedBox(height: 10),
                Align(
                  alignment: Alignment.centerLeft,
                  child: PrimaryButton(
                    label: 'Send for moderation',
                    icon: Icons.send,
                    onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Report sent for moderation (fake action)')),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
