import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:librarian/components/reusableButton.dart';
import 'package:librarian/constants.dart';
import 'package:librarian/screens/browseBooks.dart';
import 'package:librarian/screens/buy_book.dart';

final userRegisterId = "/userRegister";
final userLoginId = "/userLogin";

class User extends StatefulWidget {
  final bool newUser;

  User({required this.newUser});

  @override
  _UserState createState() => _UserState();
}

class _UserState extends State<User> {
  final _auth = FirebaseAuth.instance;
  var loggedInUser;
  var books;

  // final _firestore = FirebaseFirestore.instance;
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  Future<void> addUser(String email) {
    return users
        .doc(email)
        .set({
          'email': email,
          'books': {},
        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

/*
  void getCurrentUser() {
    try {
      final thisUser = _auth.currentUser;
      if (thisUser != null) {
        loggedInUser = thisUser;
        if (widget.newUser == true) {
          addUser(thisUser.email.toString());
        }
        FirebaseFirestore.instance
            .collection('users')
            .doc(thisUser.email)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            print('Document data: ${documentSnapshot.data()}');
            Map<String, dynamic>? userData = documentSnapshot.data() as Map<String, dynamic>?;

            if (userData != null) {
              books = userData["books"];
              // Now you can use 'books' safely
              if (books != null) {
                // Your logic here
              }
            }
          } else {
            print('Document does not exist on the database');
          }
        });
      }
    } catch (e) {
      print(e);
    }
  }
*/
  Future<Map<String, dynamic>> getCurrentUser() async {
    try {
      final thisUser = _auth.currentUser;
      if (thisUser != null) {
        loggedInUser = thisUser;
        String userEmail = thisUser.email.toString();

        if (widget.newUser == true) {
          await addUser(userEmail);
        }

        DocumentSnapshot documentSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(userEmail)
            .get();

        if (documentSnapshot.exists) {
          print('Document data: ${documentSnapshot.data()}');
          Map<String, dynamic>? userData =
              documentSnapshot.data() as Map<String, dynamic>?;

          if (userData != null) {
            return userData;
          }
        } else {
          print('Document does not exist on the database');
        }
      }
    } catch (e) {
      print(e);
    }

    return {}; // Return an empty map if there is an error or no data
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: cream,
      body: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 40,
          vertical: 50,
        ),
        child: FutureBuilder<Map<String, dynamic>>(
          future: getCurrentUser(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              var books = snapshot.data?["books"];
              return ListView(
                children: [
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back),
                        onPressed: () {
                          _auth.signOut();
                          print("Logging out");
                          Navigator.pop(context);
                          // print("Testing");
                        },
                      ),
                      SizedBox(
                        width: 100,
                      ),
                      Text(
                        "Welcome",
                        style: kAppText,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 25,
                  ),
                  ReusableButton(
                    text: "My book",
                    onPressed: () {
                      List<String> ownedBooksTitles = [];

                      // Check if books is not null and contains titles
                      if (books != null && books.isNotEmpty) {
                        ownedBooksTitles = books.keys.toList();
                      }

                      currentlyBorrowing(
                          context,
                          ownedBooksTitles.isNotEmpty
                              ? ownedBooksTitles.join(", ")
                              : "No books");
                    },
                  ),
                  ReusableButton(
                    text: "Search Library",
                    onPressed: () {
                      Navigator.pushNamed(context, browseId);
                    },
                  ),
                  ReusableButton(
                    text: "Buy New Book",
                    onPressed: () {
                      Navigator.pushNamed(context, BuyBookId);
                    },
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}
