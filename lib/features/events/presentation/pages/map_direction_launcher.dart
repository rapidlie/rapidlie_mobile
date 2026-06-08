import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:url_launcher/url_launcher.dart';

class MapDirectionLauncher extends StatefulWidget {
  final LatLng targetLocation;

  const MapDirectionLauncher({super.key, required this.targetLocation});

  @override
  _MapDirectionLauncherState createState() => _MapDirectionLauncherState();
}

class _MapDirectionLauncherState extends State<MapDirectionLauncher> {
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
          const SnackBar(content: Text('Location services are disabled.')));
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Location permissions are permanently denied.')));
      return;
    }

    try {
      final position = await Geolocator.getCurrentPosition(
          locationSettings:
              const LocationSettings(accuracy: LocationAccuracy.high));
      if (!mounted) return;
      setState(() {
        _currentPosition = LatLng(position.latitude, position.longitude);
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Could not get current location.')));
    }
  }

  Future<void> _openDirections() async {
    if (_currentPosition == null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Waiting for current location...')));
      return;
    }

    final origin =
        '${_currentPosition!.latitude},${_currentPosition!.longitude}';
    final destination =
        '${widget.targetLocation.latitude},${widget.targetLocation.longitude}';

    final String url = Platform.isIOS
        ? 'http://maps.apple.com/?saddr=$origin&daddr=$destination&dirflg=d'
        : 'https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$destination&travelmode=driving';

    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not open maps.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(borderRadius),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                initialCenter: widget.targetLocation,
                initialZoom: 15.5,
                interactionOptions:
                    const InteractionOptions(flags: InteractiveFlag.none),
              ),
              children: [
                TileLayer(
                  urlTemplate:
                      'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  userAgentPackageName: 'com.rapidlie.app',
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                      point: widget.targetLocation,
                      width: 40,
                      height: 40,
                      child: Icon(
                        Icons.location_on,
                        color: primary,
                        size: 36,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  borderRadius: BorderRadius.circular(borderRadius),
                  onTap: _openDirections,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
