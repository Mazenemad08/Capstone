import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/dashboard_card.dart';

class AdminDashboardPage extends StatelessWidget {
  const AdminDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        final currentYear = appState.getCurrentAcademicYear();
        final totalUsers = appState.users.length;
        final activeUsers = appState.users.where((u) => u.isActive).length;
        final chairCount = appState.users
            .where((u) => u.role == 'chair')
            .length;
        final moderatorCount = appState.users
            .where((u) => u.role == 'moderator')
            .length;

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Current Academic Year Card
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Current Academic Year',
                                style: Theme.of(context).textTheme.titleMedium
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                currentYear?.name ?? 'Not Set',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                              ),
                            ],
                          ),
                          ElevatedButton.icon(
                            onPressed: () => context.go('/admin/academic-year'),
                            icon: const Icon(Icons.calendar_today, size: 20),
                            label: const Text('Manage'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Theme.of(context).primaryColor,
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      if (currentYear != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          '${currentYear.startDate} - ${currentYear.endDate}',
                          style: Theme.of(context).textTheme.bodyMedium
                              ?.copyWith(color: Colors.grey[600]),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Statistics Cards
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 4,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 1.2,
                children: [
                  DashboardCard(
                    title: 'Total Users',
                    value: totalUsers.toString(),
                    icon: Icons.people,
                    color: Colors.blue,
                    onTap: () => context.go('/admin/users'),
                  ),
                  DashboardCard(
                    title: 'Active Users',
                    value: activeUsers.toString(),
                    icon: Icons.person_outline,
                    color: Colors.green,
                    onTap: () => context.go('/admin/users'),
                  ),
                  DashboardCard(
                    title: 'Chairs',
                    value: chairCount.toString(),
                    icon: Icons.business_center,
                    color: Colors.orange,
                    onTap: () => context.go('/admin/users'),
                  ),
                  DashboardCard(
                    title: 'Moderators',
                    value: moderatorCount.toString(),
                    icon: Icons.admin_panel_settings,
                    color: Colors.purple,
                    onTap: () => context.go('/admin/users'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Quick Actions
              Text(
                'Quick Actions',
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () => context.go('/admin/users/new'),
                        borderRadius: BorderRadius.circular(14),
                        child: const Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.person_add,
                                size: 48,
                                color: Colors.blue,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Create User',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Add new users to the system',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () => context.go('/admin/academic-year'),
                        borderRadius: BorderRadius.circular(14),
                        child: const Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.date_range,
                                size: 48,
                                color: Colors.green,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Academic Year',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'Set current academic year',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Card(
                      child: InkWell(
                        onTap: () => context.go('/admin/users'),
                        borderRadius: BorderRadius.circular(14),
                        child: const Padding(
                          padding: EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Icon(
                                Icons.manage_accounts,
                                size: 48,
                                color: Colors.orange,
                              ),
                              SizedBox(height: 12),
                              Text(
                                'Manage Users',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              SizedBox(height: 4),
                              Text(
                                'View and manage all users',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
