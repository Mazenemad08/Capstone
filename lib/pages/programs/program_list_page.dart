import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_card.dart';
import '../../widgets/ui/status_badge.dart';

class ProgramListPage extends StatelessWidget {
  const ProgramListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final programs = context.watch<AppState>().programs;
    return GridView.builder(
      itemCount: programs.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 18,
        mainAxisSpacing: 18,
        childAspectRatio: 1.8,
      ),
      itemBuilder: (context, index) {
        final program = programs[index];
        return InkWell(
          onTap: () => context.go('/programs/${program.id}'),
          child: AppCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(program.name, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
                const SizedBox(height: 6),
                Text(program.code, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.black54)),
                const SizedBox(height: 8),
                Text('Department: ${program.department}'),
                Text('Level: ${program.level}'),
                const SizedBox(height: 8),
                StatusBadge(label: program.accreditationStatus),
                const Spacer(),
                TextButton(onPressed: () => context.go('/programs/${program.id}'), child: const Text('Details')),
              ],
            ),
          ),
        );
      },
    );
  }
}
