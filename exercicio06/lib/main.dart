import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => FavoritesProvider()),
        ChangeNotifierProvider(create: (context) => NormalItemsProvider()),
      ],
      child: MaterialApp(
        title: 'Exercicio 06',
        theme: ThemeData(
          primaryColor: Colors.green,
        ),
        home: FavoritesScreen(),
      ),
    );
  }
}

class FavoriteItem {
  final String name;

  FavoriteItem(this.name);
}

class FavoritesProvider extends ChangeNotifier {
  List<FavoriteItem> _favorites = [];

  List<FavoriteItem> get favorites => _favorites;

  void addFavorite(FavoriteItem item) {
    _favorites.add(item);
    notifyListeners();
  }

  void removeFavorite(FavoriteItem item) {
    _favorites.remove(item);
    notifyListeners();
  }
}

class NormalItem {
  final String name;

  NormalItem(this.name);
}

class NormalItemsProvider extends ChangeNotifier {
  List<NormalItem> _items = [];

  List<NormalItem> get items => _items;

  void addItem(NormalItem item) {
    _items.add(item);
    notifyListeners();
  }

  void removeItem(NormalItem item) {
    _items.remove(item);
    notifyListeners();
  }
}

class FavoritesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final favoritesProvider = Provider.of<FavoritesProvider>(context);
    final normalItemsProvider = Provider.of<NormalItemsProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('List App'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ElevatedButton(
            onPressed: () {
              _showAddDialog(context, normalItemsProvider);
            },
            child: Text('Add Item'),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: normalItemsProvider.items.length,
              itemBuilder: (context, index) {
                final item = normalItemsProvider.items[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          normalItemsProvider.removeItem(item);
                        },
                      ),
                      IconButton(
                        icon: favoritesProvider.favorites.any((favItem) => favItem.name == item.name)
                            ? Icon(Icons.favorite)
                            : Icon(Icons.favorite_border_outlined),
                        onPressed: () {
                          final favoriteItem = FavoriteItem(item.name);
                          if (favoritesProvider.favorites.any((favItem) => favItem.name == item.name)) {
                            favoritesProvider.removeFavorite(favoriteItem);
                          } else {
                            favoritesProvider.addFavorite(favoriteItem);
                          }
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          SizedBox(height: 20),
          Text('Favorites', textAlign: TextAlign.center),
          Expanded(
            child: ListView.builder(
              itemCount: favoritesProvider.favorites.length,
              itemBuilder: (context, index) {
                final item = favoritesProvider.favorites[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: IconButton(
                    icon: Icon(Icons.favorite),
                    onPressed: () {
                      favoritesProvider.removeFavorite(item);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showAddDialog(BuildContext context, NormalItemsProvider provider) {
    showDialog(
      context: context,
      builder: (context) {
        final TextEditingController controller = TextEditingController();

        return AlertDialog(
          title: Text('Add Item'),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: 'Item name',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final item = NormalItem(controller.text);
                provider.addItem(item);
                Navigator.pop(context);
              },
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
