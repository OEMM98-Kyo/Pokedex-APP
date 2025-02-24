import 'package:flutter/material.dart';

class PokemonDetails extends StatelessWidget {
  final Map<String, dynamic> pokemon;

  const PokemonDetails({super.key, required this.pokemon});

  @override
  Widget build(BuildContext context) {
    // Extract the primary type color of the Pokémon
    Color primaryColor = getPokemonColor(pokemon['types'][0]['type']['name']);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              pokemon['name'].toUpperCase(),
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.blue, 
              ),
            ),
            Text(
              "#${pokemon['id'].toString().padLeft(3, '0')}",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 80),
            // Card with the background of the Pokémon's primary color
            Stack(
              clipBehavior: Clip.none, // Allows the image to stand out
              children: [
                Card(
                  color: primaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  elevation: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: SizedBox(
                      height: 100,
                      width: double.infinity,
                    ),
                  ),
                ),
                Positioned(
                  top: -100,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Image.network(
                      pokemon['sprites']['other']['home']['front_default'],
                      height: 200,
                      width: 200,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.height, size: 30, color: primaryColor),
                          SizedBox(height: 5),
                          Text("Altura", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${pokemon['height'] / 10} m"),
                        ],
                      ),
                    ),
                    Container(height: 50, width: 1, color: Colors.grey), // Divider
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.scale, size: 30, color: primaryColor),
                          SizedBox(height: 5),
                          Text("Peso", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text("${pokemon['weight'] / 10} kg"),
                        ],
                      ),
                    ),
                    Container(height: 50, width: 1, color: Colors.grey), // Divider
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.settings, size: 30, color: primaryColor),
                          SizedBox(height: 5),
                          Text("Tipo", style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(pokemon['types'].map((t) => t['type']['name']).join(", ")),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Estadísticas Base",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...pokemon['stats'].map<Widget>((stat) {
                      String statName = {
                        "hp": "HP",
                        "attack": "Ataque",
                        "defense": "Defensa",
                        "special-attack": "Ataque Especial",
                        "special-defense": "Defensa Especial",
                        "speed": "Velocidad"
                      }[stat['stat']['name']] ?? stat['stat']['name']; // If it's not in the map, use the original name

                      int baseStat = stat['base_stat'];
                      double progress = baseStat / 255;

                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 5.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "$statName: $baseStat",
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            SizedBox(height: 5),
                            TweenAnimationBuilder<double>(
                              tween: Tween<double>(begin: 0, end: progress),
                              duration: Duration(seconds: 1),
                              curve: Curves.easeOut,
                              builder: (context, value, child) {
                                return LinearProgressIndicator(
                                  value: value,
                                  backgroundColor: Colors.grey.shade300,
                                  color: primaryColor,
                                  minHeight: 15,
                                  borderRadius: BorderRadius.circular(5),
                                );
                              },
                            )
                          ],
                        ),
                      );
                    }).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Function to get the color based on the Pokémon type
  Color getPokemonColor(String type) {
    switch (type) {
      case 'fire':
        return Colors.orange;
      case 'water':
        return Colors.blue;
      case 'grass':
        return Colors.green;
      case 'electric':
        return Colors.yellow.shade700;
      case 'psychic':
        return Colors.pink;
      case 'ice':
        return Colors.lightBlueAccent;
      case 'dragon':
        return Colors.deepPurple;
      case 'dark':
        return Colors.brown;
      case 'fairy':
        return Colors.pinkAccent;
      case 'normal':
        return Colors.grey;
      case 'fighting':
        return Colors.redAccent;
      case 'flying':
        return Colors.indigo;
      case 'poison':
        return Colors.purple;
      case 'ground':
        return Colors.brown.shade600;
      case 'rock':
        return Colors.brown.shade800;
      case 'bug':
        return Colors.lightGreen;
      case 'ghost':
        return Colors.deepPurpleAccent;
      case 'steel':
        return Colors.blueGrey;
      default:
        return Colors.grey.shade400;
    }
  }

}
