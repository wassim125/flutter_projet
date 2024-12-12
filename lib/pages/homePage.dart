import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    // Simulate some loading time (e.g., fetching data or performing an initial setup)
    Future.delayed(const Duration(seconds: 3), () {
      setState(() {
        _isLoading = false; // Stop showing the loading indicator after 3 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image with higher clarity
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('images/background.jpg'),
                fit: BoxFit.cover, // Ensure the image covers the screen
                alignment: Alignment.center, // Keep the image centered
              ),
            ),
            child: Container(
              // Optionally remove the gradient overlay or reduce opacity for clearer background
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent, // No dark overlay for better image visibility
                    Colors.transparent,
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
          ),
          // If the page is loading, show the CircularProgressIndicator
          if (_isLoading)
            Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.blueAccent),
                strokeWidth: 6.0,
              ),
            ),
          // Main content of the page
          if (!_isLoading)
            Align(
              alignment: Alignment.centerLeft, // Aligning content to the left-center
              child: Padding(
                padding: const EdgeInsets.only(left: 40.0), // Padding for left margin
                child: Container(
                  padding: EdgeInsets.all(16), // Padding inside the container
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.blueAccent, width: 2), // Border around the entire content
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // First part of the text (smaller size and different style)
                      Text(
                        'Welcome to the Ultimate',
                        style: TextStyle(
                          fontFamily: 'Roboto', // Change to a modern font family
                          fontWeight: FontWeight.w400, // Lighter weight for a smoother feel
                          fontSize: 32, // Smaller font size
                          color: Colors.white,
                          letterSpacing: 1.0, // Adjusted letter spacing for readability
                          height: 1.3, // Adjusted line height
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      // Second part of the text (smaller size and different style)
                      Text(
                        'General Knowledge Quiz!',
                        style: TextStyle(
                          fontFamily: 'Roboto', // Consistent font family
                          fontWeight: FontWeight.w400, // Lighter weight for a balanced look
                          fontSize: 32, // Smaller font size
                          color: Colors.white,
                          letterSpacing: 1.0,
                          height: 1.3,
                          shadows: [
                            Shadow(
                              blurRadius: 8.0,
                              color: Colors.black.withOpacity(0.6),
                              offset: Offset(2.0, 2.0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 40), // Less space between text and button
                      // Button
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(horizontal: 60, vertical: 20),
                          textStyle: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          elevation: 12, // Higher elevation for depth
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(40), // Smooth rounded corners
                          ),
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.blueAccent.withOpacity(0.4),
                        ).copyWith(
                          side: MaterialStateProperty.all(BorderSide(color: Colors.blueAccent, width: 2)),
                        ),
                        onPressed: () {
                          Navigator.pushNamed(context, '/menu');
                        },
                        child: Ink(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [Colors.blueAccent, Colors.purpleAccent], // Subtle gradient
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(40), // Smooth rounded corners
                          ),
                          child: Container(
                            alignment: Alignment.center,
                            constraints: BoxConstraints(maxWidth: 230, minHeight: 55),
                            child: Text(
                              'Continue',
                              style: TextStyle(
                                fontSize: 18, // Smaller font size for button text
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
