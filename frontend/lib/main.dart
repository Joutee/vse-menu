import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

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
  //Map<String, dynamic> jsonData = await fetchData();
  //print(jsonData['jizniMesto'][1]['meals'][0]);

  runApp(const MyApp(/*data: jsonData*/));
}

class MyApp extends StatelessWidget {
  const MyApp({
    super.key,
    /*required this.data*/
  });
  //final Map<String, dynamic> data;
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
      home: FutureBuilder<Map<String, dynamic>>(
        future: fetchData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          } else if (snapshot.hasError) {
            // Handle errors
            return Scaffold(
              appBar: AppBar(
                title: const Text('Error'),
              ),
              body: Center(
                child: Text('Failed to load data: ${snapshot.error}'),
              ),
            );
          } else {
            // Data has been fetched, display your HomePage
            return HomePage(data: snapshot.data ?? {});
          }
        },
      ),
    );
  }
}

void _launchPrivacyPolicyURL() async {
  final url = Uri.parse('https://vseprivacypolicy6.webnode.cz/');
  if (!await launchUrl(url)) {
    throw 'Could not launch $url';
  }
}

Future<Map<String, dynamic>> fetchData() async {
  final response = await http
      .get(Uri.parse('https://vse-menu-apii.onrender.com/api/scrapedData'));

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
    return Scaffold(
      body: SwipeableWidget(data: data),
      bottomSheet: Container(
        color: const Color.fromARGB(255, 163, 7, 7),
        padding: const EdgeInsets.all(4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () {
                _launchPrivacyPolicyURL(); // Open privacy policy URL
              },
              child: const Text(
                'Privacy Policy',
                style: TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SwipeableWidget extends StatefulWidget {
  final Map<String, dynamic> data;
  const SwipeableWidget({super.key, required this.data});
  @override
  _SwipeableWidgetState createState() => _SwipeableWidgetState();
}

class _SwipeableWidgetState extends State<SwipeableWidget> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    final voDaysList = widget.data['volha'];
    final jmDaysList = widget.data['jizniMesto'];
    final ziDaysList = widget.data['zizkov'];
    return PageView(
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
              for (int index = 0; index < voDaysList.length; index++)
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
                        child: Center(child: Text(voDaysList[index]['day'])),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: voDaysList[index]['meals'].length,
                        itemBuilder: (BuildContext context, int mealIndex) {
                          return ListTile(
                            title: Text(voDaysList[index]['meals'][mealIndex],
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
              for (int index = 0; index < jmDaysList.length; index++)
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
                        child: Center(child: Text(jmDaysList[index]['day'])),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: jmDaysList[index]['meals'].length,
                        itemBuilder: (BuildContext context, int mealIndex) {
                          return ListTile(
                              title: Text(jmDaysList[index]['meals'][mealIndex],
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
              for (int index = 0; index < ziDaysList.length; index++)
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
                        child: Center(child: Text(ziDaysList[index]['day'])),
                      ),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const ClampingScrollPhysics(),
                        itemCount: ziDaysList[index]['meals'].length,
                        itemBuilder: (BuildContext context, int mealIndex) {
                          return ListTile(
                              title: Text(ziDaysList[index]['meals'][mealIndex],
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
    );
  }
}
