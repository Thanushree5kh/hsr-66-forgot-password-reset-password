import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/locale_provider.dart';
import '../widgets/language_selector_pill.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = ref.watch(stringsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(strings.neetCommunity),
        actions: const [
          Padding(
            padding: EdgeInsets.only(right: 8),
            child: Center(
              child: LanguageSelectorPill(isLight: false),
            ),
          ),
          SizedBox(width: 4),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Row(
            children: [
              Expanded(child: _StatCard(label: strings.streakLabel, value: strings.zeroDays)),
              const SizedBox(width: 12),
              Expanded(child: _StatCard(label: strings.aiDoubtsLeftLabel, value: strings.doubtsCount)),
            ],
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.quiz_outlined),
              title: Text(strings.todaysQuizTitle),
              subtitle: Text(strings.todaysQuizSubtitle),
            ),
          ),
          Card(
            child: ListTile(
              leading: const Icon(Icons.trending_up),
              title: Text(strings.weakTopicsTitle),
              subtitle: Text(strings.weakTopicsSubtitle),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 0,
        destinations: [
          NavigationDestination(icon: const Icon(Icons.dashboard_outlined), label: strings.navHome),
          NavigationDestination(icon: const Icon(Icons.quiz_outlined), label: strings.navQuizzes),
          NavigationDestination(icon: const Icon(Icons.emoji_events_outlined), label: strings.navLeaderboard),
          NavigationDestination(icon: const Icon(Icons.smart_toy_outlined), label: strings.navAiDoubt),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: Theme.of(context).textTheme.bodySmall),
            const SizedBox(height: 8),
            Text(value, style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
