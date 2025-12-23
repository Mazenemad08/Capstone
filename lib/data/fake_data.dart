import 'package:flutter/material.dart';

@immutable
class WeeklyTopic {
  final String title;
  final String closCovered;
  final String teachingMethods;
  final String assessmentMethods;

  const WeeklyTopic({
    required this.title,
    required this.closCovered,
    required this.teachingMethods,
    required this.assessmentMethods,
  });
}

@immutable
class AssessmentItem {
  final String name;
  final String method;
  final String type; // formative or summative
  final String closAssessed;
  final String description;
  final String nqfLevel;
  final String weight;

  const AssessmentItem({
    required this.name,
    required this.method,
    required this.type,
    required this.closAssessed,
    required this.description,
    required this.nqfLevel,
    required this.weight,
  });
}

@immutable
class CourseClo {
  final String code;
  final String description;
  final String descriptor;
  final String category;
  final String nqfLevel;

  const CourseClo({
    required this.code,
    required this.description,
    required this.descriptor,
    this.category = '',
    this.nqfLevel = 'Level 7',
  });
}

@immutable
class User {
  final String id;
  final String email;
  final String firstName;
  final String lastName;
  final String role; // 'admin', 'chair', 'moderator', 'faculty'
  final String? department;
  final bool isActive;
  final String createdAt;

  const User({
    required this.id,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.role,
    this.department,
    this.isActive = true,
    required this.createdAt,
  });

  String get fullName => '$firstName $lastName';
}

@immutable
class AcademicYear {
  final String id;
  final String name; // e.g., '2023-2024'
  final String startDate;
  final String endDate;
  final bool isCurrent;
  final List<AcademicSemester> semesters;

  const AcademicYear({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
    required this.semesters,
  });
}

@immutable
class AcademicSemester {
  final String id;
  final String name; // e.g., 'Fall 2023', 'Spring 2024'
  final String startDate;
  final String endDate;
  final bool isCurrent;

  const AcademicSemester({
    required this.id,
    required this.name,
    required this.startDate,
    required this.endDate,
    required this.isCurrent,
  });
}

@immutable
class Course {
  final String id;
  final String code;
  final String title;
  final String description;
  final String programId;
  final String instructor;
  final String semester;
  final int credits;
  final List<WeeklyTopic> topics;
  final List<AssessmentItem> assessments;
  final List<CourseClo> clos;

  const Course({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.programId,
    required this.instructor,
    required this.semester,
    required this.credits,
    required this.topics,
    required this.assessments,
    required this.clos,
  });
}

@immutable
class CourseReport {
  final String courseId;
  final String description;
  final List<String> learningOutcomes;
  final List<String> weeklyOutline;
  final List<String> assessmentMethods;

  const CourseReport({
    required this.courseId,
    required this.description,
    required this.learningOutcomes,
    required this.weeklyOutline,
    required this.assessmentMethods,
  });
}

@immutable
class CourseReflection {
  final String id;
  final String courseId;
  final String semester;
  final String instructor;
  final int enrolled;
  final String summary;

  const CourseReflection({
    required this.id,
    required this.courseId,
    required this.semester,
    required this.instructor,
    required this.enrolled,
    required this.summary,
  });
}

@immutable
class Program {
  final String id;
  final String name;
  final String code;
  final String department;
  final String level;
  final String accreditationStatus;
  final String description;
  final String college;

  const Program({
    required this.id,
    required this.name,
    required this.code,
    required this.department,
    required this.level,
    required this.accreditationStatus,
    required this.description,
    required this.college,
  });
}

@immutable
class ProgramReport {
  final String id;
  final String programId;
  final String name;
  final String date;
  final String status;
  final String summary;

  const ProgramReport({
    required this.id,
    required this.programId,
    required this.name,
    required this.date,
    required this.status,
    required this.summary,
  });
}

@immutable
class ProgramFile {
  final String id;
  final String programId;
  final String filename;
  final String type;
  final String updatedAt;

