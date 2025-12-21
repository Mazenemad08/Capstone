import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/primary_button.dart';

class ModerationRequestPage extends StatefulWidget {
  const ModerationRequestPage({super.key, required this.requestId});

  final String requestId;

  @override
  State<ModerationRequestPage> createState() => _ModerationRequestPageState();
}

class _ModerationRequestPageState extends State<ModerationRequestPage> {
  final _formKey = GlobalKey<FormState>();

  // Course Information
  final _courseCodeController = TextEditingController();
  final _courseTitleController = TextEditingController();
  final _departmentController = TextEditingController();
  final _collegeDivisionController = TextEditingController();
  final _sectionsController = TextEditingController();
  final _academicYearController = TextEditingController();
  final _coordinatorController = TextEditingController();
  String _selectedSemester = '';

  // Moderation criteria responses
  final List<String> _criteriaResponses = List.filled(13, '');
  final List<TextEditingController> _remarksControllers = List.generate(
    13,
    (_) => TextEditingController(),
  );

  // Confirmation and remarks
  bool _changesIncorporated = false;
  final _otherRemarksController = TextEditingController();

  // Sign-off information
  final _moderatorNameController = TextEditingController();
  final _moderatorSignatureController = TextEditingController();
  final _moderatorDateController = TextEditingController();
  final _programLeadNameController = TextEditingController();
  final _programLeadSignatureController = TextEditingController();
  final _programLeadDateController = TextEditingController();

  static const List<String> _criteria = [
    'Is the approved syllabus template used?',
    'Is the Course Syllabus complete?',
    'Is the Course Syllabus clearly written and free from typographical errors?',
    'Do the course learning outcomes match those of the master syllabus? (If there are any changes the revised CLOs should be discussed in the College and approved by the University Curriculum Committee)',
    'Does the weightage given to each assessment conform to AUBH assessment manual guidelines?',
    'Are the dates or schedule for each assessment clearly stated and appropriately spaced across the semester?',
    'Are the instructor\'s office hours and contact information listed?',
    'Is there a clear schedule of weekly topics?',
    'Are the CLOs mapped to the NQF levels, PLOs/GELOs?',
    'Are Assessments clearly mapped to the CLOs/PLOs? Does the mapping enable clear judgement on the level of achievement of the CLO/PLO?',
    'Are the required core texts listed?',
    'Are the course policies clearly stated?',
    'Does the Syllabus clearly state when and how feedback will be provided to students for both their inquiries and feedback on assessment?',
  ];

  static const List<String> _semesters = ['Fall', 'Spring', 'Summer'];

  @override
  void dispose() {
    _courseCodeController.dispose();
    _courseTitleController.dispose();
    _departmentController.dispose();
    _collegeDivisionController.dispose();
    _sectionsController.dispose();
    _academicYearController.dispose();
    _coordinatorController.dispose();
    for (var controller in _remarksControllers) {
      controller.dispose();
    }
    _otherRemarksController.dispose();
    _moderatorNameController.dispose();
    _moderatorSignatureController.dispose();
    _moderatorDateController.dispose();
    _programLeadNameController.dispose();
    _programLeadSignatureController.dispose();
    _programLeadDateController.dispose();
    super.dispose();
  }

  bool get _isFormValid {
    // Course information validation
    if (_courseCodeController.text.trim().isEmpty ||
        _courseTitleController.text.trim().isEmpty ||
        _departmentController.text.trim().isEmpty ||
        _collegeDivisionController.text.trim().isEmpty ||
        _sectionsController.text.trim().isEmpty ||
        _academicYearController.text.trim().isEmpty ||
        _coordinatorController.text.trim().isEmpty ||
        _selectedSemester.isEmpty) {
      return false;
    }

    // Validate sections is numeric
    if (int.tryParse(_sectionsController.text.trim()) == null) {
      return false;
    }

    // Validate all criteria have responses
    for (int i = 0; i < _criteriaResponses.length; i++) {
      if (_criteriaResponses[i].isEmpty) return false;

      // If marked as "No", remarks must be filled
      if (_criteriaResponses[i] == 'No' &&
          _remarksControllers[i].text.trim().isEmpty) {
        return false;
      }
    }

    // Confirmation checkbox must be checked
    if (!_changesIncorporated) return false;

    // Sign-off validation
    if (_moderatorNameController.text.trim().isEmpty ||
        _moderatorSignatureController.text.trim().isEmpty ||
        _moderatorDateController.text.trim().isEmpty ||
        _programLeadNameController.text.trim().isEmpty ||
        _programLeadSignatureController.text.trim().isEmpty ||
        _programLeadDateController.text.trim().isEmpty) {
      return false;
    }

    return true;
  }

