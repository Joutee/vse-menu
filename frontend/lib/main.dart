import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

Color darkgrey = const Color.fromARGB(169, 99, 99, 99);
MaterialColor myCustomMaterialColor = MaterialColor(darkgrey.value, {
  50: darkgrey.withOpacity(0.1),
  100: darkgrey.withOpacity(0.2),
  200: darkgrey.withOpacity(0.3),
  300: darkgrey.withOpacity(0.4),
  400: darkgrey.withOpacity(0.5),
  500: darkgrey.withOpacity(0.6), // The primary color
  600: darkgrey.withOpacity(0.7),
  700: darkgrey.withOpacity(0.8),
  800: darkgrey.withOpacity(0.9),
  900: darkgrey.withOpacity(1.0),
});

void main() async {
  Map<String, dynamic> jsonData = await fetchData();
  //print(jsonData['jizniMesto'][1]['meals'][0]);

  runApp(MyApp(data: jsonData));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.data});
  final Map<String, dynamic> data;
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: myCustomMaterialColor,
        ),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        scaffoldBackgroundColor: const Color.fromARGB(255, 59, 59, 59),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 163, 7, 7),
        ),
        textTheme: const TextTheme(
          bodyLarge:
              TextStyle(fontFamily: '', fontSize: 18, color: Colors.white),
          bodyMedium: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 25,
              color: Colors.white,
              fontWeight: FontWeight.bold),
          displayLarge: TextStyle(color: Colors.white),
          displayMedium: TextStyle(color: Colors.white),
          displaySmall: TextStyle(color: Colors.white),
          titleLarge: TextStyle(color: Colors.white),
        ),
      ),
      home: HomePage(data: data),
    );
  }
}

Future<Map<String, dynamic>> fetchData() async {
  final response = await http
      .get(Uri.parse('https://vse-menu-api.onrender.com/api/scrapedData'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    return jsonData; //FetchedData.fromJson(jsonData);
  } else {
    throw Exception('Failed to load data');
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.data});
  final Map<String, dynamic> data;

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SwipeableWidget(data: data));
  }
}

class SwipeableWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  const SwipeableWidget({required this.data});
  @override
  _SwipeableWidgetState createState() => _SwipeableWidgetState();
}

class _SwipeableWidgetState extends State<SwipeableWidget> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final VODaysList = widget.data['volha'];
    final JMDaysList = widget.data['jizniMesto'];
    final ZIDaysList = widget.data['zizkov'];
    return Container(
        //color: const Color.fromARGB(255, 70, 70, 70),
        child: PageView(
      controller: _pageController,
      children: <Widget>[
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppBar(
                title: const Center(
                    child: Text('Volha',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold))), // Dynamic title
              ),
              for (int index = 0; index < VODaysList.length; index++)
                Container(
                  //padding: EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16.0)),
                  //decoration: BoxDecoration(color: Colors.red),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 163, 7, 7),
                            borderRadius: BorderRadius.circular(16.0)),
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text(VODaysList[index]['day'])),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: VODaysList[index]['meals'].length,
                        itemBuilder: (BuildContext context, int mealIndex) {
                          return ListTile(
                            title: Text(VODaysList[index]['meals'][mealIndex],
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 255, 255, 255))),
                          );
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppBar(
                  title: const Center(
                child: Text('Jižní Město AV Gastro',
                    style: TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontWeight: FontWeight.bold)), // Dynamic title
              )),
              for (int index = 0; index < JMDaysList.length; index++)
                Container(
                  //padding: EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 163, 7, 7),
                            borderRadius: BorderRadius.circular(16.0)),
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text(JMDaysList[index]['day'])),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: JMDaysList[index]['meals'].length,
                        itemBuilder: (BuildContext context, int mealIndex) {
                          return ListTile(
                              title: Text(JMDaysList[index]['meals'][mealIndex],
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255))));
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
        SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppBar(
                title: const Center(
                    child: Text('Žižkov menza AV Gastro',
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontWeight: FontWeight.bold))),
                // Dynamic title
              ),
              for (int index = 0; index < ZIDaysList.length; index++)
                Container(
                  //padding: EdgeInsets.all(16.0),
                  margin: const EdgeInsets.only(
                      left: 8.0, right: 8.0, top: 20.0, bottom: 20.0),
                  decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primary,
                      borderRadius: BorderRadius.circular(16.0)),
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 163, 7, 7),
                            borderRadius: BorderRadius.circular(16.0)),
                        width: double.infinity,
                        padding: const EdgeInsets.all(16.0),
                        child: Center(child: Text(ZIDaysList[index]['day'])),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: ZIDaysList[index]['meals'].length,
                        itemBuilder: (BuildContext context, int mealIndex) {
                          return ListTile(
                              title: Text(ZIDaysList[index]['meals'][mealIndex],
                                  style: const TextStyle(
                                      color:
                                          Color.fromARGB(255, 255, 255, 255))));
                        },
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ],
    ));
  }
}
