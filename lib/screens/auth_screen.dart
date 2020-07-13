import 'package:Catch_up/widgets/auth/auth_form.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _auth = FirebaseAuth.instance;
  bool _isloading = false;
  void _submitAuthForm(String email, String password, String username,
      File image, bool isLogin, BuildContext ctx) async {
    AuthResult authResult;

    try {
      setState(() {
        _isloading = true;
      });
      if (isLogin) {
        authResult = await _auth.signInWithEmailAndPassword(
            email: email, password: password);
      } else {
        authResult = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
      }

      final ref = FirebaseStorage.instance
          .ref()
          .child('user_images')
          .child(authResult.user.uid + '.jpg');

      await ref.putFile(image).onComplete;

      final url = await ref.getDownloadURL();

      await Firestore.instance
          .collection('users')
          .document(authResult.user.uid)
          .setData({
        "username": username,
        'email': email,
        'password': password,
        'image_url': url
      });
    } on PlatformException catch (error) {
      var message = "An error ocurred, please check your credentials!";

      if (error.message != null) {
        message = error.message;
      }
      Scaffold.of(ctx).showSnackBar(SnackBar(
        content: Text(message),
        backgroundColor: Theme.of(ctx).errorColor,
      ));
      setState(() {
        _isloading = false;
      });
    } catch (error) {
      print(error);
      setState(() {
        _isloading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: AuthForm(_submitAuthForm, _isloading));
  }
}
