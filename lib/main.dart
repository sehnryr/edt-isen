import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_calendar_week/calendar_week.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

final Color white = Color(0xFFEEEEEE);
final Color gray = Color(0xFF393E46);
final Color darkGray = Color(0xFF222831);
final Color amber = Colors.amber[800];

void main() => runApp(MyApp());

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
          FocusManager.instance.primaryFocus.unfocus();
        }
      },
      child: MaterialApp(
        theme: ThemeData(
          primaryColor: darkGray,
          accentColor: white,
          fontFamily: 'OpenSans',
          textTheme: TextTheme(
            headline1: TextStyle(
              color: white,
              fontSize: 30.0,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
            ),
            headline6: TextStyle(
              color: white,
              fontSize: 16.0,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.bold,
            ),
            bodyText1: TextStyle(
              color: white,
              fontSize: 16.0,
              fontFamily: 'OpenSans',
              fontWeight: FontWeight.normal,
            ),
          ),
        ),
        home: HomeScreen(),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray,
      body: AutoLogin(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  Widget _buildPlanning() {
    return SfCalendar(
      view: CalendarView.workWeek,
      timeSlotViewSettings: TimeSlotViewSettings(
        timeFormat: 'H:mm',
        startHour: 8,
        endHour: 18,
      ),
    );
  }

  Widget _buildViewWeek() {
    return CalendarWeek(
      height: 80,
      minDate: DateTime.now().add(Duration(days: -2)),
      maxDate: DateTime.now().add(Duration(days: 11)),
      backgroundColor: darkGray.withOpacity(0.5),
      todayDateStyle: TextStyle(color: amber),
      pressedDateBackgroundColor: amber,
      pressedDateStyle: TextStyle(
        color: darkGray,
        fontWeight: FontWeight.bold,
      ),
      dateStyle: TextStyle(color: white),
      dayOfWeekStyle: TextStyle(color: white),
      dayOfWeek: <String>['LUN', 'MAR', 'MER', 'JEU', 'VEN', 'SAM', 'DIM'],
      decorations: [],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: gray,
      appBar: AppBar(
        actions: [
          IconButton(
              icon: Icon(
                Icons.person,
                color: white,
              ),
              onPressed: null),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) => setState(() => _selectedIndex = index),
        unselectedItemColor: white,
        currentIndex: _selectedIndex,
        selectedItemColor: amber,
        backgroundColor: darkGray,
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.date_range),
            title: Text('Mon planning'),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.format_list_bulleted),
            title: Text('Plannings des groupes'),
          ),
        ],
      ),
      body: _buildPlanning(),
    );
  }
}

class AutoLogin extends StatefulWidget {
  @override
  _AutoLoginState createState() => _AutoLoginState();
}

class _AutoLoginState extends State<AutoLogin> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isLoggedIn = false;
  bool _showPassword = false;
  String test = '';
  String username = '';

  @override
  void initState() {
    super.initState();
    autoLogin();
  }

  void autoLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String _username = prefs.getString('username');

    if (_username != null) {
      setState(() {
        _isLoggedIn = true;
        username = _username;
      });
      return;
    }
  }

  Future<Null> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('password', null);

    setState(() {
      _isLoggedIn = false;
    });
  }

  Future<Null> loginUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('username', usernameController.text);
    prefs.setString('password', passwordController.text);

    final Map<String, String> parameters = {
      'username': usernameController.text,
      'password': passwordController.text,
    };

    setState(() {
      username = usernameController.text;
      _isLoggedIn = true;
    });

    passwordController.clear();
  }

  Widget _buildUsername() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          child: Text(
            'Identifiant',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(height: 10.0),
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
          child: TextField(
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
          child: Text(
            'Mot de passe',
            style: Theme.of(context).textTheme.headline6,
          ),
        ),
        SizedBox(height: 10.0),
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
          child: TextField(
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
        onPressed: () => _isLoggedIn ? logout() : loginUser(),
        padding: EdgeInsets.all(15.0),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30.0),
        ),
        color: white,
        child: Text(
          'SE CONNECTER',
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

  Widget _buildLoginPage() {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40.0,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Connexion',
              style: Theme.of(context).textTheme.headline1,
            ),
            SizedBox(height: 30.0),
            _buildUsername(),
            SizedBox(height: 30.0),
            _buildPassword(),
            SizedBox(height: 45.0),
            _buildLoginBtn(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainPage() {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () => _isLoggedIn ? logout() : loginUser(),
          ),
        ],
      ),
    );
  }

  Widget _buildLogout() {
    return RaisedButton(
      onPressed: () {
        _isLoggedIn ? logout() : loginUser();
      },
      child: _isLoggedIn ? Text('Logout') : Text('Login'),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          !_isLoggedIn ? _buildLoginPage() : _buildLogout(),
        ],
      ),
    );
  }
}

// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }

// class _LoginScreenState extends State<LoginScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Text('center'),
//     );
//   }
// }
