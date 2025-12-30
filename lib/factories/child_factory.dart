import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_entry.dart';
import '../models/user_role.dart';
import '../providers/app_providers.dart';
import '../l10n/app_localizations.dart';
import '../widgets/common_widgets.dart';
import '../data/suggested_tasks.dart'; // Import suggested tasks
import 'section_factory.dart';

class ChildFactory implements SectionFactory {
  @override
  Widget buildHeader(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
            Theme.of(context).colorScheme.tertiary,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('⭐', style: TextStyle(fontSize: 32)),
                Column(
                  children: [
                    Text(
                      l10n.get('appTitleKids'),
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      l10n.get('greeting'),
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.language, color: Colors.white, size: 28),
                      onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
                    ),
                    PopupMenuButton<UserRole>(
                      icon: const Icon(Icons.face, color: Colors.white, size: 28),
                      onSelected: (role) => ref.read(userRoleProvider.notifier).setRole(role),
                      itemBuilder: (context) => [
                        PopupMenuItem(value: UserRole.adultMale, child: Text(l10n.get('man'))),
                        PopupMenuItem(value: UserRole.adultFemale, child: Text(l10n.get('woman'))),
                        PopupMenuItem(value: UserRole.child, child: Text(l10n.get('child'))),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildQuranZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    return ModernZoneCard(
      title: l10n.get('quranZone'),
      emoji: '📖',
      color: Colors.green,
      child: Column(
        children: [
          InteractiveActionCard(
            emoji: '📚',
            label: l10n.get('quranWord'),
            isChecked: data.quranRead,
            onTap: () => notifier.updateQuranRead(!data.quranRead),
            color: Colors.teal,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InteractiveActionCard(
                  emoji: '🌅',
                  label: l10n.get('morningAzkar'),
                  isChecked: data.azkar['morning'] ?? false,
                  onTap: () => notifier.updateAzkar('morning', !(data.azkar['morning'] ?? false)),
                  color: Colors.orange,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InteractiveActionCard(
                  emoji: '🌙',
                  label: l10n.get('eveningAzkar'),
                  isChecked: data.azkar['evening'] ?? false,
                  onTap: () => notifier.updateAzkar('evening', !(data.azkar['evening'] ?? false)),
                  color: Colors.indigo,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildPrayerZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    final prayers = [
      ('fajr', '🌅', Colors.orange),
      ('dhuhr', '☀️', Colors.amber),
      ('asr', '🌤️', Colors.yellow),
      ('maghrib', '🌅', Colors.deepOrange),
      ('isha', '🌙', Colors.indigo),
    ];
    
    return ModernZoneCard(
      title: l10n.get('prayerZone'),
      emoji: '🕌',
      color: Colors.purple,
      child: Wrap(
        spacing: 12,
        runSpacing: 12,
        children: prayers.map((prayer) {
          final details = data.prayerStatus[prayer.$1] ?? PrayerDetails();
          return InteractiveActionCard(
            emoji: prayer.$2,
            label: l10n.get(prayer.$1),
            isChecked: details.fard,
            onTap: () => notifier.updatePrayer(
              prayer.$1,
              details.copyWith(fard: !details.fard),
            ),
            color: prayer.$3,
            width: 100,
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget buildKnowledgeZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    return ModernZoneCard(
      title: l10n.get('knowledgeZone'),
      emoji: '🎓',
      color: Colors.blue,
      child: Column(
        children: [
          InteractiveActionCard(
            emoji: '📖',
            label: l10n.get('reading'),
            isChecked: data.roleSpecificTasks['reading'] ?? false,
            onTap: () => notifier.updateRoleTask('reading', !(data.roleSpecificTasks['reading'] ?? false)),
            color: Colors.cyan,
          ),
          const SizedBox(height: 12),
          InteractiveActionCard(
            emoji: '📝',
            label: l10n.get('homework'),
            isChecked: data.roleSpecificTasks['homework'] ?? false,
            onTap: () => notifier.updateRoleTask('homework', !(data.roleSpecificTasks['homework'] ?? false)),
            color: Colors.lightBlue,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildFitnessZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    return ModernZoneCard(
      title: l10n.get('fitnessZone'),
      emoji: '⚽',
      color: Colors.green,
      child: InteractiveActionCard(
        emoji: '🏃',
        label: l10n.get('play'),
        isChecked: data.roleSpecificTasks['play'] ?? false,
        onTap: () => notifier.updateRoleTask('play', !(data.roleSpecificTasks['play'] ?? false)),
        color: Colors.lime,
      ),
    );
  }

  @override
  Widget buildSelfCareZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    final moods = ['😊', '😐', '😢', '😴'];
    
    return ModernZoneCard(
      title: l10n.get('moodToday'),
      emoji: '💭',
      color: Colors.pink,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: moods.map((mood) {
          final isSelected = data.childMood == mood;
          return GestureDetector(
            onTap: () => notifier.updateChildMood(mood),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? Colors.pink.shade100 : Colors.transparent,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isSelected ? Colors.pink : Colors.transparent,
                  width: 3,
                ),
              ),
              child: Text(mood, style: const TextStyle(fontSize: 40)),
            ),
          );
        }).toList(),
      ),
    );
  }

  @override
  Widget buildTaskZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    return ModernZoneCard(
      title: l10n.get('childTasks'),
      emoji: '✨',
      color: Colors.amber,
      child: Column(
        children: [
          StatefulTextField(
            key: ValueKey('mainTask_${data.id}'),
            initialValue: data.mainTask,
            decoration: InputDecoration(
              labelText: l10n.get('mainTask'),
              prefixIcon: const Icon(Icons.assignment),
              suffixIcon: IconButton(
                icon: const Icon(Icons.lightbulb_outline),
                tooltip: 'Suggested Tasks',
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (context) => ListView(
                      padding: const EdgeInsets.all(16),
                      children: SuggestedTasks.childTasks.map((task) => ListTile(
                        title: Text(task),
                        onTap: () {
                          notifier.updateMainTask(task);
                          Navigator.pop(context);
                        },
                      )).toList(),
                    ),
                  );
                },
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            ),
            onChanged: notifier.updateMainTask,
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: InteractiveActionCard(
                  emoji: '😴',
                  label: l10n.get('nap'),
                  isChecked: data.roleSpecificTasks['nap'] ?? false,
                  onTap: () => notifier.updateRoleTask('nap', !(data.roleSpecificTasks['nap'] ?? false)),
                  color: Colors.purple,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: InteractiveActionCard(
                  emoji: '🍎',
                  label: l10n.get('food'),
                  isChecked: data.roleSpecificTasks['food'] ?? false,
                  onTap: () => notifier.updateRoleTask('food', !(data.roleSpecificTasks['food'] ?? false)),
                  color: Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InteractiveActionCard(
            emoji: '🤝',
            label: l10n.get('helping'),
            isChecked: data.roleSpecificTasks['helping'] ?? false,
            onTap: () => notifier.updateRoleTask('helping', !(data.roleSpecificTasks['helping'] ?? false)),
            color: Colors.teal,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildRoleSpecificZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    
    // Calculate stars earned
    int stars = 0;
    if (data.quranRead) stars++;
    if (data.azkar['morning'] ?? false) stars++;
    if (data.azkar['evening'] ?? false) stars++;
    data.prayerStatus.forEach((_, details) {
      if (details.fard) stars++;
    });
    data.roleSpecificTasks.forEach((_, completed) {
      if (completed) stars++;
    });
    
    return ModernZoneCard(
      title: l10n.get('treasureChest'),
      emoji: '🎁',
      color: Colors.amber,
      child: Column(
        children: [
          // Rainbow progress path
          Container(
            height: 60,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.red,
                  Colors.orange,
                  Colors.yellow,
                  Colors.green,
                  Colors.blue,
                  Colors.purple,
                ],
              ),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(10, (index) {
                return Icon(
                  index < stars ? Icons.star : Icons.star_border,
                  color: Colors.white,
                  size: 32,
                );
              }),
            ),
          ),
          const SizedBox(height: 16),
          // Treasure chest
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            child: Text(
              stars >= 10 ? '🎉🏆🎉' : '🎁',
              style: TextStyle(fontSize: stars >= 10 ? 64 : 48),
            ),
          ),
          Text(
            '$stars ${l10n.get('stars')}',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.amber.shade800,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildWaterTracker(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    return ModernZoneCard(
      title: l10n.get('waterTracker'),
      emoji: '💧',
      color: Colors.blue,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(8, (index) {
          final filled = index < data.waterIntake;
          return GestureDetector(
            onTap: () => notifier.updateWaterIntake(filled ? index : index + 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              child: Text(
                filled ? '💧' : '⚪',
                style: const TextStyle(fontSize: 32),
              ),
            ),
          );
        }),
      ),
    );
  }
}

