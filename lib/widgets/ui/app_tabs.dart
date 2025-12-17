import 'package:flutter/material.dart';

class AppTab {
  final String label;
  final Widget content;
  const AppTab({required this.label, required this.content});
}

class AppTabs extends StatelessWidget {
  const AppTabs({super.key, required this.tabs});

  final List<AppTab> tabs;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TabBar(
            isScrollable: true,
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black54,
            labelStyle: const TextStyle(fontWeight: FontWeight.w600),
            indicatorColor: Colors.black,
            tabs: tabs.map((t) => Tab(text: t.label)).toList(),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 320,
            child: TabBarView(
              children: tabs.map((t) => t.content).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
