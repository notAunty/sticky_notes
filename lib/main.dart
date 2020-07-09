import 'package:flutter/material.dart';

import 'home_page.dart';
import 'data.dart';

Data d = Data.getInstance();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await d.init();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sticky Notes',
      theme: ThemeData(
        primaryTextTheme: TextTheme(headline6: TextStyle(color: Colors.black)),

        bottomSheetTheme: BottomSheetThemeData(backgroundColor: Colors.white),
      ),
      home: HomePage(),

      debugShowCheckedModeBanner: false,
    );
  }
}
