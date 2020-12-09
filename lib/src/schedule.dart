import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutter_week_view/flutter_week_view.dart';

import 'common.dart';

class ScheduleScreen extends StatefulWidget {
  final List<dynamic> schedule;

  ScheduleScreen({Key key, @required this.schedule}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarWeekController _viewWeekController;
  int _selectedIndex = 0;
  final DateTime now = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    DateTime.now().day,
  );
  DateTime _selectedDateTime = DateTime.now();

  @override
  initState() {
    _viewWeekController = CalendarWeekController();
    super.initState();
  }

  Future<Null> suicide() async {
    showDialog(
      context: context,
      builder: (_) {
        return AlertDialog(
          backgroundColor: gray,
          content: Image.network(
            'https://cdn.discordapp.com/emojis/712065195270340649.png?v=1',
          ),
        );
      },
    );
  }

  Widget _buildViewWeek() {
    return CalendarWeek(
      height: 105,
      controller: _viewWeekController,
      backgroundColor: semiGray,
      showMonth: true,
      minDate: DateTime.now().subtract(Duration(days: 365)),
      maxDate: DateTime.now().add(Duration(days: 365)),
      dayOfWeek: <String>[
        'lun.',
        'mar.',
        'mer.',
        'jeu.',
        'ven.',
        'sam.',
        'dim.',
      ],
      month: <String>[
        'JANVIER',
        'FEVRIER',
        'MARS',
        'AVRIL',
        'MAI',
        'JUIN',
        'JUILLET',
        'AOUT',
        'SEPTEMBRE',
        'OCTOBRE',
        'NOVEMBRE',
        'DECEMBRE',
      ],
      decorations: [],
      weekendsStyle: TextStyle(color: amber),
      dateStyle: TextStyle(color: white),
      dayOfWeekStyle: TextStyle(color: white),
      monthStyle: TextStyle(color: white),
      pressedDateBackgroundColor: amber,
      pressedDateStyle: TextStyle(
        color: darkGray,
        fontWeight: FontWeight.bold,
      ),
      onDatePressed: (date) => setState(() {
        _selectedDateTime = date;
      }),
    );
  }

  Widget _buildViewDay(DateTime date) {
    DateTime reducedDate = DateTime(date.year, date.month, date.day);
    List<FlutterWeekViewEvent> events = [];
    for (Map<String, dynamic> event in widget.schedule) {
      List<dynamic> _date = event['start']
          .split('T')[0]
          .split('-')
          .map((val) => int.parse(val))
          .toList();
      if (reducedDate == DateTime(_date[0], _date[1], _date[2])) {
        List<dynamic> _start = event['start']
            .split('T')[1]
            .split('+')[0]
            .split(':')
            .map((val) => int.parse(val))
            .toList();
        List<dynamic> _end = event['end']
            .split('T')[1]
            .split('+')[0]
            .split(':')
            .map((val) => int.parse(val))
            .toList();
        String title = RegExp(r'^[^-]*-[^-]*-[^-]*-[^-]*- ([^-]*) ')
            .firstMatch(event['title'])
            .group(1);
        String description =
            RegExp(r'((?<= - )(?:(?! - ).)*?) - ((?<= - )(?:(?! - ).)*?)$')
                .firstMatch(event['title'])
                .groups([1, 2])
                .reversed
                .join(' - ');
        String detailedDescription =
            RegExp(r'((?:(?<= - )|^)(?:(?! - ).)*?)(?: - |$)')
                .allMatches(event['title'])
                .map((e) => e.group(1))
                .toList()
                .join('\n');
        bool isExam = event.containsKey('className') &&
            event['className'] == 'est-epreuve';
        events.add(
          FlutterWeekViewEvent(
            title: title,
            description: description,
            backgroundColor: !isExam ? semiAmber : semiRed,
            start: reducedDate.add(
              Duration(
                hours: _start[0],
                minutes: _start[1],
              ),
            ),
            end: reducedDate.add(
              Duration(
                hours: _end[0],
                minutes: _end[1],
              ),
            ),
            // onTap: () => print(title),
            onTap: () => showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  backgroundColor: gray,
                  title: Row(
                    children: <Widget>[
                      Text(title),
                      Expanded(flex: 1, child: Container()),
                      isExam
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: IconButton(
                                icon: Icon(Icons.school, color: white),
                                onPressed: () => suicide(),
                              ),
                            )
                          : Container(),
                    ],
                  ),
                  content: Text(
                    detailedDescription,
                    style: TextStyle(color: white),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text(
                        'Ok',
                        style: TextStyle(color: amber),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
        );
      }
    }

    return DayView(
      date: date,
      userZoomable: false,
      minimumTime: HourMinute(hour: 8),
      maximumTime: HourMinute(hour: 20),
      style: DayViewStyle(
        headerSize: 0,
        backgroundColor:
            (date.day == DateTime.now().day) ? amber.withOpacity(0.1) : gray,
        backgroundRulesColor: white,
        currentTimeRuleColor: amber,
        currentTimeCircleColor: amber,
        currentTimeRuleHeight: 3.0,
      ),
      hoursColumnStyle: HoursColumnStyle(
        textStyle: TextStyle(color: white),
        color: semiGray,
      ),
      events: events,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray,
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _selectedIndex = index),
        unselectedItemColor: white,
        currentIndex: _selectedIndex,
        selectedItemColor: amber,
        backgroundColor: darkGray,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            label: 'Mon planning',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            label: 'Plannings des groupes',
          ),
        ],
      ),
      body: Container(
        constraints: BoxConstraints.expand(),
        child: Column(
          children: [
            _buildViewWeek(),
            Flexible(child: _buildViewDay(_selectedDateTime)),
          ],
        ),
      ),
    );
  }
}
