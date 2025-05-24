import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

// Weather Model
class Weather {
  final String? city;
  final String? description;
  final double temperature;
  final int humidity;
  final double windSpeed;
  final int pressure;
  final int visibility;
  final DateTime? sunrise;
  final DateTime? sunset;

  Weather({
    this.city,
    this.description,
    required this.temperature,
    required this.humidity,
    required this.windSpeed,
    required this.pressure,
    required this.visibility,
    this.sunrise,
    this.sunset,
  });

  // Parse JSON from OpenWeatherMap API
  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      city: json['name'],
      description: (json['weather'] != null && json['weather'].isNotEmpty)
          ? json['weather'][0]['description']
          : 'No description',
      temperature: (json['main']['temp'] as num).toDouble(),
      humidity: json['main']['humidity'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      pressure: json['main']['pressure'],
      visibility: json['visibility'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunrise'] * 1000, isUtc: true).toLocal(),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000, isUtc: true).toLocal(),
    );
  }
}

// Weather service to fetch data
class WeatherServices {
  static const String _apiKey = '1695da0ffb036e82360dda8d7f0deb9c';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5/weather';

  Future<Weather> fetchWeather(String city) async {
    final url = Uri.parse('$_baseUrl?q=$city&appid=$_apiKey&units=metric');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return Weather.fromJson(jsonData);
    } else {
      throw Exception('Failed to load weather');
    }
  }
}

// WeatherCard Widget
class WeatherCard extends StatelessWidget {
  final Weather weather;
  final String lottieAsset;

  const WeatherCard({
    super.key,
    required this.weather,
    required this.lottieAsset,
  });

  String _formatTime(DateTime? dateTime) {
    if (dateTime == null) return '--:--';
    return DateFormat.jm().format(dateTime);
  }

  Widget _infoItem(String label, String value, IconData icon) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 150),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white70, size: 32),
            const SizedBox(height: 10),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 16)),
            const SizedBox(height: 6),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      color: Colors.white.withOpacity(0.28),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Lottie.asset(
              lottieAsset,
              height: 160,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error, size: 64, color: Colors.white),
            ),
            const SizedBox(height: 16),
            Text(
              weather.city ?? 'Unknown City',
              style: const TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              weather.description ?? 'No description',
              style: const TextStyle(
                fontSize: 24,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '${weather.temperature.toStringAsFixed(1)} °C',
              style: const TextStyle(
                fontSize: 64,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 20,
              runSpacing: 20,
              alignment: WrapAlignment.center,
              children: [
                _infoItem('Humidity', '${weather.humidity}%', Icons.water_drop),
                _infoItem('Wind', '${weather.windSpeed} m/s', Icons.air),
                _infoItem('Pressure', '${weather.pressure} hPa', Icons.speed),
                _infoItem('Visibility', '${weather.visibility} m',
                    Icons.remove_red_eye),
                _infoItem(
                    'Sunrise', _formatTime(weather.sunrise), Icons.wb_twilight),
                _infoItem('Sunset', _formatTime(weather.sunset),
                    Icons.nightlight_round),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Main HomeScreen widget
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

  String _getLottieAsset(String? description) {
    final desc = (description ?? '').toLowerCase();
    if (desc.contains('rain')) {
      return 'assets/rain.json';
    } else if (desc.contains('clear')) {
      return 'assets/sunny.json';
    } else if (desc.contains('cloud')) {
      return 'assets/cloudy.json';
    } else if (desc.contains('snow')) {
      return 'assets/snow.json';
    }
    return 'assets/loading.json';
  }

  void _getWeather() async {
    FocusScope.of(context).unfocus();
    if (_controller.text.isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final weather = await _weatherServices.fetchWeather(_controller.text);
      setState(() {
        _weather = weather;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error fetching weather data: $e')),
      );
    }
  }

  LinearGradient _buildGradient() {
    final desc = (_weather?.description ?? '').toLowerCase();
    if (desc.contains('rain')) {
      return const LinearGradient(
        colors: [Colors.blueGrey, Color(0xFF616161)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('clear')) {
      return const LinearGradient(
        colors: [Color(0xFF077397), Color(0xFF6F86D6)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else if (desc.contains('cloud')) {
      return const LinearGradient(
        colors: [Colors.grey, Colors.blueGrey],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      );
    } else {
      return const LinearGradient(
        colors: [Color(0xFF0F565B), Color(0xFF104A9C)],
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
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  '🌦 Weather App 2.0',
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
                  onSubmitted: (_) => _getWeather(),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _getWeather,
                  icon: const Icon(Icons.search),
                  label:
                      const Text('Get Weather', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_isLoading) const CircularProgressIndicator(color: Colors.white),
                if (_weather != null && !_isLoading)
                  WeatherCard(
                    weather: _weather!,
                    lottieAsset: _getLottieAsset(_weather?.description),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: HomeScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
