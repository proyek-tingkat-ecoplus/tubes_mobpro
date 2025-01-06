import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _selectedIndex = 0;
  List<Map<String, dynamic>> forumPosts = [
    {
      'title': 'Infrastruktur terbaru',
      'author': 'Rendy Nugraha',
      'timeAgo': '2 jam lalu',
      'role': 'Kepala Staff',
      'content': 'Infrastruktur terbaru dimana kita akan menempatkan beberapa kincir air di desa dengan debit dan arus air yang...',
      'comments': []
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _deletePost(int index) {
    setState(() {
      forumPosts.removeAt(index);
    });
  }

  void _addNewPost(Map<String, String> newPost) {
    setState(() {
      forumPosts.insert(0, {...newPost, 'comments': []});
    });
  }

  void _addComment(int postIndex, String comment) {
    setState(() {
      forumPosts[postIndex]['comments'].add(comment);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum Diskusi"),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(38, 66, 22, 10),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      backgroundColor: Colors.grey[200],
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search...',
                      prefixIcon: Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                ElevatedButton.icon(
                  onPressed: () async {
                    final newPost = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => TambahForumPage()),
                    );
                    if (newPost != null) {
                      _addNewPost(newPost);
                    }
                  },
                  icon: Icon(Icons.add, color: Colors.white),
                  label: Text('Tambah', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: forumPosts.length,
                itemBuilder: (context, index) {
                  final post = forumPosts[index];
                  return PostCard(
                    title: post['title']!,
                    author: post['author']!,
                    timeAgo: post['timeAgo']!,
                    role: post['role']!,
                    content: post['content']!,
                    comments: List<String>.from(post['comments']),
                    onDelete: () {
                      _deletePost(index);
                    },
                    onReply: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReplyPage(
                            postTitle: post['title']!,
                            onCommentAdded: (comment) {
                              _addComment(index, comment);
                            },
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class TambahForumPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final _controller = QuillController.basic();

  void _showPostConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          contentPadding: EdgeInsets.all(20),
          title: Center(
            child: Text(
              'Forum telah diunggah',
              style: TextStyle(
                color: Color.fromRGBO(38, 66, 22, 10),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'klik di sini untuk melihat forum yang telah Anda buat!',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  minimumSize: Size(double.infinity, 50),
                ),
                child: Text('lihat forum', style: TextStyle(color: Colors.white)),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tambah Forum", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(38, 66, 22, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Judul Forum', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan judul forum',
              ),
            ),
            SizedBox(height: 16),
            Text('Isi Forum', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      QuillSimpleToolbar(
                        controller: _controller,
                        configurations: const QuillSimpleToolbarConfigurations(),
                      ),
                      Expanded(
                        child: QuillEditor.basic(
                          controller: _controller,
                          configurations: const QuillEditorConfigurations(),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newPost = {
                      'title': _titleController.text,
                      'author': 'Pengguna',
                      'timeAgo': 'Baru saja',
                      'role': 'Anggota',
                      'content': _controller.document.toPlainText(), // Get content from Quill
                    };
                    Navigator.pop(context, newPost);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                  ),
                  child: Text('Post ke Forum', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostCard extends StatelessWidget {
  final String title;
  final String author;
  final String timeAgo;
  final String role;
  final String content;
  final List<String> comments;
  final VoidCallback onDelete;
  final VoidCallback onReply;

  PostCard({
    required this.title,
    required this.author,
    required this.timeAgo,
    required this.role,
    required this.content,
    required this.comments,
    required this.onDelete,
    required this.onReply,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.grey[300],
                  child: Text(author[0].toUpperCase()),
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: TextStyle(fontWeight: FontWeight.bold)),
                    Text('$timeAgo • $role'),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(title, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text(content),
            SizedBox(height: 10),
            if (comments.isNotEmpty)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: comments.map((comment) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('- $comment'),
                )).toList(),
              ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.chat_bubble_outline, color: Color.fromRGBO(38, 66, 22, 10)),
                SizedBox(width: 5),
                Text('Partisipan', style: TextStyle(color: Colors.grey)),
                Spacer(),
                TextButton(
                  onPressed: onReply,
                  child: Text('Balas', style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10))),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReplyPage extends StatelessWidget {
  final String postTitle;
  final ValueChanged<String> onCommentAdded;

  ReplyPage({required this.postTitle, required this.onCommentAdded});

  final TextEditingController _replyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Balas ke: $postTitle', style: TextStyle(color: Colors.white)),
        backgroundColor: Color.fromRGBO(38, 66, 22, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tulis Komentar Anda:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            TextField(
              controller: _replyController,
              maxLines: 5,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan komentar di sini...',
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () {
                    if (_replyController.text.isNotEmpty) {
                      onCommentAdded(_replyController.text);
                    }
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                  ),
                  child: Text('Post Komentar', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}