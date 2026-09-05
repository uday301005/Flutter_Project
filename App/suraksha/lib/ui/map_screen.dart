import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import '../services/appwrite_services.dart';
import 'package:appwrite/appwrite.dart';
import 'package:geolocator/geolocator.dart';

class MapScreen extends StatefulWidget {
  final String userId;
  final double lat;
  final double lon;
  final String alertId;

  const MapScreen({
    super.key,
    required this.userId,
    required this.lat,
    required this.lon,
    required this.alertId,
  });

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late LatLng userLocation;
  LatLng? helperLocation;
  double distanceKm = 0;
  GoogleMapController? mapController;
  Timer? timer;
  Set<Marker> markers = {};
  final AppwriteService _appwriteService = AppwriteService();

  RealtimeSubscription? _alertSubscription;

  RealtimeSubscription? _subscription;

  Future<void> loadHelperLocation() async {
    final myPos = await Geolocator.getCurrentPosition();

    setState(() {
      helperLocation = LatLng(
        myPos.latitude,
        myPos.longitude,
      );
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    mapController?.dispose();
    _subscription?.close();
    _alertSubscription?.close();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    loadHelperLocation();
    userLocation = LatLng(widget.lat, widget.lon);
    // initial marker
    markers.add(
      Marker(
        markerId: const MarkerId("user"),
        position: userLocation,
      ),
    );
    _subscription = _appwriteService.subscribeToLocation(
      widget.userId,
          (data) {
            debugPrint("📍 MAP UPDATE RECEIVED");
            debugPrint(data.toString());



            final lat = (data['latitude'] as num).toDouble();
        final lon = (data['longitude'] as num).toDouble();

        userLocation = LatLng(lat, lon);
            if (helperLocation != null) {
              distanceKm =
                  Geolocator.distanceBetween(
                    helperLocation!.latitude,
                    helperLocation!.longitude,
                    lat,
                    lon,
                  ) /
                      1000;
            }

        setState(() {
          markers = {
            Marker(
              markerId: const MarkerId("victim"),
              position: userLocation,
              infoWindow: const InfoWindow(
                title: "Victim",
              ),
            ),

            if (helperLocation != null)
              Marker(
                markerId: const MarkerId("helper"),
                position: helperLocation!,
                infoWindow: const InfoWindow(
                  title: "You",
                ),
              ),
          };
        });

        mapController?.animateCamera(
          CameraUpdate.newLatLng(userLocation),
        );
      },


    );

    _alertSubscription =
        _appwriteService.subscribeToAlert(
          widget.alertId,
              (data) {

            if (data['status'] == 'closed') {

              if (!mounted) return;

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text("SOS Ended"),
                ),
              );

              Navigator.pop(context);
            }
          },
        );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Live Location")),
      body: Stack(
        children: [

          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: userLocation,
              zoom: 15,
            ),
            markers: markers,
            onMapCreated: (controller) {
              mapController = controller;
            },
          ),

          Positioned(
            top: 15,
            left: 15,
            child: Card(
              child: Padding(
                padding: EdgeInsets.all(8),
                child: Text(
                  "Distance: ${distanceKm.toStringAsFixed(2)} km",
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}