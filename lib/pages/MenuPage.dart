import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';
import 'package:miniprojet/pages/theme_notifier.dart';

class MenuPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    bool isDarkMode = themeNotifier.isDarkMode;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade600, // Match button color
        title: Text(
          'Menu',
          style: TextStyle(
            color: isDarkMode ? Colors.black : Colors.white, // Conditional text color
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: isDarkMode ? Colors.black : Colors.white, // Conditional icon color
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/home'); // Navigate to Home Page
          },
        ),
      ),
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'images/back.jpg', // Update path as needed
              fit: BoxFit.cover,
            ),
          ),

          // Main Content
          Center(
            child: Container(
              width: 360,
              padding: const EdgeInsets.all(24.0),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? Colors.black.withOpacity(0.7)
                    : Colors.black.withOpacity(0.5), // Semi-transparent overlay
                borderRadius: BorderRadius.circular(25),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.8),
                    blurRadius: 20,
                    spreadRadius: 3,
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'Quiz App',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent, // Neon cyan title
                    ),
                  ),
                  SizedBox(height: 30),

                  // Play Quiz Button
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                      backgroundColor: Colors.purple.shade800, // Updated to purple.shade800
                      foregroundColor: Colors.white,
                      textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(25),
                      ),
                      shadowColor: Colors.purple.shade800.withOpacity(0.5), // Updated shadow
                      elevation: 10,
                    ),
                    icon: Icon(Icons.play_arrow, size: 28),
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, '/choices');
                    },
                    label: Text('play_quiz'.tr()),
                  ),
                  SizedBox(height: 30),

                  // Language Selector
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'choose_language'.tr(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.white, // White text for visibility
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.cyanAccent, // Neon cyan border
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: DropdownButton<Locale>(
                          value: context.locale,
                          dropdownColor: Colors.black87, // Dark dropdown background
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          isExpanded: true,
                          underline: SizedBox(),
                          icon: Icon(
                            Icons.language,
                            color: Colors.purple.shade800, // Updated to purple.shade800
                          ),
                          onChanged: (Locale? newLocale) {
                            if (newLocale != null) {
                              context.setLocale(newLocale);
                            }
                          },
                          items: [
                            DropdownMenuItem(
                              value: Locale('en'),
                              child: Text('English'),
                            ),
                            DropdownMenuItem(
                              value: Locale('fr'),
                              child: Text('Français'),
                            ),
                            DropdownMenuItem(
                              value: Locale('ar'),
                              child: Text('العربية'),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),

                  // Dark/Light Mode Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        isDarkMode ? 'Dark Mode' : 'Light Mode',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white, // Consistent neon effect
                        ),
                      ),
                      SizedBox(width: 15),
                      GestureDetector(
                        onTap: () {
                          themeNotifier.toggleTheme();
                        },
                        child: AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          width: 55,
                          height: 30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: isDarkMode
                                ? Colors.purple.shade800
                                : Colors.cyanAccent,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black45,
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ],
                          ),
                          child: AnimatedAlign(
                            duration: Duration(milliseconds: 300),
                            alignment: isDarkMode ? Alignment.centerRight : Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black12,
                                      blurRadius: 5,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
