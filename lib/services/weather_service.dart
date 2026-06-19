// import 'dart:convert';
import 'package:dio/dio.dart';
class WeatherService {
  final Dio _dio = Dio();
  final String apiKey = "8ffd87edb12fbd42dae87d563861ebb1";
  final String baseUrl = "https://api.openweathermap.org/data/2.5/weather";

  Future<Map<String, dynamic>> getWeather(String city) async{
    try{
      final response = await _dio.get(
        baseUrl,
        queryParameters: {
          "q":city,
          "appid": apiKey,
          "units": "metric"
        }
      );
      print("Data: ${response.data}");
      return response.data;
    } catch(e){
      print("Error: $e");
      throw Exception("Failed to fetch weather");
    }
  }
}