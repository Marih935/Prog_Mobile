import 'package:flutter/material.dart';
import 'cadastro_form.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Exercício 04',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Formulário de Cadastro'),
        ),
        body: Padding(
          padding: EdgeInsets.all(20),
          child: CadastroForm(),
        ),
      ),
    );
  }
}
