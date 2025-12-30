import 'package:flutter/material.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'appTitle': 'Muslim Leader',
      'appTitleKids': 'My Beautiful Day ⭐',
      'greeting': 'Assalamu Alaikum',
      'selectRole': 'Select Role',
      'man': 'Man',
      'woman': 'Woman',
      'child': 'Child',
      'quranZone': 'Quran & Azkar',
      'quranWord': 'Daily Quran',
      'pagesRead': 'Pages Read',
      'morningAzkar': 'Morning Azkar',
      'eveningAzkar': 'Evening Azkar',
      'prayerZone': 'Prayer Tracker',
      'fajr': 'Fajr',
      'duha': 'Duha',
      'dhuhr': 'Dhuhr',
      'asr': 'Asr',
      'maghrib': 'Maghrib',
      'isha': 'Isha',
      'witr': 'Witr',
      'sunnahBefore': 'Sunnah Before',
      'fard': 'Fard',
      'sunnahAfter': 'Sunnah After',
      'onTime': 'On Time',
      'surahName': 'Surah Name',
      'juz': 'Juz',
      'knowledgeZone': 'Knowledge',
      'bookTitle': 'Book / Video Title',
      'completed': 'Completed',
      'fitnessZone': 'Fitness',
      'minutes': 'minutes',
      'running': 'Running',
      'walking': 'Walking',
      'cycling': 'Cycling',
      'gym': 'Gym',
      'selfCare': 'Self Care',
      'gazeLowering': 'Gaze Lowering',
      'hijabProgress': 'Hijab Check',
      'moodToday': 'Mood Today',
      'taskZone': 'Daily Task',
      'mainTask': 'Main Task',
      'silatRahim': 'Silat Al-Rahim',
      'parentsCorner': 'Parents Corner',
      'callParents': 'Call',
      'visitParents': 'Visit',
      'duaaParents': 'Duaa',
      'helpParents': 'Help',
      'remindParents': 'Remind Parents',
      'silatRahim': 'Family Ties',
      'whoDidYouConnect': 'Who did you connect with?',
      'homeTasks': 'Home Tasks',
      'cleaning': 'Cleaning',
      'cooking': 'Cooking',
      'laundry': 'Laundry',
      'childcare': 'Childcare',
      'groceries': 'Groceries',
      'organizing': 'Organizing',
      'childTasks': 'My Activities',
      'nap': 'Nap Time',
      'food': 'Ate Well',
      'play': 'Playtime',
      'homework': 'Homework',
      'reading': 'Reading',
      'helping': 'Helping',
      'waterTracker': 'Water Intake',
      'cups': 'cups',
      'treasureChest': 'Treasure Chest',
      'stars': 'Stars',
      'goodDeeds': 'Good Deeds',
    },
    'ar': {
      'appTitle': 'القائد المسلم',
      'appTitleKids': 'يومي الجميل ⭐',
      'greeting': 'السلام عليكم',
      'selectRole': 'اختر الدور',
      'man': 'رجل',
      'woman': 'امرأة',
      'child': 'طفل',
      'quranZone': 'القرآن والأذكار',
      'quranWord': 'ورد القرآن',
      'pagesRead': 'الصفحات المقروءة',
      'morningAzkar': 'أذكار الصباح',
      'eveningAzkar': 'أذكار المساء',
      'prayerZone': 'متتبع الصلاة',
      'fajr': 'الفجر',
      'duha': 'الضحى',
      'dhuhr': 'الظهر',
      'asr': 'العصر',
      'maghrib': 'المغرب',
      'isha': 'العشاء',
      'witr': 'الوتر',
      'sunnahBefore': 'سنة قبلية',
      'fard': 'فرض',
      'sunnahAfter': 'سنة بعدية',
      'onTime': 'في الوقت',
      'surahName': 'اسم السورة',
      'juz': 'الجزء',
      'knowledgeZone': 'المعرفة',
      'bookTitle': 'عنوان الكتاب / الفيديو',
      'completed': 'مكتمل',
      'fitnessZone': 'اللياقة',
      'minutes': 'دقيقة',
      'running': 'جري',
      'walking': 'مشي',
      'cycling': 'عجلة',
      'gym': 'جيم',
      'selfCare': 'العناية بالنفس',
      'gazeLowering': 'غض البصر',
      'hijabProgress': 'الحجاب',
      'moodToday': 'مزاجي اليوم',
      'taskZone': 'مهمة اليوم',
      'mainTask': 'المهمة الرئيسية',
      'silatRahim': 'صلة الرحم',
      'parentsCorner': 'ركن الوالدين',
      'callParents': 'اتصال',
      'visitParents': 'زيارة',
      'duaaParents': 'دعاء',
      'helpParents': 'مساعدة',
      'remindParents': 'تذكير الوالدين',
      'silatRahim': 'صلة الرحم',
      'whoDidYouConnect': 'من وصلت رحمه؟',
      'homeTasks': 'مهام المنزل',
      'cleaning': 'التنظيف',
      'cooking': 'طبخ',
      'laundry': 'غسيل',
      'childcare': 'رعاية الأطفال',
      'groceries': 'تسوق',
      'organizing': 'ترتيب',
      'childTasks': 'أنشطتي',
      'nap': 'وقت القيلولة',
      'food': 'أكلت جيداً',
      'play': 'وقت اللعب',
      'homework': 'الواجب',
      'reading': 'القراءة',
      'helping': 'المساعدة',
      'waterTracker': 'شرب الماء',
      'cups': 'أكواب',
      'treasureChest': 'صندوق الكنز',
      'stars': 'نجوم',
      'goodDeeds': 'حسنات',
    },
  };

  String get(String key) {
    return _localizedValues[locale.languageCode]?[key] ?? key;
  }

  bool get isRtl => locale.languageCode == 'ar';
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) {
    return ['en', 'ar'].contains(locale.languageCode);
  }

  @override
  Future<AppLocalizations> load(Locale locale) async {
    return AppLocalizations(locale);
  }

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
