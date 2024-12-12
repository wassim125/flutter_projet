import 'package:flutter/material.dart';
import 'package:miniprojet/pages/LeaderboardPage.dart';
import 'package:miniprojet/pages/MenuPage.dart';
import 'dart:async';

import 'package:shared_preferences/shared_preferences.dart';

class QuizPage extends StatefulWidget {
  final List questions;
  final String? selectedType;

  QuizPage({required this.questions, required this.selectedType});

  @override
  _QuizPageState createState() => _QuizPageState();
}

class _QuizPageState extends State<QuizPage> {
  PageController _pageController = PageController();
  Map<int, String?> _selectedAnswers = {};
  Map<int, bool?> _isCorrectAnswer = {};
  Map<int, int> _remainingTime = {};
  Map<int, bool> _isTimeUp = {};
  Timer? _timer; // Utiliser Timer? pour permettre la nullité
  final int _timeLimit = 10;
  int _currentIndex = 0;
  int _totalQuestions = 0;
  List<List<String>> _shuffledOptions = [];

  @override
  void initState() {
    super.initState();
    _totalQuestions = widget.questions.length;
  }

  @override
  void dispose() {
    _cancelTimer();
    _pageController.dispose();
    super.dispose();
  }

  void _cancelTimer() {
    if (_timer != null) {
      _timer!.cancel();
      _timer = null;
    }
  }

  void _restartQuiz() {
    _cancelTimer(); // Annuler tout timer existant
    setState(() {
      _selectedAnswers.clear();
      _isCorrectAnswer.clear();
      _remainingTime.clear();
      _isTimeUp.clear();
      _shuffledOptions.clear(); // Clear the shuffled options to reshuffle
      _currentIndex = 0;
    });
    _pageController.jumpToPage(0);
    _startTimer(0); // Démarrer le timer pour la première question

    // Ensure options are reshuffled for each question
    for (int i = 0; i < widget.questions.length; i++) {
      final question = widget.questions[i];
      _shuffledOptions.add(_getShuffledOptions(question)); // Reshuffle options
    }
  }

  void _startTimer(int index) {
    _remainingTime[index] = _timeLimit;
    _isTimeUp[index] = false;

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_remainingTime[index]! > 0 && !_isTimeUp[index]!) {
        setState(() {
          _remainingTime[index] = _remainingTime[index]! - 1;
        });
      } else {
        setState(() {
          _isTimeUp[index] = true;
        });
        _cancelTimer();
        _goToNextQuestion();
      }
    });
  }

  void _goToNextQuestion() {
    _cancelTimer(); // Annuler le timer actuel avant de passer à la question suivante
    if (_currentIndex < _totalQuestions - 1) {
      setState(() {
        _currentIndex++;
      });
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.ease,
      );
      _startTimer(_currentIndex); // Démarrer le timer pour la nouvelle question
    } else {
      _showResult();
    }
  }
  void _saveScore(int correctAnswers) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Create a key for the leaderboard based on the category and difficulty
    String key = "${widget.selectedType ?? 'Default'}-${'Easy'}"; // You can use real difficulty
    List<String> scores = prefs.getStringList(key) ?? [];

    // Add the new score to the list
    scores.add("Score: $correctAnswers / $_totalQuestions");
    await prefs.setStringList(key, scores);
  }

  void _showResult() {
    int correctAnswers = _isCorrectAnswer.values.where((e) => e == true).length;
    int incorrectAnswers = _totalQuestions - correctAnswers;
    double scorePercentage = (correctAnswers / _totalQuestions) * 100;

    // Save the score after quiz completion
    _saveScore(correctAnswers); // This will save the score

    String feedbackMessage;
    Icon feedbackIcon;

    if (scorePercentage < 50) {
      feedbackMessage =
      "Your score is very low 😔. I hope you put it higher next time!";
      feedbackIcon =
          Icon(Icons.sentiment_dissatisfied, size: 80, color: Colors.redAccent);
    } else if (scorePercentage < 80) {
      feedbackMessage = "Good job! You can still improve! 👍";
      feedbackIcon =
          Icon(Icons.thumb_up, size: 80, color: Colors.orangeAccent);
    } else if (scorePercentage < 100) {
      feedbackMessage = "Well done! You're doing great! 🌟";
      feedbackIcon = Icon(Icons.star, size: 80, color: Colors.amber);
    } else {
      feedbackMessage = "Excellent! Perfect score! 🎉";
      feedbackIcon =
          Icon(Icons.emoji_events, size: 80, color: Colors.green);
    }

    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dialog closure on tap outside
      builder: (_) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 16,
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.purpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                feedbackIcon,
                SizedBox(height: 16),
                Text(
                  'Quiz Completed!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Your score: $correctAnswers / $_totalQuestions',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  feedbackMessage,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Correct answers: $correctAnswers\n'
                      'Incorrect answers: $incorrectAnswers',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        _restartQuiz();
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Replay',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the result dialog
                        Navigator.pushReplacement( // Navigate to MenuPage, replacing the current page
                          context,
                          MaterialPageRoute(
                            builder: (context) => MenuPage(), // Make sure you have MenuPage defined
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Close the dialog
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => LeaderboardPage(
                              selectedCategory: widget.selectedType ?? 'Default',
                              selectedDifficulty: 'Easy', // Adjust based on your logic
                            ),
                          ),
                        );
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Leaderboard',
                        style: TextStyle(
                          color: Colors.deepPurple,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  List<String> _getShuffledOptions(Map question) {
    List<String> options = [];
    if (widget.selectedType == 'multiple') {
      options.add(question['correct_answer']);
      options.addAll(List<String>.from(question['incorrect_answers']));
    } else if (widget.selectedType == 'boolean') {
      options.add(question['correct_answer']);
      options.add(question['incorrect_answers'][0]);
    }
    options.shuffle();
    return options;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Quiz'),
        backgroundColor:Colors.purple.shade600,
      ),
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/back.jpg'), // Assurez-vous que l'image existe
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Quiz Content
          PageView.builder(
            controller: _pageController,
            itemCount: widget.questions.length,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final question = widget.questions[index];
              if (_shuffledOptions.length <= index) {
                _shuffledOptions.add(_getShuffledOptions(question));
              }

              if (_remainingTime[index] == null) {
                _startTimer(index);
              }

              return QuestionCard(
                index: index,
                question: question,
                options: _shuffledOptions[index],
                selectedAnswer: _selectedAnswers[index],
                isCorrectAnswer: _isCorrectAnswer[index],
                remainingTime: _remainingTime[index] ?? _timeLimit,
                isTimeUp: _isTimeUp[index] ?? false,
                onAnswerSelected: (value) {
                  setState(() {
                    _selectedAnswers[index] = value;
                    _isCorrectAnswer[index] =
                        value == question['correct_answer'];
                  });
                  _cancelTimer(); // Annuler le timer après avoir répondu
                },
                onNext: _goToNextQuestion,
              );
            },
          ),
        ],
      ),
    );
  }
}
class QuestionCard extends StatelessWidget {
  final int index;
  final Map question;
  final List<String> options;
  final String? selectedAnswer;
  final bool? isCorrectAnswer;
  final int remainingTime;
  final bool isTimeUp;
  final Function(String) onAnswerSelected;
  final VoidCallback onNext;

