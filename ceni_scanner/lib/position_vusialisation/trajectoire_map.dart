import 'package:ceni_scanner/constant.dart';
import 'package:ceni_scanner/position_vusialisation/position_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/material.dart';

class TrajectoryPage extends StatefulWidget {
  static const String pageRoute = "/trajectory_page";
  final List<ObjectPosition> trajet;

  const TrajectoryPage({Key? key, required this.trajet}) : super(key: key);

  @override
  _TrajectoryPageState createState() => _TrajectoryPageState();
}

class _TrajectoryPageState extends State<TrajectoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Trajectoire'),
        backgroundColor: AppConstants.primaryColor,
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Display trajectory details (e.g., object ID, source, destination)
          const Text('Détails de la trajectoire'),

          // Display the trajectory map
          Expanded(
            child: _showTrajectoryMap(widget.trajet),
          ),
        ],
      ),
    );
  }

  Widget _showTrajectoryMap(List<ObjectPosition> trajet) {
    final Set<Polyline> polylines = {}; // To store the polyline
    final List<LatLng> latLngList = trajet
        .map((position) => LatLng(position.latitude, position.longitude))
        .toList();

    polylines.add(Polyline(
      polylineId: const PolylineId('trajectory'),
      points: latLngList,
      color: Colors.blue,
      width: 3,
    ));

    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: LatLng(trajet.first.latitude, trajet.first.longitude),
        zoom: 12.0,
      ),
      markers: _createMarkers(trajet), // Call the marker creation function
      polylines: polylines,
    );
  }

  // Helper function to create markers (remains the same)
  Set<Marker> _createMarkers(List<ObjectPosition> trajet) {
    final Set<Marker> markers = {};
    for (final position in trajet) {
      markers.add(Marker(
        markerId: MarkerId(position.toString()),
        position: LatLng((position.latitude), position.longitude),
        infoWindow: InfoWindow(
          title: 'Trajet Point',
          snippet: 'Lat: ${position.latitude}, Lng: ${position.longitude}',
        ),
      ));
    }
    return markers;
  }
}
