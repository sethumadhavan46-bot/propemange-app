import 'package:flutter/material.dart';
import '../pages/add_property_view.dart';

class PropeMangeColors {
  static const Color primaryGreen = Color(0xFF004840);
  static const Color accentBlue = Color(0xFF0078DB);
  static const Color lightBlue = Color(0xFFF1F7FF);
}

class PropeMangeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuPressed;
  final VoidCallback onProfilePressed;

  const PropeMangeAppBar({
    super.key,
    required this.onMenuPressed,
    required this.onProfilePressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: PropeMangeColors.primaryGreen,
      elevation: 0,
      title: Row(
        children: [
          const Text(
            'propemange',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.white70),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Row(
              children: const [
                Text(
                  'All India',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
                Icon(Icons.keyboard_arrow_down, color: Colors.white, size: 16),
              ],
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {},
          child: const Text('For Buyers', style: TextStyle(color: Colors.white, fontSize: 12)),
        ),
        IconButton(
          onPressed: onProfilePressed,
          icon: const Icon(Icons.account_circle_outlined, color: Colors.white),
        ),
        IconButton(
          onPressed: onMenuPressed,
          icon: const Icon(Icons.menu, color: Colors.white),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class HeroBannerSection extends StatelessWidget {
  const HeroBannerSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: const BoxDecoration(
        color: PropeMangeColors.primaryGreen,
      ),
      child: Stack(
        children: [
          Positioned(
            right: 0,
            bottom: 0,
            top: 0,
            child: Opacity(
              opacity: 0.6,
              child: Image.network(
                'https://static.propemange.com/universal/images/skyscraper_banner.png', // Replace with actual asset if available
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Spacer(),
                const Text(
                  'A LANDMARK OF ELEVATED LIVING\nIN NEW GURUGRAM',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.1,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  '3 BHK + 3T | Starting @ ₹2.75 Cr*',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PropeMangeColors.accentBlue,
                    foregroundColor: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: const [
                      Text('Explore Now', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(width: 8),
                      Icon(Icons.arrow_right_alt),
                    ],
                  ),
                ),
                const SizedBox(height: 60), // Space for search card overlap
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SearchCardOverlay extends StatefulWidget {
  final Function(String query) onSearch;
  final Function(String category) onCategoryChanged;
  final VoidCallback onSearchNearMe;

  const SearchCardOverlay({
    super.key,
    required this.onSearch,
    required this.onCategoryChanged,
    required this.onSearchNearMe,
  });

  @override
  State<SearchCardOverlay> createState() => _SearchCardOverlayState();
}

class _SearchCardOverlayState extends State<SearchCardOverlay> {
  int _selectedTabIndex = 0;
  final TextEditingController _searchController = TextEditingController();

  final List<String> _tabs = ['Buy', 'Rent', 'New Launch', 'Commercial', 'Plots/Land', 'Projects'];

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: _tabs.asMap().entries.map((entry) {
                final index = entry.key;
                final label = entry.value;
                final isSelected = _selectedTabIndex == index;
                return InkWell(
                  onTap: () {
                    setState(() => _selectedTabIndex = index);
                    widget.onCategoryChanged(label);
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: isSelected ? PropeMangeColors.accentBlue : Colors.transparent,
                          width: 3,
                        ),
                      ),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        color: isSelected ? PropeMangeColors.accentBlue : Colors.black87,
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(height: 1),
          // Search Input Area
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => widget.onSearch(''), // Trigger search navigation
                    child: AbsorbPointer(
                      child: Row(
                        children: [
                          const Icon(Icons.search, color: Colors.grey),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              decoration: const InputDecoration(
                                hintText: 'Search "Farm house in Punjab below 1 cr"',
                                border: InputBorder.none,
                                hintStyle: TextStyle(fontSize: 14, color: Colors.grey),
                              ),
                              onSubmitted: widget.onSearch,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => widget.onSearch(''), // Microphone icon on home
                  icon: const Icon(Icons.mic, color: PropeMangeColors.accentBlue),
                ),
                const SizedBox(width: 12),
                ElevatedButton(
                  onPressed: () => widget.onSearch(_searchController.text),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PropeMangeColors.accentBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Text('Search'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class QuickLinkItem extends StatelessWidget {
  final String title;
  final String? label;
  final String image;
  final VoidCallback onTap;

  const QuickLinkItem({
    super.key,
    required this.title,
    this.label,
    required this.image,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 120,
        height: 150,
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    image,
                    width: 120,
                    height: 80,
                    fit: BoxFit.cover,
                  ),
                ),
                if (label != null)
                  Positioned(
                    top: 4,
                    left: 4,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        label!,
                        style: const TextStyle(color: Colors.white, fontSize: 8),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
class ExploreServicesSection extends StatelessWidget {
  const ExploreServicesSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF5F7F9),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Sidebar
              SizedBox(
                width: 200,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSidebarItem('RENT A HOME'),
                    _buildSidebarItem('PG/CO-LIVING'),
                    _buildSidebarItem('COMMERCIAL'),
                    _buildSidebarItem('INSIGHTS', hasBadge: true),
                    _buildSidebarItem('ARTICLES & NEWS'),
                    const SizedBox(height: 60),
                    const Text(
                      'contact us toll free on',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    const Text(
                      '1800 41 99099 (9AM-11PM IST)',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.black87),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 40),
              // Top Cities List
              const Expanded(
                flex: 2,
                child: TopCitiesList(),
              ),
              const SizedBox(width: 40),
              // Insights Card
              const Expanded(
                flex: 3,
                child: InsightsCard(),
              ),
            ],
          ),
          const SizedBox(height: 40),
          const Divider(),
          const SizedBox(height: 16),
          const Center(
            child: Text(
              'Email us at services@propemange.com. or call us at 1800 41 99099 (IND Toll-Free)',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebarItem(String title, {bool hasBadge = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
              letterSpacing: 0.5,
            ),
          ),
          if (hasBadge) ...[
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: PropeMangeColors.accentBlue,
                borderRadius: BorderRadius.circular(2),
              ),
              child: const Text(
                'NEW',
                style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class TopCitiesList extends StatelessWidget {
  const TopCitiesList({super.key});

  final List<String> cities = const [
    'Delhi / NCR',
    'Mumbai',
    'Bangalore',
    'Hyderabad Metropolitan Region',
    'Pune',
    'Kolkata',
    'Chennai',
    'Ahmedabad'
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TOP CITIES',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
            letterSpacing: 1.1,
          ),
        ),
        const SizedBox(height: 16),
        ...cities.map((city) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                'Property for rent in $city',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            )),
      ],
    );
  }
}

class InsightsCard extends StatelessWidget {
  const InsightsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: PropeMangeColors.lightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'INTRODUCING',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                      letterSpacing: 1.1,
                    ),
                  ),
                  const Text(
                    'Insights',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1A1A1A),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.north_east, color: PropeMangeColors.accentBlue),
            ],
          ),
          const SizedBox(height: 24),
          _buildInsightFeature('Understand localities'),
          _buildInsightFeature('Read Resident Reviews'),
          _buildInsightFeature('Check Price Trends'),
          _buildInsightFeature('Tools, Utilities & more'),
        ],
      ),
    );
  }

  Widget _buildInsightFeature(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          const Icon(Icons.check_circle_outline, color: Colors.blue, size: 20),
          const SizedBox(width: 12),
          Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
class PostPropertySection extends StatelessWidget {
  const PostPropertySection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Are you a Property Owner?',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Sell or Rent your property for free on propemange.',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const AddPropertyView()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: PropeMangeColors.accentBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                  child: const Text('Post your Property for FREE'),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          Image.network(
            'https://static.propemange.com/universal/images/owner_listing_v1.png', // Mock illustration
            width: 100,
            height: 100,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => const Icon(
              Icons.home_work_outlined,
              size: 80,
              color: PropeMangeColors.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }
}
