import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/property_entity.dart';
import '../providers/property_provider.dart';

class PropertyCard extends StatelessWidget {
  final PropertyEntity property;
  final VoidCallback onTap;
  final String heroSuffix;

  const PropertyCard({
    super.key,
    required this.property,
    required this.onTap,
    this.heroSuffix = '',
  });

  @override
  Widget build(BuildContext context) {
    final priceFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final numberFormatter = NumberFormat.decimalPattern();

    return InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAlias,
        elevation: 1,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Hero(
                  tag: 'property-image-${property.id}$heroSuffix',
                  child: Image.network(
                    property.images.isNotEmpty ? property.images.first : 'https://images.unsplash.com/photo-1560518883-ce09059eeffa',
                    height: 160,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 8,
                  left: 8,
                  child: Row(
                    children: [
                      if (property.id.hashCode % 2 == 0)
                        _buildBadge('VERIFIED', Colors.blue, Icons.verified_user),
                      const SizedBox(width: 4),
                      if (property.id.hashCode % 3 == 0)
                        _buildBadge('RERA', Colors.orange, Icons.gavel),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 8,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.6),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      property.id.hashCode % 4 == 0 ? 'Owner' : 'Dealer',
                      style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                Positioned(
                  top: 8,
                  right: 8,
                  child: Consumer<PropertyProvider>(
                    builder: (context, provider, child) {
                      final isSaved = provider.isSaved(property.id);
                      return GestureDetector(
                        onTap: () => provider.toggleSaveProperty(property.id),
                        child: CircleAvatar(
                          backgroundColor: Colors.white.withOpacity(0.9),
                          radius: 18,
                          child: Icon(
                            isSaved ? Icons.favorite : Icons.favorite_border,
                            color: isSaved ? Colors.red : Colors.black87,
                            size: 20,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    priceFormatter.format(property.price),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text('${property.beds}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const Text(' bd | ', style: TextStyle(fontSize: 13)),
                      Text('${property.baths}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const Text(' ba | ', style: TextStyle(fontSize: 13)),
                      Text(numberFormatter.format(property.sqft), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                      const Text(' sqft', style: TextStyle(fontSize: 13)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    property.locationAddress,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBadge(String text, Color color, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 10),
          const SizedBox(width: 2),
          Text(
            text,
            style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
