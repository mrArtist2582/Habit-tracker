import 'package:flutter/material.dart';
import 'package:habit_tracker/service/noti_service.dart';
import 'package:habit_tracker/theme/theme_provider.dart';
import 'package:provider/provider.dart';

import 'databases/habit_database.dart';
import 'pages/home_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotiService().initNotification();
  // initialize database
  await HabitDatabase.initialiize();
  await HabitDatabase().saveFirstLaunchDate();
  runApp(
    MultiProvider(
      providers: [
        // habit provider
        ChangeNotifierProvider(
          create: (context) => HabitDatabase(),
        ),
        // theme provider
        ChangeNotifierProvider(
          create: (context) => ThemeProvider(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
