import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../widgets/ui/search_bar.dart';
import '../widgets/ui/page_header.dart';

class MainLayout extends StatelessWidget {
  const MainLayout({
    super.key,
    required this.title,
    required this.location,
    required this.child,
  });

  final String title;
  final String location;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Sidebar(location: location),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 20,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(child: AppSearchBar(onSubmitted: (value) {})),
                        if (location != '/')
                          Row(
                            children: [
                              const SizedBox(width: 16),
                              _CreateButton(
                                onTap: () {
                                  if (location.startsWith('/courses')) {
                                    context.go('/courses/new');
                                  } else if (location.startsWith('/programs')) {
                                    context.go('/programs/new');
                                  } else if (location.startsWith('/issues')) {
                                    context.go('/issues/new');
                                  } else if (location.startsWith('/admin')) {
                                    context.go('/admin/users/new');
                                  } else {
                                    context.go('/meetings/new');
                                  }
                                },
                              ),
                            ],
                          ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    PageHeader(title: title, subtitle: _subtitleFor(title)),
                    const SizedBox(height: 12),
                    Expanded(child: child),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _subtitleFor(String title) {
    switch (title) {
      case 'Courses':
        return 'All courses available in the university';
      case 'Programs':
        return 'Manage and monitor academic programs';
      case 'Issues':
        return 'Track curriculum and quality issues';
      case 'Meetings':
        return 'Upcoming academic meetings';
      case 'Reports':
        return 'Central view of reports and scorecards';
      case 'Administration':
        return 'System administration and user management';
      default:
        return 'Welcome to your workspace';
    }
  }
}

class _Sidebar extends StatelessWidget {
  const _Sidebar({required this.location});

  final String location;

  @override
  Widget build(BuildContext context) {
    final entries = [
      _NavEntry('Dashboard', Icons.home_rounded, '/'),
      _NavEntry('Courses', Icons.menu_book_rounded, '/courses'),
      _NavEntry('Programs', Icons.school_rounded, '/programs'),
      _NavEntry('Issues', Icons.warning_amber_rounded, '/issues'),
      _NavEntry('Meetings', Icons.event_rounded, '/meetings'),
      _NavEntry('Admin', Icons.admin_panel_settings_rounded, '/admin'),
    ];

    return Container(
      width: 230,
      height: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Dashboard',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ...entries.map((entry) {
            final selected = location.startsWith(entry.route);
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => context.go(entry.route),
                child: Container(
                  height: 48,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: selected
                        ? const Color(0xFFF2F3F6)
                        : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: selected
                        ? Border.all(color: const Color(0xFFE5E7EB))
                        : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        entry.icon,
                        size: 22,
                        color: selected ? Colors.black87 : Colors.black54,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        entry.label,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: selected
                              ? FontWeight.w600
                              : FontWeight.w500,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _NavEntry {
  final String label;
  final IconData icon;
  final String route;
  _NavEntry(this.label, this.icon, this.route);
}

class _CreateButton extends StatelessWidget {
  const _CreateButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.black,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 42,
          height: 42,
          child: Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
}
