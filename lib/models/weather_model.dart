class Weather {
  final String cityName;
  final String country;
  final double temperature;
  final double feelsLike;
  final String description;
  final String iconCode;
  final int humidity;
  final int pressure;
  final double windSpeed;
  final int visibility;
  final DateTime sunrise;
  final DateTime sunset;

  Weather({
    required this.cityName,
    required this.country,
    required this.temperature,
    required this.feelsLike,
    required this.description,
    required this.iconCode,
    required this.humidity,
    required this.pressure,
    required this.windSpeed,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      country: json['sys']['country'],
      temperature: (json['main']['temp'] as num).toDouble(),
      feelsLike: (json['main']['feels_like'] as num).toDouble(),
      description: json['weather'][0]['description'],
      iconCode: json['weather'][0]['icon'],
      humidity: json['main']['humidity'],
      pressure: json['main']['pressure'],
      windSpeed: (json['wind']['speed'] as num).toDouble(),
      visibility: json['visibility'],
      sunrise: DateTime.fromMillisecondsSinceEpoch(
        json['sys']['sunrise'] * 1000,
      ),
      sunset: DateTime.fromMillisecondsSinceEpoch(json['sys']['sunset'] * 1000),
    );
  }

  /// Helper method to get full icon URL
  String get iconUrl => "https://openweathermap.org/img/wn/$iconCode@2x.png";

  /// Helper method to format time from DateTime
  String formatTime(DateTime time) {
    return "${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}";
  }
}