  const ProgramFile({
    required this.id,
    required this.programId,
    required this.filename,
    required this.type,
    required this.updatedAt,
  });
}

@immutable
class ProgramVersion {
  final String id;
  final String programId;
  final String version;
  final String effectiveDate;
  final String summary;

  const ProgramVersion({
    required this.id,
    required this.programId,
    required this.version,
    required this.effectiveDate,
    required this.summary,
  });
}

@immutable
class Issue {
  final String id;
  final String title;
  final String description;
  final String? relatedCourseId;
  final String? relatedProgramId;
  final String status;
  final String severity;
  final String createdAt;
  final String owner;

  const Issue({
    required this.id,
    required this.title,
    required this.description,
    required this.relatedCourseId,
    required this.relatedProgramId,
    required this.status,
    required this.severity,
    required this.createdAt,
    required this.owner,
  });
}

@immutable
class IssueReport {
  final String id;
  final String issueId;
  final String correctiveActions;
  final String followUp;
  final String status;

  const IssueReport({
    required this.id,
    required this.issueId,
    required this.correctiveActions,
    required this.followUp,
    required this.status,
  });
}

@immutable
class Meeting {
  final String id;
  final String title;
  final DateTime dateTime;
  final List<String> participants;
  final String? relatedCourseId;
  final String? relatedProgramId;
  final List<String> relatedIssueIds;
  final List<String> minutes;

  const Meeting({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.participants,
    required this.relatedCourseId,
    required this.relatedProgramId,
    required this.relatedIssueIds,
    required this.minutes,
  });
}

@immutable
class GenericReport {
  final String id;
  final String title;
  final String type;
  final String related;
  final String status;
  final String body;

  const GenericReport({
    required this.id,
    required this.title,
    required this.type,
    required this.related,
    required this.status,
    required this.body,
  });
}

@immutable
class ModerationRequest {
  final String id;
  final String courseId;
  final String direction; // sent or received
  final String status; // pending, accepted, rejected
  final String title;
  final String reportSummary;

  const ModerationRequest({
    required this.id,
    required this.courseId,
    required this.direction,
    required this.status,
    required this.title,
    required this.reportSummary,
  });
}

@immutable
class ProgramOutcome {
  final String code;
  final String description;

  const ProgramOutcome({required this.code, required this.description});
}

@immutable
class CloPloMap {
  final String cloCode;
  final String ploCode;

  const CloPloMap({required this.cloCode, required this.ploCode});
}

@immutable
class ProgramCourseSelection {
  final String courseId;
  final String category;
  final List<CloPloMap> mappings;

  const ProgramCourseSelection({
    required this.courseId,
    required this.category,
    required this.mappings,
  });
}

@immutable
class ProgramStructure {
  final String category;
  final int credits;
  final List<ProgramCourseSelection> courses;
  final bool graduatePortfolio;

  const ProgramStructure({
    required this.category,
    required this.credits,
    required this.courses,
    this.graduatePortfolio = false,
  });
}

@immutable
class ProgramProfile {
  final String programId;
  final List<String> objectives;
  final String whyTake;
  final List<String> destinations;
  final List<ProgramOutcome> plos;
  final List<ProgramOutcome> pis;
  final List<String> ilos;
  final String graduateProfile;
  final List<ProgramStructure> structures;

  const ProgramProfile({
    required this.programId,
    required this.objectives,
    required this.whyTake,
    required this.destinations,
    required this.plos,
    required this.pis,
    required this.ilos,
    required this.graduateProfile,
    required this.structures,
  });
}

@immutable
class CourseEvaluation {
  final String id;
  final String courseId;
  final String version;
  final String notes;
  final String date;

  const CourseEvaluation({
    required this.id,
    required this.courseId,
    required this.version,
    required this.notes,
    required this.date,
  });
}

@immutable
class ProgramEvaluation {
  final String id;
  final String programId;
  final String version;
  final String notes;
  final String date;

  const ProgramEvaluation({
    required this.id,
    required this.programId,
    required this.version,
    required this.notes,
    required this.date,
  });
}

