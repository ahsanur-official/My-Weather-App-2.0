import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
        const SnackBar(content: Text('Error fetching weather data')),
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
                  label: const Text('Get Weather', style: TextStyle(fontSize: 18)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.indigo,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                ),
                const SizedBox(height: 30),
                if (_isLoading)
                  const CircularProgressIndicator(color: Colors.white),
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
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Widget _infoItem(String label, String value, IconData icon) {
    return Container(
      width: 130,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white70, size: 28),
          const SizedBox(height: 8),
          Text(label,
              style: const TextStyle(color: Colors.white70, fontSize: 14)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white.withOpacity(0.25),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Lottie.asset(lottieAsset, height: 120),
            const SizedBox(height: 10),
            Text(
              weather.city ?? 'Unknown City',
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              weather.description,
              style: const TextStyle(
                fontSize: 22,
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '${weather.temperature.toStringAsFixed(1)} °C',
              style: const TextStyle(
                fontSize: 60,
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 30),
            Wrap(
              spacing: 16,
              runSpacing: 16,
              alignment: WrapAlignment.center,
              children: [
                _infoItem('Humidity', '${weather.humidity}%', Icons.water_drop),
                _infoItem('Wind', '${weather.windSpeed} m/s', Icons.air),
                _infoItem('Pressure', '${weather.pressure} hPa', Icons.speed),
                _infoItem('Visibility', '${weather.visibility} m', Icons.remove_red_eye),
                _infoItem('Sunrise', _formatTime(weather.sunrise), Icons.wb_twilight),
                _infoItem('Sunset', _formatTime(weather.sunset), Icons.nightlight_round),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
