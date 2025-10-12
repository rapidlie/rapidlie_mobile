import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MapDirectionLauncher extends StatefulWidget {
  final LatLng targetLocation;

  MapDirectionLauncher({required this.targetLocation});

  @override
  _MapDirectionLauncherState createState() => _MapDirectionLauncherState();
}

class _MapDirectionLauncherState extends State<MapDirectionLauncher> {
  GoogleMapController? _controller;
  LatLng? _currentPosition;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location services are disabled.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Location permissions are denied')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request them.')));
      return;
    }

    try {
      Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      if (!mounted) return;
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not get current location.')));
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    _controller = controller;
  }

  Future<void> _openDirections() async {
    if (_currentPosition == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Waiting for current location...')));
      return;
    }

    final String origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final String destination =
        '${widget.targetLocation.latitude},${widget.targetLocation.longitude}';
    String url;
    if (Platform.isIOS) {
      url = 'http://maps.apple.com/?saddr=$origin&daddr=$destination&dirflg=d';
    } else {
      url =
          'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving';
    }

    final uri = Uri.parse(url);

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not open maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    return Container(
      height: 200,
      width: width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 6,
            offset: Offset(0, 5), // changes position of shadow
          ),
        ],
      ),
      child: Stack(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(borderRadius),
            child: GoogleMap(
              onMapCreated: _onMapCreated,
              scrollGesturesEnabled: false,
              zoomGesturesEnabled: false,
              myLocationButtonEnabled: false,
              initialCameraPosition: CameraPosition(
                target: widget.targetLocation,
                zoom: 16.0,
              ),
              mapType: MapType.normal,
              markers: {
                Marker(
                  markerId: MarkerId("eventLocation"),
                  position: widget.targetLocation,
                  icon: BitmapDescriptor.defaultMarkerWithHue(
                    BitmapDescriptor.hueCyan,
                  ),
                )
              },
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(borderRadius),
                onTap: () {
                  _openDirections();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
