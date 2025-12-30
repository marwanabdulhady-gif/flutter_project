import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/daily_entry.dart';
import '../models/user_role.dart';
import '../providers/app_providers.dart';
import '../l10n/app_localizations.dart';
import '../widgets/common_widgets.dart';
import '../data/suggested_tasks.dart'; // Import suggested tasks
import 'section_factory.dart';

class AdultFemaleFactory implements SectionFactory {
  @override
  Widget buildHeader(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final data = ref.watch(dailyEntryProvider);
    
    // Calculate Daily Progress & Hasanat
    int totalHasanat = 0;
    int completedItems = 0;
    int totalItems = 0;

    // Prayers (7 prayers * 3 states)
    for (final prayer in data.prayerStatus.values) {
      if (prayer.fard) { totalHasanat += 10; completedItems++; }
      if (prayer.sunnahBefore) { totalHasanat += 5; }
      if (prayer.sunnahAfter) { totalHasanat += 5; }
      totalItems++; 
    }
    
    // Quran
    if (data.quranRead) { totalHasanat += 20; completedItems++; }
    if (data.azkar['morning'] == true) { totalHasanat += 10; completedItems++; }
    if (data.azkar['evening'] == true) { totalHasanat += 10; completedItems++; }
    totalItems += 3;

    // Fitness
    totalHasanat += (data.fitnessDuration / 10).floor();
    if (data.fitnessDuration > 0) completedItems++;
    totalItems++;

    // Water
    totalHasanat += data.waterIntake;
    if (data.waterIntake >= 8) completedItems++;
    totalItems++;

    // Tasks
    if (data.mainTaskCompleted) { totalHasanat += 15; completedItems++; }
    if (data.silatRahim) { totalHasanat += 15; completedItems++; }
    totalItems += 2;
    
    // Role Tasks
    for (final completed in data.roleSpecificTasks.values) {
       if (completed) { totalHasanat += 5; completedItems++; }
       totalItems++;
    }

    final double dailyProgress = totalItems > 0 ? completedItems / totalItems : 0.0;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.secondary,
          ],
        ),
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.get('appTitle'),
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
            DailyProgressIndicator(
              progress: dailyProgress,
              points: totalHasanat,
              label: l10n.get('goodDeeds'),
            ),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.language, color: Colors.white),
                  onPressed: () => ref.read(localeProvider.notifier).toggleLocale(),
                ),
                PopupMenuButton<UserRole>(
                  icon: const Icon(Icons.person, color: Colors.white),
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
      ),
    );
  }

  @override
  Widget buildQuranZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    // Calculate Progress
    int completed = 0;
    if (data.quranRead) completed++;
    if (data.azkar['morning'] == true) completed++;
    if (data.azkar['evening'] == true) completed++;
    final double progress = completed / 3.0;

    return ModernZoneCard(
      title: l10n.get('quranZone'),
      icon: Icons.menu_book,
      color: Theme.of(context).colorScheme.primary,
      progress: progress,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 3,
                child: StatefulTextField(
                  key: ValueKey('surah_${data.id}'),
                  initialValue: data.quranSurah,
                  decoration: InputDecoration(
                    labelText: l10n.get('surahName'),
                    prefixIcon: const Icon(Icons.book),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: notifier.updateQuranSurah,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                flex: 2,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<int>(
                      value: data.quranJuz == 0 ? null : data.quranJuz,
                      hint: Text(l10n.get('juz')),
                      isExpanded: true,
                      items: List.generate(30, (index) => index + 1).map((juz) {
                        return DropdownMenuItem(
                          value: juz,
                          child: Text('${l10n.get('juz')} $juz'),
                        );
                      }).toList(),
                      onChanged: (v) => notifier.updateQuranJuz(v ?? 0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          InteractiveActionCard(
            icon: Icons.menu_book,
            label: l10n.get('quranWord'),
            isChecked: data.quranRead,
            onTap: () => notifier.updateQuranRead(!data.quranRead),
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(height: 12),
          Padding(
             padding: const EdgeInsets.symmetric(horizontal: 8),
             child: Row(
              children: [
                Text(l10n.get('pagesRead'), style: const TextStyle(fontWeight: FontWeight.bold)),
                Expanded(
                  child: Slider(
                    value: data.quranPages.toDouble(),
                    min: 0,
                    max: 20,
                    divisions: 20,
                    label: '${data.quranPages}',
                    onChanged: (v) => notifier.updateQuranPages(v.toInt()),
                    activeColor: Theme.of(context).colorScheme.primary,
                  ),
                ),
                Text('${data.quranPages}', style: Theme.of(context).textTheme.titleMedium),
              ],
            ),
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
      ('fajr', '🌅', Colors.pink.shade300),
      ('duha', '☀️', Colors.amber.shade300),
      ('dhuhr', '☀️', Colors.amber.shade700),
      ('asr', '🌤️', Colors.orange.shade300),
      ('maghrib', '🌅', Colors.deepOrange.shade300),
      ('isha', '🌙', Colors.indigo.shade300),
      ('witr', '🌌', Colors.deepPurple.shade300),
    ];

    // Calculate Progress
    int completedFard = 0;
    for (final p in prayers) {
       if (data.prayerStatus[p.$1]?.fard == true) completedFard++;
    }
    final double progress = completedFard / prayers.length;
    
    Widget buildPrayerCard(String name, String emoji, Color color) {
      final details = data.prayerStatus[name] ?? PrayerDetails();
      
      // Define Sunnah Rak'ats counts
      int beforeCount = 0;
      int afterCount = 0;
      
      switch (name) {
        case 'fajr': beforeCount = 2; afterCount = 0; break;
        case 'dhuhr': beforeCount = 4; afterCount = 2; break;
        case 'asr': beforeCount = 0; afterCount = 0; break;
        case 'maghrib': beforeCount = 0; afterCount = 2; break;
        case 'isha': beforeCount = 0; afterCount = 2; break;
      }

      return Expanded(
        child: Column(
          children: [
            // Main Fard Card
            InteractiveActionCard(
              emoji: emoji,
              label: l10n.get(name),
              isChecked: details.fard,
              onTap: () => notifier.updatePrayer(
                name,
                details.copyWith(fard: !details.fard),
              ),
              color: color,
            ),
            const SizedBox(height: 12),
            
            // Details Row
            if (name != 'duha' && name != 'witr') // Skip details for Duha/Witr
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Sunnah Before
                if (beforeCount > 0)
                  _PrayerDetailBox(
                    label: l10n.get('sunnahBefore'),
                    content: '$beforeCount',
                    isChecked: details.sunnahBefore,
                    color: color,
                    onTap: () => notifier.updatePrayer(
                      name,
                      details.copyWith(sunnahBefore: !details.sunnahBefore),
                    ),
                  )
                else
                  const SizedBox(width: 32),

                const SizedBox(width: 8),

                // On Time
                _PrayerDetailBox(
                  label: l10n.get('onTime'),
                  icon: Icons.check,
                  isChecked: details.onTime,
                  color: color,
                  onTap: () => notifier.updatePrayer(
                    name,
                    details.copyWith(onTime: !details.onTime),
                  ),
                ),

                const SizedBox(width: 8),

                // Sunnah After
                if (afterCount > 0)
                  _PrayerDetailBox(
                    label: l10n.get('sunnahAfter'),
                    content: '$afterCount',
                    isChecked: details.sunnahAfter,
                    color: color,
                    onTap: () => notifier.updatePrayer(
                      name,
                      details.copyWith(sunnahAfter: !details.sunnahAfter),
                    ),
                  )
                else
                   const SizedBox(width: 32),
              ],
            ),
          ],
        ),
      );
    }
    
    return ModernZoneCard(
      title: l10n.get('prayerZone'),
      icon: Icons.mosque,
      color: Theme.of(context).colorScheme.primary,
      progress: progress,
      child: Column(
        children: [
          // Row 1: Fajr, Duha, Dhuhr, Asr
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPrayerCard('fajr', '🌅', Colors.pink.shade300),
              const SizedBox(width: 8),
              buildPrayerCard('duha', '☀️', Colors.amber.shade300),
              const SizedBox(width: 8),
              buildPrayerCard('dhuhr', '☀️', Colors.amber.shade700),
              const SizedBox(width: 8),
              buildPrayerCard('asr', '🌤️', Colors.orange.shade300),
            ],
          ),
          const SizedBox(height: 16),
          
          // Row 2: Maghrib, Isha, Witr
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              buildPrayerCard('maghrib', '🌅', Colors.deepOrange.shade300),
              const SizedBox(width: 8),
              buildPrayerCard('isha', '🌙', Colors.indigo.shade300),
              const SizedBox(width: 8),
              buildPrayerCard('witr', '🌌', Colors.deepPurple.shade300),
              const Spacer(), // Empty space for alignment
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildKnowledgeZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    final progress = data.knowledgeCompleted ? 1.0 : 0.0;

    return ModernZoneCard(
      title: l10n.get('knowledgeZone'),
      icon: Icons.school,
      color: Colors.blue.shade300,
      progress: progress,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: StatefulTextField(
              key: ValueKey('knowledge_${data.id}'),
              initialValue: data.knowledgeTask,
              decoration: InputDecoration(
                labelText: l10n.get('bookTitle'),
                prefixIcon: const Icon(Icons.book),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: notifier.updateKnowledgeTask,
            ),
          ),
          const SizedBox(width: 12),
          // Inline completion checkbox
          InkWell(
            onTap: () => notifier.updateKnowledgeCompleted(!data.knowledgeCompleted),
            borderRadius: BorderRadius.circular(12),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: data.knowledgeCompleted ? Colors.blue.shade300 : Colors.grey.shade200,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                data.knowledgeCompleted ? Icons.check_circle : Icons.check_circle_outline,
                color: data.knowledgeCompleted ? Colors.white : Colors.grey,
                size: 28,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildFitnessZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    final progress = (data.fitnessDuration / 30.0).clamp(0.0, 1.0);

    final activities = [
      ('running', '🏃', l10n.get('running')),
      ('walking', '🚶', l10n.get('walking')),
      ('cycling', '🚴', l10n.get('cycling')),
      ('gym', '🏋️', l10n.get('gym')),
    ];

    return ModernZoneCard(
      title: l10n.get('fitnessZone'),
      icon: Icons.self_improvement,
      color: Colors.teal,
      progress: progress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Activity selector
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: activities.map((activity) {
              final isSelected = data.fitnessActivity == activity.$1;
              return InkWell(
                onTap: () => notifier.updateFitnessActivity(activity.$1),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.teal : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isSelected ? Colors.teal : Colors.teal.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(activity.$2, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 6),
                      Text(
                        activity.$3,
                        style: TextStyle(
                          color: isSelected ? Colors.white : Colors.teal.shade700,
                          fontSize: 12,
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          
          // Duration slider
          Row(
            children: [
              const Icon(Icons.timer, color: Colors.teal),
              const SizedBox(width: 8),
              Expanded(
                child: Slider(
                  value: data.fitnessDuration.toDouble(),
                  min: 0,
                  max: 120,
                  divisions: 24,
                  label: '${data.fitnessDuration} ${l10n.get('minutes')}',
                  activeColor: Colors.teal,
                  onChanged: (v) => notifier.updateFitnessDuration(v.toInt()),
                ),
              ),
              Text('${data.fitnessDuration} ${l10n.get('minutes')}',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.teal)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildSelfCareZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    final progress = data.selfCareProgress / 100.0;

    return ModernZoneCard(
      title: l10n.get('hijabProgress'),
      icon: Icons.checkroom,
      color: Colors.pink,
      progress: progress,
      child: Column(
        children: [
          const Text('🧕', style: TextStyle(fontSize: 40)),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: data.selfCareProgress.toDouble(),
                  min: 0,
                  max: 100,
                  divisions: 10,
                  label: '${data.selfCareProgress}%',
                  activeColor: Colors.pink,
                  onChanged: (v) => notifier.updateSelfCareProgress(v.toInt()),
                ),
              ),
              Text('${data.selfCareProgress}%',
                style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.pink)),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildTaskZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    final progress = data.mainTaskCompleted ? 1.0 : 0.0;

    return ModernZoneCard(
      title: l10n.get('taskZone'),
      icon: Icons.check_box,
      color: Colors.teal.shade300,
      progress: progress,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Task input with inline completion checkbox
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: StatefulTextField(
                  key: ValueKey('mainTask_${data.id}'),
                  initialValue: data.mainTask,
                  decoration: InputDecoration(
                    labelText: l10n.get('mainTask'),
                    prefixIcon: const Icon(Icons.assignment),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.lightbulb_outline),
                      tooltip: 'More Suggestions',
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => ListView(
                            padding: const EdgeInsets.all(16),
                            children: SuggestedTasks.femaleTasks.map((task) => ListTile(
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
              ),
              const SizedBox(width: 12),
              // Inline completion checkbox
              InkWell(
                onTap: () => notifier.updateMainTaskCompleted(!data.mainTaskCompleted),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: data.mainTaskCompleted ? Colors.teal.shade300 : Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    data.mainTaskCompleted ? Icons.check_circle : Icons.check_circle_outline,
                    color: data.mainTaskCompleted ? Colors.white : Colors.grey,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Suggested tasks as stickers
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: SuggestedTasks.femaleTasks.take(6).map((task) {
              return InkWell(
                onTap: () => notifier.updateMainTask(task),
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: data.mainTask == task ? Colors.teal.shade300 : Colors.teal.shade50,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: data.mainTask == task ? Colors.teal.shade300 : Colors.teal.shade200,
                      width: 1.5,
                    ),
                  ),
                  child: Text(
                    task,
                    style: TextStyle(
                      color: data.mainTask == task ? Colors.white : Colors.teal.shade700,
                      fontSize: 12,
                      fontWeight: data.mainTask == task ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }


  @override
  Widget buildRoleSpecificZone(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    final tasks = [
      ('callParents', '📞', l10n.get('callParents')),
      ('visitParents', '🏠', l10n.get('visitParents')),
      ('duaaParents', '🤲', l10n.get('duaaParents')),
      ('helpParents', '🤝', l10n.get('helpParents')),
      ('remindParents', '💭', l10n.get('remindParents')),
      ('cleaning', '🧹', l10n.get('cleaning')),
      ('cooking', '🍳', l10n.get('cooking')),
      ('laundry', '👗', l10n.get('laundry')),
      ('childcare', '👶', l10n.get('childcare')),
      ('groceries', '🛒', l10n.get('groceries')),
      ('organizing', '📦', l10n.get('organizing')),
    ];
    
    int completed = 0;
    for (var t in tasks) {
      if (data.roleSpecificTasks[t.$1] == true) completed++;
    }
    if (data.silatRahim) completed++;
    final progress = (tasks.length + 1) > 0 ? completed / (tasks.length + 1) : 0.0;

    return ModernZoneCard(
      title: l10n.get('parentsCorner'),
      icon: Icons.family_restroom,
      color: Colors.indigo.shade300,
      progress: progress,
      child: Column(
        children: [
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: tasks.map((task) {
              final isChecked = data.roleSpecificTasks[task.$1] ?? false;
              return InteractiveActionCard(
                emoji: task.$2,
                label: task.$3,
                isChecked: isChecked,
                onTap: () => notifier.updateRoleTask(task.$1, !isChecked),
                color: Colors.indigo.shade300,
                width: 100,
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          
          // Family Ties Section
          Row(
            children: [
              Expanded(
                flex: 2,
                child: InteractiveActionCard(
                  emoji: '🤝',
                  label: l10n.get('silatRahim'),
                  isChecked: data.silatRahim,
                  onTap: () => notifier.updateSilatRahim(!data.silatRahim),
                  color: Colors.teal.shade300,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 3,
                child: StatefulTextField(
                  key: ValueKey('familyTies_${data.id}'),
                  initialValue: data.familyTiesName,
                  decoration: InputDecoration(
                    labelText: l10n.get('whoDidYouConnect'),
                    prefixIcon: const Icon(Icons.person),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  onChanged: notifier.updateFamilyTiesName,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget buildWaterTracker(BuildContext context, WidgetRef ref, DailyEntry data) {
    final l10n = AppLocalizations.of(context);
    final notifier = ref.read(dailyEntryProvider.notifier);
    
    final progress = (data.waterIntake / 8.0).clamp(0.0, 1.0);

    return ModernZoneCard(
      title: l10n.get('waterTracker'),
      icon: Icons.water_drop,
      color: Colors.blue,
      progress: progress,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(8, (index) {
          final filled = index < data.waterIntake;
          return GestureDetector(
            onTap: () => notifier.updateWaterIntake(filled ? index : index + 1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: filled ? Colors.blue : Colors.blue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                filled ? Icons.water_drop : Icons.water_drop_outlined,
                size: 24,
                color: filled ? Colors.white : Colors.blue,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _PrayerDetailBox extends StatelessWidget {
  final String label;
  final String? content;
  final IconData? icon;
  final bool isChecked;
  final VoidCallback onTap;
  final Color color;

  const _PrayerDetailBox({
    required this.label,
    this.content,
    this.icon,
    required this.isChecked,
    required this.onTap,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        GestureDetector(
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            width: 32,
            height: 32,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: isChecked ? color : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isChecked ? color : Colors.grey.shade400,
                width: 2,
              ),
            ),
            child: content != null
                ? Text(
                    content!,
                    style: TextStyle(
                      color: isChecked ? Colors.white : Colors.grey.shade600,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  )
                : Icon(
                    icon,
                    size: 18,
                    color: isChecked ? Colors.white : Colors.grey.shade400,
                  ),
          ),
        ),
      ],
    );
  }
}
