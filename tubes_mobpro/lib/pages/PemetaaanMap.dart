import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;


class PemetaaanMap extends StatefulWidget {
  const PemetaaanMap({super.key});

  @override
  State<PemetaaanMap> createState() => _PemetaaanMapState();
}
// Models
class PemetaanAlatResponse {
  final List<PemetaanData> data;

  PemetaanAlatResponse({required this.data});

  factory PemetaanAlatResponse.fromJson(Map<String, dynamic> json) {
    return PemetaanAlatResponse(
      data: (json['data'] as List).map((item) => PemetaanData.fromJson(item)).toList(),
    );
  }
}

class PemetaanData {
  final int id;
  final String judulReport;
  final String deskripsi;
  final String binwas;
  final String tahunOperasi;
  final String latitude;
  final String longitude;
  final String address;
  final String tanggal;
  final Alat alat;
  final User user;

  PemetaanData({
    required this.id,
    required this.judulReport,
    required this.deskripsi,
    required this.binwas,
    required this.tahunOperasi,
    required this.latitude,
    required this.longitude,
    required this.address,
    required this.tanggal,
    required this.alat,
    required this.user,
  });

  factory PemetaanData.fromJson(Map<String, dynamic> json) {
    return PemetaanData(
      id: json['id'],
      judulReport: json['judul_report'],
      deskripsi: json['deskripsi'],
      binwas: json['binwas'] ?? '',
      tahunOperasi: json['tahun_operasi'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      address: json['address'],
      tanggal: json['tanggal'],
      alat: Alat.fromJson(json['alat']),
      user: User.fromJson(json['user']),
    );
  }
}

class Alat {
  final int id;
  final String kodeAlat;
  final String namaAlat;
  final String jenis;
  final String kondisi;
  final int jumlah;
  final String deskripsBarang;

  Alat({
    required this.id,
    required this.kodeAlat,
    required this.namaAlat,
    required this.jenis,
    required this.kondisi,
    required this.jumlah,
    required this.deskripsBarang,
  });

  factory Alat.fromJson(Map<String, dynamic> json) {
    return Alat(
      id: json['id'],
      kodeAlat: json['kode_alat'],
      namaAlat: json['nama_alat'],
      jenis: json['jenis'],
      kondisi: json['kondisi'],
      jumlah: json['jumlah'],
      deskripsBarang: json['deskripsi_barang'],
    );
  }
}

class User {
  final int id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }
}

class LocationResult {
  final Location location;
  final Placemark placemark;
  final Map<String, String> formattedAddress;

  LocationResult({
    required this.location,
    required this.placemark,
    required this.formattedAddress,
  });
}

