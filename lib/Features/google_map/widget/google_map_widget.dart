import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class GoogleMapWidget extends StatefulWidget {
  const GoogleMapWidget({super.key});

  @override
  State<GoogleMapWidget> createState() => _GoogleMapWidgetState();
}

class _GoogleMapWidgetState extends State<GoogleMapWidget> {
  String _mapStyle = '';

  GoogleMapController? googleMapController;
  BitmapDescriptor? sourceIcon;
  BitmapDescriptor? destinationIcon;

  Set<Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  List<LatLng> polylineCoordinatesFromCurrentLocationToSourceLocation = [];
  final PolylinePoints polylinePoints = PolylinePoints();
  Set<Marker> markers = {};

  LatLng? sourceLoc;
  LatLng? destinationLoc = const LatLng(22.5754, 88.4798);

  LocationData? currentLocation;
  Location location = Location();

  @override
  void initState() {
    getCurrentLocation();

    startLocationUpdates();

    if (sourceLoc != null && destinationLoc != null) {
      fetchPolylineFromSourceLocationToDestinationLocation();
    }
    super.initState();
  }

  @override
  void dispose() {
    googleMapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    setState(() {
      googleMapController = controller;
      controller.setMapStyle(_mapStyle);
    });
  }

  Future<void> getCurrentLocation() async {
    try {
      currentLocation = await location.getLocation();
    } catch (e) {
      currentLocation = null;
    }

    if (currentLocation != null) {
      googleMapController?.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target:
                LatLng(currentLocation!.latitude!, currentLocation!.longitude!),
            zoom: 15.0,
          ),
        ),
      );

      updateMarkers();
    }
  }

  void updateMarkers() async {
    markers.clear();

    /// configure marker icons for source and destination location
    markers.addAll([
      Marker(
        markerId: const MarkerId('current_location_id'),
        position: LatLng(
          currentLocation != null ? currentLocation!.latitude! : 0.0,
          currentLocation != null ? currentLocation!.longitude! : 0.0,
        ),
      ),
      if (sourceLoc != null)
        Marker(
          markerId: const MarkerId('source_location_marker_id'),
          position: sourceLoc ?? const LatLng(0.0, 0.0),
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/icons/source-icon.png"),
        ),
      if (destinationLoc != null)
        Marker(
          markerId: const MarkerId('destination_location_marker_id'),
          position: destinationLoc ?? const LatLng(0.0, 0.0),
          icon: await BitmapDescriptor.fromAssetImage(
              const ImageConfiguration(), "assets/icons/destination-icon.png"),
        ),
    ]);

    // await fetchPolylineFromCurrentLocationToSourceLocation();
  }

  void startLocationUpdates() {
    location.enableBackgroundMode(enable: true);
    location.onLocationChanged.listen((LocationData newLocation) {
      setState(() {
        currentLocation = newLocation;
        updateMarkers();
      });
    });
  }

  Future<void> fetchPolylineFromSourceLocationToDestinationLocation() async {
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      'AIzaSyCq81eVlh3DH1AmkxwuCf0Da8azyTnZcH8',
      PointLatLng(sourceLoc!.latitude, sourceLoc!.longitude),
      PointLatLng(destinationLoc!.latitude, destinationLoc!.longitude),
    );

    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    await googleMapController?.animateCamera(CameraUpdate.newLatLngBounds(
        LatLngBounds(
            southwest: LatLng(
              sourceLoc!.latitude <= destinationLoc!.latitude
                  ? sourceLoc!.latitude
                  : destinationLoc!.latitude,
              sourceLoc!.longitude <= destinationLoc!.longitude
                  ? sourceLoc!.longitude
                  : destinationLoc!.longitude,
            ),
            northeast: LatLng(
              sourceLoc!.latitude <= destinationLoc!.latitude
                  ? destinationLoc!.latitude
                  : sourceLoc!.latitude,
              sourceLoc!.longitude <= destinationLoc!.longitude
                  ? destinationLoc!.longitude
                  : sourceLoc!.longitude,
            )),
        100));

    setState(() {
      if (sourceLoc != null && destinationLoc != null) {
        Polyline polyline = Polyline(
            polylineId: const PolylineId('poly_id_from_source'),
            points: polylineCoordinates,
            color: Colors.black,
            startCap: Cap.roundCap,
            endCap: Cap.roundCap,
            width: 3);

        polylines.add(polyline);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      mapType: MapType.normal,
      mapToolbarEnabled: false,
      compassEnabled: false,

      /// remove current location blue dot on current location
      myLocationEnabled: false,

      /// remove compass icon on top left corner
      myLocationButtonEnabled: false,

      /// remove navigation button on top right corner
      zoomControlsEnabled: false,
      trafficEnabled: true,
      initialCameraPosition: CameraPosition(
          target: currentLocation != null
              ? LatLng(currentLocation!.latitude!, currentLocation!.longitude!)
              : sourceLoc ?? const LatLng(0.0, 0.0),
          zoom: 14.151926040649414,
          //tilt: 30,
          bearing: currentLocation?.heading ?? 15.0),
      onMapCreated: _onMapCreated,

      /// set markers on source location and destination location
      markers: markers,

      /// create polyline from source location to destination location
      polylines: polylines,
    );
  }
}
