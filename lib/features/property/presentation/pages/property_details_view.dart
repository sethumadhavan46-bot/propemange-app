import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../domain/entities/property_entity.dart';
import '../providers/property_provider.dart';
import '../widgets/propemange_widgets.dart';

class PropertyDetailsView extends StatelessWidget {
  final PropertyEntity property;

  const PropertyDetailsView({super.key, required this.property});

  @override
  Widget build(BuildContext context) {
    final priceFormatter = NumberFormat.currency(locale: 'en_IN', symbol: '₹', decimalDigits: 0);
    final numberFormatter = NumberFormat.decimalPattern();

    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              _buildSliverAppBar(context),
              SliverToBoxAdapter(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildMainInfo(context, priceFormatter, numberFormatter),
                    const Divider(height: 32, thickness: 0.5),
                    _buildOverviewSection(context),
                    const Divider(height: 32, thickness: 0.5),
                    _buildAmenitiesSection(context),
                    const Divider(height: 32, thickness: 0.5),
                    _buildFloorPlanSection(context),
                    const Divider(height: 32, thickness: 0.5),
                    _buildFactsAndFeatures(context),
                    const SizedBox(height: 100), // Space for sticky footer
                  ],
                ),
              ),
            ],
          ),
          _buildStickyFooter(context),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 300,
      backgroundColor: Colors.white,
      elevation: 0,
      pinned: true,
      leading: IconButton(
        icon: const CircleAvatar(
          backgroundColor: Colors.white70,
          child: Icon(Icons.arrow_back, color: Colors.black87),
        ),
        onPressed: () => Navigator.pop(context),
      ),
      actions: [
        Consumer<PropertyProvider>(
          builder: (context, provider, child) {
            final isSaved = provider.isSaved(property.id);
            return IconButton(
              icon: CircleAvatar(
                backgroundColor: Colors.white70,
                child: Icon(
                  isSaved ? Icons.favorite : Icons.favorite_border,
                  color: isSaved ? Colors.red : Colors.black87,
                ),
              ),
              onPressed: () => provider.toggleSaveProperty(property.id),
            );
          },
        ),
        IconButton(
          icon: const CircleAvatar(
            backgroundColor: Colors.white70,
            child: Icon(Icons.share_outlined, color: Colors.black87),
          ),
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Share link copied to clipboard!')),
            );
          },
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          fit: StackFit.expand,
          children: [
            if (property.images.isNotEmpty)
              Hero(
                tag: 'property-image-${property.id}',
                child: Image.network(
                  property.images.first,
                  fit: BoxFit.cover,
                ),
              )
            else
              Container(color: Colors.grey[200], child: const Icon(Icons.image, size: 64)),
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.black26, Colors.transparent, Colors.transparent],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainInfo(BuildContext context, NumberFormat priceFmt, NumberFormat numFmt) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            priceFmt.format(property.price),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w900,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Text('${property.beds}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Text(' bd | ', style: TextStyle(fontSize: 16)),
              Text('${property.baths}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Text(' ba | ', style: TextStyle(fontSize: 16)),
              Text(numFmt.format(property.sqft), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              const Text(' sqft', style: TextStyle(fontSize: 16)),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            property.locationAddress,
            style: const TextStyle(fontSize: 16, color: Colors.black54),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _buildStatusBadge('FOR SALE', PropeMangeColors.primaryGreen),
              const SizedBox(width: 8),
              Text('ZEXTIMATE®: ', style: TextStyle(color: Colors.grey[600], fontSize: 12, fontWeight: FontWeight.bold)),
              Text(priceFmt.format(property.price * 1.05), style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(2),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildOverviewSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Overview', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Text(
            property.description,
            style: const TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: () {},
            style: TextButton.styleFrom(padding: EdgeInsets.zero, minimumSize: Size.zero),
            child: const Text('Read more', style: TextStyle(color: PropeMangeColors.primaryGreen, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildFactsAndFeatures(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Facts and features', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 24),
          _buildFeatureRow(Icons.home_outlined, 'Type', property.category),
          _buildFeatureRow(Icons.calendar_today_outlined, 'Year built', '2018'),
          _buildFeatureRow(Icons.straighten, 'Lot size', '0.25 acres'),
          _buildFeatureRow(Icons.severe_cold_outlined, 'Cooling', 'Central Air'),
          _buildFeatureRow(Icons.local_parking_outlined, 'Parking', '2 Parking spaces'),
        ],
      ),
    );
  }

  Widget _buildAmenitiesSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Amenities', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 20),
          Wrap(
            spacing: 24,
            runSpacing: 24,
            children: [
              _buildAmenityItem(Icons.water_drop_outlined, '24x7 Water'),
              _buildAmenityItem(Icons.flash_on_outlined, 'Power Backup'),
              _buildAmenityItem(Icons.security_outlined, 'Security'),
              _buildAmenityItem(Icons.elevator_outlined, 'Lift'),
              _buildAmenityItem(Icons.fitness_center_outlined, 'Gym'),
              _buildAmenityItem(Icons.pool_outlined, 'Pool'),
              _buildAmenityItem(Icons.local_parking_outlined, 'Parking'),
              _buildAmenityItem(Icons.park_outlined, 'Garden'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAmenityItem(IconData icon, String label) {
    return SizedBox(
      width: 70,
      child: Column(
        children: [
          Icon(icon, color: PropeMangeColors.primaryGreen, size: 28),
          const SizedBox(height: 8),
          Text(
            label,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 11, color: Colors.black87),
          ),
        ],
      ),
    );
  }

  Widget _buildFloorPlanSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Floor Plan', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Stack(
              children: [
                Image.network(
                  'https://images.unsplash.com/photo-1574362848149-11496d93a7c7?ixlib=rb-4.0.3&auto=format&fit=crop&w=1200&q=80',
                  height: 200,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
                Container(
                  height: 200,
                  width: double.infinity,
                  color: Colors.black26,
                  child: const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.zoom_in, color: Colors.white, size: 40),
                        SizedBox(height: 8),
                        Text('View Detailed Plan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Icon(icon, color: Colors.grey[600], size: 24),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              Text(value, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.check_circle, color: Colors.green, size: 64),
            const SizedBox(height: 16),
            const Text(
              'Success!',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PropeMangeColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Great'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStickyFooter(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _showSuccessDialog(context, 'Your tour request has been sent to the agent successfully!'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: PropeMangeColors.primaryGreen,
                  side: const BorderSide(color: PropeMangeColors.primaryGreen),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text('Tour with an agent', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () => _showSuccessDialog(context, 'Your inquiry has been sent! The agent will contact you shortly.'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PropeMangeColors.primaryGreen,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  elevation: 0,
                ),
                child: const Text('Contact agent', style: TextStyle(fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
