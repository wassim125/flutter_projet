import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart'; // Import easy_localization

class LanguageSelectorPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose_language'.tr()), // Translated title
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            onPressed: () {
              context.setLocale(Locale('en', 'US')); // Set language to English
            },
            child: Text('English'),
          ),
          ElevatedButton(
            onPressed: () {
              context.setLocale(Locale('fr', 'FR')); // Set language to French
            },
            child: Text('Français'),
          ),
          ElevatedButton(
            onPressed: () {
              context.setLocale(Locale('ar', 'AR')); // Set language to Arabic
            },
            child: Text('العربية'),
          ),
        ],
      ),
    );
  }
}
