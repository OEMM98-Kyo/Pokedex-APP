import 'package:flutter/material.dart';
import 'api_conn.dart';
import 'pokemon_details.dart';


void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Pokedex',
      theme: ThemeData(
        primarySwatch: Colors.red,
        scaffoldBackgroundColor: Colors.grey[200],
      ),
      home: const PokemonList(),
    );
  }
}

class PokemonList extends StatefulWidget {
  const PokemonList({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PokemonListState createState() => _PokemonListState();
}

class _PokemonListState extends State<PokemonList> {
  TextEditingController searchController = TextEditingController();
  List<Map<String, dynamic>> allPokemon = [];
  List<Map<String, dynamic>> filteredPokemon = [];
  bool isLoading = true; // Boolean to control the loading state

  @override
  void initState() {
    super.initState();
    loadPokemon();
    searchController.addListener(() {
      filterPokemon();
    });
  }

  // Load Pokémon from the API
  void loadPokemon() async {
    List<Map<String, dynamic>> data = await ApiService.getGen1Pokemon();
    setState(() {
      allPokemon = data;
      filteredPokemon = allPokemon;
      isLoading = false; // When loading is complete, disable the loading state
    });
  }

  // Filter Pokémon in real-time
  void filterPokemon() {
    String query = searchController.text.toLowerCase();
    setState(() {
      filteredPokemon = allPokemon.where((pokemon) {
        String name = pokemon['name'].toLowerCase();
        String id = pokemon['id'].toString();
        return name.contains(query) || id.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          children: [
            Image.asset(
              'assets/blue_pokeball.png',
              height: 40, 
            ),
            const SizedBox(width: 10), 
            Text(
              'POKEDEX',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue, 
              ),
            ),
          ],
        ),
      ),
      body: isLoading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.red),
                const SizedBox(height: 20),
                const Text(
                  "Espere mientras obtenemos los Pokémon...",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          )
        : Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            child: Text(
              '¡Bienvenido! Busca tu Pokémon favorito de la Generación 1:',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black, 
              ),
              textAlign: TextAlign.center,
            ),
          ),
          // Search bar
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Buscar Pokémon...',
                prefixIcon: const Icon(Icons.search, color: Colors.amber,),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                filled: true,
                fillColor: Colors.white,
              ),
            ),
          ),

          // Pokémon list in a grid
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 15,
                mainAxisSpacing: 15,
              ),
              itemCount: filteredPokemon.length,
              itemBuilder: (context, index) {
                final pokemon = filteredPokemon[index];

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PokemonDetails(pokemon: pokemon),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Image.network(
                                pokemon['sprites']['other']['home']['front_default'],
                                height: 100,
                                width: 100,
                              ),
                              Text(
                                pokemon['name'].toUpperCase(),
                                style: TextStyle(
                                  color: Colors.indigo,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          top: 15,
                          right: 15,
                          child: Text(
                            "#${pokemon['id'].toString().padLeft(3, '0')}",
                            style: TextStyle(
                              color: Colors.grey.shade700,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container( // The footer goes here
        padding: const EdgeInsets.all(12.0),
        color: Colors.white,
        child: const Text(
          "© 2025 Pokedex App - Oscar E. Mejia",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }
}
