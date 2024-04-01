import 'package:flutter/material.dart';
import 'item_list_screen.dart';
import 'item.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<Item> items = [
      Item(title: 'Item 1', imageUrl: 'https://example.com/image1.png'),
      Item(title: 'Item 2', imageUrl: 'https://example.com/image2.png'),
      Item(title: 'Item 3', imageUrl: 'https://example.com/image3.png'),
    ];

    return MaterialApp(
      title: 'Lista de Itens',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: ItemListScreen(items: items),
    );
  }
}
