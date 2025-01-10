import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ReplyPage extends StatefulWidget {
  final String postTitle;
  final Function(String comment) onCommentAdded;

  ReplyPage({
    required this.postTitle,
    required this.onCommentAdded,
  });

  @override
  _ReplyPageState createState() => _ReplyPageState();
}

class _ReplyPageState extends State<ReplyPage> {
  final TextEditingController _commentController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Reply to: ${widget.postTitle}'),
        backgroundColor: Color.fromRGBO(38, 66, 22, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _commentController,
              decoration: InputDecoration(
                hintText: 'Write your comment...',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                final comment = _commentController.text;
                if (comment.isNotEmpty) {
                  widget.onCommentAdded(comment);  // Call the callback
                  Navigator.pop(context);  // Close the reply page
                }
              },
              child: Text('Post Comment'),
            ),
          ],
        ),
      ),
    );
  }
}
