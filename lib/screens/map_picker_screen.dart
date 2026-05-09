import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerScreen extends StatefulWidget {
  final bool isDark;
  final Color themeColor;

  const MapPickerScreen({super.key, required this.isDark, required this.themeColor});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  // Theme colors
  Color get _bgColor => widget.isDark ? const Color(0xFF121212) : const Color(0xFFF8F9FA);
  Color get _cardBgColor => widget.isDark ? const Color(0xFF1E1E1E) : Colors.white;
  Color get _textPrimary => widget.isDark ? Colors.white : const Color(0xFF1A1A1A);
  Color get _textSecondary => widget.isDark ? const Color(0xFFAAAAAA) : const Color(0xFF757575);
  Color get _borderColor => widget.isDark ? Colors.white.withOpacity(0.05) : Colors.grey.withOpacity(0.15);

  // ── MAP STATE ──
  final MapController _mapController = MapController();
  
  // Default fallback position (Delhi)
  static const LatLng _defaultPosition = LatLng(28.6139, 77.2090);
  LatLng _currentPosition = _defaultPosition;

  // Address variables
  String _displayAddress = "Fetching address...";
  String _houseNo = "";
  String _area = "";
  String _pincode = "";
  
  bool _isLoading = true; 
  bool _mapMoved = false; 

  @override
  void initState() {
    super.initState();
    // Default location Bihar, India context setup karte hain
    _currentPosition = const LatLng(25.5941, 85.1376); // Patna 
    _fetchCurrentLocation();
  }

  // ── GPS LOGIC ──
  Future<void> _fetchCurrentLocation() async {
    setState(() => _isLoading = true);
    
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _handleLocationError("GPS is disabled.");
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        _handleLocationError("Location permission denied.");
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      _handleLocationError("Location permissions permanently denied.");
      return;
    }

    // Get position
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    LatLng userLatLng = LatLng(position.latitude, position.longitude);

    setState(() {
      _currentPosition = userLatLng;
    });

    _mapController.move(userLatLng, 15.0); 
    _reverseGeocode(userLatLng); 
  }

  // ── REVERSE GEOCODING (Native Free Geocoder) ──
  Future<void> _reverseGeocode(LatLng location) async {
    setState(() => _isLoading = true);
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(location.latitude, location.longitude);
      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        
        setState(() {
          _houseNo = place.name ?? ""; 
          
          List<String> areaParts = [];
          if (place.subLocality != null && place.subLocality!.isNotEmpty) areaParts.add(place.subLocality!);
          if (place.locality != null && place.locality!.isNotEmpty) areaParts.add(place.locality!);
          if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) areaParts.add(place.administrativeArea!);
          
          _area = areaParts.join(", ");
          _pincode = place.postalCode ?? "";

          _displayAddress = "$_houseNo, $_area, Pin - $_pincode";
          if (_displayAddress.startsWith(', ')) _displayAddress = _displayAddress.substring(2);
        });
      }
    } catch (e) {
      setState(() => _displayAddress = "Address not found. Drag pin or edit manually.");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handleLocationError(String message) {
    setState(() {
      _displayAddress = message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _bgColor,
      appBar: AppBar(
        backgroundColor: _bgColor,
        elevation: 0,
        leading: IconButton(icon: Icon(Icons.arrow_back_ios_new_rounded, color: _textPrimary, size: 20), onPressed: () => Navigator.pop(context)),
        title: Text('Pin Delivery Location', style: TextStyle(color: _textPrimary, fontSize: 18, fontWeight: FontWeight.w800)),
        centerTitle: true,
      ),
      body: Stack(
        alignment: Alignment.center, 
        children: [
          // ── 1. OPENSTREETMAP RENDERER (FREE) ──
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: _currentPosition,
              initialZoom: 15.0,
              onPositionChanged: (MapPosition position, bool hasGesture) {
                if (hasGesture) {
                  setState(() {
                    _currentPosition = position.center!;
                    _mapMoved = true;
                  });
                }
              },
              onMapEvent: (MapEvent event) {
                // When dragging stops, fetch the address
                if (event is MapEventMoveEnd && _mapMoved) {
                  _mapMoved = false;
                  _reverseGeocode(_currentPosition);
                }
              },
            ),
            children: [
              TileLayer(
                // FREE OSM Tile Server
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.app', // IMPORTANT for free OSM policy
              ),
            ],
          ),

          // ── 2. FIXED CENTER MARKER (Zepto Style) ──
          Positioned(
            top: (MediaQuery.of(context).size.height / 2) - 80, 
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: _cardBgColor, borderRadius: BorderRadius.circular(20), boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 8)]),
                  child: Text('Order will be delivered here', style: TextStyle(color: _textPrimary, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 4),
                Icon(Icons.location_on, color: widget.themeColor, size: 40),
                const SizedBox(height: 40), // Offset to put the tip exactly on center
              ],
            ),
          ),

          // ── 3. BOTTOM UI OVERLAYS ──
          Positioned(
            bottom: 20, left: 16, right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // GPS CURRENT LOCATION BUTTON
                GestureDetector(
                  onTap: _fetchCurrentLocation,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(color: widget.themeColor.withOpacity(0.9), shape: BoxShape.circle, boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))]),
                    child: const Icon(Icons.my_location, color: Colors.white, size: 24),
                  ),
                ),
                const SizedBox(height: 16),
                
                // ADDRESS CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _cardBgColor, 
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: const [BoxShadow(color: Colors.black12, blurRadius: 15, offset: Offset(0, -5))],
                    border: !widget.isDark ? Border.all(color: _borderColor) : null,
                  ),
                  child: Column(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.pin_drop_rounded, color: widget.themeColor, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SELECTED LOCATION', style: TextStyle(color: _textSecondary, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.2)),
                                const SizedBox(height: 6),
                                _isLoading 
                                    ? Row(children: [const SizedBox(width: 12, height: 12, child: CircularProgressIndicator(strokeWidth: 2)), const SizedBox(width: 8), Text("Fetching address...", style: TextStyle(color: _textPrimary, fontSize: 12))])
                                    : Text(_displayAddress, style: TextStyle(color: _textPrimary, fontSize: 13, height: 1.4)),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Divider(color: _borderColor, height: 30),
                      
                      // ── CONFIRM BUTTON ──
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(backgroundColor: widget.themeColor, padding: const EdgeInsets.symmetric(vertical: 16), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16))),
                          onPressed: () {
                            if (_isLoading) return; 
                            
                            // Return map data to the AddressScreen
                            Navigator.pop(context, {
                              'house': _houseNo,
                              'area': _area,
                              'pin': _pincode,
                            });
                          },
                          child: const Text('Confirm Location & Add details', style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}