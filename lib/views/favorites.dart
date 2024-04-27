import 'dart:convert';

import 'package:discounttour/views/events/events-detail.dart';
import 'package:discounttour/views/home.dart';
import 'package:discounttour/views/profile/profile.dart';
import 'package:flutter/material.dart';

import '../api/event.dart';
import '../data/data.dart';
import '../model/event_model.dart';
import 'details.dart';
import 'events/events.dart';

class FavoritesScreen extends StatefulWidget {
  static const routeName = '/favorites';

  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<FavoritesScreen> {
  List<EventModel> favoritesList = new List();

  // Define GlobalKey
  GlobalKey<_FavoritesState> parentKey = GlobalKey<_FavoritesState>();

  var currentPage = 0;
  var totalCount;
  String selectedCategory;

  bool isLoading = false;

  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    selectedCategory = "Toate";
    _paginateDataByCategory(selectedCategory);
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
        totalCount != favoritesList.length) {
      currentPage += 1;
      _paginateDataByCategory(selectedCategory);
    }
  }

  void handleCategoryTap(String category) {
    print("Handle category $category");
    selectedCategory = category;
    resetData();
  }

  void handleDetailPage(bool state) {
    if (state) {
      resetData();
    }
  }

  void resetData() {
    totalCount = 0;
    currentPage = 0;
    favoritesList = [];
    _paginateDataByCategory(selectedCategory);
  }

  _paginateDataByCategory(category) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });
    await EventService().fetchFavoritesEvents(currentPage, category).then(
        (data) => {
              favoritesList.addAll(data['events']),
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
              "Favorite",
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
              padding: EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                children: [
                  CategoryList(
                    parentKey: parentKey,
                    handleTap: handleCategoryTap,
                  ),
                  favoritesList.isEmpty && !isLoading
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
                          padding: EdgeInsets.only(top: 10),
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: favoritesList.length,
                          itemBuilder: (context, index) {
                            return EventScrollList(
                              parentKey: parentKey,
                              handleDetailPage: handleDetailPage,
                              event: favoritesList[index],
                            );
                          }),
                  if (isLoading)
                    Center(
                        child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: CircularProgressIndicator(),
                    )),
                ],
              ))),
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
                icon: Icons.favorite, text: 'Favorite', isActive: true),
            buildNavItem(
              icon: Icons.event,
              text: 'Evenimente',
              isActive: false,
              onPressed: () {
                Navigator.of(context)
                    .pushReplacementNamed(EventsScreen.routeName);
              },
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

class CategoryList extends StatefulWidget {
  // Receive GlobalKey from parent widget
  final GlobalKey<_FavoritesState> parentKey;

  // Receive handleTap function from parent widget
  final Function(String) handleTap;

  // Constructor
  CategoryList({this.parentKey, @required this.handleTap});

  @override
  _CategoryListState createState() => _CategoryListState();
}

class _CategoryListState extends State<CategoryList> {
  String selectedCategory;

  final List<String> categories = getCategories();

  @override
  void initState() {
    super.initState();
    selectedCategory = categories.first;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories
            .map((category) => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8.0),
                  // Adjust horizontal spacing between categories
                  child: CategoryButton(
                    category: category,
                    isSelected: category == selectedCategory,
                    onPressed: () {
                      setState(() {
                        selectedCategory = category;
                      });
                      widget.handleTap(category);
                    },
                  ),
                ))
            .toList(),
      ),
    );
  }
}

class CategoryButton extends StatelessWidget {
  final String category;
  final bool isSelected;
  final VoidCallback onPressed;

  CategoryButton({this.category, this.isSelected, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xff454545) : Color(0xfffefefe),
          // Background color
          borderRadius: BorderRadius.circular(15.0), // Border radius
        ),
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        // Adjust padding as needed
        child: Center(
          child: Text(
            category,
            style: TextStyle(
              color: isSelected ? Colors.white : Colors.black, // Text color
            ),
          ),
        ),
      ),
    );
  }
}

class EventScrollList extends StatelessWidget {
  final EventModel event;

  // Receive GlobalKey from parent widget
  final GlobalKey<_FavoritesState> parentKey;

  // Receive handleTap function from parent widget
  final Function(bool) handleDetailPage;

  EventScrollList(
      {@required this.event, @required this.parentKey, this.handleDetailPage});

  _navigateToDetailPage(BuildContext context) async {

    if (event.type == 'Evenimente') {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  EventDetails(
                    event: event,
                  )));
      if (result) {
        handleDetailPage(true);
      }
    } else {
      final result = await Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) =>
                  Details(
                    event: event,
                  )));
      if (result) {
        handleDetailPage(true);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _navigateToDetailPage(context);
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
            color: Color(0xffE9F4F9), borderRadius: BorderRadius.circular(20)),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20)),
              child: Image.memory(base64Decode(event.preViewImg),
                  width: 130, height: 130, fit: BoxFit.cover),
            ),
            Expanded(
              // To make the first container take 80% of the width
              flex: 8, // 8
              child: // 0% of available
                  Container(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xff4E6059)),
                    ),
                    SizedBox(
                      height: 3,
                    ),
                    Text(
                      event.description,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff89A097)),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                  ],
                ),
              ),
            ),
            Container(
                margin: EdgeInsets.only(bottom: 10, right: 8),
                padding: EdgeInsets.symmetric(horizontal: 4, vertical: 8),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(6),
                    color: Color(0xff139157)),
                child: Column(
                  children: [
                    Text(
                      "${event.rating}",
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                          fontSize: 12),
                    ),
                    SizedBox(
                      height: 2,
                    ),
                    Icon(
                      Icons.star,
                      color: Colors.white,
                      size: 20,
                    )
                  ],
                ))
          ],
        ),
      ),
    );
  }
}
