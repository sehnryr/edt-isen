import 'package:flutter/material.dart';
import '../src/common.dart';
import 'package:google_fonts/google_fonts.dart';

class LoginInput extends StatelessWidget {
  final TextEditingController controller;
  final Iterable<String> autofillHints;
  final Icon prefixIcon;
  final String hintText;
  final bool isPassword;
  final Color color;

  const LoginInput(
      {Key? key,
      required this.controller,
      required this.autofillHints,
      required this.prefixIcon,
      required this.hintText,
      this.isPassword = false,
      this.color = white})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerLeft,
          decoration: BoxDecoration(
            border: Border.all(width: 2, color: this.color),
            borderRadius: BorderRadius.circular(30),
          ),
          height: 60.0,
          padding: EdgeInsets.only(left: 10, right: 10),
          child: LoginTextFormField(
            controller: this.controller,
            autofillHints: this.autofillHints,
            prefixIcon: this.prefixIcon,
            hintText: this.hintText,
            isPassword: this.isPassword,
          ),
        ),
      ],
    );
  }
}

class LoginTextFormField extends StatefulWidget {
  final TextEditingController controller;
  final Iterable<String> autofillHints;
  final Icon prefixIcon;
  final String hintText;
  final bool isPassword;

  LoginTextFormField(
      {Key? key,
      required this.controller,
      required this.autofillHints,
      required this.prefixIcon,
      required this.hintText,
      this.isPassword = false})
      : super(key: key);

  @override
  _LoginTextFormFieldState createState() => new _LoginTextFormFieldState();
}

class _LoginTextFormFieldState extends State<LoginTextFormField> {
  late bool showPassword = false;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofillHints: widget.autofillHints,
      cursorColor: white,
      controller: widget.controller,
      obscureText: widget.isPassword ? !this.showPassword : false,
      style: Theme.of(context).textTheme.bodyText1,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: widget.prefixIcon,
          suffixIcon: widget.isPassword
              ? IconButton(
                  icon: Icon(
                    this.showPassword ? Icons.visibility : Icons.visibility_off,
                    color: white.withOpacity(0.25),
                  ),
                  onPressed: () {
                    setState(() => this.showPassword = !this.showPassword);
                  },
                )
              : null,
          hintText: widget.hintText,
          hintStyle: GoogleFonts.getFont(
            "Montserrat",
            color: white.withOpacity(0.5),
            fontWeight: FontWeight.w200,
          )),
    );
  }
}

class UsernameInput extends StatelessWidget {
  final TextEditingController controller;
  final Color color;

  const UsernameInput({
    Key? key,
    required this.controller,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginInput(
      controller: this.controller,
      autofillHints: [AutofillHints.username],
      prefixIcon: Icon(
        Icons.person,
        color: white,
      ),
      hintText: "Identifiant",
      color: this.color,
    );
  }
}

class PasswordInput extends StatelessWidget {
  final TextEditingController controller;
  final Color color;

  const PasswordInput({
    Key? key,
    required this.controller,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LoginInput(
      controller: this.controller,
      autofillHints: [AutofillHints.password],
      prefixIcon: Icon(
        Icons.lock_open,
        color: white,
      ),
      hintText: "Mot de passe",
      isPassword: true,
      color: this.color,
    );
  }
}

class LoginButton extends StatelessWidget {
  final void Function() onPressed;

  const LoginButton({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 60,
      child: ElevatedButton(
        onPressed: this.onPressed,
        child: Text(
          "CONNEXION",
          style: GoogleFonts.getFont(
            "Reem Kufi",
            color: white,
            fontSize: 20,
          ),
        ),
        style: ElevatedButton.styleFrom(
            primary: amber,
            elevation: 5.0,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0))),
      ),
    );
  }
}
