import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: WeatherApp(),
    );
  }
}

class WeatherApp extends StatefulWidget {
  @override
  _WeatherAppState createState() => _WeatherAppState();
}

class Todo {
  String city;
  String weather;
  double temperature;

  Todo(this.city, this.weather, this.temperature);
}

class _WeatherAppState extends State<WeatherApp> {
  final String apiKey = 'be5f7ac5e6e09779dd7d8baca677fee5';
  final cityController = TextEditingController();
  String city = '';
  String weather = '';
  double temperature = 0.0;

  void fetchWeatherData() async {
    final cityName = cityController.text;
    final url = Uri.parse('https://api.openweathermap.org/data/2.5/weather?q=$cityName&appid=$apiKey');

    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      setState(() {
        city = jsonData['name'];
        weather = jsonData['weather'][0]['description'];
        temperature = jsonData['main']['temp'] - 273.15; // Convert temperature from Kelvin to Celsius
      });
      await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => SecondScreen(
            city: city,
            weather: weather,
            temperature: temperature,
          ),
        ),
      );
    } else {
      setState(() {
        city = 'City not found';
        weather = '';
        temperature = 0.0;
      });
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Thời tiết'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: cityController,
              decoration: InputDecoration(
                labelText: 'Nhập khu vực mong muốn',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: fetchWeatherData,
              child: Text('Tìm kiếm'),
            ),
          ],
        ),
      ),
    );
  }
}

class SecondScreen extends StatelessWidget {
  final String city;
  final String weather;
  final double temperature;

  SecondScreen({required this.city, required this.weather, required this.temperature});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Second Screen"),
      ),
      body: Center(
        child: Container(
          child: Column(
            children: [
              Text(
                'Thành phố: $city',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 8),
              Text(
                'Thời tiết: $weather',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 8),
              Text(
                'Nhiệt độ: ${temperature.toStringAsFixed(1)} °C',
                style: TextStyle(fontSize: 24),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Go back!'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

