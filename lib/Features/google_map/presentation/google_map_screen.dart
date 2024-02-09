import 'package:flutter/material.dart';
import 'package:max_assignment/Features/google_map/widget/google_map_widget.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: GoogleMapWidget(),
    );
  }
}
