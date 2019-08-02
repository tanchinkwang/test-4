import 'dart:async';
import 'package:flutter/services.dart';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';



void main() => runApp(MyApp());


class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  Position _lastKnownPosition;
  Position _currentPosition;

  @override
  void initState() {
    super.initState();
    _currentPosition = new Position(longitude: 50.0, latitude: 50.0);  // ADD default location

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  @override
  void didUpdateWidget(Widget oldWidget) {
    super.didUpdateWidget(oldWidget);

    setState(() {
      _lastKnownPosition = null;
      _currentPosition = null;
    });

    _initLastKnownLocation();
    _initCurrentLocation();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _initLastKnownLocation() async {
    Position position;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final Geolocator geolocator = Geolocator()
        ..forceAndroidLocationManager = false ;
      position = await geolocator.getLastKnownPosition(
          desiredAccuracy: LocationAccuracy.best);
    } on PlatformException {
      position = null;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) {
      return;
    }

    setState(() {
      _lastKnownPosition = position;
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  _initCurrentLocation() {
    Geolocator()
      ..forceAndroidLocationManager = false
      ..getCurrentPosition(
        desiredAccuracy: LocationAccuracy.best,
      ).then((position) {
        if (mounted) {
          setState(() => _currentPosition = position);
        }
      }).catchError((e) {
        //
      });
  }

  GoogleMapController mapController;

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Testing_3 App'),
          backgroundColor: Colors.green[700],
        ),
         body: Center(
          child: Column(
            children: <Widget>[
              Expanded(
                child: Container(
                  child: GoogleMap(
                    onMapCreated: _onMapCreated,
                    initialCameraPosition: CameraPosition(
                      target: LatLng(_currentPosition.latitude, _currentPosition.longitude), // delete _center
                      zoom: 11.0,
                    ),
                  ),
                )
              ), // THIS ONE U LESS ONE BACKET
              Container(
                height: 200,
                child: Card(
                  child: new Form(
                    child: new Column(
                      children: <Widget>[
                        new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new TextFormField(
                            decoration: new InputDecoration(labelText: "FROM"),
                          ),
                        ),
                        new Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: new TextFormField(
                            decoration: new InputDecoration(labelText: "DESTINATION"),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
