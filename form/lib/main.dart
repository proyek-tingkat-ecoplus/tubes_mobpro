import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Forum Diskusi',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: ForumPage(),
    );
  }
}

class ForumPage extends StatefulWidget {
  const ForumPage({Key? key}) : super(key: key);

  @override
  State<ForumPage> createState() => _ForumPageState();
}

class _ForumPageState extends State<ForumPage> {
  int _selectedIndex = 0;
  // Daftar data forum yang akan ditampilkan
  List<Map<String, String>> forumPosts = [
    {
      'title': 'Infrastruktur terbaru',
      'author': 'Rendy Nugraha',
      'timeAgo': '2 jam lalu',
      'role': 'Kepala Staff',
      'content': 'Infrastruktur terbaru dimana kita akan menempatkan beberapa kincir air di desa dengan debit dan arus air yang...',
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _deletePost(int index) {
    setState(() {
      forumPosts.removeAt(index); // Menghapus item dari daftar
    });
  }

  // Fungsi untuk menambahkan post baru ke dalam daftar
  void _addNewPost(Map<String, String> newPost) {
    setState(() {
      forumPosts.insert(0, newPost); // Menambah post baru ke posisi paling atas
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Forum Diskusi"),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Color.fromRGBO(38, 66, 22, 10),
        titleTextStyle: TextStyle(
          color: Colors.white,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
        iconTheme: IconThemeData(color: Colors.black),
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
                      _addNewPost(newPost); // Tambahkan post baru ke dalam daftar
                    }
                  },
                  icon: Icon(
                    Icons.add,
                    color: Colors.white,
                  ),
                  label: Text(
                    'Tambah', 
                    style: TextStyle(color: Colors.white)
                  ),
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
                    onDelete: () {
                      _deletePost(index); // Panggil fungsi untuk menghapus forum
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.file_copy),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Color.fromRGBO(38, 66, 22, 10),
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
      ),
    );
  }
}

class TambahForumPage extends StatelessWidget {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

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
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold
                ),
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
        title: Text(
          "Tambah Forum",
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Color.fromRGBO(38, 66, 22, 10),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Judul Forum',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Masukkan judul forum',
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Isi Forum',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextField(
                    controller: _contentController,
                    maxLines: null,
                    decoration: InputDecoration(
                      hintText: 'Tulis pertanyaan di sini...',
                      border: InputBorder.none,
                    ),
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
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.grey,
                  ),
                  child: Text(
                    'Cancel',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    final newPost = {
                      'title': _titleController.text,
                      'author': 'Pengguna', // Pengguna default
                      'timeAgo': 'Baru saja',
                      'role': 'Anggota',
                      'content': _contentController.text,
                    };
                    Navigator.pop(context, newPost); // Kirim post baru ke ForumPage
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(38, 66, 22, 10),
                  ),
                  child: Text(
                    'Post ke Forum',
                    style: TextStyle(color: Colors.white),
                  ),
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
  final VoidCallback onDelete;

  PostCard({
    required this.title,
    required this.author,
    required this.timeAgo,
    required this.role,
    required this.content,
    required this.onDelete,
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
                    Text(
                      author,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('$timeAgo • $role'),
                  ],
                ),
                Spacer(),
                IconButton(
                  icon: Icon(Icons.delete , color: Colors.red),
                  onPressed: onDelete,
                ),
              ],
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Text(content
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Icon(Icons.chat_bubble_outline, color: Color.fromRGBO(38, 66, 22, 10)),
                SizedBox(width: 5),
                Text(
                  'Partisipan',
                  style: TextStyle(color: Colors.grey),
                ),
                Spacer(),
                TextButton(
                  onPressed: () {
                    // Action for "Balas" button
                  },
                  child: Text(
                    'Balas',
                    style: TextStyle(color: Color.fromRGBO(38, 66, 22, 10)),
                  ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}
