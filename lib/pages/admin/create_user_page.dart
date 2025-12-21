import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../../data/app_state.dart';
import '../../data/fake_data.dart';

class CreateUserPage extends StatefulWidget {
  final User? existingUser;

  const CreateUserPage({super.key, this.existingUser});

  @override
  State<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends State<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();

  String _selectedRole = 'faculty';
  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    if (widget.existingUser != null) {
      _firstNameController.text = widget.existingUser!.firstName;
      _lastNameController.text = widget.existingUser!.lastName;
      _emailController.text = widget.existingUser!.email;
      _departmentController.text = widget.existingUser!.department ?? '';
      _selectedRole = widget.existingUser!.role;
      _isActive = widget.existingUser!.isActive;
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existingUser != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Edit User' : 'Create New User'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'User Information',
                          style: Theme.of(context).textTheme.titleLarge
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 24),

                        Row(
                          children: [
                            Expanded(
                              child: TextFormField(
                                controller: _firstNameController,
                                decoration: const InputDecoration(
                                  labelText: 'First Name',
                                  hintText: 'Enter first name',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter first name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _lastNameController,
                                decoration: const InputDecoration(
                                  labelText: 'Last Name',
                                  hintText: 'Enter last name',
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter last name';
                                  }
                                  return null;
                                },
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _emailController,
                          decoration: const InputDecoration(
                            labelText: 'Email Address',
                            hintText: 'Enter email address',
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter email address';
                            }
                            if (!value.contains('@')) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Expanded(
                              child: DropdownButtonFormField<String>(
                                value: _selectedRole,
                                decoration: const InputDecoration(
                                  labelText: 'Role',
                                ),
                                items: const [
                                  DropdownMenuItem(
                                    value: 'admin',
                                    child: Text('Administrator'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'chair',
                                    child: Text('Chair'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'moderator',
                                    child: Text('Moderator'),
                                  ),
                                  DropdownMenuItem(
                                    value: 'faculty',
                                    child: Text('Faculty'),
                                  ),
                                ],
                                onChanged: (value) {
                                  setState(() {
                                    _selectedRole = value!;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextFormField(
                                controller: _departmentController,
                                decoration: const InputDecoration(
                                  labelText: 'Department (Optional)',
                                  hintText: 'Enter department',
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),

                        Row(
                          children: [
                            Checkbox(
                              value: _isActive,
                              onChanged: (value) {
                                setState(() {
                                  _isActive = value!;
                                });
                              },
                            ),
                            const Text('Active User'),
                          ],
                        ),

                        const SizedBox(height: 32),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => context.pop(),
                              child: const Text('Cancel'),
                            ),
                            const SizedBox(width: 16),
                            ElevatedButton(
                              onPressed: _saveUser,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Theme.of(context).primaryColor,
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 32,
                                  vertical: 16,
                                ),
                              ),
                              child: Text(
                                isEditing ? 'Update User' : 'Create User',
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                if (_selectedRole != 'faculty') ...[
                  const SizedBox(height: 24),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Role Permissions',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 16),
                          _buildPermissionDescription(_selectedRole),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPermissionDescription(String role) {
    String description;
    List<String> permissions;

    switch (role) {
      case 'admin':
        description = 'Administrators have full system access';
        permissions = [
          'Manage all users and their roles',
          'Set academic year and semesters',
          'Access all courses, programs, and reports',
          'System configuration and settings',
        ];
        break;
      case 'chair':
        description =
            'Department chairs have elevated access to their department';
        permissions = [
          'Manage courses in their department',
          'Review and approve curriculum changes',
          'Access department reports and analytics',
          'Oversee faculty in their department',
        ];
        break;
      case 'moderator':
        description = 'Moderators can review and moderate content';
        permissions = [
          'Review curriculum proposals',
          'Moderate course content and changes',
          'Access quality assurance reports',
          'Facilitate curriculum reviews',
        ];
        break;
      default:
        return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(description, style: const TextStyle(fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        ...permissions.map(
          (permission) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                const Icon(Icons.check, size: 16, color: Colors.green),
                const SizedBox(width: 8),
                Expanded(child: Text(permission)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _saveUser() {
    if (_formKey.currentState!.validate()) {
      final appState = context.read<AppState>();

      if (widget.existingUser != null) {
        // Update existing user
        final updatedUser = User(
          id: widget.existingUser!.id,
          email: _emailController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          role: _selectedRole,
          department: _departmentController.text.isEmpty
              ? null
              : _departmentController.text,
          isActive: _isActive,
          createdAt: widget.existingUser!.createdAt,
        );
        appState.updateUser(widget.existingUser!.id, updatedUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User updated successfully')),
        );
      } else {
        // Create new user
        final newUser = User(
          id: 'u${DateTime.now().millisecondsSinceEpoch}',
          email: _emailController.text,
          firstName: _firstNameController.text,
          lastName: _lastNameController.text,
          role: _selectedRole,
          department: _departmentController.text.isEmpty
              ? null
              : _departmentController.text,
          isActive: _isActive,
          createdAt: 'Dec 18, 2025',
        );
        appState.addUser(newUser);

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User created successfully')),
        );
      }

      context.go('/admin/users');
    }
  }
}
