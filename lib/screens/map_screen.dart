import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  late GoogleMapController mapController;
  String? _selectedDestination;

  static const LatLng cuLocation = LatLng(30.7689, 76.5754);

  final Map<String, LatLng> destinationLocations = {
    // 🅰️ A Block
    'A1 Block – Classes & Admission Cell': const LatLng(30.77162701053086, 76.57819671293444),
    'A2 Block – Classes & Department Library': const LatLng(30.7691, 76.5745),
    'A3 Block – Classes & Department Library': const LatLng(30.7693, 76.5748),

    // 🅱️ B Block
    'B1 Block – Classes & Department Library': const LatLng(30.769668070968102, 76.5755324270292),
    'B2 Block – Classes & Department Library': const LatLng(30.769202429988468, 76.57585041687098),
    'B3 Block – Classes & Department Library': const LatLng(30.76885020817041, 76.57635818773011),

    // 🅲 C Block (First Year)
    'C1 Block – First Year Classes & Library': const LatLng(30.76712720565699, 76.5761780431832),
    'C2 Block – First Year Classes & Library': const LatLng(30.76632150517348, 76.57606032126833),
    'C3 Block – First Year Classes & Library': const LatLng(30.767101484877834, 76.57476001749203),

    // 🅳 D Block
    'D1 Block – Classes': const LatLng(30.7679, 76.5770),
    'D2 Block – Classes': const LatLng(30.7677, 76.5773),
    'D3 Block – Classes': const LatLng(30.7675, 76.5776),
    'D4 Block – Classes': const LatLng(30.7673, 76.5779),
    'D5 Block – Classes': const LatLng(30.7671, 76.5782),
    'D6 Block – Central Library': const LatLng(30.7669, 76.5785),

    // 🏠 Hostels
    'Sukna Hostel – Girls Hostel': const LatLng(30.7707100549292, 76.57795588231626),
    'LC Hostel – Girls Hostel': const LatLng(30.7656, 76.5754),
    'Tagore Hostel - Girls Hostel': const LatLng(30.7658047596623, 76.57578871752388),

    // 🚪 Gates
    'Gate 1 – Main Gate (Bus & Private Vehicles)': const LatLng(30.7705, 76.5728),
    'Gate 2 – Student Entry Gate': const LatLng(30.7710, 76.5736),
    'Gate 3 – Near D Block': const LatLng(30.7662, 76.5789),

    // Extras
    'Fountain Park': const LatLng(30.769436754143157, 76.57679970466121),
    'Food Republic (FR)': const LatLng(30.76687718466037, 76.57602810314471),
    'Punjab National Bank ATM': const LatLng(30.770739448122182, 76.57626203541047),
  };

  Future<void> _openGoogleMaps(LatLng destination) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Could not open Google Maps'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Campus Map'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
            onMapCreated: (GoogleMapController controller) {
              mapController = controller;
              if (isDark) {
                mapController.setMapStyle('''
                  [
                    {
                      "elementType": "geometry",
                      "stylers": [{"color": "#1a1a2e"}]
                    },
                    {
                      "elementType": "labels.text.stroke",
                      "stylers": [{"color": "#1a1a2e"}]
                    },
                    {
                      "elementType": "labels.text.fill",
                      "stylers": [{"color": "#bdbdbd"}]
                    },
                    {
                      "featureType": "road",
                      "elementType": "geometry",
                      "stylers": [{"color": "#38414e"}]
                    },
                    {
                      "featureType": "water",
                      "elementType": "geometry",
                      "stylers": [{"color": "#17263c"}]
                    }
                  ]
                ''');
              }
            },
            initialCameraPosition: const CameraPosition(
              target: cuLocation,
              zoom: 16,
            ),
            markers: _buildMarkers(),
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
            zoomControlsEnabled: true,
          ),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _selectedDestination,
                  hint: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: const [
                        Icon(Icons.location_on_rounded,
                            color: Color(0xFF1F65B0)),
                        SizedBox(width: 8),
                        Text('Select destination'),
                      ],
                    ),
                  ),
                  isExpanded: true,
                  items: destinationLocations.keys.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(value),
                      ),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedDestination = newValue;
                    });
                    if (newValue != null &&
                        destinationLocations.containsKey(newValue)) {
                      final location = destinationLocations[newValue]!;
                      mapController.animateCamera(
                        CameraUpdate.newCameraPosition(
                          CameraPosition(
                            target: location,
                            zoom: 17,
                          ),
                        ),
                      );
                    }
                  },
                  dropdownColor:
                      isDark ? const Color(0xFF1A1A2E) : Colors.white,
                  style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 14,
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: 16,
            left: 16,
            child: _selectedDestination != null
                ? ElevatedButton.icon(
                    onPressed: () {
                      _openGoogleMaps(
                        destinationLocations[_selectedDestination]!,
                      );
                    },
                    icon: const Icon(Icons.navigation_rounded),
                    label: const Text('Navigate'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1F65B0),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
          Positioned(
            bottom: 24,
            right: 24,
            child: FloatingActionButton(
              backgroundColor: const Color(0xFF1F65B0),
              onPressed: () {
                mapController.animateCamera(
                  CameraUpdate.newCameraPosition(
                    const CameraPosition(
                      target: cuLocation,
                      zoom: 16,
                    ),
                  ),
                );
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Centered to campus'),
                    duration: Duration(seconds: 1),
                  ),
                );
              },
              child: const Icon(Icons.my_location_rounded),
            ),
          ),
        ],
      ),
    );
  }

  Set<Marker> _buildMarkers() {
    return destinationLocations.entries.map((entry) {
      return Marker(
        markerId: MarkerId(entry.key),
        position: entry.value,
        infoWindow: InfoWindow(title: entry.key),
      );
    }).toSet();
  }
}
