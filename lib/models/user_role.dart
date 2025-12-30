import 'package:hive/hive.dart';

part 'user_role.g.dart';

@HiveType(typeId: 0)
enum UserRole {
  @HiveField(0)
  adultMale,
  
  @HiveField(1)
  adultFemale,
  
  @HiveField(2)
  child,
}

extension UserRoleExtension on UserRole {
  String get displayName {
    switch (this) {
      case UserRole.adultMale:
        return 'Man';
      case UserRole.adultFemale:
        return 'Woman';
      case UserRole.child:
        return 'Child';
    }
  }
  
  String get displayNameAr {
    switch (this) {
      case UserRole.adultMale:
        return 'رجل';
      case UserRole.adultFemale:
        return 'امرأة';
      case UserRole.child:
        return 'طفل';
    }
  }
}