class _PemetaaanMapState extends State<PemetaaanMap> {
  late GoogleMapController _mapController;
  Map<String, MarkerData> markerInfo = {};
  final List<Marker> _markers = [];
  final SearchControllers = TextEditingController();
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _checkPermissionAndGetCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Check if location services are enabled
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await Geolocator.openLocationSettings();
      return Future.error('Location services are disabled.');
    }

    // Check for location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied.');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately
      return Future.error(
        'Location permissions are permanently denied, we cannot request permissions.',
      );
    }

    // Get the current location
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    // Center the map to the user's current location
    _mapController.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: LatLng(position.latitude, position.longitude),
          zoom: 15,
        ),
      ),
    );

    // Add a marker for the current location
    setState(() {
      _markers.add(
        Marker(
          markerId: MarkerId('current_location'),
          position: LatLng(position.latitude, position.longitude),
          infoWindow: const InfoWindow(title: 'You are here'),
        ),
      );
    });
  }

  Future<void> _initializeApp() async {
    setState(() => _isLoading = true);
    await Future.wait([
      fetchMarkers(),
      _checkPermissionAndGetCurrentLocation(),
    ]);
    setState(() => _isLoading = false);
  }

  Future<void> fetchMarkers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('access_token');
      if (token == null) {
        setState(() => _error = 'No access token found');
        return;
      }

      final response = await http.get(
        Uri.parse('https://ecopulse.top/api/pemetaanalat'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final responseData = PemetaanAlatResponse.fromJson(jsonDecode(response.body));
        
        setState(() {
          _markers.clear();
          
          for (var data in responseData.data) {
            String markerId = 'marker_${data.id}';
            LatLng position = LatLng(
              double.parse(data.latitude),
              double.parse(data.longitude),
            );

            _markers.add(
              Marker(
                markerId: MarkerId(markerId),
                position: position,
                infoWindow: InfoWindow(
                  title: data.alat.namaAlat,
                  snippet: data.address,
                ),
                onTap: () {
                  _showMarkerDialog(context, markerId);
                },
              ),
            );

            markerInfo[markerId] = MarkerData(
              namaEnergi: data.alat.namaAlat,
              namaPenanggungJawab: data.user.username,
              tanggalBinswas: data.binwas,
              areaCabang: data.address,
              kapasitas: "${data.alat.jumlah} ${data.alat.jenis}",
              tahunOperasi: data.tahunOperasi,
              langLong: '${data.latitude}, ${data.longitude}',
            );
          }
          _error = null;
        });
      } else {
        setState(() => _error = 'Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() => _error = 'Error: $e');
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
          child: TypeAheadField<LocationResult>(
            builder: (context, controller, focusNode) {
              return TextField(
                controller: controller,
                focusNode: focusNode,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'Cari lokasi (cth: Wisma Darul Ilmi)',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              );
            },
            suggestionsCallback: (pattern) async {
              if (pattern.length < 3) return [];
              try {
                final searchQuery = '$pattern, Bandung';
                List<Location> locations =
                    await locationFromAddress(searchQuery);
                List<LocationResult> results = [];

                for (var location in locations) {
                  try {
                    List<Placemark> placemarks = await placemarkFromCoordinates(
                      location.latitude,
                      location.longitude,
                    );

                    if (placemarks.isNotEmpty) {
                      Placemark place = placemarks.first;

                      // Skip if not in Bandung area
                      if (!(place.subAdministrativeArea
                                  ?.toLowerCase()
                                  .contains('bandung') ??
                              false) &&
                          !(place.locality?.toLowerCase().contains('bandung') ??
                              false)) {
                        continue;
                      }

                      List<String> mainParts = [];
                      List<String> secondaryParts = [];

                      // Build main address (building name or street)
                      if (place.name != null && !place.name!.contains('+')) {
                        mainParts.add(place.name!);
                      }
                      if (place.street != null && place.street!.isNotEmpty) {
                        mainParts.add(place.street!);
                      }

                      // Build secondary address (area details)
                      if (place.subLocality != null &&
                          place.subLocality!.isNotEmpty) {
                        secondaryParts.add(place.subLocality!);
                      }
                      if (place.locality != null &&
                          place.locality!.isNotEmpty) {
                        secondaryParts.add(place.locality!);
                      }

                      // Create formatted address
                      Map<String, String> formattedAddress = {
                        'main': mainParts.join(', '),
                        'secondary': secondaryParts.join(', '),
                      };

                      results.add(LocationResult(
                        location: location,
                        placemark: place,
                        formattedAddress: formattedAddress,
                      ));
                    }
                  } catch (e) {
                    print('Error getting placemark: $e');
                  }
                }

                // Sort results to prioritize exact matches
                results.sort((a, b) {
                  bool aContainsBandung =
                      a.placemark.locality?.toLowerCase().contains('bandung') ??
                          false;
                  bool bContainsBandung =
                      b.placemark.locality?.toLowerCase().contains('bandung') ??
                          false;
                  if (aContainsBandung && !bContainsBandung) return -1;
                  if (!aContainsBandung && bContainsBandung) return 1;
                  return 0;
                });

                return results;
              } catch (e) {
                print('Error searching location: $e');
                return [];
              }
            },
            itemBuilder: (context, LocationResult suggestion) {
              return ListTile(
                leading: const Icon(
                  Icons.location_on,
                  color: Color.fromRGBO(38, 66, 22, 10),
                ),
                title: Text(
                  suggestion.formattedAddress['main'] ?? '',
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                subtitle: Text(
                  suggestion.formattedAddress['secondary'] ?? '',
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.black54,
                  ),
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
              );
            },
            onSelected: (LocationResult suggestion) {
              _mapController.animateCamera(
                CameraUpdate.newCameraPosition(
                  CameraPosition(
                    target: LatLng(
                      suggestion.location.latitude,
                      suggestion.location.longitude,
                    ),
                    zoom: 18,
                  ),
                ),
              );
            },
            loadingBuilder: (context) => const ListTile(
              leading: CircularProgressIndicator(strokeWidth: 2),
              title: Text('Mencari lokasi...'),
            ),
            errorBuilder: (context, error) => ListTile(
              leading: const Icon(Icons.error, color: Colors.red),
              title: Text('Error: ${error.toString()}'),
            ),
            hideOnEmpty: true,
            hideOnError: true,
            animationDuration: const Duration(milliseconds: 300),
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
        mapType: MapType.normal,
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
        myLocationEnabled: true,
        compassEnabled: true,
        tiltGesturesEnabled: false,
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
