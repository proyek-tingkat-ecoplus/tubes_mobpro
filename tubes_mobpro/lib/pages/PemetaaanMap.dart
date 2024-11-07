import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';

class PemetaaanMap extends StatefulWidget {
  const PemetaaanMap({super.key});

  @override
  State<PemetaaanMap> createState() => _PemetaaanMapState();
}

class _PemetaaanMapState extends State<PemetaaanMap> {
  late GoogleMapController _mapController;
  Map<String, MarkerData> markerInfo = {};
  final List<Marker> _markers = [];
  final SearchControllers = TextEditingController();

  @override
  void initState() {
    super.initState();

    // List of 10 coordinates around Bandung
    List<LatLng> markerPositions = [
      LatLng(-6.914744, 107.609810),
      LatLng(-6.917464, 107.619123),
      LatLng(-6.920132, 107.606789),
      LatLng(-6.910532, 107.605645),
      LatLng(-6.912543, 107.616790),
      LatLng(-6.918675, 107.602456),
      LatLng(-6.916789, 107.610234),
      LatLng(-6.911234, 107.614678),
      LatLng(-6.915678, 107.608456),
      LatLng(-6.909876, 107.612345),
    ];

    // Create 10 markers with information
    for (int i = 0; i < markerPositions.length; i++) {
      String markerId = 'marker_$i';
      LatLng position = markerPositions[i];

      _markers.add(
        Marker(
          markerId: MarkerId(markerId),
          position: position,
          infoWindow: InfoWindow(
            title: 'Marker $i',
            snippet: 'Location in Bandung',
          ),
          onTap: () {
            _showMarkerDialog(context, markerId);
          },
        ),
      );

      // Add marker data to markerInfo map
      markerInfo[markerId] = MarkerData(
        namaEnergi: 'Energi Terbarukan $i',
        namaPenanggungJawab: 'Penanggung Jawab $i',
        tanggalBinswas: '2023-12-${20 + i}',
        areaCabang: 'Area ${i + 1}',
        kapasitas: '${1000 + i * 100} kW',
        tahunOperasi: '202${i % 3}',
        langLong: '${position.latitude}, ${position.longitude}',
      );
    }
  }