  List<String> _getValidationErrors() {
    List<String> errors = [];

    if (_courseCodeController.text.trim().isEmpty)
      errors.add('Course Code is required');
    if (_courseTitleController.text.trim().isEmpty)
      errors.add('Course Title is required');
    if (_departmentController.text.trim().isEmpty)
      errors.add('Department is required');
    if (_collegeDivisionController.text.trim().isEmpty)
      errors.add('College/Division is required');
    if (_sectionsController.text.trim().isEmpty)
      errors.add('Number of sections is required');
    if (int.tryParse(_sectionsController.text.trim()) == null)
      errors.add('Number of sections must be numeric');
    if (_academicYearController.text.trim().isEmpty)
      errors.add('Academic Year is required');
    if (_coordinatorController.text.trim().isEmpty)
      errors.add('Coordinator/Instructor name is required');
    if (_selectedSemester.isEmpty) errors.add('Semester must be selected');

    for (int i = 0; i < _criteriaResponses.length; i++) {
      if (_criteriaResponses[i].isEmpty) {
        errors.add('Criterion ${i + 1} must be answered');
      } else if (_criteriaResponses[i] == 'No' &&
          _remarksControllers[i].text.trim().isEmpty) {
        errors.add(
          'Criterion ${i + 1}: Changes/Remarks required when marked as "No"',
        );
      }
    }

    if (!_changesIncorporated)
      errors.add('Must confirm that changes have been incorporated');

    if (_moderatorNameController.text.trim().isEmpty)
      errors.add('Moderator name is required');
    if (_moderatorSignatureController.text.trim().isEmpty)
      errors.add('Moderator signature is required');
    if (_moderatorDateController.text.trim().isEmpty)
      errors.add('Moderator date is required');
    if (_programLeadNameController.text.trim().isEmpty)
      errors.add('Program Lead/QA Officer name is required');
    if (_programLeadSignatureController.text.trim().isEmpty)
      errors.add('Program Lead/QA Officer signature is required');
    if (_programLeadDateController.text.trim().isEmpty)
      errors.add('Program Lead/QA Officer date is required');

    return errors;
  }

  Map<String, dynamic> _collectFormData() {
    return {
      'courseInformation': {
        'courseCode': _courseCodeController.text.trim(),
        'courseTitle': _courseTitleController.text.trim(),
        'department': _departmentController.text.trim(),
        'collegeDivision': _collegeDivisionController.text.trim(),
        'numberOfSections': int.tryParse(_sectionsController.text.trim()),
        'academicYear': _academicYearController.text.trim(),
        'coordinatorName': _coordinatorController.text.trim(),
        'semester': _selectedSemester,
      },
      'moderationCriteria': List.generate(
        _criteria.length,
        (i) => {
          'criterion': _criteria[i],
          'response': _criteriaResponses[i],
          'remarks': _remarksControllers[i].text.trim(),
        },
      ),
      'changesIncorporated': _changesIncorporated,
      'otherRemarks': _otherRemarksController.text.trim(),
      'signOff': {
        'moderator': {
          'name': _moderatorNameController.text.trim(),
          'signature': _moderatorSignatureController.text.trim(),
          'date': _moderatorDateController.text.trim(),
        },
        'programLead': {
          'name': _programLeadNameController.text.trim(),
          'signature': _programLeadSignatureController.text.trim(),
          'date': _programLeadDateController.text.trim(),
        },
      },
      'timestamp': DateTime.now().toIso8601String(),
    };
  }

