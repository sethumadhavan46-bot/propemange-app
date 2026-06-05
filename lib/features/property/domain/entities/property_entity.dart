import 'package:equatable/equatable.dart';

class PropertyEntity extends Equatable {
  final String id;
  final String ownerId;
  final String title;
  final String description;
  final double price;
  final String category;
  final String locationAddress;
  final List<String> images;
  final int beds;
  final int baths;
  final double sqft;
  final double latitude;
  final double longitude;

  const PropertyEntity({
    required this.id,
    required this.ownerId,
    required this.title,
    required this.description,
    required this.price,
    required this.category,
    required this.locationAddress,
    required this.images,
    required this.beds,
    required this.baths,
    required this.sqft,
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [
        id,
        ownerId,
        title,
        description,
        price,
        category,
        locationAddress,
        images,
        beds,
        baths,
        sqft,
        latitude,
        longitude,
      ];
}
