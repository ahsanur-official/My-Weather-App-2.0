import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:intl/intl.dart';

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
    return DateFormat.jm().format(dateTime);
  }

  Widget _infoItem(String label, String value, IconData icon) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 160), // a bit wider
      child: Container(
        padding: const EdgeInsets.all(18), // a bit more padding
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.18),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          children: [
            Icon(icon,
                color: Colors.white70,
                size: 36,
                semanticLabel: label), // bigger icon
            const SizedBox(height: 12), // more space
            Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 18)), // bigger label text
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 22, // bigger value text
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
              height: 180, // increased from 160 to 180
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.error,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 20), // increased space
            Text(
              weather.city ?? 'Unknown City',
              style: GoogleFonts.roboto(
                fontSize: 40, // increased from 36
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.2,
              ),
            ),
            const SizedBox(height: 14), // increased from 10
            Text(
              weather.description ?? 'No description',
              style: const TextStyle(
                fontSize: 26, // increased from 24
                color: Colors.white70,
                fontStyle: FontStyle.italic,
              ),
            ),
            const SizedBox(height: 24), // increased from 20
            Text(
              '${weather.temperature.toStringAsFixed(1)} °C',
              style: const TextStyle(
                fontSize: 72, // increased from 64
                color: Colors.white,
                fontWeight: FontWeight.w300,
              ),
            ),
            const SizedBox(height: 48), // increased from 40
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
