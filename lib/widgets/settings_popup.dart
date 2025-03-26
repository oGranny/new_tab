import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPopup extends StatefulWidget {
  final VoidCallback onClose;

  SettingsPopup({super.key, required this.onClose});

  @override
  State<SettingsPopup> createState() => _SettingsPopupState();
}

class _SettingsPopupState extends State<SettingsPopup> {
  final TextEditingController weatherApiKeyController = TextEditingController();
  final TextEditingController geminiApiKeyController = TextEditingController();
  final TextEditingController cityController = TextEditingController();

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((prefs) {
      weatherApiKeyController.text = prefs.getString('weatherApiKey') ?? '';
      geminiApiKeyController.text = prefs.getString('geminiApiKey') ?? '';
      cityController.text = prefs.getString('city') ?? '';
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      title: Text('Settings'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: cityController,
                  decoration: InputDecoration(
                    labelText: 'City Name',
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: weatherApiKeyController,
                  decoration: InputDecoration(
                    labelText: 'Weather API Key',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () => _launchURL('https://www.weatherapi.com/my/'),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: geminiApiKeyController,
                  decoration: InputDecoration(
                    labelText: 'Gemini API Key',
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () =>
                    _launchURL('https://aistudio.google.com/apikey'),
              ),
            ],
          ),
        ],
      ),
      actions: [
        TextButton(
          // onPressed: () => Navigator.of(context).pop(),
          onPressed: () {
            widget.onClose();
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (weatherApiKeyController.text.isNotEmpty) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                  'weatherApiKey', weatherApiKeyController.text);
            }
            if (geminiApiKeyController.text.isNotEmpty) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString(
                  'geminiApiKey', geminiApiKeyController.text);
            }
            if (cityController.text.isNotEmpty) {
              SharedPreferences prefs = await SharedPreferences.getInstance();
              await prefs.setString('city', cityController.text);
            }
            widget.onClose();
          },
          child: Text('Save'),
        ),
      ],
    );
  }

  void _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
