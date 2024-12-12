import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:miniprojet/pages/QuizPage.dart';

class ChoicesPage extends StatefulWidget {
  @override
  _ChoicesScreenState createState() => _ChoicesScreenState();
}

class _ChoicesScreenState extends State<ChoicesPage> {
  final TextEditingController _questionController = TextEditingController();
  List<Map<String, dynamic>> _categories = [];
  List<String> _difficulties = ['easy', 'medium', 'hard'];
  List<String> _types = ['multiple', 'boolean'];
  List<String> _encodings = ['default', 'url3986', 'base64'];
  String? _selectedCategory;
  String? _selectedDifficulty;
  String? _selectedType;
  String? _selectedEncoding = 'url3986';

  @override
  void initState() {
    super.initState();
    _fetchCategories();
  }

  Future<void> _fetchCategories() async {
    try {
      final response = await http.get(Uri.parse('https://opentdb.com/api_category.php'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _categories = (data['trivia_categories'] as List)
              .map((category) => {
            'id': category['id'],
            'name': category['name'],
          })
              .toList();
        });
      } else {
        _showError('Failed to load categories');
      }
    } catch (e) {
      _showError('An error occurred while loading categories');
    }
  }

  void _showError(String message) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Display error message using SnackBar
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black, // Text color based on the theme
        ),
      ),
      backgroundColor: isDarkMode ? Colors.black : Colors.white, // Background color based on the theme
      behavior: SnackBarBehavior.floating,
      action: SnackBarAction(
        label: 'OK',
        onPressed: () {},
        textColor: isDarkMode ? Colors.white : Colors.black, // Button text color based on the theme
      ),
    ));
  }

  Future<void> _startQuiz() async {
    if (_questionController.text.isNotEmpty &&
        _selectedCategory != null &&
        _selectedDifficulty != null &&
        _selectedType != null &&
        _selectedEncoding != null) {
      final url =
          'https://opentdb.com/api.php?amount=${_questionController.text}&category=$_selectedCategory&difficulty=$_selectedDifficulty&type=$_selectedType&encode=$_selectedEncoding';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final questions = data['results'] as List;

          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => QuizPage(
                questions: questions,
                selectedType: _selectedType,
              ),
            ),
          );
        } else {
          _showError('Failed to load questions');
        }
      } catch (e) {
        _showError('An error occurred while loading questions');
      }
    } else {
      _showError('Please fill in all fields');
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.purple.shade600, // Match the button color
        title: Text(
          'Choices Page',
          style: TextStyle(
            color: isDarkMode ? Colors.black : Colors.white, // Title text color based on the theme
          ),
        ),
        leading: IconButton(
          icon: Icon(
            Icons.home,
            color: isDarkMode ? Colors.black : Colors.white, // Icon color based on the theme
          ),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/menu'); // Navigate to Menu Page
          },
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/back.jpg'), // Path to your background image
                fit: BoxFit.cover, // Ensure the image covers the entire screen
              ),
            ),
            child: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Container(
                    width: 350, // Increased width for the form container
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        _buildTextField(_questionController, 'Enter number of questions', TextInputType.number),
                        _buildDropdown(
                          'Select Category:',
                          _categories.map((category) => category['name'] as String).toList(),
                          _selectedCategory != null
                              ? _categories.firstWhere((category) => category['id'].toString() == _selectedCategory)['name']
                              : null,
                              (value) {
                            setState(() {
                              _selectedCategory = _categories
                                  .firstWhere((category) => category['name'] == value)['id']
                                  .toString();
                            });
                          },
                        ),
                        _buildDropdown(
                          'Select Difficulty:',
                          _difficulties,
                          _selectedDifficulty,
                              (value) {
                            setState(() {
                              _selectedDifficulty = value;
                            });
                          },
                        ),
                        _buildDropdown(
                          'Select Type:',
                          _types,
                          _selectedType,
                              (value) {
                            setState(() {
                              _selectedType = value;
                            });
                          },
                        ),
                        _buildDropdown(
                          'Select Encoding:',
                          _encodings,
                          _selectedEncoding,
                              (value) {
                            setState(() {
                              _selectedEncoding = value;
                            });
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _startQuiz,
                          child: Text('start_quiz'.tr()), // Using the translation key from the JSON file
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: Colors.purple.shade600,
                            padding: EdgeInsets.symmetric(horizontal: 50, vertical: 18),
                            textStyle: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
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
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText, TextInputType keyboardType) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0), // Increased vertical padding
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Text color based on the theme
        decoration: InputDecoration(
          labelText: labelText,
          labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54), // Label color based on the theme
          filled: true,
          fillColor: isDarkMode ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8), // Background color based on the theme
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown(
      String label,
      List<String> items,
      String? selectedValue,
      Function(String?)? onChanged) {
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: isDarkMode ? Colors.white70 : Colors.black54), // Label color based on the theme
          filled: true,
          fillColor: isDarkMode ? Colors.black.withOpacity(0.8) : Colors.white.withOpacity(0.8), // Background color based on the theme
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: isDarkMode ? Colors.white : Colors.black),
          ),
        ),
        value: selectedValue,
        onChanged: onChanged,
        items: items
            .map((item) => DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: TextStyle(color: isDarkMode ? Colors.white : Colors.black), // Text color based on the theme
          ),
        ))
            .toList(),
      ),
    );
  }
}
