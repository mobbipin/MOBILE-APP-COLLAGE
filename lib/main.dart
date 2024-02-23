import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:librarian/components/allUsers.dart';
import 'package:librarian/screens/add_books.dart';
import 'package:librarian/screens/admin.dart';
import 'package:librarian/screens/browseBooks.dart';
import 'package:librarian/screens/buy_book.dart';
import 'package:librarian/screens/login.dart';
import 'package:librarian/screens/register.dart';
import 'package:librarian/screens/user.dart';
import 'package:librarian/screens/validateRequests.dart';
import 'package:librarian/screens/validateReturns.dart';
import 'package:librarian/screens/welcomeScreen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Firebase.initializeApp(),
      builder: (context, snapshot) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Library Management System',
          initialRoute: welcomeId,
          routes: {
            welcomeId: (context) => WelcomeScreen(),
            loginId: (context) => Login(),
            loginId2: (context) => Login2(),
            registerId: (context) => Register(),
            adminId: (context) => Admin(),
            userRegisterId: (context) => User(
                  newUser: true,
                ),
            userLoginId: (context) => User(
                  newUser: false,
                ),


            browseId: (context) => BrowseBooks(),
            allUsersId: (context) => AllUsers(),
            requestsId: (context) => ValidateRequests(),
            returnId: (context) => ValidateReturns(),
            AddBooksId : (context) => AddBook(),
            BuyBookId : (context) => BuyBook(),
          },
        );
      },
    );
  }
}
