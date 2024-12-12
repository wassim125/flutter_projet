import 'package:flutter/material.dart';
import 'package:miniprojet/pages/MenuPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LeaderboardPage extends StatelessWidget {
  final String selectedCategory;
  final String selectedDifficulty;

  LeaderboardPage({required this.selectedCategory, required this.selectedDifficulty});

  @override
  Widget build(BuildContext context) {
    // Get the current theme mode (Light/Dark)
    bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, size: 28),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Leaderboard',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.5,
            color: isDarkMode ? Colors.white : Colors.black,
            fontFamily: 'Poppins', // Custom font for a unique look
          ),
        ),
        backgroundColor: isDarkMode ? Colors.deepPurple.shade700 : Colors.purple.shade300,
        elevation: 12,
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, size: 28),
            onPressed: () => Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => LeaderboardPage(
                  selectedCategory: selectedCategory,
                  selectedDifficulty: selectedDifficulty,
                ),
              ),
            ),
          ),
          // Add the button to navigate to the menu page
          IconButton(
            icon: Icon(Icons.home, size: 28),
            onPressed: () {
              // Assuming MenuPage is the page to navigate to
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => MenuPage(), // Replace MenuPage with your actual menu page widget
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: isDarkMode
                ? [Colors.deepPurple.shade700, Colors.purple.shade600]
                : [Colors.white, Colors.purple.shade100],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FutureBuilder(
          future: _getScores(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }

            if (snapshot.hasError) {
              return Center(
                child: Text(
                  "Error loading scores",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(
                child: Text(
                  "No scores yet",
                  style: TextStyle(
                    fontSize: 18,
                    color: isDarkMode ? Colors.grey.shade300 : Colors.grey.shade600,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              );
            }

            List<String> scores = snapshot.data as List<String>;

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
              child: ListView.builder(
                itemCount: scores.length,
                itemBuilder: (context, index) {
                  String scoreStr = scores[index];
                  int score = 0;
                  String message = 'Unknown'; // Default message if error in parsing

                  try {
                    score = int.parse(scoreStr.split(': ')[1]);
                  } catch (e) {
                    score = 0; // Default score if parsing fails
                  }

                  // Message logic based on the score
                  if (score >= 90) {
                    message = 'Excellent job!';
                  } else if (score >= 70) {
                    message = 'Great effort!';
                  } else if (score >= 50) {
                    message = 'Good try, keep going!';
                  } else {
                    message = 'Better luck next time!';
                  }

                  return AnimatedContainer(
                    duration: Duration(milliseconds: 500),
                    margin: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: isDarkMode ? Colors.white.withOpacity(0.1) : Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: isDarkMode ? Colors.deepPurple.withOpacity(0.4) : Colors.grey.withOpacity(0.4),
                          blurRadius: 12,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 24),
                      leading: CircleAvatar(
                        radius: 30,
                        backgroundColor: isDarkMode ? Colors.deepPurple.shade400 : Colors.purple.shade400,
                        child: Text(
                          (index + 1).toString(),
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 22,
                          ),
                        ),
                      ),
                      title: Text(
                        scoreStr,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w700,
                          color: isDarkMode ? Colors.white : Colors.black,
                          fontFamily: 'Poppins', // Custom font
                        ),
                      ),
                      subtitle: Text(
                        'Rank #${index + 1} - $message',
                        style: TextStyle(
                          fontSize: 16,
                          color: isDarkMode ? Colors.white.withOpacity(0.7) : Colors.black.withOpacity(0.7),
                        ),
                      ),
                      trailing: Icon(
                        Icons.star,
                        color: Colors.amber.shade500,
                        size: 28,
                      ),
                    ),
                  );
                },
              ),
            );
          },
        ),
      ),
      floatingActionButton: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        onEnd: () => _addScore(context),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: isDarkMode ? Colors.deepPurple.shade400 : Colors.purple.shade400,
              blurRadius: 10,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: FloatingActionButton(
          backgroundColor: isDarkMode ? Colors.deepPurple.shade700 : Colors.purple.shade300,
          onPressed: () {  },
          child: Icon(
            Icons.add,
            size: 30,
          ),
        ),
      ),
    );
  }

  Future<List<String>> _getScores() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = "$selectedCategory-$selectedDifficulty";

    List<String>? scores = prefs.getStringList(key);
    return scores ?? [];
  }

  Future<void> _addScore(BuildContext context) async {
    int newScore = 5; // Example score; replace with actual score logic

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String key = "$selectedCategory-$selectedDifficulty";

    List<String>? scores = prefs.getStringList(key) ?? [];

    // Add the new score and sort the scores in ascending order
    scores.add("Score: $newScore");
    scores.sort((a, b) {
      try {
        int scoreA = int.parse(a.split(': ')[1]);
        int scoreB = int.parse(b.split(': ')[1]);
        return scoreA.compareTo(scoreB); // Sort in ascending order
      } catch (e) {
        return 0; // If parsing fails, don't affect sorting
      }
    });

    // Save the updated list of scores
    await prefs.setStringList(key, scores);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => LeaderboardPage(
          selectedCategory: selectedCategory,
          selectedDifficulty: selectedDifficulty,
        ),
      ),
    );
  }
}
