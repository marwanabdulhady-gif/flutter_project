import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:muslim_leader/factories/adult_male_factory.dart';
import 'package:muslim_leader/factories/adult_female_factory.dart';
import 'package:muslim_leader/widgets/common_widgets.dart';
import 'package:muslim_leader/models/daily_entry.dart';
import 'package:muslim_leader/models/user_role.dart';
import 'package:muslim_leader/l10n/app_localizations.dart';
import 'package:muslim_leader/providers/app_providers.dart';

void main() {
  setUpAll(() async {
    // Initialize Hive for testing
    final tempDir = await Directory.systemTemp.createTemp();
    Hive.init(tempDir.path);
    
    // Register Adapters
    if (!Hive.isAdapterRegistered(0)) Hive.registerAdapter(UserRoleAdapter());
    if (!Hive.isAdapterRegistered(1)) Hive.registerAdapter(PrayerDetailsAdapter());
    if (!Hive.isAdapterRegistered(2)) Hive.registerAdapter(DailyEntryAdapter());
    
    // Open Boxes
    await Hive.openBox('settings');
    await Hive.openBox<DailyEntry>('daily_entries');
  });

  tearDownAll(() async {
    await Hive.deleteFromDisk();
  });

  testWidgets('AdultMaleFactory builds header with DailyProgressIndicator', (WidgetTester tester) async {
    // Arrange
    final factory = AdultMaleFactory();
    
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [AppLocalizations.delegate],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                 return factory.buildHeader(context, ref);
              },
            ),
          ),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(DailyProgressIndicator), findsOneWidget);
    expect(find.text('Good Deeds'), findsOneWidget); // Checks for the label from l10n
  });

  testWidgets('AdultFemaleFactory builds header with DailyProgressIndicator', (WidgetTester tester) async {
    // Arrange
    final factory = AdultFemaleFactory();
    
    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp(
          localizationsDelegates: const [AppLocalizations.delegate],
          supportedLocales: const [Locale('en')],
          home: Scaffold(
            body: Consumer(
              builder: (context, ref, _) {
                 return factory.buildHeader(context, ref);
              },
            ),
          ),
        ),
      ),
    );

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.byType(DailyProgressIndicator), findsOneWidget);
    expect(find.text('Good Deeds'), findsOneWidget);
  });
  
  testWidgets('DailyProgressIndicator renders correct score', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: DailyProgressIndicator(
              progress: 0.5,
              points: 100,
              label: 'Test Label',
            ),
          ),
        ),
      );
      
      expect(find.text('100'), findsOneWidget);
      expect(find.text('Test Label'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });
}
