import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  final String name;

  const ChatListPage({Key? key, required this.name}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Чаты - $name')),
      body: Center(child: Text('Добро пожаловать, $name!')),
    );
  }
}

/*
import 'package:flutter/material.dart';

class ChatListPage extends StatelessWidget {
  const ChatListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> chats = [
      {
        'name': 'Алексей',
        'message': 'Привет! Как дела?',
        'time': '12:30',
      },
      {
        'name': 'Катя',
        'message': 'Увидимся завтра?',
        'time': '11:10',
      },
      {
        'name': 'Работа',
        'message': 'Нужно внести правки в проект',
        'time': '09:45',
      },
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Мои чаты'),
      ),
      body: ListView.builder(
        itemCount: chats.length,
        itemBuilder: (context, index) {
          final chat = chats[index];
          return ListTile(
            leading: const CircleAvatar(child: Icon(Icons.person)),
            title: Text(chat['name'] ?? ''),
            subtitle: Text(chat['message'] ?? ''),
            trailing: Text(chat['time'] ?? ''),
            onTap: () {
              // TODO: переход в чат
            },
          );
        },
      ),
    );
  }
}
*/