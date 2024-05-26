import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:discounttour/model/country_model.dart';
import 'package:discounttour/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../../api/account.dart';
import '../../api/event.dart';
import '../../utils/map_utils.dart';
import '../home.dart';

class EventDetails extends StatefulWidget {
  final EventModel event;

  EventDetails({@required this.event});

  @override
  _EventDetailsState createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  User user;
  List<CountryModel> country = new List();

  bool isFavorite = false;

  @override
  void initState() {
    isFavorite = widget.event.favorite;
    _fetchLoggedUser();
    super.initState();
  }

  _fetchLoggedUser() async {
    Response<dynamic> response = await Account().fetchAccount();
    if (response.statusCode == 200) {
      Map<String, dynamic> userData =
          response.data; // Assuming response.data contains user data
      setState(() {
        user = User.fromJson(userData);
        print(user.authorities);
      });
    } else {
      // Handle error scenario
      print("Error fetching user data: ${response.statusCode}");
    }
  }

  manageFavoriteState(id) {
    if (isFavorite) {
      removeFromFavorites(id);
    } else {
      addToFavorites(id);
    }

    setState(() {
      isFavorite = !isFavorite;
    });
  }

  addToFavorites(id) async {
    await EventService().addToFavorite(id).then((value) => null);
  }

  removeFromFavorites(id) async {
    await EventService().deleteFromFavorite(id).then((value) => null);
  }

  deleteEvent(id) async {
    print('88888');
    await EventService().deleteEvent(id).then((value) => null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              Stack(
                children: [
                  Image.memory(base64Decode(widget.event.preViewImg),
                      height: 350,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover),
                  Container(
                    height: 350,
                    color: Colors.black12,
                    padding: EdgeInsets.only(top: 50),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                            left: 24,
                            right: 24,
                          ),
                          child: Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  Navigator.pop(context, true);
                                },
                                child: Container(
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                              ),
                              Spacer(),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                // Adjust padding as needed
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.6),
                                  border: Border.all(color: Colors.grey),
                                  // Border color
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Border radius
                                ),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        Share.share(
                                            "${widget.event.description} ${widget.event.url}",
                                            subject: "${widget.event.title}");
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          // color: Colors.grey[300],
                                          // Background color
                                          borderRadius: BorderRadius.circular(
                                              8.0), // Border radius
                                        ),
                                        child: Icon(
                                          Icons.share,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                width: 18,
                              ),
                              Container(
                                padding: EdgeInsets.all(8.0),
                                // Adjust padding as needed
                                decoration: BoxDecoration(
                                  color: Colors.grey.withOpacity(0.6),
                                  border: Border.all(color: Colors.grey),
                                  // Border color
                                  borderRadius: BorderRadius.circular(
                                      20.0), // Border radius
                                ),
                                child: Stack(
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        manageFavoriteState(widget.event.id);
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(8.0),
                                        ),
                                        child: Icon(
                                          Icons.favorite,
                                          color: isFavorite
                                              ? Colors.red
                                              : Colors.white,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          padding: EdgeInsets.only(
                            left: 24,
                            right: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.event.title,
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 23),
                              ),
                              SizedBox(
                                height: 12,
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.location_on,
                                    color: Colors.white70,
                                    size: 25,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "${widget.event.location}",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w500,
                                        fontSize: 17),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 8,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 18,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30))),
                          height: 20,
                        )
                      ],
                    ),
                  )
                ],
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24),
                child: Text(
                  widget.event.description ?? '',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff879D95)),
                ),
              ),
              SizedBox(
                height: 16,
              ),
              Divider(),
              SizedBox(height: 15.0),
              Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.calendar_today,
                      color: Colors.grey,
                    ),
                    SizedBox(width: 5),
                    // Add some space between the icon and text
                    Text(
                      '${widget.event.eventDate.toIso8601String().split('T').first} ${widget.event.eventDate.hour}:${widget.event.eventDate.minute}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
        bottomNavigationBar: Container(
          color: Color(0xfffefefe),
          // Background color
          padding:
          EdgeInsets.only(left: 16.0, right: 16.0, bottom: 30.0, top: 10),
          // Padding for the container, excluding top
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  MapUtils.openUrl(widget.event.url);
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.blue, // Background color
                  onPrimary: Colors.white, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Border radius
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 30, right: 30, top: 12, bottom: 12),
                  child: Text('Verifică disponibilitate',
                      style: TextStyle(fontSize: 16)), // Button text
                ),
              ),
              if (user != null && user.authorities.contains('ROLE_ADMIN'))
              Container(
                decoration: BoxDecoration(
                  color: Colors.red, // Button background color
                  shape: BoxShape.rectangle,
                  borderRadius: BorderRadius.circular(10), // Border radius
                ),
                margin: EdgeInsets.only(left: 10),
                child: IconButton(
                  onPressed: () {
                    print('Trash button tapped');
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("Confirmare ștergere"),
                          content: const Padding(
                            padding: EdgeInsets.symmetric(vertical: 15.0),
                            child: Text(
                                "Sunteți sigur că doriți să ștergeți înregistrarea ?"),
                          ),
                          actions: [
                            TextButton(
                              onPressed: () async {
                                await deleteEvent(widget.event.id); // Wait for the deletion to complete
                                Navigator.of(context).pop(); // Close the dialog
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                    Home.routeName, (_) => false); // Navigate to Home
                              },
                              child: Text("Da"),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop(); // Close the dialog
                              },
                              child: Text("Nu"),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                  // Icon color
                  padding: EdgeInsets.all(10),
                  // Padding inside the button
                  constraints: BoxConstraints(),
                  // Removes default constraints to allow for custom size
                  iconSize: 24,
                  // Icon size
                  splashColor: Colors.redAccent,
                  // Splash color on press
                  splashRadius: 28, // Splash radius
                ),
              ),
            ],
          ),
        )
    );
  }
}

class FeaturesTile extends StatelessWidget {
  final Icon icon;
  final String label;

  FeaturesTile({this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.7,
      child: Container(
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                  border: Border.all(color: Color(0xff5A6C64).withOpacity(0.5)),
                  borderRadius: BorderRadius.circular(40)),
              child: icon,
            ),
            SizedBox(
              height: 9,
            ),
            Container(
                width: 70,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xff5A6C64)),
                ))
          ],
        ),
      ),
    );
  }
}
