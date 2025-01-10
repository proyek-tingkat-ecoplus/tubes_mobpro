import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:tubes_mobpro/service/ApiService.dart';
import 'package:tubes_mobpro/pages/ReplyPage.dart';

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  List<Map<String, dynamic>> forumPosts = [];
  final ApiService _apiService = ApiService(baseUrl: 'https://ecopulse.top/api');

  @override
  void initState() {
    super.initState();
    _fetchForumData();
  }

  Future<void> _fetchForumData() async {
    try {
      final response = await _apiService.request(
        endpoint: '/forum',
        method: 'GET',
      );
      if (response['statusCode'] == 200) {
        setState(() {
          forumPosts = List<Map<String, dynamic>>.from(response['body']['data']);
        });
      }
    } catch (e) {
      print('Error fetching forum data: $e');
    }
  }

  Future<void> _deletePost(int postId) async {
    try {
      final response = await _apiService.request(
        endpoint: '/forum/$postId/delete',
        method: 'DELETE',
      );
      if (response['statusCode'] == 200) {
        setState(() {
          forumPosts.removeWhere((post) => post['id'] == postId);
        });
      }
    } catch (e) {
      print('Error deleting post: $e');
    }
  }

  Future<void> _addNewPost(Map<String, String> newPost) async {
    try {
      final response = await _apiService.request(
        endpoint: '/forum/add',
        method: 'POST',
        body: {
          'name': newPost['title']!,
          'description': newPost['content']!,
          'user': '3',
        },
      );
      if (response['statusCode'] == 200) {
        setState(() {
          forumPosts.insert(0, response['body']['forum']);
        });
        _fetchForumData();
      }
    } catch (e) {
      print('Error adding post: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Forum Diskusi"),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
      ),
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
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
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
                  icon: const Icon(Icons.add, color: Colors.white),
                  label: const Text('Tambah', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Expanded(
              child: forumPosts.isEmpty
                  ? const Center(child: Text('No posts available'))
                  : ListView.builder(
                      itemCount: forumPosts.length,
                      itemBuilder: (context, index) {
                        final post = forumPosts[index];
                        return PostCard(
                          title: post['name'] ?? 'Untitled',
                          author: post['user']?['username'] ?? 'Unknown',
                          timeAgo: 'Recently', // Replace with actual timestamp logic
                          role: post['user']?['role_id'].toString() ?? 'User',
                          content: post['description'] ?? '',
                          comments: [], // Handle comments
                          onDelete: () => _deletePost(post['id']),
                          onReply: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ReplyPage(
                                  postTitle: post['name'] ?? '',
                                  onCommentAdded: (comment) {
                                    setState(() {
                                      forumPosts[index]['comments'] ??= [];
                                      forumPosts[index]['comments'].add(comment);
                                    });
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
  final QuillController _controller = QuillController.basic();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Tambah Forum", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Judul Forum', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan judul forum',
              ),
            ),
            const SizedBox(height: 16),
            const Text('Isi Forum', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
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
                        child: QuillEditor.basic(controller: _controller),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.grey),
                  child: const Text('Cancel', style: TextStyle(color: Colors.white)),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newPost = {
                      'title': _titleController.text,
                      'content': _controller.document.toPlainText(),
                    };
                    Navigator.pop(context, newPost);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
                  ),
                  child: const Text('Post', style: TextStyle(color: Colors.white)),
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

  const PostCard({
    Key? key,
    required this.title,
    required this.author,
    required this.timeAgo,
    required this.role,
    required this.content,
    required this.comments,
    required this.onDelete,
    required this.onReply,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      margin: const EdgeInsets.symmetric(vertical: 8),
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
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(author, style: const TextStyle(fontWeight: FontWeight.bold)),
                    Text('$timeAgo • $role', style: const TextStyle(color: Colors.grey)),
                  ],
                ),
                const Spacer(),
                IconButton(
                  icon: const Icon(Icons.delete, color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(content),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(onPressed: onReply, child: const Text('Reply')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
