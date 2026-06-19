//   import 'package:flutter/material.dart';
//     final WeatherService _weatherService = WeatherService();

//   void loadWeather() async {
//     try {
//       final data = await _weatherService.getWeather("biratnagar");
//       setState(() {
//         weather = WeatherModel.fromJson(data);
//         isLoadingWeather = false;
//       });
//     } catch (e) {
//       setState(() {
//         isLoadingWeather = false;
//       });
//     }
//   }


// Widget buildWeatherCard() {
//     if (isLoadingWeather) {
//       return CircularProgressIndicator();
//     }
//     if (weather == null) {
//       return Text("Failed to load weather");
//     }
//     return Container(
//       width: double.infinity,
//       padding: EdgeInsets.all(20),
//       margin: EdgeInsets.only(top: 10),
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: [Colors.blue, const Color.fromARGB(255, 114, 188, 223)],
//         ),
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             "${weather!.cityName} Weather",
//             style: TextStyle(
//               fontSize: 18,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           SizedBox(height: 10),
//           Text(
//             "${weather!.temperature}°C",
//             style: TextStyle(
//               fontSize: 36,
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//           Text(
//             weather!.description,
//             style: TextStyle(fontSize: 16, color: Colors.white70),
//           ),
//         ],
//       ),
//     );
//   }