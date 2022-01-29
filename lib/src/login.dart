import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'common.dart';
import 'schedule.dart';
import '../utils/login_input.dart';
import '../utils/secure_storage.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController usernameController;
  late TextEditingController passwordController;
  late String name;

  // bool _showPassword = false;
  bool _saving = false;
  bool _isLoggedIn = false;
  bool _hasSchedule = false;
  bool errorUsername = false;
  bool errorPassword = false;
  List<dynamic> schedule = [];

  @override
  void initState() {
    _isLoggedIn = false;
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    // autoLogin();
    loadSchedule();
    super.initState();
  }

  void loadSchedule() async {
    setState(() {
      _saving = true;
    });

    final String? rawSchedule = await SecureStorage.getSchedule();

    if (rawSchedule != null) {
      schedule = json.decode(rawSchedule);
      name = await SecureStorage.getName() ?? "";
      setState(() {
        _hasSchedule = true;
      });
    }

    setState(() {
      _saving = false;
    });
  }

  void autoLogin() async {
    setState(() {
      _saving = true;
    });

    final String username = await SecureStorage.getUsername() ?? "";
    final String password = await SecureStorage.getPassword() ?? "";

    if (username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _loginUser(username, password);
      });
      return;
    }
    setState(() {
      _saving = false;
    });
  }

  void logoutUser() async {
    setState(() {
      SecureStorage.deletePassword();
      SecureStorage.deleteSchedule();
      SecureStorage.deleteName();
      _isLoggedIn = false;
      passwordController.text = '';
      _saving = false;
    });
  }

  String fetchViewState(String html) {
    return RegExp(r'name="javax\.faces\.ViewState".*?value="([^"]*)')
        .firstMatch(html)!
        .group(1)!;
  }

  String fetchDefaultParam(String html) {
    return RegExp(
            r'id="([^"]*)"\s*?(?=class="schedule")|(?<=class="schedule")\s*?id="([^"]*)"')
        .firstMatch(html)!
        .group(1)!;
  }

  Future<void> _updateSchedule() async {
    if (!_isLoggedIn && !_saving) autoLogin();
    Response r = await Requests.get('https://web.isen-ouest.fr/webAurion/');

    String viewState = fetchViewState(r.content());
    String defaultParam = fetchDefaultParam(r.content());
    int timeStampStart = Timestamp.fromDate(DateTime.now()
            .subtract(Duration(days: weeksBehind * 7 + today.weekday)))
        .millisecondsSinceEpoch;
    int timeStampEnd = Timestamp.fromDate(DateTime.now()
            .add(Duration(days: weeksAhead * 7 - today.weekday - 1)))
        .millisecondsSinceEpoch;
    Map<String, String> params = {
      "javax.faces.partial.ajax": "true",
      "javax.faces.source": defaultParam,
      "javax.faces.partial.execute": defaultParam,
      "javax.faces.partial.render": defaultParam,
      defaultParam: defaultParam,
      "${defaultParam}_start": timeStampStart.toString(),
      "${defaultParam}_end": timeStampEnd.toString(),
      "form": "form",
      'javax.faces.ViewState': viewState,
    };

    Response response = await Requests.post(
        'https://web.isen-ouest.fr/webAurion/faces/MainMenuPage.xhtml',
        body: params);

    String edt = RegExp(r'"events".*?(\[(?:.|\s)*?\])')
        .firstMatch(response.content())!
        .group(1)!;

    SecureStorage.setSchedule(edt);

    setState(() {
      schedule = json.decode(edt);
    });
    return;
  }

  bool _creditentialVerification(Response response) {
    return RegExp(r'Planning').hasMatch(response.content());
  }

  void _updateName(Response response) {
    final String _name = RegExp(r'role="menu".*?<h3>(.*?)<\/h3>')
        .firstMatch(response.content())!
        .group(1)!;
    SecureStorage.setName(_name);
    setState(() {
      name = _name;
    });
  }

  void _loginUser(String username, String password) async {
    FocusManager.instance.primaryFocus!.unfocus();

    if (username.length < 6 || password.length < 6) {
      setState(() {
        errorUsername = username.length < 6;
        errorPassword = password.length < 6;
      });
      return;
    }
    setState(() {
      _saving = true;
    });

    final String url = 'https://web.isen-ouest.fr/webAurion/login';
    final String hostname = Requests.getHostname(url);
    await Requests.clearStoredCookies(hostname);

    // We try to repass the last cookie to check if it's still alive
    String? stringRepresentationConnexionToken =
        await SecureStorage.getConnexionToken();
    if (stringRepresentationConnexionToken != null) {
      Map<String, String> connexionToken = Map<String, String>.from(
          json.decode(stringRepresentationConnexionToken));
      await Requests.setStoredCookies(hostname, connexionToken);
    }

    Response response = await Requests.get(url);

    if (!_creditentialVerification(response)) {
      await Requests.post(
        url,
        body: {
          'username': username,
          'password': password,
        },
      );
      Map<String, String> connexionToken =
          await Requests.getStoredCookies(hostname);
      SecureStorage.setConnexionToken(json.encode(connexionToken));
    }

    Response r = await Requests.get('https://web.isen-ouest.fr/webAurion/');
    if (!_creditentialVerification(r)) {
      setState(() {
        _saving = false;
        errorUsername = true;
        errorPassword = true;
      });
      return;
    } else {
      _updateName(r);
      SecureStorage.setUsername(username);
      SecureStorage.setPassword(password);
    }

    _updateSchedule();

    setState(() {
      _saving = false;
      errorUsername = false;
      errorPassword = false;
      _isLoggedIn = true;
    });
  }

  Widget _buildLoginScreen() {
    return ModalProgressHUD(
      child: Scaffold(
        body: Form(
          child: Center(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SvgPicture.asset(
                    "assets/images/logo_hat.svg",
                    color: white,
                    width: 100,
                    height: 100,
                  ),
                  SizedBox(height: 30.0),
                  AutofillGroup(
                    child: Column(
                      children: [
                        UsernameInput(
                          controller: this.usernameController,
                          color: errorUsername
                              ? Colors.red.withOpacity(0.7)
                              : white,
                        ),
                        SizedBox(height: 30.0),
                        PasswordInput(
                          controller: this.passwordController,
                          color: errorPassword
                              ? Colors.red.withOpacity(0.7)
                              : white,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30.0),
                  LoginButton(
                    onPressed: () => _loginUser(
                        usernameController.text, passwordController.text),
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: Container(
          child: Center(
              child: Text(
            "Cette application est à l'usage exclusif des étudiants de l'ISEN.",
            style: GoogleFonts.getFont(
              "Montserrat",
              color: white.withOpacity(0.5),
              fontWeight: FontWeight.w200,
              fontSize: 12,
            ),
            textAlign: TextAlign.center,
          )),
          height: 60,
        ),
        backgroundColor: gray,
      ),
      inAsyncCall: _saving,
    );
  }

  Widget _buildScheduleScreen() {
    return Scaffold(
      appBar: AppBar(),
      // body: ScheduleScreen(schedule: schedule),
      body: RefreshIndicator(
        backgroundColor: gray,
        color: amber,
        child: ScheduleScreen(schedule: schedule),
        onRefresh: _updateSchedule,
      ),
      endDrawer: Drawer(
        child: Container(
          color: gray,
          child: ListView(
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(15),
                color: semiGray,
                child: Text(
                  name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              SizedBox(height: 15),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: RaisedButton(
                  onPressed: logoutUser,
                  color: white,
                  padding: EdgeInsets.all(15.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0),
                  ),
                  child: Text(
                    'DECONNEXION',
                    style: TextStyle(
                      color: darkGray,
                      letterSpacing: 1.5,
                      fontSize: 18.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: _hasSchedule || _isLoggedIn
          ? _buildScheduleScreen()
          : _buildLoginScreen(),
    );
  }
}
