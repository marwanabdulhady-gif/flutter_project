// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'daily_entry.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PrayerDetailsAdapter extends TypeAdapter<PrayerDetails> {
  @override
  final int typeId = 1;

  @override
  PrayerDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PrayerDetails(
      sunnahBefore: fields[0] as bool,
      fard: fields[1] as bool,
      sunnahAfter: fields[2] as bool,
      onTime: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, PrayerDetails obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.sunnahBefore)
      ..writeByte(1)
      ..write(obj.fard)
      ..writeByte(2)
      ..write(obj.sunnahAfter)
      ..writeByte(3)
      ..write(obj.onTime);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PrayerDetailsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DailyEntryAdapter extends TypeAdapter<DailyEntry> {
  @override
  final int typeId = 2;

  @override
  DailyEntry read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DailyEntry(
      id: fields[0] as String,
      quranRead: fields[1] as bool,
      quranPages: fields[2] as int,
      prayerStatus: (fields[3] as Map?)?.cast<String, PrayerDetails>(),
      azkar: (fields[4] as Map?)?.cast<String, bool>(),
      knowledgeTask: fields[5] as String,
      knowledgeCompleted: fields[6] as bool,
      fitnessDuration: fields[7] as int,
      selfCareProgress: fields[8] as int,
      mainTask: fields[9] as String,
      mainTaskCompleted: fields[10] as bool,
      silatRahim: fields[11] as bool,
      roleSpecificTasks: (fields[12] as Map?)?.cast<String, bool>(),
      waterIntake: fields[13] as int,
      childMood: fields[14] as String,
      quranSurah: fields[15] as String,
      quranJuz: fields[16] as int,
      familyTiesName: fields[17] as String,
      fitnessActivity: fields[18] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DailyEntry obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.quranRead)
      ..writeByte(2)
      ..write(obj.quranPages)
      ..writeByte(3)
      ..write(obj.prayerStatus)
      ..writeByte(4)
      ..write(obj.azkar)
      ..writeByte(5)
      ..write(obj.knowledgeTask)
      ..writeByte(6)
      ..write(obj.knowledgeCompleted)
      ..writeByte(7)
      ..write(obj.fitnessDuration)
      ..writeByte(8)
      ..write(obj.selfCareProgress)
      ..writeByte(9)
      ..write(obj.mainTask)
      ..writeByte(10)
      ..write(obj.mainTaskCompleted)
      ..writeByte(11)
      ..write(obj.silatRahim)
      ..writeByte(12)
      ..write(obj.roleSpecificTasks)
      ..writeByte(13)
      ..write(obj.waterIntake)
      ..writeByte(14)
      ..write(obj.childMood)
      ..writeByte(15)
      ..write(obj.quranSurah)
      ..writeByte(16)
      ..write(obj.quranJuz)
      ..writeByte(17)
      ..write(obj.familyTiesName)
      ..writeByte(18)
      ..write(obj.fitnessActivity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DailyEntryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
