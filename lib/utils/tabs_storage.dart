import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TabsStorage {
  static const String _tabsKey = 'saved_tabs';

  static String iconToString(IconData icon) {
    return '${icon.fontFamily},${icon.codePoint}';
  }

  static IconData stringToIcon(String iconString) {
    final parts = iconString.split(',');
    return IconData(int.parse(parts[1]), fontFamily: parts[0]);
  }

  Future<void> makeDefaultTabs() async {
    final defaultTabs = [
      {
        'tab_icon': iconToString(Icons.edit_document),
        'tab_name': 'Docs',
        'tab_summary': 'Create and edit text documents',
        'link': 'https://docs.google.com',
      },
      {
        'tab_icon': iconToString(Icons.image_outlined),
        'tab_name': 'Photos',
        'tab_summary': 'View and edit photos',
        'link': 'https://photos.google.com',
      },
      {
        'tab_icon': iconToString(Icons.g_mobiledata),
        'tab_name': 'Lens',
        'tab_summary': 'Search by image',
        'link': 'https://lens.google.com',
      },
      {
        'tab_icon': iconToString(Icons.play_arrow_sharp),
        'tab_name': 'Youtube',
        'tab_summary': 'Watch and share videos',
        'link': 'https://www.youtube.com',
      },
      {
        'tab_icon': iconToString(Icons.music_note),
        'tab_name': 'Play Music',
        'tab_summary': 'Listen to music',
        'link': 'https://play.google.com',
      },
      {
        'tab_icon': iconToString(Icons.calendar_month),
        'tab_name': 'Google Calendar',
        'tab_summary': 'Organize your schedule',
        'link': 'https://calendar.google.com',
      },
      {
        'tab_icon': iconToString(Icons.pin_drop_outlined),
        'tab_name': 'Google Maps',
        'tab_summary': 'Find local businesses, view maps, and get directions',
        'link': 'https://maps.google.com',
      },
      {
        'tab_icon': iconToString(Icons.payment_outlined),
        'tab_name': 'Google pay',
        'tab_summary': 'Make payments and send money',
        'link': 'https://pay.google.com',
      },
    ];
    await _saveTabs(defaultTabs);
  }

  Future<void> addTab(Map<String, dynamic> tab) async {
    final tabs = await getTabs();
    tabs.add(tab);
    await _saveTabs(tabs);
  }

  Future<void> editTab(int index, Map<String, dynamic> updatedTab) async {
    final tabs = await getTabs();
    if (index >= 0 && index < tabs.length) {
      tabs[index] = updatedTab;
      await _saveTabs(tabs);
    }
  }

  Future<void> deleteTab(int index) async {
    final tabs = await getTabs();
    if (index >= 0 && index < tabs.length) {
      tabs.removeAt(index);
      await _saveTabs(tabs);
    }
  }

  Future<List<Map<String, dynamic>>> getTabs() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey(_tabsKey)) {
      await makeDefaultTabs();
    }
    final tabsJson = prefs.getString(_tabsKey);
    if (tabsJson != null) {
      final List<dynamic> decoded = jsonDecode(tabsJson);
      return decoded.cast<Map<String, dynamic>>();
    }
    return [];
  }

  Future<void> _saveTabs(List<Map<String, dynamic>> tabs) async {
    final prefs = await SharedPreferences.getInstance();
    final tabsJson = jsonEncode(tabs);
    await prefs.setString(_tabsKey, tabsJson);
  }
}
