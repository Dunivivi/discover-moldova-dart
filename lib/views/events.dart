import 'package:discounttour/views/favorites.dart';
import 'package:discounttour/views/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../api/event.dart';
import '../model/event_model.dart';
import 'home.dart';

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
    // _paginateData();
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
    await EventService().fetchActivitiesEvents(currentPage).then((data) =>
    {
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
              icon: Icons.favorite, text: 'Favorite', isActive: false,
              onPressed: () {
                Navigator.of(context).pushReplacementNamed(
                    FavoritesScreen.routeName);
              },
            ),
            buildNavItem(
              icon: Icons.event,
              text: 'Evenimente',
              isActive: false,
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
