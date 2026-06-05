import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/property_provider.dart';
import '../widgets/property_card.dart';
import 'add_property_view.dart';
import 'property_details_view.dart';
import 'search_view.dart';
import '../widgets/custom_bottom_nav.dart';
import '../widgets/propemange_widgets.dart';
import '../../../auth/presentation/pages/signin_view.dart';
import 'account_view.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _currentIndex = 0;
  final TextEditingController _heroSearchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        Provider.of<PropertyProvider>(context, listen: false).fetchProperties());
  }

  @override
  void dispose() {
    _heroSearchController.dispose();
    super.dispose();
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _filterByCategory(String category) {
    Provider.of<PropertyProvider>(context, listen: false).setCategory(category);
    setState(() {
      _currentIndex = 2; // Jump to search view
    });
  }

  void _handleHeroSearch(String value) {
    if (value.isNotEmpty) {
      Provider.of<PropertyProvider>(context, listen: false).setSearchQuery(value);
    }
    setState(() {
      _currentIndex = 2; // Jump to search view
    });
  }

  @override
  Widget build(BuildContext context) {
    // Listen for errors from provider
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
      drawer: _buildDrawer(),
      appBar: (_currentIndex == 0 || _currentIndex == 1) 
          ? PropeMangeAppBar(
              onMenuPressed: () => Scaffold.of(context).openDrawer(),
              onProfilePressed: () => _onTabTapped(4),
            ) 
          : null,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _buildDiscoveryHome(),
          _buildSavedView(),
          const SearchView(),
          _buildUpdatesView(), 
          const AccountView(),
        ],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onTabTapped,
      ),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: PropeMangeColors.primaryGreen),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('propemange', style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('Premium Real Estate in Tamil Nadu', style: TextStyle(color: Colors.white70)),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Home'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 0);
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Settings'),
            onTap: () {
              Navigator.pop(context);
              setState(() => _currentIndex = 4);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildDiscoveryHome() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const HeroBannerSection(),
          Transform.translate(
            offset: const Offset(0, -50),
            child: SearchCardOverlay(
              onSearch: _handleHeroSearch,
              onSearchNearMe: () => Provider.of<PropertyProvider>(context, listen: false).searchNearMe().then((_) => setState(() => _currentIndex = 2)),
              onCategoryChanged: (category) {
                // Map propemange tabs to provider categories
                String mappedCategory = 'All';
                if (category == 'Commercial') {
                  mappedCategory = 'Commercial';
                } else if (category == 'Buy' || category == 'Rent') {
                  mappedCategory = 'All'; // Or specific logic
                }
                
                Provider.of<PropertyProvider>(context, listen: false).setCategory(mappedCategory);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'EXPLORE PREMIUM REAL ESTATE IN TAMIL NADU, INDIA',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.grey,
              ),
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 160,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                QuickLinkItem(
                  title: 'Buying a home',
                  image: 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
                  onTap: () => _filterByCategory('House'),
                ),
                const SizedBox(width: 12),
                QuickLinkItem(
                  title: 'Renting a home',
                  image: 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
                  onTap: () => _filterByCategory('Apartment'),
                ),
                const SizedBox(width: 12),
                QuickLinkItem(
                  title: 'Invest in Real Estate',
                  label: 'NEW',
                  image: 'https://images.unsplash.com/photo-1560520653-9e0e4c89eb11?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
                  onTap: () => _filterByCategory('Plot'),
                ),
                const SizedBox(width: 12),
                QuickLinkItem(
                  title: 'Sell/Rent your property',
                  image: 'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPropertyView())),
                ),
                const SizedBox(width: 12),
                QuickLinkItem(
                  title: 'Plots/Land',
                  image: 'https://images.unsplash.com/photo-1500382017468-9049fed747ef?ixlib=rb-4.0.3&auto=format&fit=crop&w=300&q=80',
                  onTap: () {},
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const PostPropertySection(),
          const SizedBox(height: 24),
          _buildSectionHeader('Trending Properties', 'Based on recent activity', onSeeAll: () => setState(() => _currentIndex = 2)),
          _buildTrendingProperties(),
          _buildSectionHeader('Recommendations', 'Curated for you', onSeeAll: () => setState(() => _currentIndex = 2)),
          _buildRecommendationsGrid(),
          const SizedBox(height: 40),
          const ExploreServicesSection(),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSavedView() {
    return Consumer<PropertyProvider>(
      builder: (context, provider, child) {
        final savedPros = provider.getSavedProperties();
        return savedPros.isEmpty
            ? _buildPlaceholder('No saved homes yet', Icons.favorite_border, 'Tap the heart icon on any home to save it.')
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: savedPros.length,
                separatorBuilder: (_, __) => const SizedBox(height: 16),
                itemBuilder: (context, index) {
                  final prop = savedPros[index];
                  return PropertyCard(
                    property: prop,
                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailsView(property: prop))),
                  );
                },
              );
      },
    );
  }

  Widget _buildUpdatesView() {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7F9),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text('Updates', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold, fontSize: 18)),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(vertical: 8),
        children: [
          _buildUpdateSection('ACTIVITY', [
            _buildUpdateItem('New Listing', 'A new villa was posted in Thindal, Erode', '2h ago', Icons.home_work_outlined),
            _buildUpdateItem('Price Drop', 'Modern Apartment price reduced by ₹5,00,000', '5h ago', Icons.trending_down),
          ]),
          const SizedBox(height: 8),
          _buildUpdateSection('RECOMMENDED FOR YOU', [
            _buildUpdateItem('Price Trends', 'Property prices in Thindal are rising. Check out why.', '1d ago', Icons.insights),
            _buildUpdateItem('Resident Reviews', 'New reviews for Perundurai Road apartments.', '2d ago', Icons.rate_review_outlined),
          ]),
        ],
      ),
    );
  }

  Widget _buildUpdateSection(String title, List<Widget> items) {
    return Container(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Colors.grey, letterSpacing: 1.1),
          ),
          const SizedBox(height: 16),
          ...items,
        ],
      ),
    );
  }

  Widget _buildUpdateItem(String title, String subtitle, String time, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: PropeMangeColors.primaryGreen.withOpacity(0.05),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: PropeMangeColors.primaryGreen, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                    Text(time, style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
                const SizedBox(height: 4),
                Text(subtitle, style: const TextStyle(fontSize: 13, color: Colors.black54, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildPlaceholder(String title, IconData icon, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[200]),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Text(subtitle, textAlign: TextAlign.center, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }




  Widget _buildSectionHeader(String title, String subtitle, {VoidCallback? onSeeAll}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              if (onSeeAll != null) TextButton(onPressed: onSeeAll, child: const Text('See all', style: TextStyle(color: Color(0xFF004840)))),
            ],
          ),
          Text(subtitle, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
        ],
      ),
    );
  }

  Widget _buildTrendingProperties() {
    return Consumer<PropertyProvider>(
      builder: (context, provider, child) {
        final properties = provider.properties.take(5).toList();
        if (properties.isEmpty) return const SizedBox.shrink();
        return SizedBox(
          height: 260,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            scrollDirection: Axis.horizontal,
            itemCount: properties.length,
            separatorBuilder: (_, __) => const SizedBox(width: 12),
            itemBuilder: (context, index) => SizedBox(width: 220, child: PropertyCard(heroSuffix: '-trending', property: properties[index], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailsView(property: properties[index]))))),
          ),
        );
      },
    );
  }

  Widget _buildRecommendationsGrid() {
    return Consumer<PropertyProvider>(
      builder: (context, provider, child) {
        final properties = provider.properties.skip(1).take(4).toList();
        if (properties.isEmpty) return const SizedBox.shrink();
        return GridView.builder(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: 0.8),
          itemCount: properties.length,
          itemBuilder: (context, index) => PropertyCard(heroSuffix: '-rec', property: properties[index], onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => PropertyDetailsView(property: properties[index])))),
        );
      },
    );
  }
}
