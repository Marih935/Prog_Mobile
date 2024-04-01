import 'package:flutter/material.dart';

class CadastroForm extends StatefulWidget {
  @override
  _CadastroFormState createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _senhaController = TextEditingController();
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          TextFormField(
            controller: _nomeController,
            decoration: InputDecoration(
              labelText: 'Nome',
              hintText: 'Insira seu nome',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              filled: true,
              fillColor: Colors.white70,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu nome.';
              }
              if (value.length < 3) {
                return 'O nome deve ter pelo menos 3 caracteres.';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _emailController,
            decoration: InputDecoration(
              labelText: 'E-mail',
              hintText: 'Insira seu e-mail',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              filled: true,
              fillColor: Colors.white70,
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira seu e-mail.';
              }
              if (!value.contains('@')) {
                return 'Por favor, insira um e-mail válido.';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          TextFormField(
            controller: _senhaController,
            obscureText: _isObscure,
            decoration: InputDecoration(
              labelText: 'Senha',
              hintText: 'Insira sua senha',
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.deepPurple),
              ),
              filled: true,
              fillColor: Colors.white70,
              suffixIcon: IconButton(
                icon: Icon(
                  _isObscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() {
                    _isObscure = !_isObscure;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Por favor, insira sua senha.';
              }
              if (value.length < 6) {
                return 'A senha deve ter pelo menos 6 caracteres.';
              }
              if (!RegExp(r'\d').hasMatch(value)) {
                return 'A senha deve conter pelo menos um número.';
              }
              return null;
            },
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                _submitForm();
              }
            },
            child: Text('Enviar'),
          ),
        ],
      ),
    );
  }

  void _submitForm() {
    final nome = _nomeController.text;
    final email = _emailController.text;
    final senha = _senhaController.text;
    _showConfirmationDialog(nome, email, senha);
  }

  void _showConfirmationDialog(String nome, String email, String senha) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Informações de Cadastro'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Nome: $nome'),
              Text('E-mail: $email'),
              Text('Senha: $senha'),
            ],
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Fechar'),
            ),
          ],
        );
      },
    );
  }
}
