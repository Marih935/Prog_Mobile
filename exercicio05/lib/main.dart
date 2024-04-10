import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class Pokemon {
  final String name;
  final List<String> abilities;
  final int height;
  final int weight;
  final String imageUrl;

  Pokemon({
    required this.name,
    required this.abilities,
    required this.height,
    required this.weight,
    required this.imageUrl,
  });

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      name: json['name'],
      abilities: (json['abilities'] as List<dynamic>)
          .map((ability) => ability['ability']['name'] as String)
          .toList(),
      height: json['height'],
      weight: json['weight'],
      imageUrl: json['sprites']['front_default'],
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon Search',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: PokemonSearchPage(),
    );
  }
}

class PokemonSearchPage extends StatefulWidget {
  @override
  _PokemonSearchPageState createState() => _PokemonSearchPageState();
}

class _PokemonSearchPageState extends State<PokemonSearchPage> {
  late List<String> _pokemonNames = [];
  late String _selectedPokemonName = '';

  @override
  void initState() {
    super.initState();
    fetchPokemonNames().then((pokemonNames) {
      setState(() {
        _pokemonNames = pokemonNames;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus(); // Desfoca o campo de texto quando o usuário toca fora dele.
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('Pokémon Search'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Autocomplete<String>(
                optionsBuilder: (TextEditingValue textEditingValue) {
                  return _pokemonNames
                      .where((name) =>
                          name.toLowerCase().startsWith(
                              textEditingValue.text.toLowerCase()))
                      .toList();
                },
                onSelected: (String selectedPokemon) {
                  setState(() {
                    _selectedPokemonName = selectedPokemon;
                  });
                },
                fieldViewBuilder: (context, controller, focusNode, onEditingComplete) {
                  return TextField(
                    controller: controller,
                    focusNode: focusNode,
                    onEditingComplete: onEditingComplete,
                    decoration: InputDecoration(
                      labelText: 'Search for a Pokémon',
                    ),
                  );
                },
              ),
              SizedBox(height: 20),
              _selectedPokemonName.isNotEmpty
                  ? Expanded(
                      child: FutureBuilder<Pokemon>(
                        future: fetchPokemonInfo(_selectedPokemonName),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(child: CircularProgressIndicator());
                          } else if (snapshot.hasData) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Image.network(snapshot.data!.imageUrl),
                                Text(
                                  'Name: ${snapshot.data!.name}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'Height: ${snapshot.data!.height}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'Weight: ${snapshot.data!.weight}',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Text(
                                  'Abilities:',
                                  style: TextStyle(fontSize: 20),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: snapshot.data!.abilities
                                      .map((ability) => Text(
                                            '- $ability',
                                            style: TextStyle(fontSize: 16),
                                          ))
                                      .toList(),
                                ),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('Failed to load Pokémon info: ${snapshot.error}');
                          }
                          return Container();
                        },
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Future<List<String>> fetchPokemonNames() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=1000'));
    if (response.statusCode == 200) {
      final pokemonList = json.decode(response.body)['results'] as List<dynamic>;
      return pokemonList.map((pokemon) => pokemon['name'] as String).toList();
    } else {
      throw Exception('Failed to load Pokémon names');
    }
  }

  Future<Pokemon> fetchPokemonInfo(String pokemonName) async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon/$pokemonName'));
    if (response.statusCode == 200) {
      return Pokemon.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load Pokémon info');
    }
  }
}
