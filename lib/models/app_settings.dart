import 'package:isar/isar.dart';

// run this im cmd  to genetate file :dart run build_runner build
part 'app_settings.g.dart';

 @Collection()
class AppSettings {

 Id id = Isar.autoIncrement;
 DateTime? firstLaunchDate;
  
}