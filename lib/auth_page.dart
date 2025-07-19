import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'chat_list_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;
  String _message = '';

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
      _message = ''; // Сбрасываем сообщение при переключении
    });
  }

  Future<void> _submit() async {
    if (_formKey.currentState!.validate()) {
      final login = _loginController.text.trim();
      final password = _passwordController.text.trim();
      final name = _isLogin ? _nameController.text.trim() : '';

      try {
        final response = await (_isLogin
            ? loginUser(login, password)
            : registerUser(login, password, name));
        setState(() {
          if (response.statusCode == 200) {
            _message = _isLogin ? 'Вход успешен!' : 'Регистрация успешна!';
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatListPage()),
            );
          } else {
            _message = _isLogin
                ? 'Ошибка входа: ${jsonDecode(response.body)['detail']}'
                : 'Ошибка регистрации: ${jsonDecode(response.body)['detail']}';
          }
        });
      } catch (e) {
        setState(() {
          _message = 'Ошибка: $e';
        });
      }
    }
  }

  Future<http.Response> loginUser(String login, String password) async {
    return await http.post(
      Uri.parse('http://localhost:8000/login'), // Замени на IP для устройства
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': login,
        'password': password,
      }),
    );
  }

  Future<http.Response> registerUser(
      String login, String password, String name) async {
    return await http.post(
      Uri.parse(
          'http://localhost:8000/register'), // Замени на IP для устройства
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'login': login,
        'password': password,
        'name': name,
      }),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 51, 78),
      appBar: AppBar(
        title: const Text('Begemotik'),
        backgroundColor: const Color.fromARGB(113, 230, 17, 17),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLogin ? 'Вход' : 'Регистрация',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                if (!_isLogin)
                  TextFormField(
                    controller: _nameController,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      labelStyle: TextStyle(color: Colors.white70),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white70),
                      ),
                    ),
                    style: const TextStyle(color: Colors.white),
                    validator: (value) =>
                        value == null || value.isEmpty ? 'Введите имя' : null,
                  ),
                if (!_isLogin) const SizedBox(height: 12),
                TextFormField(
                  controller: _loginController,
                  decoration: const InputDecoration(
                    labelText: 'Логин',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Введите логин' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Пароль',
                    labelStyle: TextStyle(color: Colors.white70),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.white70),
                    ),
                  ),
                  style: const TextStyle(color: Colors.white),
                  validator: (value) =>
                      value == null || value.isEmpty ? 'Введите пароль' : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(113, 230, 17, 17),
                    foregroundColor: Colors.white,
                  ),
                  child: Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
                ),
                TextButton(
                  onPressed: _toggleForm,
                  child: Text(
                    _isLogin
                        ? 'Нет аккаунта? Зарегистрироваться'
                        : 'Уже есть аккаунт? Войти',
                    style: const TextStyle(color: Colors.white70),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _message,
                  style: TextStyle(
                    color:
                        _message.contains('Ошибка') ? Colors.red : Colors.green,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


/*
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'chat_list_page.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _loginController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isLogin = true;

  String name = '';
  String login = '';
  String password = '';

  void _toggleForm() {
    setState(() {
      _isLogin = !_isLogin;
    });
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text.trim();
      final login = _loginController.text.trim();
      final password = _passwordController.text.trim();

      if (_isLogin) {
        print('Вход: $login, $password');
        // TODO: логика входа
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatListPage()),
        );
      } else {
        print('Регистрация: $login, $name, $password');
        // TODO: логика регистрации
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ChatListPage()),
        );
      }
    }
  }

  @override
  void dispose() {
    _loginController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 51, 78),
      appBar: AppBar(
        title: const Text('Begemotik'),
        backgroundColor: Color.fromARGB(113, 230, 17, 17),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isLogin ? 'Exit' : 'Регистрация',
                  style: const TextStyle(
                      fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _loginController,
                  decoration: const InputDecoration(labelText: 'Login'),
                  validator: (value) =>
                      (value == null || value.isEmpty) ? 'Введите login' : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(labelText: 'Password'),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'Введите пароль'
                      : null,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isLogin ? 'Войти' : 'Зарегистрироваться'),
                ),
                TextButton(
                  onPressed: _toggleForm,
                  child: Text(_isLogin
                      ? 'Нет аккаунта? Зарегистрироваться'
                      : 'Уже есть аккаунтт? Войти'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Future<void> registerUser(String login, String password, String name) async {
  final response = await http.post(
    Uri.parse('http://localhost:8000/register'),
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({
      'login': login,
      'password': password,
      'name': name,
    }),
  );

  if (response.statusCode == 200) {
    print('Успешная регистрация!');
  } else {
    print('Ошибка регистрации: ${response.body}');
  }
}


========



@override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 41, 51, 78),
      appBar: AppBar(
        title: const Text('Begemotik'),
        backgroundColor: Color.fromARGB(113, 230, 17, 17),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(labelText: 'Name'),
                onSaved: (value) => name = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Enter the name' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Login'),
                onSaved: (value) => login = value!.trim(),
                validator: (value) => value!.isEmpty ? 'Enter the login' : null,
              ),
              TextFormField(
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                onSaved: (value) => password = value!.trim(),
                validator: (value) =>
                    value!.length < 6 ? 'Minimum 6 symbols' : null,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _register,
                child: const Text('Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  try {
        final response = await http.post(
          Uri.parse('https://your-api-url.com/register'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'name': name,
            'login': login,
            'password': password,
          }),
        );

        if (response.statusCode == 200) {
          // регистрация успешна
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ChatListPage()),
          );
        } else {
          // регистрация не удалась — показываем ошибку
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text('Ошибка регистрации: ${response.statusCode}')),
          );
        }
      } catch (e) {
        // ошибка сети или сервера
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Ошибка подключения: $e')),
        );
      }
    }
    //Navigator.pushReplacement(
    //context, MaterialPageRoute(builder: (context) => const ChatListPage()));
  }
  */