import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "https://pokeapi.co/api/v2/";

  // Obtener la lista de los primeros 10 pokemones de la GEN1
  static Future<List<Map<String, dynamic>>> getGen1Pokemon() async {
    final url = Uri.parse('${baseUrl}pokemon?limit=20');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List results = data['results'];

        // Obtener detalles de cada Pokémon
        List<Map<String, dynamic>> pokemonList = [];

        for (var pokemon in results) {
          final details = await getPokemon(pokemon['name']);
          if (details != null) {
            pokemonList.add(details);
          }
        }

        return pokemonList;
      } else {
        return [];
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      return [];
    }
  }

  // Obtener detalles de un Pokémon
  static Future<Map<String, dynamic>?> getPokemon(String name) async {
    final url = Uri.parse('${baseUrl}pokemon/$name');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        return null;
      }
    } catch (e) {
      print("Error en la solicitud: $e");
      return null;
    }
  }
}
