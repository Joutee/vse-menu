import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SwipeableWidget());
  }
}

class SwipeableWidget extends StatefulWidget {
  @override
  _SwipeableWidgetState createState() => _SwipeableWidgetState();
}

class _SwipeableWidgetState extends State<SwipeableWidget> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return PageView(
      controller: _pageController,
      children: <Widget>[
        Container(
          color: Colors.blue,
          child: Center(
            child: Text("Page 1"),
          ),
        ),
        Container(
          color: Colors.green,
          child: Center(
            child: Text("Page 2"),
          ),
        ),
        Container(
          color: Colors.red,
          child: Center(
            child: Text("Page 3"),
          ),
        ),
      ],
    );
  }
}
