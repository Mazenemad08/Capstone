import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'data/app_state.dart';
import 'layouts/main_layout.dart';
import 'pages/auth/login_page.dart';
import 'pages/dashboard/home_page.dart';
import 'pages/courses/course_list_page.dart';
import 'pages/courses/course_detail_page.dart';
import 'pages/courses/course_report_page.dart';
import 'pages/courses/course_reflection_list_page.dart';
import 'pages/courses/course_versions_page.dart';
import 'pages/courses/create_course_page.dart';
import 'pages/courses/course_evaluations_page.dart';
import 'pages/moderation/moderation_request_page.dart';
import 'pages/programs/program_list_page.dart';
import 'pages/programs/program_detail_page.dart';
import 'pages/programs/program_reports_page.dart';
import 'pages/programs/program_files_page.dart';
import 'pages/programs/program_versions_page.dart';
import 'pages/programs/create_program_page.dart';
import 'pages/programs/program_evaluations_page.dart';
import 'pages/issues/issue_list_page.dart';
import 'pages/issues/issue_detail_page.dart';
import 'pages/issues/issue_report_page.dart';
import 'pages/issues/create_issue_page.dart';
import 'pages/meetings/meeting_list_page.dart';
import 'pages/meetings/single_meeting_page.dart';
import 'pages/meetings/create_meeting_page.dart';
import 'pages/reports/single_report_page.dart';

GoRouter buildRouter(AppState appState) {
  return GoRouter(
    initialLocation: '/login',
    refreshListenable: appState,
    redirect: (context, state) {
      final loggingIn = state.matchedLocation == '/login';
      if (!appState.isLoggedIn && !loggingIn) return '/login';
      if (appState.isLoggedIn && loggingIn) return '/';
      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: 'login',
        builder: (context, state) => const LoginPage(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainLayout(
          title: _titleForRoute(state.matchedLocation),
          location: state.matchedLocation,
          child: child,
        ),
        routes: [
          GoRoute(
            path: '/',
            name: 'dashboard',
            builder: (context, state) => const HomePage(),
          ),
          GoRoute(
            path: '/courses',
            name: 'courses',
            builder: (context, state) => const CourseListPage(),
            routes: [
              GoRoute(
                path: 'new',
                name: 'create-course',
                builder: (context, state) => const CreateCoursePage(),
              ),
              GoRoute(
                path: ':courseId',
                name: 'course-detail',
                builder: (context, state) {
                  final id = state.pathParameters['courseId']!;
                  return CourseDetailPage(courseId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'edit-course',
                    builder: (context, state) {
                      final id = state.pathParameters['courseId']!;
                      final course = context.read<AppState>().findCourse(id);
                      return CreateCoursePage(existingCourse: course);
                    },
                  ),
                  GoRoute(
                    path: 'evaluations',
                    name: 'course-evaluations',
                    builder: (context, state) {
                      final id = state.pathParameters['courseId']!;
                      return CourseEvaluationsPage(courseId: id);
                    },
                  ),
                  GoRoute(
                    path: 'report',
                    name: 'course-report',
                    builder: (context, state) {
                      final id = state.pathParameters['courseId']!;
                      final payload = state.extra is GeneratedReportPayload ? state.extra as GeneratedReportPayload : null;
                      return CourseReportPage(courseId: id, payload: payload);
                    },
                  ),
                  GoRoute(
                    path: 'reflections',
                    name: 'course-reflections',
                    builder: (context, state) {
                      final id = state.pathParameters['courseId']!;
                      return CourseReflectionListPage(courseId: id);
                    },
                  ),
                  GoRoute(
                    path: 'versions',
                    name: 'course-versions',
                    builder: (context, state) {
                      final id = state.pathParameters['courseId']!;
                      return CourseVersionsPage(courseId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/programs',
            name: 'programs',
            builder: (context, state) => const ProgramListPage(),
            routes: [
              GoRoute(
                path: 'new',
                name: 'create-program',
                builder: (context, state) => const CreateProgramPage(),
              ),
              GoRoute(
                path: ':programId',
                name: 'program-detail',
                builder: (context, state) {
                  final id = state.pathParameters['programId']!;
                  return ProgramDetailPage(programId: id);
                },
                routes: [
                  GoRoute(
                    path: 'edit',
                    name: 'edit-program',
                    builder: (context, state) {
                      final id = state.pathParameters['programId']!;
                      final program = context.read<AppState>().findProgram(id);
                      final profile = context.read<AppState>().findProgramProfile(id);
                      return CreateProgramPage(existingProgram: program, existingProfile: profile);
                    },
                  ),
                  GoRoute(
                    path: 'evaluations',
                    name: 'program-evaluations',
                    builder: (context, state) {
                      final id = state.pathParameters['programId']!;
                      return ProgramEvaluationsPage(programId: id);
                    },
                  ),
                  GoRoute(
                    path: 'reports',
                    name: 'program-reports',
                    builder: (context, state) {
                      final id = state.pathParameters['programId']!;
                      return ProgramReportsPage(programId: id);
                    },
                  ),
                  GoRoute(
                    path: 'files',
                    name: 'program-files',
                    builder: (context, state) {
                      final id = state.pathParameters['programId']!;
                      return ProgramFilesPage(programId: id);
                    },
                  ),
                  GoRoute(
                    path: 'versions',
                    name: 'program-versions',
                    builder: (context, state) {
                      final id = state.pathParameters['programId']!;
                      return ProgramVersionsPage(programId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/issues',
            name: 'issues',
            builder: (context, state) => const IssueListPage(),
            routes: [
              GoRoute(
                path: 'new',
                name: 'create-issue',
                builder: (context, state) => const CreateIssuePage(),
              ),
              GoRoute(
                path: ':issueId',
                name: 'issue-detail',
                builder: (context, state) {
                  final id = state.pathParameters['issueId']!;
                  return IssueDetailPage(issueId: id);
                },
                routes: [
                  GoRoute(
                    path: 'report',
                    name: 'issue-report',
                    builder: (context, state) {
                      final id = state.pathParameters['issueId']!;
                      return IssueReportPage(issueId: id);
                    },
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: '/meetings',
            name: 'meetings',
            builder: (context, state) => const MeetingListPage(),
            routes: [
              GoRoute(
                path: 'new',
                name: 'create-meeting',
                builder: (context, state) => const CreateMeetingPage(),
              ),
              GoRoute(
                path: ':meetingId',
                name: 'single-meeting',
                builder: (context, state) {
                  final id = state.pathParameters['meetingId']!;
                  return SingleMeetingPage(meetingId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/reports/:reportId',
            name: 'single-report',
            builder: (context, state) {
              final id = state.pathParameters['reportId']!;
              return SingleReportPage(reportId: id);
            },
          ),
          GoRoute(
            path: '/moderation/:requestId',
            name: 'moderation',
            builder: (context, state) {
              final id = state.pathParameters['requestId']!;
              return ModerationRequestPage(requestId: id);
            },
          ),
        ],
      ),
    ],
  );
}

String _titleForRoute(String location) {
  if (location.startsWith('/courses')) return 'Courses';
  if (location.startsWith('/programs')) return 'Programs';
  if (location.startsWith('/issues')) return 'Issues';
  if (location.startsWith('/meetings')) return 'Meetings';
  if (location.startsWith('/reports')) return 'Reports';
  if (location.startsWith('/moderation')) return 'Moderation';
  return 'Dashboard';
}

extension BuildContextX on BuildContext {
  AppState get appState => read<AppState>();
}
