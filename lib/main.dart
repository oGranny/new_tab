import 'package:flutter/material.dart';
import 'package:flutter_iconpicker/Models/configuration.dart';
import 'package:flutter_iconpicker/Models/icon_picker_icon.dart';
import 'package:flutter_iconpicker/flutter_iconpicker.dart';
import 'package:new_tab_app/utils/get_temp.dart';
import 'package:new_tab_app/utils/google_search_url.dart';
import 'package:new_tab_app/utils/tabs_storage.dart';
import 'package:new_tab_app/widgets/search_bar.dart';
import 'package:new_tab_app/widgets/chatbot_popup.dart';
import 'package:new_tab_app/widgets/content_tile.dart';
import 'package:new_tab_app/widgets/notes/notes_popup.dart';
import 'package:new_tab_app/widgets/settings_popup.dart';
import 'package:new_tab_app/widgets/timer_popup.dart';
import 'package:new_tab_app/widgets/top_weather.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.black,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool showTodo = false;
  bool showTimer = false;
  bool showGemini = false;
  bool showSettings = false;
  String temperature = '-';
  String humidity = '-';
  String location = '-';
  TabsStorage tabsStorage = TabsStorage();
  List<Map<String, dynamic>> tabs = [];
  int gridLen = 0;

  @override
  void initState() {
    super.initState();
    _fetchTemperatureData();
    _loadTabs();
  }

  void _loadTabs() async {
    tabs = await tabsStorage.getTabs();
    print(tabs);
    setState(() {
      gridLen = tabs.length; // +1 for the add button
    });
  }

  Future<void> _fetchTemperatureData() async {
    Map<String, dynamic> data = await getTemp();
    setState(() {
      temperature = (data['current']['temp_c'] ~/ 1).toString();
      humidity = data['current']['humidity'].toString();
      location = data['location']['name'].toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
        backgroundColor: Colors.black,
        actions: [
          IconButton(
            icon: const Icon(Icons.code_outlined),
            onPressed: () {
              setState(() {
                showGemini = !showGemini;
              });
            },
          ),
          IconButton(
            tooltip: 'Todo',
            icon: const Icon(Icons.article_outlined),
            onPressed: () {
              setState(() {
                showTodo = !showTodo;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.timer_outlined),
            onPressed: () {
              setState(() {
                showTimer = !showTimer;
              });
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            onPressed: () {
              setState(() {
                showSettings = !showSettings;
              });
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(160.0, 00, 160, 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TopBox(
                          title: 'Temperature',
                          content: temperature != '-' ? '$temperature°C' : '-',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TopBox(
                          title: 'Humidity',
                          content: humidity != '-' ? '$humidity%' : '-',
                        ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: TopBox(
                          title: 'Location',
                          content: location,
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                SearchBarSection(),
                SizedBox(height: 30),
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 6,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    children: List.generate(gridLen, (index) {
                      return GestureDetector(
                        onTap: () {
                          launchLink(tabs[index]['link']);
                        },
                        onDoubleTap: () async {
                          await tabsStorage.deleteTab(index).then((_) {
                            tabs.removeAt(index);
                            setState(() {});
                          });
                          // setState(() {});
                        },
                        child: ContentTile(
                          description: tabs[index]['tab_summary'],
                          icon:
                              TabsStorage.stringToIcon(tabs[index]['tab_icon']),
                          index: index,
                          title: tabs[index]['tab_name'],
                        ),
                      );
                    })
                      ..add(
                        GestureDetector(
                          onTap: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                final TextEditingController titleController =
                                    TextEditingController();
                                final TextEditingController urlController =
                                    TextEditingController();
                                final TextEditingController
                                    descriptionController =
                                    TextEditingController();
                                IconData selectedIcon = Icons.link;

                                return AlertDialog(
                                  title: const Text('Add New Tab'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          controller: titleController,
                                          decoration: const InputDecoration(
                                              labelText: 'Title'),
                                        ),
                                        TextField(
                                          controller: urlController,
                                          decoration: const InputDecoration(
                                              labelText: 'URL'),
                                        ),
                                        TextField(
                                          controller: descriptionController,
                                          decoration: const InputDecoration(
                                              labelText: 'Description'),
                                        ),
                                        IconButton(
                                            icon: Icon(selectedIcon),
                                            onPressed: () async {
                                              Icon? _icon;
                                              IconPickerIcon? icon =
                                                  await showIconPicker(
                                                context,
                                                configuration:
                                                    SinglePickerConfiguration(
                                                  iconPackModes: [
                                                    IconPack.cupertino
                                                  ],
                                                ),
                                              );

                                              _icon = Icon(icon?.data);
                                              setState(() {});

                                              debugPrint('Picked Icon:  $icon');
                                            }
                                            // if (icon != null) {
                                            //   setState(() {
                                            //     selectedIcon = icon.data;
                                            //   });
                                            // }
                                            // },
                                            ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Cancel'),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        if (titleController.text.isNotEmpty &&
                                            urlController.text.isNotEmpty &&
                                            descriptionController
                                                .text.isNotEmpty) {
                                          Map<String, dynamic> newTab = {
                                            'tab_name': titleController.text,
                                            'link': urlController.text,
                                            'tab_summary':
                                                descriptionController.text,
                                            'tab_icon':
                                                TabsStorage.iconToString(
                                                    selectedIcon),
                                          };
                                          await tabsStorage.addTab(newTab);
                                          tabs.add(newTab);
                                          setState(() {
                                            gridLen = tabs.length;
                                          });
                                          Navigator.of(context).pop();
                                        }
                                      },
                                      child: const Text('Save'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              color: const Color(0xFF191515).withOpacity(.7),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: Center(
                              child: Icon(
                                Icons.add,
                                size: 50,
                                color: Colors.white.withOpacity(.2),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ),
                ),
              ],
            ),
          ),
          if (showTodo)
            DraggableNotesWindow(onClose: () {
              setState(
                () {
                  showTodo = false;
                },
              );
            }),
          if (showTimer)
            PomodoroTimerWindow(onClose: () {
              setState(
                () {
                  showTimer = false;
                },
              );
            }),
          if (showGemini)
            AIChatPopup(onClose: () {
              setState(
                () {
                  showGemini = false;
                },
              );
            }),
          if (showSettings)
            SettingsPopup(onClose: () {
              setState(
                () {
                  showSettings = false;
                },
              );
            }),
        ],
      ),
    );
  }
}
