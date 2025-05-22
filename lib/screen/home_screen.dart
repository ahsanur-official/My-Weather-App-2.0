import 'package:myapp/widgets/weather_card.dart';
import 'package:flutter/material.dart';
import 'package:myapp/models/weather_model.dart';
import 'package:myapp/services/weather_services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final WeatherServices _weatherServices = WeatherServices();
  final TextEditingController _controller = TextEditingController();
  bool _isLoading = false;
  Weather? _weather;

  void _getWeather() async {
    FocusScope.of(context).unfocus(); // Hide keyboard
    setState(() => _isLoading = true);

    try {
      final weather = await _weatherServices.featchWeather(_controller.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Error fetching weather data')),
      );
    }
  }

  LinearGradient _buildGradient() {
    final desc = _weather?.description.toLowerCase() ?? '';
    if (desc.contains('rain')) {
      return const LinearGradient(
        colors: [Colors.blueGrey, Color(0xFF616161)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('clear')) {
      return const LinearGradient(
        colors: [Color(0xFF48C6EF), Color(0xFF6F86D6)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF89F7FE), Color(0xFF66A6FF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: BoxDecoration(gradient: _buildGradient()),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Column(
              children: [
                const Text(
                  '🌦 Weather App',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 30),
                TextField(
                  controller: _controller,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Enter city name",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.2),
                    prefixIcon: const Icon(
                      Icons.location_city,
                      color: Colors.white,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _getWeather,
                  icon: const Icon(Icons.search),
                  label: const Text(
                    'Get Weather',
                    style: TextStyle(fontSize: 18),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.white),
                if (_weather != null) ...[
                  const SizedBox(height: 30),
                  WeatherCard(weather: _weather!),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
