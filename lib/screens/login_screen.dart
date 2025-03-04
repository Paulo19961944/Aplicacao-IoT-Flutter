import 'package:flutter/material.dart';

// Função principal para a tela de login
class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // Função para validar email
  String? _validateEmail(String? email) {
    if (email == null || email.isEmpty) {
      return 'O campo de email não pode estar vazio';
    }
    String emailPattern =
        r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$";
    RegExp regex = RegExp(emailPattern);
    if (!regex.hasMatch(email)) {
      return 'Digite um email válido';
    }
    return null;
  }

  // Função para validar senha
  String? _validatePassword(String? password) {
    if (password == null || password.isEmpty) {
      return 'O campo de senha não pode estar vazio';
    }
    if (password.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  // Função para enviar o formulário
  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      // Aqui você pode adicionar a lógica para o envio do login
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login bem-sucedido!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Aplicativo IoT',
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
        backgroundColor: Colors.blue, // Cabeçalho azul
        iconTheme: IconThemeData(color: Colors.white), // Ícones do AppBar em branco
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Entrar na sua conta',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Email',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.email),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: _validateEmail,
              ),
              SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Senha',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                obscureText: true,
                validator: _validatePassword,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submit,
                child: Text('Fazer Login', style: TextStyle(color: Colors.white)), // Texto branco
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue, // Cor de fundo azul
                  padding: EdgeInsets.symmetric(vertical: 16),
                  textStyle: TextStyle(fontSize: 16), // Tamanho da fonte do botão
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
