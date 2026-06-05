import 'package:flutter/material.dart';
import '../../data/models/property_model.dart';
import '../../domain/entities/property_entity.dart';
import 'package:geolocator/geolocator.dart';

class PropertyProvider extends ChangeNotifier {
  List<PropertyEntity> _properties = [];
  List<PropertyEntity> get properties => _properties;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  // Search & Filter State
  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  String _searchQuery = '';
  String get searchQuery => _searchQuery;

  RangeValues _priceRange = const RangeValues(0, 50000000); // 0 to 5Cr
  RangeValues get priceRange => _priceRange;

  List<int> _selectedBHKs = [];
  List<int> get selectedBHKs => _selectedBHKs;

  List<String> _selectedPropertyTypes = [];
  List<String> get selectedPropertyTypes => _selectedPropertyTypes;

  String _constructionStatus = 'Any';
  String get constructionStatus => _constructionStatus;

  Position? _currentPosition;
  bool _isNearbyActive = false;
  bool get isNearbyActive => _isNearbyActive;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Saved Properties State
  final Set<String> _savedPropertyIds = {};
  Set<String> get savedPropertyIds => _savedPropertyIds;

  bool isSaved(String id) => _savedPropertyIds.contains(id);

  void toggleSaveProperty(String id) {
    if (_savedPropertyIds.contains(id)) {
      _savedPropertyIds.remove(id);
    } else {
      _savedPropertyIds.add(id);
    }
    notifyListeners();
  }

  List<PropertyEntity> _cachedAllProperties = [];

  PropertyProvider() {
    _cachedAllProperties = _getInitialMockProperties();
    fetchProperties();
  }

  // Filters
  void setCategory(String category) {
    _selectedCategory = category;
    fetchProperties();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    fetchProperties();
  }

  void setAdvancedFilters({
    RangeValues? priceRange,
    List<int>? selectedBHKs,
    List<String>? selectedPropertyTypes,
    String? constructionStatus,
  }) {
    if (priceRange != null) _priceRange = priceRange;
    if (selectedBHKs != null) _selectedBHKs = selectedBHKs;
    if (selectedPropertyTypes != null) _selectedPropertyTypes = selectedPropertyTypes;
    if (constructionStatus != null) _constructionStatus = constructionStatus;
    fetchProperties();
  }

  void resetFilters() {
    _selectedCategory = 'All';
    _searchQuery = '';
    _priceRange = const RangeValues(0, 50000000);
    _constructionStatus = 'Any';
    _isNearbyActive = false;
    fetchProperties();
  }

