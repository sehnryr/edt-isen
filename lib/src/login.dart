import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:requests/requests.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'common.dart';
import 'schedule.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => new _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController usernameController;
  TextEditingController passwordController;

  bool _showPassword = false;
  bool _saving = false;
  bool _isLoggedIn = false;
  bool _easterEgg1 = false;
  String error = '';
  String name = '';
  List<dynamic> schedule = [];

  @override
  void initState() {
    _isLoggedIn = false;
    super.initState();
    usernameController = TextEditingController();
    passwordController = TextEditingController();
    autoLogin();
  }

  void autoLogin() async {
    setState(() {
      _saving = true;
    });
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String username = prefs.getString('username');
    final String password = prefs.getString('password');

    if (password != null) {
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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.remove('password');
      _isLoggedIn = false;
      passwordController.text = '';
      _saving = false;
    });
  }

  String fetchViewState(String html) {
    return RegExp(r'name="javax\.faces\.ViewState".*?value="([^"]*)')
        .firstMatch(html)
        .group(1);
  }

  String fetchDefaultParam(String html) {
    return RegExp(
            r'id="([^"]*)"\s*?(?=class="schedule")|(?<=class="schedule")\s*?id="([^"]*)"')
        .firstMatch(html)
        .group(1);
  }

  Future<void> _updateSchedule() async {
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
        .firstMatch(response.content())
        .group(1);

    setState(() {
      schedule = json.decode(edt);
    });
    return;
  }

  bool _creditentialVerification(Response response) {
    return RegExp(r'Planning').hasMatch(response.content());
  }

  void _updateName(Response response) {
    setState(() {
      name = RegExp(r'role="menu".*?<h3>(.*?)<\/h3>')
          .firstMatch(response.content())
          .group(1);
    });
  }

  void _loginUser(String username, String password) async {
    if (username.toString().length < 6 || password.toString().length < 6) {
      setState(() {
        error = 'Veuillez indiquer un identifiant et un mot de passe valide !';
      });
      return;
    }
    setState(() {
      _saving = true;
    });

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    final String url = 'https://web.isen-ouest.fr/webAurion/login';
    final String hostname = Requests.getHostname(url);
    await Requests.clearStoredCookies(hostname);

    // We try to repass the last cookie to check if it's still alive
    String stringRepresentationConnexionToken =
        prefs.getString('connexionToken');
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
      prefs.setString('connexionToken', json.encode(connexionToken));
    }

    Response r = await Requests.get('https://web.isen-ouest.fr/webAurion/');
    if (!_creditentialVerification(r)) {
      setState(() {
        _saving = false;
        error = 'Identifiant ou Mot de passe incorrect';
      });
      return;
    } else {
      _updateName(r);
      prefs.setString('username', username);
      prefs.setString('password', password);
    }

    _updateSchedule();

    setState(() {
      _saving = false;
      error = '';
      _isLoggedIn = true;
    });
  }

  Widget _buildUsername() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: darkGray,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: semiGray,
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            autofillHints: [AutofillHints.username],
            cursorColor: white,
            controller: this.usernameController,
            keyboardType: TextInputType.text,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.person,
                color: white,
              ),
              hintText: 'Entrez votre Identifiant',
              hintStyle: TextStyle(
                color: white.withOpacity(0.25),
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPassword() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            color: darkGray,
            borderRadius: BorderRadius.circular(10.0),
            boxShadow: [
              BoxShadow(
                color: darkGray.withOpacity(0.3),
                blurRadius: 6.0,
                offset: Offset(0, 2),
              ),
            ],
          ),
          height: 60.0,
          child: TextFormField(
            autofillHints: [AutofillHints.password],
            // onEditingComplete: () => TextInput.finishAutofillContext(),
            cursorColor: white,
            controller: this.passwordController,
            obscureText: !this._showPassword,
            style: Theme.of(context).textTheme.bodyText1,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(top: 14.0),
              prefixIcon: Icon(
                Icons.lock_open,
                color: white,
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  this._showPassword ? Icons.visibility : Icons.visibility_off,
                  color: white.withOpacity(0.25),
                ),
                onPressed: () {
                  setState(() => this._showPassword = !this._showPassword);
                },
              ),
              hintText: 'Entrez votre Mot de passe',
              hintStyle: TextStyle(
                color: white.withOpacity(0.25),
                fontFamily: 'OpenSans',
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginBtn() {
    return Container(
      width: double.infinity,
      child: RaisedButton(
        elevation: 5.0,
        onPressed: () =>
            _loginUser(usernameController.text, passwordController.text),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: white,
        child: Text(
          'CONNEXION',
          style: TextStyle(
            color: darkGray,
            letterSpacing: 1.5,
            fontSize: 18.0,
            fontWeight: FontWeight.bold,
            fontFamily: 'OpenSans',
          ),
        ),
      ),
    );
  }

  Widget _buildLoginScreen() {
    return ModalProgressHUD(
      child: Form(
        child: Center(
          child: Container(
            color: gray,
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("I", style: Theme.of(context).textTheme.headline1),
                    GestureDetector(
                      onTap: () => setState(() => _easterEgg1 = !_easterEgg1),
                      child: Text(
                        !_easterEgg1 ? 'S' : 'Ç',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Text("EN EDT",
                        style: Theme.of(context).textTheme.headline1),
                  ],
                ),
                SizedBox(height: 10.0),
                Center(
                  child: Text(
                    error,
                    style: TextStyle(
                      color: Colors.red.withOpacity(0.7),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10.0),
                AutofillGroup(
                  child: Column(
                    children: [
                      _buildUsername(),
                      SizedBox(height: 30.0),
                      _buildPassword()
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                _buildLoginBtn(),
              ],
            ),
          ),
        ),
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
      body: _isLoggedIn ? _buildScheduleScreen() : _buildLoginScreen(),
    );
  }
}
