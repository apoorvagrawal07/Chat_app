import 'package:Catch_up/widgets/pickers/user_image_picker.dart';
import 'package:flutter/material.dart';
import 'dart:io';

// requires import 'dart:io';
class AuthForm extends StatefulWidget {
  AuthForm(this.submitFn, this.isLoading);
  final void Function(String email, String password, String userName,
      File image, bool isLogin, BuildContext ctx) submitFn;
  final bool isLoading;
  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  final _formKey = GlobalKey<FormState>();
  var _isLogin = true;
  String _userEmail = "";
  String _userName = "";
  String _userPassword = "";
  File _userImageFile;

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  void _trySubmit() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();

    if (_userImageFile == null && !_isLogin) {
      Scaffold.of(context).showSnackBar(SnackBar(
          backgroundColor: Theme.of(context).errorColor,
          content: Text("Please Pick an Image!")));
      return;
    }

    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_userEmail.trim(), _userPassword.trim(), _userName.trim(),
          _userImageFile, _isLogin, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(20),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                if (!_isLogin) UserImagePicker(_pickedImage),
                TextFormField(
                  key: ValueKey('Email'),
                  autocorrect: false,
                  textCapitalization: TextCapitalization.none,
                  enableSuggestions: false,
                  validator: (value) {
                    if (value.isEmpty || !value.contains("@")) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _userEmail = value;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: "Email address"),
                ),
                if (!_isLogin)
                  TextFormField(
                    key: ValueKey('Username'),
                    autocorrect: true,
                    textCapitalization: TextCapitalization.words,
                    enableSuggestions: false,
                    validator: (value) {
                      if (value.isEmpty || value.length < 4) {
                        return "Please enter atleast four characters";
                      }
                      return null;
                    },
                    decoration: InputDecoration(labelText: "Username"),
                    onSaved: (value) {
                      _userName = value;
                    },
                  ),
                TextFormField(
                  key: ValueKey('Password'),
                  validator: (value) {
                    if (value.isEmpty || value.length < 7) {
                      return "Password must be at least 7 characters long!";
                    }
                    return null;
                  },
                  decoration: InputDecoration(labelText: "Password"),
                  obscureText: true,
                  onSaved: (value) {
                    _userPassword = value;
                  },
                ),
                SizedBox(
                  height: 12,
                ),
                if (widget.isLoading) CircularProgressIndicator(),
                if (!widget.isLoading)
                  RaisedButton(
                    onPressed: () {
                      _trySubmit();
                    },
                    child: Text(_isLogin ? "Login" : "Signup"),
                  ),
                if (!widget.isLoading)
                  FlatButton(
                    textColor: Theme.of(context).primaryColor,
                    onPressed: () {
                      setState(() {
                        _isLogin = !_isLogin;
                      });
                    },
                    child: Text(_isLogin
                        ? "Create a new Account"
                        : "I already have an account!"),
                  )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
