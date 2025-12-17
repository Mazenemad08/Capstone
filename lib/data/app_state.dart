import 'package:flutter/material.dart';
import 'fake_data.dart';

class AppState extends ChangeNotifier {
  bool isLoggedIn = false;
  final List<Course> courses;
  final List<CourseReport> courseReports;
  final List<CourseReflection> courseReflections;
  final List<Program> programs;
  final List<ProgramReport> programReports;
  final List<ProgramFile> programFiles;
  final List<ProgramVersion> programVersions;
  final List<ProgramProfile> programProfiles;
  final List<ModerationRequest> moderationRequests;
  final List<CourseEvaluation> courseEvaluations;
  final List<ProgramEvaluation> programEvaluations;
  final List<Issue> issues;
  final List<IssueReport> issueReports;
  final List<Meeting> meetings;
  final List<GenericReport> reports;

  AppState()
      : courses = List.from(FakeData.courses),
        courseReports = List.from(FakeData.courseReports),
        courseReflections = List.from(FakeData.courseReflections),
        programs = List.from(FakeData.programs),
        programReports = List.from(FakeData.programReports),
        programFiles = List.from(FakeData.programFiles),
        programVersions = List.from(FakeData.programVersions),
        programProfiles = List.from(FakeData.programProfiles),
        moderationRequests = List.from(FakeData.moderationRequests),
        courseEvaluations = List.from(FakeData.courseEvaluations),
        programEvaluations = List.from(FakeData.programEvaluations),
        issues = List.from(FakeData.issues),
        issueReports = List.from(FakeData.issueReports),
        meetings = List.from(FakeData.meetings),
        reports = List.from(FakeData.reports);

  void login() {
    isLoggedIn = true;
    notifyListeners();
  }

  void logout() {
    isLoggedIn = false;
    notifyListeners();
  }

  Course? findCourse(String id) {
    try {
      return courses.firstWhere((c) => c.id == id);
    } catch (_) {
      return null;
    }
  }

