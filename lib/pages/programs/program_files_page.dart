import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../data/app_state.dart';
import '../../widgets/ui/app_table.dart';

class ProgramFilesPage extends StatelessWidget {
  const ProgramFilesPage({super.key, required this.programId});

  final String programId;

  @override
  Widget build(BuildContext context) {
    final files = context.watch<AppState>().filesForProgram(programId);
    if (files.isEmpty) return const Center(child: Text('No files uploaded'));

    return SingleChildScrollView(
      child: AppTable(
        columns: const ['Filename', 'Type', 'Last Updated'],
        rows: files
            .map(
              (f) => [
                Text(f.filename),
                Text(f.type),
                Text(f.updatedAt),
              ],
            )
            .toList(),
      ),
    );
  }
}