class FakeData {
  static List<Course> courses = [
    const Course(
      id: 'c1',
      code: 'COSC248',
      title: 'Algorithms & Complexity',
      description:
          'Study of algorithm design, complexity analysis, and optimization patterns.',
      programId: 'p1',
      instructor: 'Dr. Hana Ibrahim',
      semester: 'Fall 2024',
      credits: 3,
      clos: [
        CourseClo(
          code: 'A1',
          description:
              'Demonstrate advanced knowledge of algorithm design and complexity analysis.',
          descriptor: 'Knowledge – Theoretical Understanding (Level 7)',
          category: 'A. Knowledge',
        ),
        CourseClo(
          code: 'A2',
          description:
              'Apply design techniques (divide and conquer, DP, greedy) to solve problems.',
          descriptor: 'Knowledge – Applied Knowledge (Level 7)',
          category: 'A. Knowledge',
        ),
        CourseClo(
          code: 'B1',
          description:
              'Analyze trade-offs and select efficient data structures/algorithms.',
          descriptor:
              'Skills – Generic Problem Solving & Analytical Skills (Level 7)',
          category: 'B. Skills',
        ),
      ],
      topics: [
        WeeklyTopic(
          title: 'Algorithm analysis basics',
          closCovered: 'A1, A2',
          teachingMethods: 'Lecture, discussion',
          assessmentMethods: 'In-class exercises',
        ),
        WeeklyTopic(
          title: 'Divide and conquer',
          closCovered: 'A1, B1',
          teachingMethods: 'Lecture, tutorial',
          assessmentMethods: 'Tutorial tasks',
        ),
      ],
      assessments: [
        AssessmentItem(
          name: 'Programming Assignments',
          method: 'Problem solving sets',
          type: 'Formative',
          closAssessed: 'A1, A2, B1',
          description: 'Weekly coding problems reinforcing design patterns.',
          nqfLevel: '7',
          weight: '35',
        ),
        AssessmentItem(
          name: 'Midterm Exam',
          method: 'Written, problem solving',
          type: 'Summative',
          closAssessed: 'A1, B1',
          description: 'Complexity and divide-and-conquer analysis.',
          nqfLevel: '7',
          weight: '25',
        ),
      ],
    ),
    const Course(
      id: 'c2',
      code: 'BUSN210',
      title: 'Principles of Management',
      description:
          'Fundamentals of management, leadership, and organizational behavior.',
      programId: 'p2',
      instructor: 'Prof. Laila Ahmed',
      semester: 'Spring 2025',
      credits: 3,
      clos: [
        CourseClo(
          code: 'A1',
          description:
              'Explain core management functions and leadership theories.',
          descriptor: 'Knowledge – Theoretical Understanding (Level 7)',
          category: 'A. Knowledge',
        ),
        CourseClo(
          code: 'B1',
          description: 'Analyze organizational structures and diagnose issues.',
          descriptor: 'Skills – Analytical (Level 7)',
          category: 'B. Skills',
        ),
      ],
      topics: [
        WeeklyTopic(
          title: 'Management roles & functions',
          closCovered: 'A1, B1',
          teachingMethods: 'Lecture, case discussion',
          assessmentMethods: 'In-class discussion',
        ),
        WeeklyTopic(
          title: 'Organizational design',
          closCovered: 'A2, B2',
          teachingMethods: 'Lecture, workshop',
          assessmentMethods: 'Group activity',
        ),
      ],
      assessments: [
        AssessmentItem(
          name: 'Case Study Writeups',
          method: 'Short papers',
          type: 'Summative',
          closAssessed: 'A1, B1',
          description: 'Apply leadership models to cases.',
          nqfLevel: '7',
          weight: '30',
        ),
        AssessmentItem(
          name: 'Final Exam',
          method: 'Written exam',
          type: 'Summative',
          closAssessed: 'A1, A2, B2',
          description: 'Comprehensive exam covering all topics.',
          nqfLevel: '7',
          weight: '40',
        ),
      ],
    ),
    const Course(
      id: 'c3',
      code: 'ENGR101',
      title: 'Introduction to Engineering',
      description:
          'Broad survey of engineering disciplines with hands-on design labs.',
      programId: 'p3',
      instructor: 'Dr. Omar Salman',
      semester: 'Fall 2024',
      credits: 4,
      clos: [
        CourseClo(
          code: 'A1',
          description:
              'Describe the breadth of engineering disciplines and impacts.',
          descriptor: 'Knowledge – Applied (Level 6)',
          category: 'A. Knowledge',
        ),
      ],
      topics: [
        WeeklyTopic(
          title: 'What is Engineering?',
          closCovered: 'A1',
          teachingMethods: 'Lecture, panel',
          assessmentMethods: 'Reflection task',
        ),
      ],
      assessments: [
        AssessmentItem(
          name: 'Design Lab',
          method: 'Hands-on lab',
          type: 'Formative',
          closAssessed: 'A1, B1',
          description: 'Mini design challenge in teams.',
          nqfLevel: '6',
          weight: '20',
        ),
      ],
    ),
    const Course(
      id: 'c4',
      code: 'MATH220',
      title: 'Discrete Mathematics',
      description:
          'Logic, combinatorics, graph theory, and proofs for computer science.',
      programId: 'p1',
      instructor: 'Dr. Reem Al-Hassan',
      semester: 'Summer 2024',
      credits: 3,
      clos: [
        CourseClo(
          code: 'A1',
          description:
              'Apply logic, sets, and proof techniques to discrete problems.',
          descriptor: 'Knowledge – Applied (Level 7)',
          category: 'A. Knowledge',
        ),
      ],
      topics: [
        WeeklyTopic(
          title: 'Logic & Proofs',
          closCovered: 'A1',
          teachingMethods: 'Lecture, tutorial',
          assessmentMethods: 'Tutorial problems',
        ),
      ],
      assessments: [
        AssessmentItem(
          name: 'Problem Sets',
          method: 'Weekly exercises',
          type: 'Formative',
          closAssessed: 'A1, B1',
          description: 'Proof writing and combinatorics practice.',
          nqfLevel: '6',
          weight: '30',
        ),
      ],
    ),
  ];

