import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

Future<Map<String, dynamic>> getTemp() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String city = prefs.getString('city') ?? 'auto:ip';
  String? weatherApiKey = prefs.getString('weatherApiKey');
  String url =
      'https://api.weatherapi.com/v1/current.json?key=$weatherApiKey&q=$city';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    print('Failed to load data, $response, ${response.statusCode}');
    return {
      'temperature': '-',
      'humidity': '-',
      'location': '-',
    };
  }
}
