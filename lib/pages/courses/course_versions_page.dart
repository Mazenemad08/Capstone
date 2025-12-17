import 'package:flutter/material.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';

class CourseVersionsPage extends StatelessWidget {
  const CourseVersionsPage({super.key, required this.courseId});

  final String courseId;

  @override
  Widget build(BuildContext context) {
    final versions = ['1.0', '1.1', '1.2', '1.3', '1.4', '1.5'];
    return SingleChildScrollView(
      child: AppCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Course Versions', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            const Text('Browse historical versions of this course.'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: versions
                  .map((v) => SizedBox(
                        width: 130,
                        child: PrimaryButton(
                          label: 'Version $v',
                          onPressed: () {},
                        ),
                      ))
                  .toList(),
            ),
          ],
        ),
      ),
    );
  }
}
