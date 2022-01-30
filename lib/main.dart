import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'package:aurion/src/login.dart';
import 'package:aurion/utils/common.dart';

void main() => initializeDateFormatting().then((_) => runApp(MyApp()));

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);

        if (!currentFocus.hasPrimaryFocus) {
          FocusManager.instance.primaryFocus!.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: Palette.darkGray,
          accentColor: Palette.white,
          fontFamily: 'OpenSans',
          textTheme: TextTheme(
            headline1: TextStyle(
              color: Palette.white,
              fontSize: 30.0,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
            ),
            headline6: TextStyle(
              color: Palette.white,
              fontSize: 16.0,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
            ),
            bodyText1: TextStyle(
              color: Palette.white,
              fontSize: 16.0,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        home: LoginScreen(),
      ),
    );
  }
}