  Program? findProgram(String id) {
    try {
      return programs.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  ProgramProfile? findProgramProfile(String programId) {
    try {
      return programProfiles.firstWhere((p) => p.programId == programId);
    } catch (_) {
      return null;
    }
  }

  List<CourseEvaluation> courseEvaluationsFor(String courseId) =>
      courseEvaluations.where((e) => e.courseId == courseId).toList();

  List<ProgramEvaluation> programEvaluationsFor(String programId) =>
      programEvaluations.where((e) => e.programId == programId).toList();

  ModerationRequest? findModerationRequest(String id) {
    try {
      return moderationRequests.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  Issue? findIssue(String id) {
    try {
      return issues.firstWhere((i) => i.id == id);
    } catch (_) {
      return null;
    }
  }

  Meeting? findMeeting(String id) {
    try {
      return meetings.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  CourseReport? findCourseReport(String courseId) {
    try {
      return courseReports.firstWhere((r) => r.courseId == courseId);
    } catch (_) {
      return null;
    }
  }

  List<CourseReflection> reflectionsForCourse(String courseId) =>
      courseReflections.where((r) => r.courseId == courseId).toList();

  List<ProgramReport> reportsForProgram(String programId) =>
      programReports.where((r) => r.programId == programId).toList();

  List<ProgramFile> filesForProgram(String programId) =>
      programFiles.where((r) => r.programId == programId).toList();

  List<ProgramVersion> versionsForProgram(String programId) =>
      programVersions.where((r) => r.programId == programId).toList();

  List<Issue> issuesForProgram(String programId) =>
      issues.where((i) => i.relatedProgramId == programId).toList();

  IssueReport? reportForIssue(String issueId) {
    try {
      return issueReports.firstWhere((r) => r.issueId == issueId);
    } catch (_) {
      return null;
    }
  }

  void addIssue({
    required String title,
    required String description,
    String? relatedCourseId,
    String? relatedProgramId,
    String status = 'Open',
    String priority = 'Medium',
    String owner = 'Quality Office',
  }) {
    final issue = Issue(
      id: 'i${issues.length + 1}',
      title: title,
      description: description,
      relatedCourseId: relatedCourseId,
      relatedProgramId: relatedProgramId,
      status: status,
      priority: priority,
      createdAt: DateTime.now().toIso8601String().substring(0, 10),
      owner: owner,
    );
    issues.insert(0, issue);
    notifyListeners();
  }

  void addCourseEvaluation({
    required String courseId,
    required String version,
    required String notes,
    required String date,
  }) {
    final evaluation = CourseEvaluation(
      id: 'ce${courseEvaluations.length + 1}',
      courseId: courseId,
      version: version,
      notes: notes,
      date: date,
    );
    courseEvaluations.insert(0, evaluation);
    notifyListeners();
  }

  void addProgramEvaluation({
    required String programId,
    required String version,
    required String notes,
    required String date,
  }) {
    final evaluation = ProgramEvaluation(
      id: 'pe${programEvaluations.length + 1}',
      programId: programId,
      version: version,
      notes: notes,
      date: date,
    );
    programEvaluations.insert(0, evaluation);
    notifyListeners();
  }

  void addIssueReport({
    required String issueId,
    required String correctiveActions,
    required String followUp,
  }) {
    final report = IssueReport(
      id: 'ir${issueReports.length + 1}',
      issueId: issueId,
      correctiveActions: correctiveActions,
      followUp: followUp,
      status: 'Submitted',
    );
    issueReports.add(report);
    notifyListeners();
  }

  void addCourse({
    required String code,
    required String title,
    required String description,
    required String programId,
    required int credits,
    required String instructor,
    required String semester,
    List<WeeklyTopic> topics = const [],
    List<AssessmentItem> assessments = const [],
    List<CourseClo> clos = const [],
  }) {
    final course = Course(
      id: 'c${courses.length + 1}',
      code: code,
      title: title,
      description: description,
      programId: programId,
      credits: credits,
      instructor: instructor,
      semester: semester,
      topics: topics,
      assessments: assessments,
      clos: clos,
    );
    courses.add(course);
    notifyListeners();
  }

  void updateCourse({
    required String id,
    required String code,
    required String title,
    required String description,
    required String programId,
    required int credits,
    required String instructor,
    required String semester,
    List<WeeklyTopic> topics = const [],
    List<AssessmentItem> assessments = const [],
    List<CourseClo> clos = const [],
  }) {
    final idx = courses.indexWhere((c) => c.id == id);
    if (idx == -1) return;
    courses[idx] = Course(
      id: id,
      code: code,
      title: title,
      description: description,
      programId: programId,
      credits: credits,
      instructor: instructor,
      semester: semester,
      topics: topics,
      assessments: assessments,
      clos: clos,
    );
    notifyListeners();
  }

  void addProgram({
    required String name,
    required String code,
    required String department,
    required String level,
    required String accreditationStatus,
    required String description,
    required String college,
    List<String> objectives = const [],
    String whyTake = '',
    List<String> destinations = const [],
    List<ProgramOutcome> plos = const [],
    List<ProgramOutcome> pis = const [],
    List<String> ilos = const [],
    String graduateProfile = '',
    List<ProgramStructure> structures = const [],
  }) {
    final program = Program(
      id: 'p${programs.length + 1}',
      name: name,
      code: code,
      department: department,
      level: level,
      accreditationStatus: accreditationStatus,
      description: description,
      college: college,
    );
    programs.add(program);
    final profile = ProgramProfile(
      programId: program.id,
      objectives: objectives,
      whyTake: whyTake,
      destinations: destinations,
      plos: plos,
      pis: pis,
      ilos: ilos,
      graduateProfile: graduateProfile,
      structures: structures,
    );
    programProfiles.add(profile);
    notifyListeners();
  }

  void updateProgramWithProfile({
    required String id,
    required String name,
    required String code,
    required String department,
    required String level,
    required String accreditationStatus,
    required String description,
    required String college,
    List<String> objectives = const [],
    String whyTake = '',
    List<String> destinations = const [],
    List<ProgramOutcome> plos = const [],
    List<ProgramOutcome> pis = const [],
    List<String> ilos = const [],
    String graduateProfile = '',
    List<ProgramStructure> structures = const [],
  }) {
    final idx = programs.indexWhere((p) => p.id == id);
    if (idx == -1) return;
    programs[idx] = Program(
      id: id,
      name: name,
      code: code,
      department: department,
      level: level,
      accreditationStatus: accreditationStatus,
      description: description,
      college: college,
    );
    final profileIdx = programProfiles.indexWhere((p) => p.programId == id);
    final newProfile = ProgramProfile(
      programId: id,
      objectives: objectives,
      whyTake: whyTake,
      destinations: destinations,
      plos: plos,
      pis: pis,
      ilos: ilos,
      graduateProfile: graduateProfile,
      structures: structures,
    );
    if (profileIdx == -1) {
      programProfiles.add(newProfile);
    } else {
      programProfiles[profileIdx] = newProfile;
    }
    notifyListeners();
  }

  void updateModerationStatus(String requestId, String status) {
    final idx = moderationRequests.indexWhere((m) => m.id == requestId);
    if (idx != -1) {
      final current = moderationRequests[idx];
      moderationRequests[idx] = ModerationRequest(
        id: current.id,
        courseId: current.courseId,
        direction: current.direction,
        status: status,
        title: current.title,
        reportSummary: current.reportSummary,
      );
      notifyListeners();
    }
  }

  void addMeeting(Meeting meeting) {
    meetings.add(meeting);
    notifyListeners();
  }

  void addGenericReport(GenericReport report) {
    reports.add(report);
    notifyListeners();
  }

  int get totalCourses => courses.length;
  int get totalPrograms => programs.length;
  int get openIssues => issues.where((i) => i.status == 'Open').length;
  int get upcomingMeetings => meetings.where((m) => m.dateTime.isAfter(DateTime.now())).length;
}
