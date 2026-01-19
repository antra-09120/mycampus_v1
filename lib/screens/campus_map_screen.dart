import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class CampusMapScreen extends StatefulWidget {
  final String role;
  const CampusMapScreen({super.key, required this.role});

  @override
  State<CampusMapScreen> createState() => _CampusMapScreenState();
}

class _CampusMapScreenState extends State<CampusMapScreen> {
  static const LatLng cuLocation = LatLng(30.7689, 76.5754);

  String? selectedPlace;

  final Map<String, LatLng> campusLocations = {
    // 🅰️ A Block
    "A1 Block – Classes & Admission Cell": LatLng(30.77162701053086, 76.57819671293444),
    "A2 Block – Classes & Department Library": LatLng(30.7691, 76.5745),
    "A3 Block – Classes & Department Library": LatLng(30.7693, 76.5748),

    // 🅱️ B Block
    "B1 Block – Classes & Department Library": LatLng(30.769668070968102, 76.5755324270292),
    "B2 Block – Classes & Department Library": LatLng(30.769202429988468, 76.57585041687098),
    "B3 Block – Classes & Department Library": LatLng(30.76885020817041, 76.57635818773011),

    // 🅲 C Block (First Year)
    "C1 Block – First Year Classes & Library": LatLng(30.76712720565699, 76.5761780431832),
    "C2 Block – First Year Classes & Library": LatLng(30.76632150517348, 76.57606032126833),
    "C3 Block – First Year Classes & Library": LatLng(30.767101484877834, 76.57476001749203),

    // 🅳 D Block
    "D1 Block – Classes": LatLng(30.7679, 76.5770),
    "D2 Block – Classes": LatLng(30.7677, 76.5773),
    "D3 Block – Classes": LatLng(30.7675, 76.5776),
    "D4 Block – Classes": LatLng(30.7673, 76.5779),
    "D5 Block – Classes": LatLng(30.771033526773625, 76.56965298064976),
    "D6 Block – Central Library": LatLng(30.7669, 76.5785),

    // 🏠 Hostels
    "Sukna Hostel – Girls Hostel": LatLng(30.7707100549292, 76.57795588231626),
    "LC Hostel – Girls Hostel": LatLng(30.7656, 76.5754),
    "Tagore Hostel - Girls Hostel": LatLng(30.7658047596623, 76.57578871752388),

    // 🚪 Gates
    "Gate 1 – Main Gate (Bus & Private Vehicles)": LatLng(30.7719047322592, 76.57943177846573),
    "Gate 2 – Student Entry Gate": LatLng(30.77254319789523, 76.57645943358823),
    "Gate 3 – Near D Block": LatLng(30.77383785131635, 76.57195447332838),

    // Extras
    "Fountain Park": LatLng(30.769436754143157, 76.57679970466121),
    "Food Republic(FR)": LatLng(30.76687718466037, 76.57602810314471),
    "Punjab National Bank ATM": LatLng(30.770739448122182, 76.57626203541047),

  };


  Future<void> openGoogleMaps(LatLng destination) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}',
    );

    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("MyCampus – ${widget.role}"),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: DropdownButtonFormField<String>(
              dropdownColor: const Color.fromRGBO(26, 29, 41, 1), // dark bg
              style: const TextStyle(
                color: Colors.white, // selected text
                fontSize: 16,
              ),
              decoration: const InputDecoration(
                labelText: "Select destination",
                labelStyle: TextStyle(color: Colors.white),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
              ),
              iconEnabledColor: Colors.white,
              value: selectedPlace,
              items: campusLocations.keys
                  .map(
                    (place) => DropdownMenuItem<String>(
                  value: place,
                  child: Text(
                    place,
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
              )
                  .toList(),
              onChanged: (value) {
                setState(() {
                  selectedPlace = value;
                });
              },
            ),

          ),

          Expanded(
            child: GoogleMap(
              initialCameraPosition: const CameraPosition(
                target: cuLocation,
                zoom: 16,
              ),
              markers: campusLocations.entries
                  .map(
                    (entry) => Marker(
                  markerId: MarkerId(entry.key),
                  position: entry.value,
                  infoWindow: InfoWindow(title: entry.key),
                ),
              )
                  .toSet(),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(12),
            child: ElevatedButton(
              onPressed: selectedPlace == null
                  ? null
                  : () {
                openGoogleMaps(
                  campusLocations[selectedPlace]!,
                );
              },
              child: const Text("Navigate"),
            ),
          ),
        ],
      ),
    );
  }
}
