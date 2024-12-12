import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:miniprojet/pages/ThemeData.dart';
import 'package:miniprojet/pages/MenuPage.dart';
import 'package:miniprojet/pages/Choices.dart';
import 'package:miniprojet/pages/HomePage.dart';
import 'package:miniprojet/pages/theme_notifier.dart';
import 'package:provider/provider.dart'; // Import your ThemeNotifier class

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized(); // Ensure EasyLocalization is initialized

  runApp(
    EasyLocalization(
      supportedLocales: [
        Locale('en'),
        Locale('fr'),
        Locale('ar'),
      ],
      path: 'assets/translations', // Path to your translation files
      fallbackLocale: Locale('en'),
      child: ChangeNotifierProvider(
        create: (_) => ThemeNotifier(), // Provide ThemeNotifier globally
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: context.localizationDelegates, // Localization delegates for EasyLocalization
      supportedLocales: context.supportedLocales, // Supported locales for EasyLocalization
      locale: context.locale, // Use the selected locale from EasyLocalization
      theme: lightTheme, // Light theme
      darkTheme: darkTheme, // Dark theme
      themeMode: themeNotifier.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Dynamic theme mode
      routes: {
        '/home': (context) => HomePage(),
        '/choices': (context) => ChoicesPage(),
        '/menu': (context) => MenuPage(),
      },
      home: HomePage(), // Start at the home page
    );
  }
}
