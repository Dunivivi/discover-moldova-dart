import 'dart:convert';

import 'package:discounttour/views/events/events-detail.dart';
import 'package:discounttour/views/favorites.dart';
import 'package:discounttour/views/profile.dart';
import 'package:flutter/material.dart';

import '../../api/event.dart';
import '../../model/event_model.dart';
import '../home.dart';

class EventsScreen extends StatefulWidget {
  static const routeName = '/activities';

  @override
  _EventsState createState() => _EventsState();
}

class _EventsState extends State<EventsScreen> {
  List<EventModel> eventsList = new List();

  // Define GlobalKey
  GlobalKey<_EventsState> parentKey = GlobalKey<_EventsState>();

  var currentPage = 0;
  var totalCount;

  bool isLoading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _paginateData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if ((_scrollController.position.maxScrollExtent -
                _scrollController.position.pixels) <
            50 &&
        totalCount != eventsList.length) {
      currentPage += 1;
      _paginateData();
    }
  }

  void handleDetailPage(bool state) {
    if (state) {
      resetData();
    }
  }

  void resetData() {
    totalCount = 0;
    currentPage = 0;
    eventsList = [];
    _paginateData();
  }

  _paginateData() async {
    setState(() {
      isLoading = true; // Set loading state to true
    });
    await EventService().fetchActivitiesEvents(currentPage).then((data) => {
          eventsList.addAll(data['events']),
          totalCount = int.parse(data['totalCount'])
        });
    setState(() {
      isLoading = false; // Set loading state to false
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffefefe),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Evenimente",
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.w700),
            )
          ],
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
          controller: _scrollController,
          child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Column(children: [
                eventsList.isEmpty && !isLoading
                    ? Center(
                        child: Padding(
                        padding: const EdgeInsets.only(top: 100.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 50),
                            SizedBox(height: 10),
                            Text('Nu sunt date'),
                          ],
                        ),
                      ))
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        itemCount: eventsList.length,
                        itemBuilder: (context, index) {
                          return EventCard(
                              parentKey: parentKey,
                              handleDetailPage: handleDetailPage,
                              event: eventsList[index]);
                        },
                      ),
                if (isLoading)
                  Center(
                      child: Padding(
                    padding: const EdgeInsets.only(top: 100.0),
                    child: CircularProgressIndicator(),
                  )),
              ]))),
      bottomNavigationBar: Container(
        color: Color(0xfffefefe),
        // Background color
        padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 16.0),
        // Padding for the container, excluding top
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            buildNavItem(
              icon: Icons.explore,
              text: 'Explorează',
              isActive: false,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(Home.routeName);
              },
            ),
            buildNavItem(
              icon: Icons.favorite,
              text: 'Favorite',
              isActive: false,
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(FavoritesScreen.routeName);
              },
            ),
            buildNavItem(
              icon: Icons.event,
              text: 'Evenimente',
              isActive: true,
            ),
            buildNavItem(
              icon: Icons.account_circle,
              text: 'Profil',
              isActive: false,
              onPressed: () {
                Navigator.of(context).pushNamed(ProfileScreen.routeName);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem(
      {IconData icon, String text, bool isActive, VoidCallback onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: isActive
                ? Colors.blue
                : Colors.black, // Change color based on isActive
          ),
          onPressed: onPressed,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.0,
            color: isActive
                ? Colors.blue
                : Colors.black, // Change color based on isActive
          ),
        ),
      ],
    );
  }
}

class EventCard extends StatelessWidget {
  final EventModel event;

  // Receive GlobalKey from parent widget
  final GlobalKey<_EventsState> parentKey;

  // Receive handleTap function from parent widget
  final Function(bool) handleDetailPage;

  EventCard(
      {@required this.event,
      @required this.parentKey,
      @required this.handleDetailPage});

  _navigateToDetailPage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => EventDetails(
                  event: event,
                )));

    if (result) {
      handleDetailPage(true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToDetailPage(context);
      },
      child: Card(
        margin: EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 4,
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: MemoryImage(base64Decode(event.preViewImg)),
                      fit: BoxFit.cover,
                    ),
                  ),
                )),
            Expanded(
              flex: 6,
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20.0),
                    Center(
                      child: Text(
                        event.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 45.0),
                    Divider(),
                    SizedBox(height: 15.0),
                    Center(
                        child: Text(
                      '${event.eventDate.toIso8601String().split('T').first} ${event.eventDate.hour}:${event.eventDate.minute}',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
