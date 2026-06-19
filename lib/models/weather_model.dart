class WeatherModel {
  final String cityName;
  final double temperature;
  final String description;

  WeatherModel({
    required this.cityName,
    required this.temperature,
    required this.description,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> json){
    return WeatherModel(
      cityName: json["name"],
      temperature: json["main"]["temp"].toDouble(),
      description: json["weather"][0]["description"],);
  }
}