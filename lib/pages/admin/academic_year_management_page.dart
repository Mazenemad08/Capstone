import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../data/fake_data.dart';

class AcademicYearManagementPage extends StatefulWidget {
  const AcademicYearManagementPage({super.key});

  @override
  State<AcademicYearManagementPage> createState() =>
      _AcademicYearManagementPageState();
}

class _AcademicYearManagementPageState
    extends State<AcademicYearManagementPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final currentYear = appState.getCurrentAcademicYear();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Current Academic Year Section
            Card(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Current Academic Year',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),

                    if (currentYear != null) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  currentYear.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  '${currentYear.startDate} - ${currentYear.endDate}',
                                  style: Theme.of(context).textTheme.bodyLarge
                                      ?.copyWith(color: Colors.grey[600]),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.check_circle,
                                  color: Colors.green,
                                  size: 16,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  'CURRENT',
                                  style: TextStyle(
                                    color: Colors.green,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Current Semester Info
                      Text(
                        'Semesters',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 12),

                      // Display semesters
                      Column(
                        children: currentYear.semesters.map((semester) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: semester.isCurrent
                                    ? Theme.of(
                                        context,
                                      ).primaryColor.withOpacity(0.1)
                                    : Colors.grey[50],
                                borderRadius: BorderRadius.circular(8),
                                border: semester.isCurrent
                                    ? Border.all(
                                        color: Theme.of(context).primaryColor,
                                      )
                                    : Border.all(color: Colors.grey[300]!),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              semester.name,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (semester.isCurrent) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 8,
                                                      vertical: 2,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(
                                                    context,
                                                  ).primaryColor,
                                                  borderRadius:
                                                      BorderRadius.circular(12),
                                                ),
                                                child: const Text(
                                                  'CURRENT',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        Text(
                                          '${semester.startDate} - ${semester.endDate}',
                                          style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 14,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ] else ...[
                      Container(
                        padding: const EdgeInsets.all(32),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Column(
                          children: [
                            Icon(
                              Icons.warning_amber,
                              color: Colors.orange,
                              size: 48,
                            ),
                            SizedBox(height: 16),
                            Text(
                              'No Academic Year Set',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: Colors.orange,
                              ),
                            ),
                            SizedBox(height: 8),
                            Text(
                              'Please select a current academic year below',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // All Academic Years Section
            Text(
              'All Academic Years',
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Academic Years (${appState.academicYears.length})',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          ElevatedButton.icon(
                            onPressed: () => _showCreateAcademicYearDialog(
                              context,
                              appState,
                            ),
                            icon: const Icon(Icons.add, size: 20),
                            label: const Text('Add Year'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      Expanded(
                        child: ListView.builder(
                          itemCount: appState.academicYears.length,
                          itemBuilder: (context, index) {
                            final year = appState.academicYears[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 12),
                              elevation: year.isCurrent ? 4 : 1,
                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text(
                                                year.name,
                                                style: const TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              if (year.isCurrent) ...[
                                                const SizedBox(width: 12),
                                                Container(
                                                  padding:
                                                      const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 4,
                                                      ),
                                                  decoration: BoxDecoration(
                                                    color: Colors.green,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          16,
                                                        ),
                                                  ),
                                                  child: const Text(
                                                    'CURRENT',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 11,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            '${year.startDate} - ${year.endDate}',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          ),
                                          const SizedBox(height: 8),
                                          Text(
                                            '${year.semesters.length} semesters',
                                            style: TextStyle(
                                              color: Colors.grey[500],
                                              fontSize: 12,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (!year.isCurrent)
                                      ElevatedButton(
                                        onPressed: () =>
                                            _setCurrentYear(appState, year.id),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(
                                            context,
                                          ).primaryColor,
                                          foregroundColor: Colors.white,
                                        ),
                                        child: const Text('Set as Current'),
                                      ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _setCurrentYear(AppState appState, String yearId) {
    appState.setCurrentAcademicYear(yearId);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Academic year updated successfully')),
    );
  }

  void _showCreateAcademicYearDialog(BuildContext context, AppState appState) {
    final nameController = TextEditingController();
    final startDateController = TextEditingController();
    final endDateController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Academic Year'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Academic Year Name',
                hintText: 'e.g., 2025-2026',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: startDateController,
              decoration: const InputDecoration(
                labelText: 'Start Date',
                hintText: 'Aug 01, 2025',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: endDateController,
              decoration: const InputDecoration(
                labelText: 'End Date',
                hintText: 'Jul 31, 2026',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  startDateController.text.isNotEmpty &&
                  endDateController.text.isNotEmpty) {
                final newYear = AcademicYear(
                  id: 'ay${DateTime.now().millisecondsSinceEpoch}',
                  name: nameController.text,
                  startDate: startDateController.text,
                  endDate: endDateController.text,
                  isCurrent: false,
                  semesters: _createDefaultSemesters(nameController.text),
                );
                appState.addAcademicYear(newYear);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Academic year added successfully'),
                  ),
                );
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  List<AcademicSemester> _createDefaultSemesters(String yearName) {
    final years = yearName.split('-');
    if (years.length != 2) return [];

    final firstYear = years[0];
    final secondYear = years[1];

    return [
      AcademicSemester(
        id: 's${DateTime.now().millisecondsSinceEpoch}1',
        name: 'Fall $firstYear',
        startDate: 'Aug 15, $firstYear',
        endDate: 'Dec 15, $firstYear',
        isCurrent: false,
      ),
      AcademicSemester(
        id: 's${DateTime.now().millisecondsSinceEpoch}2',
        name: 'Spring $secondYear',
        startDate: 'Jan 15, $secondYear',
        endDate: 'May 15, $secondYear',
        isCurrent: false,
      ),
      AcademicSemester(
        id: 's${DateTime.now().millisecondsSinceEpoch}3',
        name: 'Summer $secondYear',
        startDate: 'Jun 01, $secondYear',
        endDate: 'Jul 31, $secondYear',
        isCurrent: false,
      ),
    ];
  }
}
