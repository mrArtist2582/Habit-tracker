import 'package:isar/isar.dart';

// run this im cmd  to genetate file :dart run build_runner build
part 'habit.g.dart';

@Collection()
class Habit {
  // habit id
  Id id = Isar.autoIncrement;

  // habit name
  late String name;

  // compeleted days
  List<DateTime> completedDays = [
    // DateTime(year ,month, day)
    // DateTime(2025,1,31)
  ];
}
