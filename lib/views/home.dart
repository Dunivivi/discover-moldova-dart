import 'dart:convert';

import 'package:discounttour/api/event.dart';
import 'package:discounttour/data/data.dart';
import 'package:discounttour/views/details.dart';
import 'package:discounttour/views/favorites.dart';
import 'package:discounttour/views/profile.dart';
import 'package:flutter/material.dart';

import '../model/event_model.dart';

class Home extends StatefulWidget {
  static const routeName = '/home';

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  // Define GlobalKey
  GlobalKey<_HomeState> parentKey = GlobalKey<_HomeState>();

  List<EventModel> eventList = new List();
  List<EventModel> recommendedEventList = new List();

  ScrollController _scrollController = ScrollController();

  var currentPage = 0;
  var totalCount;
  String selectedCategory;

  bool isLoading = false;
  bool isFetchingSuggestions = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
    _loadRecommended();
    selectedCategory = "Toate";
    _loadDataByCategory(selectedCategory);
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
        totalCount != eventList.length) {
      currentPage += 1;
      _paginateDataByCategory(selectedCategory);
    }
  }

  void handleCategoryTap(String category) {
    print("Handle category $category");
    _loadDataByCategory(category);
  }

  void handleDetailPage(bool state) {
    if (state) {
      resetData();
    }
  }

  resetData() {
    _loadRecommended();
    _loadDataByCategory(selectedCategory);
  }

  _loadDataByCategory(category) async {
    selectedCategory = category;
    currentPage = 0;
    eventList = [];
    totalCount = 0;

    setState(() {
      isLoading = true; // Set loading state to true
    });
    await EventService().fetchEventsByCategory(currentPage, category).then(
        (data) => {
              eventList.addAll(data['events']),
              totalCount = int.parse(data['totalCount'])
            });
    setState(() {
      isLoading = false; // Set loading state to false
    });
  }

  _paginateDataByCategory(category) async {
    setState(() {
      isLoading = true; // Set loading state to true
    });
    await EventService().fetchEventsByCategory(currentPage, category).then(
        (data) => {
              eventList.addAll(data['events']),
              totalCount = int.parse(data['totalCount'])
            });
    setState(() {
      isLoading = false; // Set loading state to false
    });
  }

  Future<void> _loadRecommended() async {
    recommendedEventList = [];
    setState(() {
      isFetchingSuggestions = true; // Set loading state to true
    });
    await EventService().fetchRecommendedEvents().then((data) => {
          recommendedEventList.addAll(data['events']),
        });
    setState(() {
      isFetchingSuggestions = false; // Set loading state to false
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
            Padding(
              padding: EdgeInsets.only(right: 8.0),
              // Adjust the value as needed
              child: Image.asset(
                "assets/logo.png",
                height: 30,
              ),
            ),
            Text(
              "Descoperă Moldova",
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Pentru tine",
                style: TextStyle(
                    fontSize: 28,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 8,
              ),
              // ),
              Container(
                height: 240,
                child: isFetchingSuggestions
                    ? Center(
                        child:
                            CircularProgressIndicator(), // Show loading indicator
                      )
                    : ListView.builder(
                        itemCount: recommendedEventList.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return RecommendedList(
                            parentKey: parentKey,
                            handleDetailPage: handleDetailPage,
                            event: recommendedEventList[index],
                          );
                        },
                      ),
              ),
              SizedBox(
                height: 8,
              ),
              Text(
                "Categorii",
                style: TextStyle(
                    fontSize: 20,
                    color: Colors.black54,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 16,
              ),
              CategoryList(
                parentKey: parentKey,
                handleTap: handleCategoryTap,
              ),
              ListView.builder(
                  padding: EdgeInsets.only(top: 10),
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  itemCount: eventList.length,
                  itemBuilder: (context, index) {
                    return EventScrollList(
                      parentKey: parentKey,
                      handleDetailPage: handleDetailPage,
                      event: eventList[index],
                    );
                  }),
              if (isLoading)
                Center(
                  child: LinearProgressIndicator(),
                ),
            ],
          ),
        ),
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
              isActive: true,
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
                icon: Icons.event, text: 'Evenimente', isActive: false),
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
  final GlobalKey<_HomeState> parentKey;

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
  final GlobalKey<_HomeState> parentKey;

  // Receive handleTap function from parent widget
  final Function(bool) handleDetailPage;

  EventScrollList(
      {@required this.event, @required this.parentKey, this.handleDetailPage});

  _navigateToDetailPage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Details(
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
                  width: 110, height: 90, fit: BoxFit.cover),
              // child: CachedNetworkImage(
              //   imageUrl: "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQUZ7hBdZG6uZv5nN7MpXPoGQtPEDODiMx6eA9RitZ3Ew&s",
              //   width: 110,
              //   height: 90,
              //   fit: BoxFit.cover,
              // ),
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
                      overflow: TextOverflow.fade,
                      style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: Color(0xff89A097)),
                    ),
                    SizedBox(
                      height: 6,
                    ),
                    // Text(
                    //   "$price MDL",
                    //   style: TextStyle(
                    //       fontSize: 16,
                    //       fontWeight: FontWeight.w600,
                    //       color: Color(0xff4E6059)),
                    // )
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

class RecommendedList extends StatelessWidget {
  final EventModel event;

  // Receive GlobalKey from parent widget
  final GlobalKey<_HomeState> parentKey;

  // Receive handleTap function from parent widget
  final Function(bool) handleDetailPage;

  RecommendedList(
      {@required this.event,
      @required this.parentKey,
      @required this.handleDetailPage});

  _navigateToDetailPage(BuildContext context) async {
    final result = await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => Details(
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
        child: Container(
          margin: EdgeInsets.only(right: 8),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.memory(
                  base64Decode(event.preViewImg),
                  height: 220,
                  width: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Container(
                height: 200,
                width: 150,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Container(
                            margin: EdgeInsets.only(left: 8, top: 8),
                            padding: EdgeInsets.symmetric(
                                vertical: 6, horizontal: 8),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                color: Colors.white38),
                            child: Text(
                              "New",
                              style: TextStyle(color: Colors.white),
                            ))
                      ],
                    ),
                    Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(
                                bottom: 0, left: 8, right: 8, top: 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  child: Text(
                                    event.title,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                SizedBox(height: 3),
                                Text(
                                  event.noOfTours.toString() +
                                      " vizite recente",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(bottom: 0, right: 5, top: 30),
                          padding:
                              EdgeInsets.symmetric(horizontal: 3, vertical: 7),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.white38,
                          ),
                          child: Column(
                            children: [
                              Text(
                                event.rating.toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 13,
                                ),
                              ),
                              SizedBox(height: 2),
                              Icon(
                                Icons.star,
                                color: Colors.white,
                                size: 20,
                              )
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
