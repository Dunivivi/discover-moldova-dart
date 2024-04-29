// Copyright (c) 2020. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// SimpleLocationPicker screen that displays the location picker with openstreetmaps
///
///  To Use: Navigate to display this screen
///
/// Works in two modes
///  1. Picker Mode: This is the default mode to pick a location and save it
///  2. DisplayOnly Mode: This displays a fixed location without being able to change it

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart' as slpMap;

import '../../utils/slp_constants.dart';
import 'location-result.dart';

class SimpleLocationPicker extends StatefulWidget {
  /// Sets the initial location - latitude that the map must be centered on.
  final double initialLatitude;

  /// Sets initial location - longitude that the map must be centered on.
  final double initialLongitude;

  /// Sets the map zoom level.
  final double zoomLevel;

  /// Sets the mode of the picker.
  /// if true: enables DisplayOnly mode to display a marker on the map at a location only, no selection
  /// if false: enabled Picker mode allows to tap on the map to pick a location
  final bool displayOnly;

  /// Sets the appbar background color for the picker screen.
  final Color appBarColor;

  /// Sets the map marker icon background color.
  final Color markerColor;

  /// Sets the appbar text color.
  final Color appBarTextColor;

  /// Sets the appbar text color.
  final String appBarTitle;

  SimpleLocationPicker(
      {this.initialLatitude = SLPConstants.DEFAULT_LATITUDE,
        this.initialLongitude = SLPConstants.DEFAULT_LONGITUDE,
        this.zoomLevel = SLPConstants.DEFAULT_ZOOM_LEVEL,
        this.displayOnly = false,
        this.appBarColor = Colors.blueAccent,
        this.appBarTextColor = Colors.white,
        this.appBarTitle = "Select Location",
        this.markerColor = Colors.blueAccent});

  @override
  _SimpleLocationPickerState createState() => _SimpleLocationPickerState();
}

class _SimpleLocationPickerState extends State<SimpleLocationPicker> {
  // Holds the value of the picked location.
  SimpleLocationResult _selectedLocation;

  void initState() {
    super.initState();
    _selectedLocation =
        SimpleLocationResult(widget.initialLatitude, widget.initialLongitude);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: widget.appBarColor,
        title: Text(widget.appBarTitle,
            style: TextStyle(color: widget.appBarTextColor)),
        actions: <Widget>[
          // DISPLAY_ONLY MODE: no save button for display only mode
          widget.displayOnly
              ? Container()
              : IconButton(
            icon: Icon(Icons.save),
            onPressed: () {
              Navigator.of(context).pop(_selectedLocation);
            },
            color: widget.appBarTextColor,
          ),
        ],
      ),
      body: _osmWidget(),
    );
  }

  /// Returns a widget containing the openstreetmaps screen.
  Widget _osmWidget() {
    return slpMap.FlutterMap(
        options: slpMap.MapOptions(
            center: _selectedLocation.getLatLng(),
            zoom: widget.zoomLevel,
            onTap: (tapLoc) {
              // DISPLAY_ONLY MODE: no map taps for display only mode
              if (!widget.displayOnly) {
                setState(() {
                  _selectedLocation =
                      SimpleLocationResult(tapLoc.latitude, tapLoc.longitude);
                });
              }
            }),
        layers: [
          slpMap.TileLayerOptions(
              urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
              subdomains: ['a', 'b', 'c']),
          slpMap.MarkerLayerOptions(markers: [
            slpMap.Marker(
                width: 80.0,
                height: 80.0,
                anchorPos: slpMap.AnchorPos.align(slpMap.AnchorAlign.top),
                point: _selectedLocation.getLatLng(),
                builder: (ctx) {
                  return Icon(Icons.room, size: 80, color: widget.markerColor);
                })
          ])
        ]);
  }
}