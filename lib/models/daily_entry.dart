import 'package:hive/hive.dart';

part 'daily_entry.g.dart';

@HiveType(typeId: 1)
class PrayerDetails extends HiveObject {
  @HiveField(0)
  bool sunnahBefore;
  
  @HiveField(1)
  bool fard;
  
  @HiveField(2)
  bool sunnahAfter;
  
  @HiveField(3)
  bool onTime;

  PrayerDetails({
    this.sunnahBefore = false,
    this.fard = false,
    this.sunnahAfter = false,
    this.onTime = false,
  });
  
  PrayerDetails copyWith({
    bool? sunnahBefore,
    bool? fard,
    bool? sunnahAfter,
    bool? onTime,
  }) {
    return PrayerDetails(
      sunnahBefore: sunnahBefore ?? this.sunnahBefore,
      fard: fard ?? this.fard,
      sunnahAfter: sunnahAfter ?? this.sunnahAfter,
      onTime: onTime ?? this.onTime,
    );
  }
}

@HiveType(typeId: 2)
class DailyEntry extends HiveObject {
  @HiveField(0)
  String id; // Date key "YYYY-MM-DD"
  
  @HiveField(1)
  bool quranRead;
  
  @HiveField(2)
  int quranPages;
  
  @HiveField(3)
  Map<String, PrayerDetails> prayerStatus;
  
  @HiveField(4)
  Map<String, bool> azkar;
  
  @HiveField(5)
  String knowledgeTask;
  
  @HiveField(6)
  bool knowledgeCompleted;
  
  @HiveField(7)
  int fitnessDuration;
  
  @HiveField(8)
  int selfCareProgress;
  
  @HiveField(9)
  String mainTask;
  
  @HiveField(10)
  bool mainTaskCompleted;
  
  @HiveField(11)
  bool silatRahim;
  
  @HiveField(12)
  Map<String, bool> roleSpecificTasks;
  
  @HiveField(13)
  int waterIntake;
  
  @HiveField(14)
  String childMood;
  @HiveField(15)
  String quranSurah;

  @HiveField(16)
  int quranJuz;

  @HiveField(17)
  String familyTiesName;

  @HiveField(18)
  String fitnessActivity;

  DailyEntry({
    required this.id,
    this.quranRead = false,
    this.quranPages = 0,
    Map<String, PrayerDetails>? prayerStatus,
    Map<String, bool>? azkar,
    this.knowledgeTask = '',
    this.knowledgeCompleted = false,
    this.fitnessDuration = 0,
    this.selfCareProgress = 0,
    this.mainTask = '',
    this.mainTaskCompleted = false,
    this.silatRahim = false,
    Map<String, bool>? roleSpecificTasks,
    this.waterIntake = 0,
    this.childMood = 'happy',
    this.quranSurah = '',
    this.quranJuz = 0,
    this.familyTiesName = '',
    this.fitnessActivity = '',
  })  : prayerStatus = prayerStatus ?? _defaultPrayerStatus(),
        azkar = azkar ?? {'morning': false, 'evening': false},
        roleSpecificTasks = roleSpecificTasks ?? {};

  static Map<String, PrayerDetails> _defaultPrayerStatus() {
    return {
      'fajr': PrayerDetails(),
      'duha': PrayerDetails(),
      'dhuhr': PrayerDetails(),
      'asr': PrayerDetails(),
      'maghrib': PrayerDetails(),
      'isha': PrayerDetails(),
      'witr': PrayerDetails(),
    };
  }

  static DailyEntry createDefault(String dateId, {String? knowledgeTask, String? mainTask}) {
    return DailyEntry(
      id: dateId,
      knowledgeTask: knowledgeTask ?? '',
      mainTask: mainTask ?? '',
      roleSpecificTasks: {
        'callParents': false,
        'visitParents': false,
        'duaaParents': false,
        'helpParents': false,
        'remindParents': false,
        'cleaning': false,
        'cooking': false,
        'laundry': false,
        'childcare': false,
        'groceries': false,
        'organizing': false,
        'nap': false,
        'food': false,
        'play': false,
        'homework': false,
        'reading': false,
        'helping': false,
      },
    );
  }
}