  static List<CourseReport> courseReports = [
    const CourseReport(
      courseId: 'c1',
      description:
          'Syllabus outlining advanced algorithm topics with weekly labs.',
      learningOutcomes: [
        'Analyze algorithmic complexity using Big-O notation.',
        'Design algorithms for graph and network problems.',
        'Evaluate trade-offs between time and space efficiency.',
      ],
      weeklyOutline: [
        'Week 1: Algorithm analysis basics',
        'Week 2: Divide and conquer',
        'Week 3: Dynamic programming',
        'Week 4: Greedy methods',
        'Week 5: Graph algorithms',
      ],
      assessmentMethods: [
        'Midterm exam (25%)',
        'Programming assignments (35%)',
        'Final project (25%)',
        'Participation (15%)',
      ],
    ),
    const CourseReport(
      courseId: 'c2',
      description:
          'Course report covering management frameworks and case studies.',
      learningOutcomes: [
        'Apply leadership models to team scenarios.',
        'Interpret organizational culture diagnostics.',
        'Develop strategic plans with KPIs.',
      ],
      weeklyOutline: [
        'Week 1: Management roles',
        'Week 2: Organizational design',
        'Week 3: Motivation theories',
        'Week 4: Strategy execution',
      ],
      assessmentMethods: [
        'Case study writeups (30%)',
        'Group presentation (20%)',
        'Final exam (40%)',
        'Participation (10%)',
      ],
    ),
  ];

  static List<CourseReflection> courseReflections = [
    const CourseReflection(
      id: 'cr1',
      courseId: 'c1',
      semester: 'Fall 2024',
      instructor: 'Dr. Hana Ibrahim',
      enrolled: 42,
      summary:
          'Students excelled in dynamic programming; need more graph practice.',
    ),
    const CourseReflection(
      id: 'cr2',
      courseId: 'c2',
      semester: 'Spring 2025',
      instructor: 'Prof. Laila Ahmed',
      enrolled: 58,
      summary: 'Guest speakers were impactful; plan to add operations module.',
    ),
  ];

