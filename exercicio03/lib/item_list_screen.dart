import 'package:flutter/material.dart';
import 'item.dart';
import 'item_details_screen.dart';

class ItemListScreen extends StatelessWidget {
  final List<Item> items;

  const ItemListScreen({required this.items, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Lista de Itens'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            leading: Image.network(items[index].imageUrl),
            title: Text(items[index].title),
            onTap: () {
              _showItemDetails(context, items[index]);
            },
          );
        },
      ),
    );
  }

  void _showItemDetails(BuildContext context, Item item) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ItemDetailsScreen(item: item),
      ),
    );
  }
}
