import 'dart:convert';
import 'package:http/http.dart' as http;

class Coordinates {
  final double latitude;
  final double longitude;

  Coordinates({required this.latitude, required this.longitude});

  @override
  String toString() => 'Coordinates(latitude: $latitude, longitude: $longitude)';
}

Future<Coordinates> getCoordinates(String location, {http.Client? client}) async {
  client ??= http.Client();

  // Use a free geocoding API, e.g., Nominatim
  final uri = Uri.parse('https://nominatim.openstreetmap.org/search?q=$location&format=json&limit=1');

  final response = await client.get(uri, headers: {'User-Agent': 'weather-app'});

  if (response.statusCode == 200) {
    final List data = jsonDecode(response.body);
    if (data.isNotEmpty) {
      final lat = double.parse(data[0]['lat']);
      final lon = double.parse(data[0]['lon']);
      return Coordinates(latitude: lat, longitude: lon);
    } else {
      throw Exception('No geocoding results found for location: $location');
    }
  } else {
    throw Exception('Failed to fetch geocoding data.');
  }
}
