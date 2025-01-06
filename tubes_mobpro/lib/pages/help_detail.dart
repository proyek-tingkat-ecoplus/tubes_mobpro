import 'package:flutter/material.dart';

class HelpDetailPage extends StatelessWidget {
  final String question;
  final String answer;

  const HelpDetailPage({super.key, required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromRGBO(38, 66, 22, 1), // Latar hijau
      body: SafeArea(
        child: Column(
          children: [
            SizedBox(
              height: 150,
              child: Center(
                child: _buildOptionButton(
                  icon: Icons.arrow_back,
                  title: 'Bantuan',
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ),
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        question,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color.fromRGBO(38, 66, 22, 1),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        answer,
                        style: TextStyle(fontSize: 16, color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionButton({
    required IconData icon,
    required String title,
    Color titleColor = Colors.white,
    Color iconColor = Colors.white,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      style: TextButton.styleFrom(
        padding: EdgeInsets.all(0),
        alignment: Alignment.centerLeft,
      ),
      onPressed: onPressed,
      child: Row(
        children: [
          SizedBox(width: 20),
          Icon(
            icon, 
            color: iconColor, 
            size: 30,
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: TextStyle(color: titleColor, fontSize: 20),
              ),
            ),
          ),
          SizedBox(width: 30), 
        ],
      ),
    );
  }
}