  QuestionCard({
    required this.index,
    required this.question,
    required this.options,
    required this.selectedAnswer,
    required this.isCorrectAnswer,
    required this.remainingTime,
    required this.isTimeUp,
    required this.onAnswerSelected,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    double progress = remainingTime / 30;
    // Check current theme brightness (light or dark)
    Brightness brightness = Theme.of(context).brightness;
    Color cardColor = brightness == Brightness.dark
        ? Colors.black.withOpacity(0.7) // Slightly transparent black for dark mode
        : Colors.white.withOpacity(0.7); // Slightly transparent white for light mode

    return Center(
      child: SizedBox(
        width: 380,
        height: 460, // Augmenter légèrement la hauteur
        child: Card(
          margin: EdgeInsets.all(8),
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: cardColor, // Set the card color based on theme
          child: SingleChildScrollView( // Ajout d'un scroll pour éviter les débordements
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Q${index + 1}: ${Uri.decodeComponent(question['question'])}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 12),
                  Center(
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: 1.0,
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Colors.grey,
                          ),
                        ),
                        CircularProgressIndicator(
                          value: progress,
                          strokeWidth: 10,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            isTimeUp ? Colors.red : Colors.green,
                          ),
                        ),
                        Text(
                          '$remainingTime',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 12),
                  Column(
                    children: options.map((option) {
                      bool isSelected = selectedAnswer == option;
                      bool isCorrect = isCorrectAnswer ?? false;

                      return Container(
                        height: 50,
                        margin: EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? (isCorrect ? Colors.green : Colors.red)
                              : Colors.deepPurple[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isSelected ? Colors.deepPurple : Colors.grey,
                          ),
                        ),
                        child: InkWell(
                          onTap: isTimeUp || selectedAnswer != null
                              ? null
                              : () => onAnswerSelected(option),
                          child: Center(
                            child: Text(
                              Uri.decodeComponent(option),
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight:
                                isSelected ? FontWeight.bold : FontWeight.normal,
                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  SizedBox(height: 12),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed:
                      isTimeUp || selectedAnswer == null ? null : onNext,
                      child: Text('Next'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
