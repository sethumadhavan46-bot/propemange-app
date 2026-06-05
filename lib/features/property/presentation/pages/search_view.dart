import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import '../widgets/filter_modal.dart';
import '../widgets/propemange_widgets.dart';
import 'property_details_view.dart';
import '../../domain/entities/property_entity.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class SearchView extends StatefulWidget {
  const SearchView({super.key});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  bool _isMapMode = false;
  bool _isFocused = false;
  late TextEditingController _searchController;
  GoogleMapController? _mapController;
  
  // Voice search
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _lastWords = '';

  static const CameraPosition _initialCameraPosition = CameraPosition(
    target: LatLng(11.3410, 77.7172), // Erode, Tamil Nadu
    zoom: 12,
  );

  @override
  void initState() {
    super.initState();
    final initialQuery = Provider.of<PropertyProvider>(context, listen: false).searchQuery;
    _searchController = TextEditingController(text: initialQuery);
    _speech = stt.SpeechToText();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController?.dispose();
    super.dispose();
  }

  void _listen() async {
    print('Attempting to listen...');
    try {
      if (!_isListening) {
        bool available = await _speech.initialize(
          onStatus: (val) {
            print('Speech Status: $val');
            if (val == 'done') setState(() => _isListening = false);
          },
          onError: (val) {
            print('Speech Error: ${val.errorMsg}');
            setState(() => _isListening = false);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Speech Error: ${val.errorMsg}')),
            );
          },
        );
        if (available) {
          setState(() => _isListening = true);
          _speech.listen(
            onResult: (val) {
              setState(() {
                _lastWords = val.recognizedWords;
                if (val.recognizedWords.isNotEmpty) {
                  _searchController.text = _lastWords;
                }
              });
            },
          );
        } else {
          print('Speech recognition NOT available');
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Speech recognition not available on this device')),
          );
        }
      } else {
        setState(() => _isListening = false);
        _speech.stop();
        if (_searchController.text.isNotEmpty) {
          _onSearchSubmitted(_searchController.text);
        }
      }
    } catch (e) {
      print('Speech Exception: $e');
      setState(() => _isListening = false);
    }
  }

  void _onSearchSubmitted(String value) {
    Provider.of<PropertyProvider>(context, listen: false).setSearchQuery(value);
    setState(() => _isFocused = false);
  }

  @override
  Widget build(BuildContext context) {
    // Sync controller if provider state changes (e.g. from Home hero)
    final providerQuery = Provider.of<PropertyProvider>(context).searchQuery;
    if (_searchController.text != providerQuery && !_isFocused) {
      _searchController.text = providerQuery;
    }

    // Listen for errors
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PropertyProvider>(context, listen: false);
      if (provider.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(provider.errorMessage!),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: 'Dismiss',
              textColor: Colors.white,
              onPressed: () => provider.clearError(),
            ),
          ),
        );
        provider.clearError();
      }
    });

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _isFocused ? null : _buildSearchAppBar(),
      body: Stack(
        children: [
          _isMapMode ? _buildMapView() : _buildListView(),
          if (!_isFocused) _buildToggleButtons(),
          if (_isFocused) _buildSearchOverlay(),
        ],
      ),
    );
  }

  PreferredSizeWidget _buildSearchAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          const Text(
            'PropeMange',
            style: TextStyle(color: PropeMangeColors.primaryGreen, fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(width: 12),
          Expanded(child: GestureDetector(
            onTap: () => setState(() => _isFocused = true),
            child: AbsorbPointer(child: _buildFloatingSearchBar()),
          )),
        ],
      ),
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: _buildDynamicFilterChips(),
      ),
    );
  }

  Widget _buildFloatingSearchBar() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: TextField(
        controller: _searchController,
        onSubmitted: _onSearchSubmitted,
        decoration: InputDecoration(
          hintText: 'Search in Tamil Nadu, India...',
          hintStyle: const TextStyle(fontSize: 14, color: Colors.grey),
          prefixIcon: const Icon(Icons.search, color: PropeMangeColors.primaryGreen, size: 22),
          suffixIcon: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: _listen,
                icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : Colors.grey),
              ),
              Consumer<PropertyProvider>(
                builder: (context, provider, child) {
                  return IconButton(
                    onPressed: () => provider.searchNearMe(),
                    icon: Icon(
                      provider.isNearbyActive ? Icons.my_location : Icons.location_searching,
                      color: provider.isNearbyActive ? PropeMangeColors.accentBlue : Colors.grey,
                      size: 20,
                    ),
                  );
                },
              ),
            ],
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSearchOverlay() {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          _buildAdvancedHeader(),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text(
                  'Popular cities in India',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4B5E75), fontSize: 14),
                ),
                const SizedBox(height: 16),
                Wrap(
                  spacing: 12,
                  runSpacing: 12,
                  children: [
                    _buildPopularCityChip('Noida'),
                    _buildPopularCityChip('Delhi'),
                    _buildPopularCityChip('Mumbai'),
                    _buildPopularCityChip('Chennai'),
                    _buildPopularCityChip('Gurgaon'),
                    _buildPopularCityChip('Bangalore'),
                    _buildPopularCityChip('Hyderabad'),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdvancedHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 50, bottom: 20),
      color: PropeMangeColors.accentBlue,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        _buildSearchTab('Buy', true),
                        _buildSearchTab('Rent/PG', false),
                        _buildSearchTab('Commercial', false),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  onPressed: () => setState(() => _isFocused = false),
                  icon: const Icon(Icons.close, color: Colors.white, size: 28),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              height: 55,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade100),
              ),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                onSubmitted: _onSearchSubmitted,
                decoration: InputDecoration(
                  hintText: 'Try - Noida',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: _listen,
                        icon: Icon(_isListening ? Icons.mic : Icons.mic_none, color: _isListening ? Colors.red : Colors.grey),
                      ),
                      const Icon(Icons.my_location, color: PropeMangeColors.accentBlue),
                      const SizedBox(width: 12),
                    ],
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchTab(String label, bool isActive) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: isActive ? PropeMangeColors.accentBlue : Colors.white70,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPopularCityChip(String city) {
    return GestureDetector(
      onTap: () {
        _searchController.text = city;
        _onSearchSubmitted(city);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.add, size: 16, color: Colors.grey),
            const SizedBox(width: 8),
            Text(
              city,
              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF4B5E75)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicFilterChips() {
    return Consumer<PropertyProvider>(
      builder: (context, provider, child) {
        return Container(
          height: 60,
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            children: [
              _buildFilterPill(
                'Price: ₹${(provider.priceRange.start / 100000).toStringAsFixed(0)}L+',
                isActive: provider.priceRange.start > 0,
                onTap: _showFilters,
              ),
              const SizedBox(width: 8),
              _buildFilterPill(
                provider.selectedPropertyTypes.isEmpty ? 'Home Type' : provider.selectedPropertyTypes.join(', '),
                isActive: provider.selectedPropertyTypes.isNotEmpty,
                onTap: _showFilters,
              ),
              const SizedBox(width: 8),
              _buildFilterPill(
                provider.selectedBHKs.isEmpty ? 'Beds' : '${provider.selectedBHKs.join(', ')} BHK',
                isActive: provider.selectedBHKs.isNotEmpty,
                onTap: _showFilters,
              ),
              const SizedBox(width: 8),
              _buildFilterPill(
                'More',
                icon: Icons.tune,
                onTap: _showFilters,
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterPill(String label, {bool isActive = false, IconData? icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isActive ? PropeMangeColors.primaryGreen : Colors.white,
          border: Border.all(color: isActive ? PropeMangeColors.primaryGreen : Colors.grey.shade300),
          borderRadius: BorderRadius.circular(25),
          boxShadow: isActive ? [BoxShadow(color: PropeMangeColors.primaryGreen.withOpacity(0.3), blurRadius: 8, offset: const Offset(0, 2))] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isActive ? Colors.white : Colors.black87,
              ),
            ),
            if (icon != null) ...[
              const SizedBox(width: 6),
              Icon(icon, size: 16, color: isActive ? Colors.white : Colors.black54),
            ],
            if (icon == null && !isActive) ...[
              const SizedBox(width: 4),
              const Icon(Icons.keyboard_arrow_down, size: 16, color: Colors.black54),
            ],
          ],
        ),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const FilterModal(),
    );
  }

  Widget _buildListView() {
    return Consumer<PropertyProvider>(
      builder: (context, provider, child) {
        final properties = provider.properties;
        if (properties.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.search_off, size: 64, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text('No homes found for this search', style: TextStyle(color: Colors.grey, fontSize: 16)),
              ],
            ),
          );
        }
        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${properties.length} Homes in Tamil Nadu',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  TextButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.sort, size: 18, color: PropeMangeColors.accentBlue),
                    label: const Text('Sort', style: TextStyle(color: PropeMangeColors.accentBlue, fontSize: 13, fontWeight: FontWeight.bold)),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: properties.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final prop = properties[index];
                  return PropertyCard(
                    heroSuffix: '-search',
                    property: prop,
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => PropertyDetailsView(property: prop)),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  PropertyEntity? _selectedMapProperty;

  Widget _buildMapView() {
    return Consumer<PropertyProvider>(
      builder: (context, provider, child) {
        final properties = provider.properties;
        final markers = properties.map((prop) {
          return Marker(
            markerId: MarkerId(prop.id),
            position: LatLng(prop.latitude, prop.longitude),
            onTap: () => setState(() => _selectedMapProperty = prop),
          );
        }).toSet();

        return Stack(
          children: [
            GoogleMap(
              initialCameraPosition: _initialCameraPosition,
              onMapCreated: (controller) => _mapController = controller,
              markers: markers,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
              mapToolbarEnabled: false,
            ),
            // Selection Preview Card
            if (_selectedMapProperty != null)
              Positioned(
                bottom: 100,
                left: 16,
                right: 16,
                child: _buildMapPreviewCard(_selectedMapProperty!),
              ),
          ],
        );
      },
    );
  }


  Widget _buildMapPreviewCard(PropertyEntity property) {
    return Container(
      height: 120,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 15, offset: Offset(0, 5))],
      ),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                child: Image.network(property.images.first, width: 140, height: 120, fit: BoxFit.cover),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        '₹${property.price.toStringAsFixed(0)}',
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 4),
                       Text(
                        '${property.beds} bds | ${property.baths} ba | ${property.sqft} sqft',
                        style: const TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        property.locationAddress,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Positioned(
            top: 8,
            right: 8,
            child: IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => setState(() => _selectedMapProperty = null),
            ),
          ),
          Positioned.fill(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => PropertyDetailsView(property: property)),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleButtons() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24.0),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: const [BoxShadow(color: Colors.black45, blurRadius: 10, offset: Offset(0, 4))],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildToggleButton(Icons.list, 'List', !_isMapMode, () => setState(() => _isMapMode = false)),
              _buildToggleButton(Icons.map_outlined, 'Map', _isMapMode, () => setState(() => _isMapMode = true)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildToggleButton(IconData icon, String label, bool isActive, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: isActive ? PropeMangeColors.primaryGreen : Colors.transparent,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            if (isActive) ...[
              const SizedBox(width: 8),
              Text(label, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ],
          ],
        ),
      ),
    );
  }
}
