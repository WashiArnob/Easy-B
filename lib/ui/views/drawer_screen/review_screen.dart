import 'package:flutter/material.dart';

class ReviewScreen extends StatefulWidget {
  const ReviewScreen({Key? key}) : super(key: key);

  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  final TextEditingController _feedbackController = TextEditingController();
  double _rating = 0.0;

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }

  void _submitReview() {
    // Perform actions to submit the review, such as sending feedback and rating to backend
    final String feedbackText = _feedbackController.text.trim();
    final int ratingValue = _rating.toInt();

    // Print the feedback and rating for demonstration
    print('Feedback: $feedbackText');
    print('Rating: $ratingValue');

    // Reset the form
    _feedbackController.clear();
    setState(() {
      _rating = 0.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customer Reviews'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Leave your feedback:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            TextField(
              controller: _feedbackController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: 'Enter your feedback here',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16.0),
            Text(
              'Rate your experience:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => setState(() => _rating = 1.0),
                  icon: Icon(Icons.star, color: _rating >= 1 ? Colors.amber : Colors.grey),
                ),
                IconButton(
                  onPressed: () => setState(() => _rating = 2.0),
                  icon: Icon(Icons.star, color: _rating >= 2 ? Colors.amber : Colors.grey),
                ),
                IconButton(
                  onPressed: () => setState(() => _rating = 3.0),
                  icon: Icon(Icons.star, color: _rating >= 3 ? Colors.amber : Colors.grey),
                ),
                IconButton(
                  onPressed: () => setState(() => _rating = 4.0),
                  icon: Icon(Icons.star, color: _rating >= 4 ? Colors.amber : Colors.grey),
                ),
                IconButton(
                  onPressed: () => setState(() => _rating = 5.0),
                  icon: Icon(Icons.star, color: _rating >= 5 ? Colors.amber : Colors.grey),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            Center(
              child: ElevatedButton(
                onPressed: _submitReview,
                child: Text('Submit Review'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