  void _handleAction(String action) {
    if (!_isFormValid) {
      final errors = _getValidationErrors();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Form Incomplete'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Please complete the following:'),
              const SizedBox(height: 8),
              ...errors
                  .take(10)
                  .map(
                    (error) => Padding(
                      padding: const EdgeInsets.only(left: 8, bottom: 4),
                      child: Text(
                        '• $error',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  ),
              if (errors.length > 10)
                Text(
                  '... and ${errors.length - 10} more items',
                  style: const TextStyle(
                    fontSize: 12,
                    fontStyle: FontStyle.italic,
                  ),
                ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return;
    }

    final formData = _collectFormData();

    // For static implementation, show confirmation dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Confirm $action'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to $action this moderation request?'),
            const SizedBox(height: 8),
            const Text(
              'Form data has been collected and validated.',
              style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();

              // Perform the action
              context.read<AppState>().updateModerationStatus(
                widget.requestId,
                action.toLowerCase(),
              );

              // Log form data (for static implementation)
              debugPrint('Moderation Form Data: $formData');

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Request ${action.toLowerCase()} and sender notified.',
                  ),
                ),
              );
              context.go('/');
            },
            child: Text(action),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField(
    String label,
    TextEditingController controller, {
    bool isRequired = true,
    TextInputType? keyboardType,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label + (isRequired ? ' *' : ''),
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        const SizedBox(height: 4),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: (_) => setState(() {}),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
        ),
      ],
    );
  }

  Widget _buildSemesterSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Semester *', style: TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        DropdownButtonFormField<String>(
          value: _selectedSemester.isEmpty ? null : _selectedSemester,
          onChanged: (value) => setState(() => _selectedSemester = value ?? ''),
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
            isDense: true,
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          ),
          items: _semesters
              .map(
                (semester) =>
                    DropdownMenuItem(value: semester, child: Text(semester)),
              )
              .toList(),
        ),
      ],
    );
  }

  Widget _buildCriteriaRow(int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${index + 1}. ${_criteria[index]}',
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Text('Response: '),
              ...['Yes', 'No', 'NA'].map(
                (option) => Expanded(
                  child: RadioListTile<String>(
                    dense: true,
                    title: Text(option),
                    value: option,
                    groupValue: _criteriaResponses[index].isEmpty
                        ? null
                        : _criteriaResponses[index],
                    onChanged: (value) {
                      setState(() {
                        _criteriaResponses[index] = value ?? '';
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: _remarksControllers[index],
            onChanged: (_) => setState(() {}),
            maxLines: 2,
            decoration: InputDecoration(
              labelText:
                  'Changes Suggested/Remarks' +
                  (_criteriaResponses[index] == 'No' ? ' *' : ''),
              border: const OutlineInputBorder(),
              isDense: true,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSignOffSection(
    String title,
    TextEditingController nameController,
    TextEditingController signatureController,
    TextEditingController dateController,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 12),
        _buildTextField('Name', nameController),
        const SizedBox(height: 12),
        _buildTextField('Signature (type full name)', signatureController),
        const SizedBox(height: 12),
        _buildTextField('Date', dateController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<AppState>();
    final request = state.findModerationRequest(widget.requestId);
    if (request == null)
      return const Center(child: Text('Moderation request not found'));
    final course = state.findCourse(request.courseId);
    final isReceived = request.direction == 'received';

    return SingleChildScrollView(
      child: AppCard(
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Request Header
              Text(
                request.title,
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 6),
              if (course != null)
                Text(
                  '${course.code} • ${course.title}',
                  style: const TextStyle(color: Colors.black87),
                ),
              Text(request.reportSummary),
              const SizedBox(height: 12),
              Text(
                'Status: ${request.status.toUpperCase()}',
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 24),

              // Course Information Section
              const Text(
                'Course Information',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Course Code',
                      _courseCodeController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      'Course Title',
                      _courseTitleController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField('Department', _departmentController),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      'College/Division',
                      _collegeDivisionController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Number of sections',
                      _sectionsController,
                      keyboardType: TextInputType.number,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildTextField(
                      'Academic Year',
                      _academicYearController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: _buildTextField(
                      'Name of Coordinator or Course Instructor',
                      _coordinatorController,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(child: _buildSemesterSelector()),
                ],
              ),
              const SizedBox(height: 24),

              // Moderation Checklist Section
              const Text(
                'Moderation Checklist',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              ...List.generate(
                _criteria.length,
                (index) => _buildCriteriaRow(index),
              ),
              const SizedBox(height: 24),

              // Confirmation Section
              CheckboxListTile(
                title: const Text(
                  'The changes suggested have been incorporated *',
                ),
                value: _changesIncorporated,
                onChanged: (value) =>
                    setState(() => _changesIncorporated = value ?? false),
                controlAffinity: ListTileControlAffinity.leading,
              ),
              const SizedBox(height: 24),

              // Other Remarks Section
              const Text(
                'Other Remarks',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              TextFormField(
                controller: _otherRemarksController,
                maxLines: 4,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter any additional remarks...',
                ),
              ),
              const SizedBox(height: 24),

              // Sign-off Section
              const Text(
                'Sign-off',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _buildSignOffSection(
                      'Moderator',
                      _moderatorNameController,
                      _moderatorSignatureController,
                      _moderatorDateController,
                    ),
                  ),
                  const SizedBox(width: 24),
                  Expanded(
                    child: _buildSignOffSection(
                      'Program Lead / QA Officer',
                      _programLeadNameController,
                      _programLeadSignatureController,
                      _programLeadDateController,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // Action Buttons
              if (isReceived)
                Row(
                  children: [
                    Expanded(
                      child: PrimaryButton(
                        label: 'Accept',
                        icon: Icons.check,
                        onPressed: () => _handleAction('Accept'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: PrimaryButton(
                        label: 'Reject',
                        icon: Icons.close,
                        onPressed: () => _handleAction('Reject'),
                      ),
                    ),
                  ],
                )
              else
                PrimaryButton(
                  label: request.status == 'accepted'
                      ? 'Download syllabus'
                      : 'Back to dashboard',
                  onPressed: () {
                    if (request.status == 'accepted') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Downloading syllabus (fake action)...',
                          ),
                        ),
                      );
                    } else {
                      context.go('/');
                    }
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