  static List<Program> programs = [
    const Program(
      id: 'p1',
      name: 'BSc Computer Science',
      code: 'BSCS',
      department: 'Computing',
      level: 'Undergraduate',
      accreditationStatus: 'Accredited',
      description: 'Focused on software engineering, AI, and systems.',
      college: 'Engineering',
    ),
    const Program(
      id: 'p2',
      name: 'BBA Management',
      code: 'BBAM',
      department: 'Business',
      level: 'Undergraduate',
      accreditationStatus: 'Pending',
      description: 'Prepares leaders with management and strategy depth.',
      college: 'Business',
    ),
    const Program(
      id: 'p3',
      name: 'BEng General Engineering',
      code: 'BENG',
      department: 'Engineering',
      level: 'Undergraduate',
      accreditationStatus: 'Accredited',
      description: 'Broad foundation across engineering disciplines.',
      college: 'Engineering',
    ),
  ];

  static List<ProgramReport> programReports = [
    const ProgramReport(
      id: 'pr1',
      programId: 'p1',
      name: 'Annual Review 2024',
      date: '2024-12-01',
      status: 'Draft',
      summary: 'Curriculum refreshed with new AI concentration.',
    ),
    const ProgramReport(
      id: 'pr2',
      programId: 'p2',
      name: 'Accreditation Self-Study',
      date: '2024-10-15',
      status: 'Submitted',
      summary: 'Awaiting accreditor feedback.',
    ),
  ];

  static List<ProgramFile> programFiles = [
    const ProgramFile(
      id: 'pf1',
      programId: 'p1',
      filename: 'Program Specification.pdf',
      type: 'Specification',
      updatedAt: '2024-09-18',
    ),
    const ProgramFile(
      id: 'pf2',
      programId: 'p2',
      filename: 'Curriculum Map.xlsx',
      type: 'Curriculum Map',
      updatedAt: '2024-07-30',
    ),
  ];

  static List<ProgramVersion> programVersions = [
    const ProgramVersion(
      id: 'pv1',
      programId: 'p1',
      version: 'v2.1',
      effectiveDate: '2024-08-01',
      summary: 'Added capstone sequence and ethics module.',
    ),
    const ProgramVersion(
      id: 'pv2',
      programId: 'p2',
      version: 'v1.4',
      effectiveDate: '2024-05-01',
      summary: 'Updated assessment rubrics and course outlines.',
    ),
  ];

  static List<ModerationRequest> moderationRequests = [
    const ModerationRequest(
      id: 'mr1',
      courseId: 'c1',
      direction: 'sent',
      status: 'pending',
      title: 'COSC248 – Fall 2024 Report',
      reportSummary:
          'Awaiting moderation feedback for Algorithms & Complexity.',
    ),
    const ModerationRequest(
      id: 'mr2',
      courseId: 'c2',
      direction: 'sent',
      status: 'accepted',
      title: 'BUSN210 – Spring 2025 Report',
      reportSummary: 'Approved syllabus for Principles of Management.',
    ),
    const ModerationRequest(
      id: 'mr3',
      courseId: 'c3',
      direction: 'received',
      status: 'pending',
      title: 'ENGR101 – Fall 2024 Report',
      reportSummary: 'Review introductory engineering syllabus for moderation.',
    ),
  ];

