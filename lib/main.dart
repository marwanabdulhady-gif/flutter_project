import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'models/daily_entry.dart';
import 'models/user_role.dart';
import 'providers/app_providers.dart';
import 'screens/dashboard_screen.dart';
import 'l10n/app_localizations.dart';
import 'theme/app_themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Hive.initFlutter();
  Hive.registerAdapter(DailyEntryAdapter());
  Hive.registerAdapter(PrayerDetailsAdapter());
  Hive.registerAdapter(UserRoleAdapter());
  
  await Hive.openBox<DailyEntry>('daily_entries');
  await Hive.openBox('settings');
  
  runApp(const ProviderScope(child: MuslimLeaderApp()));
}

class MuslimLeaderApp extends ConsumerWidget {
  const MuslimLeaderApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(localeProvider);
    final userRole = ref.watch(userRoleProvider);
    
    return MaterialApp(
      title: 'Muslim Leader',
      debugShowCheckedModeBanner: false,
      theme: AppThemes.getTheme(userRole),
      locale: locale,
      supportedLocales: const [
        Locale('en'),
        Locale('ar'),
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const DashboardScreen(),
    );
  }
}
