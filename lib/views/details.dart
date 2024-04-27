import 'dart:convert';

import 'package:discounttour/model/country_model.dart';
import 'package:discounttour/model/event_model.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';

import '../api/event.dart';
import '../data/data.dart';
import '../utils/map_utils.dart';
import '../widget/photo-view-page.dart';

class Details extends StatefulWidget {
  final EventModel event;

  Details({@required this.event});

  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  List<CountryModel> country = new List();

  bool isFavorite = false;

  @override
  void initState() {
    country = getCountrys();
    isFavorite = widget.event.favorite;
    super.initState();
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
                                            "${widget.event.description}",
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
                                height: 8,
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  RatingBar(widget.event.rating.round()),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "${widget.event.rating}",
                                    style: TextStyle(
                                        color: Colors.white70,
                                        fontWeight: FontWeight.w600,
                                        fontSize: 17),
                                  )
                                ],
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
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              //   children: [
              //     FeaturesTile(
              //       icon: Icon(Icons.wifi, color: Color(0xff5A6C64)),
              //       label: "Free Wi-Fi",
              //     ),
              //     FeaturesTile(
              //       icon: Icon(Icons.beach_access, color: Color(0xff5A6C64)),
              //       label: "Sand Beach",
              //     ),
              //     FeaturesTile(
              //       icon: Icon(Icons.card_travel, color: Color(0xff5A6C64)),
              //       label: "First Coastline",
              //     ),
              //     FeaturesTile(
              //       icon: Icon(Icons.local_drink, color: Color(0xff5A6C64)),
              //       label: "bar and Resturant",
              //     )
              //   ],
              // ),
              SizedBox(
                height: 12,
              ),
              Row(
                children: [
                  Expanded(
                    // Wrap in Expanded widget
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 24),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.black,
                            size: 25,
                          ),
                          SizedBox(
                            width: 8,
                          ),
                          Expanded(
                            // Wrap Text widget in Expanded
                            child: Text(
                              "${widget.event.location}",
                              style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontSize: 17,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 16,
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
              Container(
                margin: EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    DetailsCard(
                      rating: widget.event.rating,
                      noOfReviews: widget.event.noOfTours,
                      url: widget.event.url,
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 15,
              ),
              Container(
                height: 240,
                child: widget.event.assets.length != null
                    ? ListView.builder(
                        padding: EdgeInsets.symmetric(horizontal: 24),
                        itemCount: widget.event.assets.length,
                        shrinkWrap: true,
                        physics: ClampingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return ImageListTile(
                            imgUrl: widget.event.assets[index].url,
                          );
                        },
                      )
                    : SizedBox(), // Display an empty SizedBox if assets is empty
              ),
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              onPressed: () {
                // Add your onTap function logic here
                print('Button tapped');
                MapUtils.openMap(
                  double.parse(widget.event.lat),
                  double.parse(widget.event.longitudine),
                );
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
                child: Text('Vizitează acum',
                    style: TextStyle(fontSize: 16)), // Button text
              ),
            ),
            // ElevatedButton(
            //   onPressed: () {
            //     // Add your phone button logic here
            //     MapUtils.callPhone('+37368768951');
            //     // call('tel:+');
            //     // Add your phone call logic here
            //   },
            //   style: ElevatedButton.styleFrom(
            //     primary: Colors.white,
            //     // Background color
            //     onPrimary: Colors.black,
            //     // Text color
            //     padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            //     // Adjust padding
            //     shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(10), // Border radius
            //     ),
            //   ),
            //   child: Icon(Icons.phone), // Phone icon
            // ),
          ],
        ),
      ),
    );
  }

  Widget buildNavItem({IconData icon, String text, VoidCallback onPressed}) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: Icon(
            icon,
            color: Colors.black, // Change color based on isActive
          ),
          onPressed: onPressed,
        ),
        Text(
          text,
          style: TextStyle(
            fontSize: 12.0,
            color: Colors.black, // Change color based on isActive
          ),
        ),
      ],
    );
  }
}

class DetailsCard extends StatelessWidget {
  final String title;
  final String url;
  final int noOfReviews;
  final double rating;

  DetailsCard({this.rating, this.title, this.noOfReviews, this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (() => MapUtils.openUrl("${url}")),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
              color: Color(0xffE9F4F9),
              borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                        color: Color(0xffD5E6F2),
                        borderRadius: BorderRadius.circular(10)),
                    child: Icon(
                        Icons.cloud_circle,
                      color: Colors.black,
                      size: 24,
                      // "assets/card1.png",
                      // height: 30,
                    ),
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Pagină web",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff5A6C64)),
                      ),
                      // SizedBox(
                      //   height: 6,
                      // ),
                      // Text(
                      //   "$rating/5",
                      //   textAlign: TextAlign.center,
                      //   style: TextStyle(
                      //       fontSize: 14,
                      //       fontWeight: FontWeight.w600,
                      //       color: Color(0xff5A6C64)),
                      // )
                    ],
                  ),
                ],
              ),
              // SizedBox(
              //   height: 8,
              // ),
              // Text(
              //   "În baza a $noOfReviews recenzii",
              //   textAlign: TextAlign.center,
              //   style: TextStyle(
              //       fontSize: 14,
              //       fontWeight: FontWeight.w600,
              //       color: Color(0xff879D95)),
              // ),
            ],
          ),
        ));
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

class RatingBar extends StatelessWidget {
  final int rating;

  RatingBar(this.rating);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(
          Icons.star,
          color: rating >= 1 ? Colors.white70 : Colors.white30,
        ),
        SizedBox(
          width: 3,
        ),
        Icon(
          Icons.star,
          color: rating >= 2 ? Colors.white70 : Colors.white30,
        ),
        SizedBox(
          width: 3,
        ),
        Icon(
          Icons.star,
          color: rating >= 3 ? Colors.white70 : Colors.white30,
        ),
        SizedBox(
          width: 3,
        ),
        Icon(
          Icons.star,
          color: rating >= 4 ? Colors.white70 : Colors.white30,
        ),
        SizedBox(
          width: 3,
        ),
        Icon(
          Icons.star,
          color: rating >= 5 ? Colors.white70 : Colors.white30,
        ),
      ],
    ));
  }
}

class ImageListTile extends StatelessWidget {
  final String imgUrl;

  ImageListTile({@required this.imgUrl});

  @override
  Widget build(BuildContext context) {
    print(imgUrl);

    return InkWell(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PhotoViewPage(base64String: imgUrl),
        ),
      ),
      child: Container(
        margin: EdgeInsets.only(right: 8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          // child:
          // Image.memory(base64Decode(imgUrl),
          //     height: 350,
          //     width: MediaQuery.of(context).size.width,
          //     fit: BoxFit.cover),
          child: Image.memory(
            base64Decode(imgUrl),
            height: 220,
            width: 150,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