  static List<ProgramProfile> programProfiles = [
    const ProgramProfile(
      programId: 'p1',
      objectives: [
        'Provide technical knowledge and skills for a successful computing career.',
        'Develop communication and social skills for teamwork.',
        'Grow ability to solve problems creatively.',
      ],
      whyTake:
          'Combines theoretical foundations with applied practice to prepare students for industry roles such as software engineer, data scientist, and cybersecurity analyst.',
      destinations: [
        'Full stack developer',
        'Data scientist',
        'Cybersecurity analyst',
        'Product engineer',
      ],
      plos: [
        ProgramOutcome(
          code: 'PLO1',
          description:
              'Demonstrate critical knowledge of core computing concepts.',
        ),
        ProgramOutcome(
          code: 'PLO2',
          description:
              'Analyze and define computing requirements and evaluate solutions.',
        ),
        ProgramOutcome(
          code: 'PLO3',
          description: 'Design and implement computing solutions in context.',
        ),
        ProgramOutcome(
          code: 'PLO4',
          description: 'Apply professional and ethical standards in practice.',
        ),
        ProgramOutcome(
          code: 'PLO5',
          description:
              'Communicate effectively with technical and non-technical audiences.',
        ),
        ProgramOutcome(
          code: 'PLO6',
          description:
              'Work effectively in teams and collaborative environments.',
        ),
        ProgramOutcome(
          code: 'PLO7',
          description:
              'Demonstrate lifelong learning and professional development.',
        ),
      ],
      pis: [
        ProgramOutcome(
          code: 'PI1',
          description: 'Use appropriate algorithms and data structures.',
        ),
        ProgramOutcome(
          code: 'PI2',
          description: 'Apply ethical and professional standards.',
        ),
      ],
      ilos: [
        'Evaluate personal strengths and weaknesses to grow.',
        'Integrate new ideas based on merit.',
        'Monitor societal and market conditions.',
      ],
      graduateProfile:
          'Graduates are adaptive computing professionals with strong analytical, ethical, and communication skills.',
      structures: [
        ProgramStructure(
          category: 'General Education',
          credits: 39,
          graduatePortfolio: false,
          courses: [],
        ),
        ProgramStructure(
          category: 'Computing Requirements',
          credits: 40,
          graduatePortfolio: false,
          courses: [],
        ),
        ProgramStructure(
          category: 'Major Requirements',
          credits: 33,
          graduatePortfolio: false,
          courses: [],
        ),
        ProgramStructure(
          category: 'Major Electives',
          credits: 9,
          graduatePortfolio: false,
          courses: [],
        ),
        ProgramStructure(
          category: 'Professional Electives',
          credits: 6,
          graduatePortfolio: true,
          courses: [],
        ),
      ],
    ),
  ];

  static List<Issue> issues = [
    const Issue(
      id: 'i1',
      title: 'Capstone prerequisite gap',
      description: 'Students enrolling without completing algorithms.',
      relatedCourseId: 'c1',
      relatedProgramId: 'p1',
      status: 'Open',
      severity: 'Major',
      createdAt: '2024-09-10',
      owner: 'Quality Office',
    ),
    const Issue(
      id: 'i2',
      title: 'Accreditation evidence missing',
      description: 'Need updated employer survey results.',
      relatedCourseId: null,
      relatedProgramId: 'p2',
      status: 'In Progress',
      severity: 'Minor',
      createdAt: '2024-10-02',
      owner: 'Accreditation Lead',
    ),
  ];

  static List<IssueReport> issueReports = [
    const IssueReport(
      id: 'ir1',
      issueId: 'i1',
      correctiveActions:
          'Introduce automated prerequisite check and advisor outreach.',
      followUp: 'Review enrollment data after add/drop.',
      status: 'Draft',
    ),
  ];

  static List<Meeting> meetings = [
    Meeting(
      id: 'm1',
      title: 'Curriculum Committee',
      dateTime: DateTime.now().add(const Duration(days: 2)),
      participants: const ['Dean', 'Program Chairs', 'QA Officer'],
      relatedCourseId: 'c1',
      relatedProgramId: 'p1',
      relatedIssueIds: const ['i1'],
      minutes: const [
        'Reviewed new AI track proposal.',
        'Action: finalize course mapping by next week.',
      ],
    ),
    Meeting(
      id: 'm2',
      title: 'Accreditation Follow-up',
      dateTime: DateTime.now().add(const Duration(days: 7)),
      participants: const ['Accreditation Lead', 'QA Officer'],
      relatedCourseId: null,
      relatedProgramId: 'p2',
      relatedIssueIds: const ['i2'],
      minutes: const [
        'Collected missing evidence list.',
        'Assigned owners for survey updates.',
      ],
    ),
  ];

