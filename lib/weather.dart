import 'dart:convert';
import 'package:http/http.dart' as http;
import 'geocoding.dart'; // Added import

Future<WeatherData> fetchWeatherData({required String location, http.Client? client}) async {
  client ??= http.Client();
  // print('Starting fetchWeatherData for location: $location'); // Removed

  // Use geocoding to get coordinates
  Coordinates coords = await getCoordinates(location, client: client);
  // print('Using latitude: ${coords.latitude}, longitude: ${coords.longitude}'); // Removed

  // Build the API URL
  String url =
      'https://api.open-meteo.com/v1/forecast?latitude=${coords.latitude}&longitude=${coords.longitude}&hourly=temperature_2m';
  // print('Requesting URL: $url'); // Removed

  // Make the HTTP GET request using the provided client
  final response = await client.get(Uri.parse(url));
  // print('Received response with status code: ${response.statusCode}'); // Removed

  if (response.statusCode == 200) {
    // Parse the JSON data
    var data = jsonDecode(response.body);
    // print('Response JSON: $data'); // Removed
    WeatherData weatherData = WeatherData.fromJson(data);
    // print('Parsed WeatherData: $weatherData'); // Removed
    return weatherData;
  } else {
    // print('Failed to fetch weather data. Status code: ${response.statusCode}'); // Removed
    throw Exception('Failed to fetch weather data.');
  }
}

class WeatherData {
  final double latitude;
  final double longitude;
  final double elevation;
  final String timezone;
  final List<String> times;
  final List<double> temperatures;

  WeatherData({
    required this.latitude,
    required this.longitude,
    required this.elevation,
    required this.timezone,
    required this.times,
    required this.temperatures,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    // print('Parsing WeatherData from JSON.'); // Removed
    return WeatherData(
      latitude: json['latitude'],
      longitude: json['longitude'], // Fixed from 'elevation'
      elevation: json['elevation'],
      timezone: json['timezone'],
      times: List<String>.from(json['hourly']['time']),
      temperatures: List<double>.from(
          json['hourly']['temperature_2m'].map((temp) => temp.toDouble())),
    );
  }

  @override
  String toString() {
    return 'WeatherData(latitude: $latitude, longitude: $longitude, elevation: $elevation, timezone: $timezone, times: ${times.length} items, temperatures: ${temperatures.length} items)';
  }
}