  Future<List<Placemark>> getPlaceMarkByCoordinates(LatLng position) async {
    final List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );
    return placemarks;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        toolbarHeight: 100,
        backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
        title: Padding(
          padding: const EdgeInsets.all(20),
          child: TypeAheadField(
            builder: (context, controller, focusNode) {
              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  obscureText: false,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    prefixIcon: const Icon(Icons.search),
                  ),
                ),
              );
            },
            suggestionsCallback: (pattern) async {
              // ini buat dapetin data yang ngebalikin location callback
              if (pattern.isEmpty) {
                return null;
              } else {
                try {
                  return await locationFromAddress(pattern); // ini https://pub.dev/packages/geocoding // ini buat nyari location
                } catch (e) {
                  return null;
                }
              }
            },
            itemBuilder: (context, Location suggestion) {
              // widget fluutter for asign operation
              return FutureBuilder<List<Placemark>>(
                future: getPlaceMarkByCoordinates(
                  LatLng(suggestion.latitude, suggestion.longitude),
                ),
                builder: (context, snapshot) {
                  // ini bawaan dari fliyyer buat menyimpan status
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const ListTile(title: Text('Loading...'));
                  } else if (snapshot.hasError ||
                      !snapshot.hasData ||
                      snapshot.data!.isEmpty) {
                    return const ListTile(title: Text('No data'));
                  } else {
                    // Loop through the list of placemarks
                    return Column(
                      children: snapshot.data!.map((placemark) {
                        // ini ng loop isi dari snapshot
                        return ListTile(
                          title: Text(placemark.name ?? 'No name'),
                          subtitle: Text(
                            [
                                  placemark.subAdministrativeArea,
                                  placemark.thoroughfare,
                                  placemark.subLocality,
                                  placemark.postalCode,
                                ].join(", ") ??
                                'No address available',
                          ),
                        );
                      }).toList(),
                    );
                  }
                },
              );
            },
            onSelected: (Location suggestion) {
              // ini jika di select maka redirect ke lokasi tersebut
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(suggestion.latitude, suggestion.longitude),
                    zoom: 15,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
        foregroundColor: Colors.white,
        onPressed: () {
          _mapController.animateCamera(
            CameraUpdate.newCameraPosition(
              const CameraPosition(
                target: LatLng(-6.914744,
                    107.609810), // ini sengaja buat di center bandung soalnya scope nya bandung
                zoom: 15,
              ),
            ),
          );
        },
        child: const Icon(Icons.location_searching),
      ),
      body: GoogleMap(
        // ini core google map nya
        initialCameraPosition: const CameraPosition(
          // default camera posision
          target: LatLng(-6.914744, 107.609810),
          zoom: 15,
        ),
        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },
        onTap: (LatLng position) {
          // final MarkerId markerId = MarkerId(position.toString());
          // _inputModelDialog(context, markerId, position);
        },
        markers: _markers.toSet(),
      ),
    );
  }

  void _searchLocation(String query) async {
    List<Location> locations = await locationFromAddress(query);
    if (locations.isNotEmpty) {
      _mapController.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: LatLng(locations.first.latitude, locations.first.longitude),
            zoom: 15,
          ),
        ),
      );
    }
  }

  // Function to show the dialog
  void _showMarkerDialog(BuildContext context, String MarkerId) {
    final inputNamaEnergi =
        TextEditingController(text: markerInfo[MarkerId]!.namaEnergi);
    final inputNamaPj =
        TextEditingController(text: markerInfo[MarkerId]!.namaPenanggungJawab);
    final inputTanggalBinswas =
        TextEditingController(text: markerInfo[MarkerId]!.tanggalBinswas);
    final inputAreaCabang =
        TextEditingController(text: markerInfo[MarkerId]!.areaCabang);
    final inputKapasitas =
        TextEditingController(text: markerInfo[MarkerId]!.kapasitas);
    final inputTahunOperasi =
        TextEditingController(text: markerInfo[MarkerId]!.tahunOperasi);
    final inputLatLong =
        TextEditingController(text: markerInfo[MarkerId]!.langLong);

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height *
              0.75, // 75% of the screen height
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              // mainAxisSize: MainAxisSize.min,
              children: [
                const Padding(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    'Data Eksisting EBT Jawa Barat',
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromRGBO(38, 66, 22, 10)),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama Enegeri terbarukan : ",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 66, 22, 10),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                          label: "",
                          controller: inputNamaEnergi,
                          icon: Icons.energy_savings_leaf),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Nama Penganggung jawab : ",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 66, 22, 10),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                          label: "",
                          controller: inputNamaPj,
                          icon: Icons.person),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tanggal Binswas : ",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 66, 22, 10),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                          label: "",
                          controller: inputTanggalBinswas,
                          icon: Icons.calendar_today),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Area Cabang Dinas ESDM : ",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 66, 22, 10),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                          label: "",
                          controller: inputAreaCabang,
                          icon: Icons.location_city),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Kapasitas (kW/KwP/M3) : ",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 66, 22, 10),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                          label: "",
                          controller: inputKapasitas,
                          icon: Icons.speed),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Tahun Operasi : ",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 66, 22, 10),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                          label: "",
                          controller: inputTahunOperasi,
                          icon: Icons.calendar_today),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.only(left: 20, right: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Lang Long : ",
                        style: TextStyle(
                            color: Color.fromRGBO(38, 66, 22, 10),
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                      const SizedBox(height: 10),
                      InputWidget(
                          label: "",
                          controller: inputLatLong,
                          icon: Icons.location_on),
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  // void _inputModelDialog(
  //     BuildContext context, MarkerId MarkerId, LatLng position) {
  //   final inputNamaEnergi = TextEditingController(); // ini buat inputan harus ada
  //   final inputNamaPj = TextEditingController();
  //   final inputTanggalBinswas = TextEditingController();
  //   final inputAreaCabang = TextEditingController();
  //   final inputKapasitas = TextEditingController();
  //   final inputTahunOperasi = TextEditingController();
  //   final inputLatLong = TextEditingController();

  //   showModalBottomSheet<void>( // ini buat model botton input
  //     context: context,
  //     isScrollControlled: true,
  //     builder: (BuildContext context) {
  //       return Container(
  //         width: double.infinity,
  //         height: MediaQuery.of(context).size.height *
  //             0.75, // 75% of the screen height
  //         padding: const EdgeInsets.all(15),
  //         child: SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.center,
  //             // mainAxisSize: MainAxisSize.min,
  //             children: [
  //               const Padding(
  //                 padding: EdgeInsets.all(20),
  //                 child: Text(
  //                   'Data Eksisting EBT Jawa Barat',
  //                   style: TextStyle(
  //                       fontSize: 18,
  //                       fontWeight: FontWeight.bold,
  //                       color: Color.fromRGBO(38, 66, 22, 10)),
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20, right: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       "Nama Enegeri terbarukan : ",
  //                       style: TextStyle(
  //                           color: Color.fromRGBO(38, 66, 22, 10),
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     InputWidget(
  //                         label: "",
  //                         controller: inputNamaEnergi,
  //                         icon: Icons.energy_savings_leaf),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20, right: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       "Nama Penganggung jawab : ",
  //                       style: TextStyle(
  //                           color: Color.fromRGBO(38, 66, 22, 10),
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     InputWidget(
  //                         label: "",
  //                         controller: inputNamaPj,
  //                         icon: Icons.person),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20, right: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       "Tanggal Binswas : ",
  //                       style: TextStyle(
  //                           color: Color.fromRGBO(38, 66, 22, 10),
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     InputWidget(
  //                         label: "",
  //                         controller: inputTanggalBinswas,
  //                         icon: Icons.calendar_today),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20, right: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       "Area Cabang Dinas ESDM : ",
  //                       style: TextStyle(
  //                           color: Color.fromRGBO(38, 66, 22, 10),
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     InputWidget(
  //                         label: "",
  //                         controller: inputAreaCabang,
  //                         icon: Icons.location_city),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20, right: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       "Kapasitas (kW/KwP/M3) : ",
  //                       style: TextStyle(
  //                           color: Color.fromRGBO(38, 66, 22, 10),
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     InputWidget(
  //                         label: "",
  //                         controller: inputKapasitas,
  //                         icon: Icons.speed),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20, right: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       "Tahun Operasi : ",
  //                       style: TextStyle(
  //                           color: Color.fromRGBO(38, 66, 22, 10),
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     InputWidget(
  //                         label: "",
  //                         controller: inputTahunOperasi,
  //                         icon: Icons.calendar_today),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               Padding(
  //                 padding: const EdgeInsets.only(left: 20, right: 20),
  //                 child: Column(
  //                   crossAxisAlignment: CrossAxisAlignment.start,
  //                   children: [
  //                     const Text(
  //                       "Lang Long : ",
  //                       style: TextStyle(
  //                           color: Color.fromRGBO(38, 66, 22, 10),
  //                           fontWeight: FontWeight.bold,
  //                           fontSize: 16),
  //                     ),
  //                     const SizedBox(height: 10),
  //                     InputWidget(
  //                         label: "",
  //                         controller: inputLatLong,
  //                         icon: Icons.location_on),
  //                   ],
  //                 ),
  //               ),
  //               const SizedBox(height: 10),
  //               TextButton(
  //                 onPressed: () {
  //                   setState(() {
  //                     _markers.add(
  //                       Marker(
  //                         markerId: MarkerId,
  //                         position: position,
  //                         infoWindow: const InfoWindow(
  //                           title: 'Energi Terbarukan',
  //                           snippet: 'Added by onTap',
  //                         ),
  //                         onTap: () {
  //                           _showMarkerDialog(context, position.toString());
  //                         },
  //                       ),
  //                     );

  //                     markerInfo[position.toString()] = MarkerData(  // ini masukin marker data ke dalam map
  //                       namaEnergi: inputNamaEnergi.text,
  //                       namaPenanggungJawab: inputNamaPj.text,
  //                       tanggalBinswas: inputTahunOperasi.text,
  //                       areaCabang: inputAreaCabang.text,
  //                       kapasitas: inputKapasitas.text,
  //                       tahunOperasi: inputTahunOperasi.text,
  //                       langLong: position.toString(),
  //                     );
  //                   });
  //                   Navigator.pop(context);
  //                 },
  //                 style: TextButton.styleFrom(
  //                   foregroundColor: Colors.white,
  //                   backgroundColor: const Color.fromRGBO(38, 66, 22, 10),
  //                   padding: const EdgeInsets.symmetric(
  //                       horizontal: 40, vertical: 10),
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(10),
  //                   ),
  //                 ),
  //                 child: Text("Simpan"),
  //               )
  //             ],
  //           ),
  //         ),
  //       );
  //     },
  //   );
  // }
}

class MarkerData {
  String namaEnergi;
  String namaPenanggungJawab;
  String tanggalBinswas;
  String areaCabang;
  String kapasitas;
  String tahunOperasi;
  String langLong;

  MarkerData({
    required this.namaEnergi,
    required this.namaPenanggungJawab,
    required this.tanggalBinswas,
    required this.areaCabang,
    required this.kapasitas,
    required this.tahunOperasi,
    required this.langLong,
  });
}

Widget InputWidget(
    {required String label,
    // required String hint,
    required TextEditingController controller,
    bool obscureText = false,
    required IconData icon,
    var keyboardType}) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      TextFormField(
        controller: controller,
        obscureText: false,
        decoration: InputDecoration(
          hintText: label,
          labelText: label,
          prefixIcon: false ? null : Icon(icon),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    ],
  );
}
