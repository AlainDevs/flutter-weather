import 'package:flutter/material.dart';
import 'package:weather/weather.dart'; // Added import
import 'package:weather/temperature_line_chart.dart'; // Updated import

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather Demo',
      theme: ThemeData(
        // Updated color scheme for a more vibrant look
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Weather Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final TextEditingController _locationController = TextEditingController();
  WeatherData? _weatherData;

  void _fetchWeather() async {
    String location = _locationController.text;
    try {
      final data = await fetchWeatherData(location: location);
      if (!mounted) return; // Added mounted check
      setState(() {
        _weatherData = data;
      });
    } catch (e) {
      if (!mounted) return; // Added mounted check
      setState(() {
        _weatherData = null;
      });
      // Display an error message to the user
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Updated AppBar with gradient
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.teal, Colors.cyan],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Text(
          widget.title,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _locationController,
                        decoration: const InputDecoration(
                          labelText: 'Enter location',
                          prefixIcon: Icon(Icons.location_on),
                          border: OutlineInputBorder(),
                        ),
                        onSubmitted: (_) => _fetchWeather(),
                      ),
                    ),
                    const SizedBox(width: 10), // Added const
                    ElevatedButton(
                      onPressed: _fetchWeather,
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(12),
                      ),
                      child: const Icon(Icons.search), // Added const
                    ), // Moved 'child' to the last position
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20), // Added const
            _weatherData == null
                ? const Text(
                    'No data',
                    style: TextStyle(fontSize: 18),
                  )
                : Expanded(
                    child: Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: LineChartSample2(
                          temperatures: _weatherData!.temperatures,
                          times: _weatherData!.times,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