  static List<GenericReport> reports = [
    const GenericReport(
      id: 'gr1',
      title: 'Maintenance Report - Capstone',
      type: 'Maintenance',
      related: 'Capstone prerequisite gap',
      status: 'Draft',
      body: 'Summary of maintenance actions for capstone readiness.',
    ),
  ];

  static List<CourseEvaluation> courseEvaluations = [
    const CourseEvaluation(
      id: 'ce1',
      courseId: 'c1',
      version: 'v1.0',
      notes: 'Midterm evaluation: strong engagement, add more graph labs.',
      date: '2024-10-15',
    ),
  ];

  static List<ProgramEvaluation> programEvaluations = [
    const ProgramEvaluation(
      id: 'pe1',
      programId: 'p1',
      version: 'v2.1',
      notes: 'Annual review: PLO alignment improved; expand electives.',
      date: '2024-11-01',
    ),
  ];

  static List<User> users = [
    const User(
      id: 'u1',
      email: 'admin@aubh.edu.bh',
      firstName: 'System',
      lastName: 'Administrator',
      role: 'admin',
      createdAt: 'Jan 01, 2023',
    ),
    const User(
      id: 'u2',
      email: 'john.smith@aubh.edu.bh',
      firstName: 'John',
      lastName: 'Smith',
      role: 'chair',
      department: 'Computer Science',
      createdAt: 'Feb 15, 2023',
    ),
    const User(
      id: 'u3',
      email: 'sarah.johnson@aubh.edu.bh',
      firstName: 'Sarah',
      lastName: 'Johnson',
      role: 'moderator',
      department: 'Engineering',
      createdAt: 'Mar 10, 2023',
    ),
    const User(
      id: 'u4',
      email: 'mike.davis@aubh.edu.bh',
      firstName: 'Mike',
      lastName: 'Davis',
      role: 'faculty',
      department: 'Business',
      createdAt: 'Apr 05, 2023',
    ),
  ];

  static List<AcademicYear> academicYears = [
    const AcademicYear(
      id: 'ay1',
      name: '2023-2024',
      startDate: 'Aug 01, 2023',
      endDate: 'Jul 31, 2024',
      isCurrent: true,
      semesters: [
        AcademicSemester(
          id: 's1',
          name: 'Fall 2023',
          startDate: 'Aug 15, 2023',
          endDate: 'Dec 15, 2023',
          isCurrent: false,
        ),
        AcademicSemester(
          id: 's2',
          name: 'Spring 2024',
          startDate: 'Jan 15, 2024',
          endDate: 'May 15, 2024',
          isCurrent: true,
        ),
        AcademicSemester(
          id: 's3',
          name: 'Summer 2024',
          startDate: 'Jun 01, 2024',
          endDate: 'Jul 31, 2024',
          isCurrent: false,
        ),
      ],
    ),
    const AcademicYear(
      id: 'ay2',
      name: '2024-2025',
      startDate: 'Aug 01, 2024',
      endDate: 'Jul 31, 2025',
      isCurrent: false,
      semesters: [
        AcademicSemester(
          id: 's4',
          name: 'Fall 2024',
          startDate: 'Aug 15, 2024',
          endDate: 'Dec 15, 2024',
          isCurrent: false,
        ),
        AcademicSemester(
          id: 's5',
          name: 'Spring 2025',
          startDate: 'Jan 15, 2025',
          endDate: 'May 15, 2025',
          isCurrent: false,
        ),
        AcademicSemester(
          id: 's6',
          name: 'Summer 2025',
          startDate: 'Jun 01, 2025',
          endDate: 'Jul 31, 2025',
          isCurrent: false,
        ),
      ],
    ),
  ];
}
