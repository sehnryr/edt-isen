import 'package:flutter/material.dart';
import 'package:flutter_calendar_week/flutter_calendar_week.dart';
import 'package:flutter_week_view/flutter_week_view.dart';
import 'package:linked_scroll_controller/linked_scroll_controller.dart';

import 'common.dart';

class ScheduleScreen extends StatefulWidget {
  final List<dynamic> schedule;

  ScheduleScreen({Key key, @required this.schedule}) : super(key: key);

  @override
  _ScheduleScreenState createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  CalendarWeekController _viewWeek;
  DayViewController _viewDay;
  LinkedScrollControllerGroup _viewDayScrollControllers;
  ScrollController _viewDayScroll;
  ScrollController _viewHourColumnScroll;
  PageController _viewDayHorizontalScroll;
  final _lowRangeDate =
      today.subtract(Duration(days: weeksBehind * 7 + today.weekday));
  bool _isAnimated = false;
  int _selectedIndex = 0;
  double _hourColumnWidth = 60;
  double _hourRowHeight = 60;
  int _minimumHour = 8;
  int _maximumHour = 20;
  DateTime now;

  @override
  initState() {
    super.initState();
    now = DateTime(
      today.year,
      today.month,
      today.day,
    );
    _viewWeek = CalendarWeekController();
    _viewDay = DayViewController();
    _viewDayScrollControllers = LinkedScrollControllerGroup();
    _viewDayScroll = _viewDayScrollControllers.addAndGet();
    _viewHourColumnScroll = _viewDayScrollControllers.addAndGet();
    _viewDayHorizontalScroll = PageController(
      initialPage: weeksBehind * 7 + today.weekday,
    );
  }

  @override
  void dispose() {
    // _viewWeek.dispose();
    _viewDay.dispose();
    _viewDayScroll.dispose();
    _viewHourColumnScroll.dispose();
    super.dispose();
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
      controller: _viewWeek,
      backgroundColor: semiGray,
      showMonth: true,
      minDate: today.subtract(Duration(days: weeksBehind * 7 + today.weekday)),
      maxDate: today.add(Duration(days: weeksAhead * 7 - today.weekday - 1)),
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
      onDatePressed: (date) async {
        setState(() {
          _isAnimated = true;
          _viewDayHorizontalScroll.animateToPage(
              date.difference(_lowRangeDate).inDays,
              duration: Duration(milliseconds: 300),
              curve: Curves.decelerate);
        });
        await Future.delayed(Duration(milliseconds: 300));
        setState(() {
          if (_isAnimated) {
            _isAnimated = false;
          }
        });
      },
    );
  }

  List<FlutterWeekViewEvent> _getDayEvents(DateTime date) {
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
    return events;
  }

  Widget _buildViewDay(DateTime date) {
    DateTime reducedDate = DateTime(date.year, date.month, date.day);
    List<FlutterWeekViewEvent> events = _getDayEvents(date);

    return Container(
      width: MediaQuery.of(context).size.width - _hourColumnWidth,
      // height: _hourRowHeight * (_maximumHour - _minimumHour),
      child: DayView(
        controller: _viewDay,
        date: date,
        userZoomable: false,
        minimumTime: HourMinute(hour: _minimumHour),
        maximumTime: HourMinute(hour: _maximumHour),
        style: DayViewStyle(
          headerSize: 0,
          backgroundColor: (now == reducedDate) ? amber.withOpacity(0.1) : gray,
          backgroundRulesColor: white,
          currentTimeRuleColor: amber,
          currentTimeCircleColor: amber,
          currentTimeRuleHeight: 3.0,
          hourRowHeight: _hourRowHeight,
        ),
        hoursColumnStyle: HoursColumnStyle(
          width: 0,
        ),
        events: events,
      ),
    );
  }

  Widget _buildViewDayHourColumn(DateTime date) {
    double width = 60;
    return Container(
      width: width,
      child: DayView(
        controller: _viewDay,
        date: date,
        userZoomable: false,
        minimumTime: HourMinute(hour: 8),
        maximumTime: HourMinute(hour: 20),
        hoursColumnStyle: HoursColumnStyle(
          textStyle: TextStyle(color: white),
          color: semiGray,
          width: width, // default
        ),
        style: DayViewStyle(
          headerSize: 0,
        ),
        events: [],
      ),
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
        // constraints: BoxConstraints.expand(),
        child: Column(
          children: <Widget>[
            _buildViewWeek(),
            Expanded(
              child: Row(
                children: <Widget>[
                  SingleChildScrollView(
                    controller: _viewHourColumnScroll,
                    child: Container(
                      // height: _hourRowHeight * (_maximumHour - _minimumHour),
                      child: _buildViewDayHourColumn(today),
                    ),
                  ),
                  SingleChildScrollView(
                    controller: _viewDayScroll,
                    child: Container(
                      width:
                          MediaQuery.of(context).size.width - _hourColumnWidth,
                      height: _hourRowHeight * (_maximumHour - _minimumHour),
                      child: PageView(
                        controller: _viewDayHorizontalScroll,
                        children: List<Widget>.generate(
                          (weeksBehind + weeksAhead) * 7,
                          (index) => _buildViewDay(today.add(Duration(
                              days:
                                  index - (weeksBehind * 7 + today.weekday)))),
                        ),
                        onPageChanged: (value) {
                          if (!_isAnimated) {
                            setState(() {
                              var t = today.add(Duration(
                                  days: value -
                                      (weeksBehind * 7 + today.weekday)));
                              _viewWeek.jumpToDate(t);
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
