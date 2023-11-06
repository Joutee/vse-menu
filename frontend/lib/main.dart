import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() async {
  Map<String, dynamic> jsonData = await fetchData();
  print(jsonData['jizniMesto'][1]['meals'][0]);

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
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primaryColor: Colors.red,
      ),
      home: HomePage(data: data),
    );
  }
}

Future<Map<String, dynamic>> fetchData() async {
  final response =
      await http.get(Uri.parse('http://10.0.2.2:3050/api/scrapedData'));

  if (response.statusCode == 200) {
    final Map<String, dynamic> jsonData = json.decode(response.body);
    print(jsonData);
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
  SwipeableWidget({required this.data});
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
                title: const Center(child: Text('Volha')), // Dynamic title
              ),
              for (int index = 0; index < VODaysList.length; index++)
                Container(
                  child: Column(
                    children: [
                      Text(VODaysList[index]['day']),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: VODaysList[index]['meals'].length,
                        itemBuilder: (BuildContext context, int mealIndex) {
                          return ListTile(
                              title:
                                  Text(VODaysList[index]['meals'][mealIndex]));
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
                child: Text('Jižní Město AV Gastro'), // Dynamic title
              )),
              for (int index = 0; index < JMDaysList.length; index++)
                Container(
                  margin: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      Text(JMDaysList[index]['day']),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: JMDaysList[index]['meals'].length,
                        itemBuilder: (BuildContext context, int mealIndex) {
                          return ListTile(
                              title:
                                  Text(JMDaysList[index]['meals'][mealIndex]));
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
                title: const Center(child: Text('Žižkov menza AV Gastro')),
                // Dynamic title
              ),
              for (int index = 0; index < ZIDaysList.length; index++)
                Container(
                  child: Column(
                    children: [
                      Text(ZIDaysList[index]['day']),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: ZIDaysList[index]['meals'].length,
                        itemBuilder: (BuildContext context, int mealIndex) {
                          return ListTile(
                              title:
                                  Text(ZIDaysList[index]['meals'][mealIndex]));
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
