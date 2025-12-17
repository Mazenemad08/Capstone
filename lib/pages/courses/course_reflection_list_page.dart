import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_table.dart';
import '../../widgets/ui/status_badge.dart';

class CourseReflectionListPage extends StatelessWidget {
  const CourseReflectionListPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final reflections = state.reflectionsForCourse(courseId);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (reflections.isEmpty)
            const Text('No reflections yet.')
          else
            AppTable(
              columns: const ['Semester', 'Instructor', 'Enrolled', 'Summary'],
              rows: reflections
                  .map(
                    (r) => [
                      Text(r.semester),
                      Text(r.instructor),
                      Text(r.enrolled.toString()),
                      SizedBox(width: 300, child: Text(r.summary)),
                    ],
                  )
                  .toList(),
            ),
          const SizedBox(height: 12),
          const StatusBadge(label: 'Draft'),
        ],
      ),
    );
  }
}
