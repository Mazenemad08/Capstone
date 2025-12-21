import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../data/fake_data.dart';

class UserManagementPage extends StatefulWidget {
  const UserManagementPage({super.key});

  @override
  State<UserManagementPage> createState() => _UserManagementPageState();
}

class _UserManagementPageState extends State<UserManagementPage> {
  String _selectedRole = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(
      builder: (context, appState, _) {
        var filteredUsers = appState.users.where((user) {
          final matchesRole =
              _selectedRole == 'All' ||
              user.role == _selectedRole.toLowerCase();
          final matchesSearch =
              _searchQuery.isEmpty ||
              user.fullName.toLowerCase().contains(
                _searchQuery.toLowerCase(),
              ) ||
              user.email.toLowerCase().contains(_searchQuery.toLowerCase()) ||
              (user.department?.toLowerCase().contains(
                    _searchQuery.toLowerCase(),
                  ) ??
                  false);
          return matchesRole && matchesSearch;
        }).toList();

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with search and filters
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Search users...',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (value) {
                      setState(() {
                        _searchQuery = value;
                      });
                    },
                  ),
                ),
                const SizedBox(width: 16),
                DropdownButton<String>(
                  value: _selectedRole,
                  items: const [
                    DropdownMenuItem(value: 'All', child: Text('All Roles')),
                    DropdownMenuItem(value: 'Admin', child: Text('Admin')),
                    DropdownMenuItem(value: 'Chair', child: Text('Chair')),
                    DropdownMenuItem(
                      value: 'Moderator',
                      child: Text('Moderator'),
                    ),
                    DropdownMenuItem(value: 'Faculty', child: Text('Faculty')),
                  ],
                  onChanged: (value) {
                    setState(() {
                      _selectedRole = value!;
                    });
                  },
                ),
                const SizedBox(width: 16),
                ElevatedButton.icon(
                  onPressed: () => context.go('/admin/users/new'),
                  icon: const Icon(Icons.add, size: 20),
                  label: const Text('Create User'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).primaryColor,
                    foregroundColor: Colors.white,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Users table
            Expanded(
              child: Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Users (${filteredUsers.length})',
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: SingleChildScrollView(
                          child: DataTable(
                            columnSpacing: 20,
                            columns: const [
                              DataColumn(label: Text('Name')),
                              DataColumn(label: Text('Email')),
                              DataColumn(label: Text('Role')),
                              DataColumn(label: Text('Department')),
                              DataColumn(label: Text('Status')),
                              DataColumn(label: Text('Created')),
                              DataColumn(label: Text('Actions')),
                            ],
                            rows: filteredUsers.map((user) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          user.fullName,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(user.email)),
                                  DataCell(
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 12,
                                        vertical: 6,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getRoleColor(
                                          user.role,
                                        ).withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(16),
                                      ),
                                      child: Text(
                                        user.role.toUpperCase(),
                                        style: TextStyle(
                                          color: _getRoleColor(user.role),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ),
                                  DataCell(Text(user.department ?? '-')),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Container(
                                          width: 8,
                                          height: 8,
                                          decoration: BoxDecoration(
                                            color: user.isActive
                                                ? Colors.green
                                                : Colors.red,
                                            shape: BoxShape.circle,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          user.isActive ? 'Active' : 'Inactive',
                                        ),
                                      ],
                                    ),
                                  ),
                                  DataCell(Text(user.createdAt)),
                                  DataCell(
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 20,
                                          ),
                                          onPressed: () {
                                            context.go(
                                              '/admin/users/${user.id}/edit',
                                            );
                                          },
                                          tooltip: 'Edit User',
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 20,
                                            color: Colors.red,
                                          ),
                                          onPressed: () => _showDeleteDialog(
                                            context,
                                            appState,
                                            user,
                                          ),
                                          tooltip: 'Delete User',
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
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

  Color _getRoleColor(String role) {
    switch (role.toLowerCase()) {
      case 'admin':
        return Colors.red;
      case 'chair':
        return Colors.orange;
      case 'moderator':
        return Colors.purple;
      case 'faculty':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  void _showDeleteDialog(BuildContext context, AppState appState, User user) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete User'),
        content: Text('Are you sure you want to delete ${user.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              appState.deleteUser(user.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${user.fullName} deleted successfully'),
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
