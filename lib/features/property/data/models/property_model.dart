import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/property_entity.dart';

class PropertyModel extends PropertyEntity {
  const PropertyModel({
    required String id,
    required String ownerId,
    required String title,
    required String description,
    required double price,
    required String category,
    required String locationAddress,
    required List<String> images,
    required int beds,
    required int baths,
    required double sqft,
    required double latitude,
    required double longitude,
  }) : super(
          id: id,
          ownerId: ownerId,
          title: title,
          description: description,
          price: price,
          category: category,
          locationAddress: locationAddress,
          images: images,
          beds: beds,
          baths: baths,
          sqft: sqft,
          latitude: latitude,
          longitude: longitude,
        );

  factory PropertyModel.fromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return PropertyModel(
      id: doc.id,
      ownerId: data['ownerId'] ?? '',
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      price: (data['price'] ?? 0).toDouble(),
      category: data['category'] ?? '',
      locationAddress: data['location'] ?? '',
      images: List<String>.from(data['images'] ?? []),
      beds: data['beds'] ?? 0,
      baths: data['baths'] ?? 0,
      sqft: (data['sqft'] ?? 0).toDouble(),
      latitude: (data['latitude'] ?? 0).toDouble(),
      longitude: (data['longitude'] ?? 0).toDouble(),
    );
  }

  Map<String, dynamic> toDocument() {
    return {
      'ownerId': ownerId,
      'title': title,
      'description': description,
      'price': price,
      'category': category,
      'location': locationAddress,
      'images': images,
      'beds': beds,
      'baths': baths,
      'sqft': sqft,
      'latitude': latitude,
      'longitude': longitude,
      'createdAt': FieldValue.serverTimestamp(),
    };
  }
}