  Future<void> searchNearMe() async {
    _isLoading = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        throw 'Location services are disabled.';
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          throw 'Location permissions are denied';
        }
      }
      
      if (permission == LocationPermission.deniedForever) {
        throw 'Location permissions are permanently denied';
      }

      _currentPosition = await Geolocator.getCurrentPosition();
      _isNearbyActive = true;
      _searchQuery = ''; // Clear search when finding nearby
      fetchProperties();
    } catch (e) {
      debugPrint('Error getting location: $e');
      _errorMessage = e.toString();
      _isNearbyActive = false;
      notifyListeners();
    }
  }

  Future<void> fetchProperties() async {
    _isLoading = true;
    notifyListeners();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 300));
      
      _properties = _cachedAllProperties.where((p) {
        final matchesCategory = _selectedCategory == 'All' || p.category == _selectedCategory;
        final matchesPrice = p.price >= _priceRange.start && p.price <= _priceRange.end;
        final matchesBeds = _selectedBHKs.isEmpty || _selectedBHKs.contains(p.beds);
        
        final matchesType = _selectedPropertyTypes.isEmpty || _selectedPropertyTypes.contains(p.category);
        
        final matchesStatus = _constructionStatus == 'Any' || 
          (_constructionStatus == 'Ready to Move' && p.id.hashCode % 2 == 0) ||
          (_constructionStatus == 'Under Construction' && p.id.hashCode % 2 != 0);

        final matchesSearch = _searchQuery.isEmpty || 
          p.locationAddress.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          p.title.toLowerCase().contains(_searchQuery.toLowerCase());
        
        bool matchesProximity = true;
        if (_isNearbyActive && _currentPosition != null) {
          double distance = Geolocator.distanceBetween(
            _currentPosition!.latitude,
            _currentPosition!.longitude,
            p.latitude,
            p.longitude,
          );
          // Standardize: Increase radius to 10,000km for debugging
          matchesProximity = distance < 10000000; 
          debugPrint('Property ${p.id} distance: ${distance}m, matches: $matchesProximity');
        }
        
        return matchesCategory && matchesPrice && matchesBeds && matchesType && matchesStatus && matchesSearch && matchesProximity;
      }).toList();
      debugPrint('Fetched ${_properties.length} properties (Nearby active: $_isNearbyActive)');

    } catch (e) {
      debugPrint('Error fetching properties: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<PropertyEntity> getSavedProperties() {
    return _cachedAllProperties.where((p) => _savedPropertyIds.contains(p.id)).toList();
  }

  List<PropertyEntity> _getInitialMockProperties() {
    return [
      PropertyModel(
        id: '1',
        ownerId: 'mock_1',
        title: 'Modern Villa in Thindal',
        description: 'Luxury 4-bedroom villa with private garden, smart home features, and panoramic views of Erode city.',
        price: 15000000,
        category: 'House',
        locationAddress: 'Thindal, Erode, Tamil Nadu',
        images: const ['https://images.unsplash.com/photo-1613490493576-7fde63acd811?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'],
        beds: 4,
        baths: 3,
        sqft: 2800.0,
        latitude: 11.3410,
        longitude: 77.7172,
      ),
      PropertyModel(
        id: '2',
        ownerId: 'mock_2',
        title: 'Skyline Apartment',
        description: 'Prime location sky-rise apartment with modern amenities, central AC, and 24/7 security.',
        price: 8500000,
        category: 'Apartment',
        locationAddress: 'Perundurai Road, Erode, Tamil Nadu',
        images: const ['https://images.unsplash.com/photo-1545324418-cc1a3fa10c00?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'],
        beds: 2,
        baths: 2,
        sqft: 1250.0,
        latitude: 11.3483,
        longitude: 77.7064,
      ),
      PropertyModel(
        id: '3',
        ownerId: 'mock_3',
        title: 'Riverside Retreat',
        description: 'Beautiful independent house near Bhavani river with lush green surroundings and traditional architecture.',
        price: 12000000,
        category: 'House',
        locationAddress: 'Bhavani, Erode, Tamil Nadu',
        images: const ['https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'],
        beds: 3,
        baths: 2,
        sqft: 1850.0,
        latitude: 11.4503,
        longitude: 77.6833,
      ),
      PropertyModel(
        id: '4',
        ownerId: 'mock_4',
        title: 'Compact Studio',
        description: 'Minimalist studio apartment perfect for young professionals, featuring efficient space design.',
        price: 4500000,
        category: 'Apartment',
        locationAddress: 'Solar, Erode, Tamil Nadu',
        images: const ['https://images.unsplash.com/photo-1522708323590-d24dbb6b0267?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'],
        beds: 1,
        baths: 1,
        sqft: 650.0,
        latitude: 11.3197,
        longitude: 77.7337,
      ),
      PropertyModel(
        id: '5',
        ownerId: 'mock_5',
        title: 'Commercial Office Space',
        description: 'Strategic commercial hub in the heart of Erode, suitable for corporate offices or clinics.',
        price: 35000000,
        category: 'Commercial',
        locationAddress: 'Brough Road, Erode, Tamil Nadu',
        images: const ['https://images.unsplash.com/photo-1497366216548-37526070297c?ixlib=rb-4.0.3&auto=format&fit=crop&w=1000&q=80'],
        beds: 0,
        baths: 2,
        sqft: 3500.0,
        latitude: 11.3412,
        longitude: 77.7275,
      ),
    ];
  }

  Future<void> addProperty({
    required String title,
    required String description,
    required double price,
    required String category,
    required String location,
  }) async {
    final newProperty = PropertyModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      ownerId: 'current_user',
      title: title,
      description: description,
      price: price,
      category: category,
      locationAddress: location,
      images: const ['https://images.unsplash.com/photo-1560518883-ce09059eeffa'],
      beds: 3,
      baths: 2,
      sqft: 1500.0,
      latitude: 11.3410,
      longitude: 77.7172,
    );
    
    _cachedAllProperties.insert(0, newProperty);
    fetchProperties();
  }
}
