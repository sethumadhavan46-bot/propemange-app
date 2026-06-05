import 'package:flutter/material.dart';
import '../widgets/propemange_widgets.dart';

class AccountView extends StatelessWidget {
  const AccountView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          _buildActionCards(context),
          const SizedBox(height: 24),
          _buildSearchActivity(),
          const SizedBox(height: 24),
          _buildMenuItem(Icons.home_outlined, 'Homepage'),
          const SizedBox(height: 24),
          _buildSectionHeader('RESEARCH AND INSIGHTS'),
          _buildMenuItem(Icons.bar_chart_outlined, 'Price Trends', subtitle: 'Explore locality and society level price growth/ drops'),
          const Divider(height: 1, indent: 56),
          _buildMenuItem(Icons.newspaper_outlined, 'Articles and News', subtitle: 'Articles, News, Policies, Guides...'),
          const SizedBox(height: 32),
          _buildRateOurApp(),
          const SizedBox(height: 40),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 16, right: 16, bottom: 24),
      decoration: const BoxDecoration(
        color: PropeMangeColors.accentBlue,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(16),
          bottomRight: Radius.circular(16),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: Text(
              'AV',
              style: TextStyle(
                color: PropeMangeColors.accentBlue,
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Aravind V',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: const [
                    Text(
                      'Buyer/ Tenant Profile',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 4.0),
                      child: Icon(Icons.circle, size: 4, color: Colors.white70),
                    ),
                    Text(
                      'Manage Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionCards(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        children: [
          _buildLargeActionCard(
            'Post Property',
            'Sell/ Rent faster with 99acres',
            Icons.home_work_outlined,
            Colors.blue.shade50,
          ),
          const SizedBox(height: 12),
          _buildLargeActionCard(
            'Post Property via Whatsapp',
            'Faster property posting experience',
            Icons.chat_bubble_outline,
            Colors.green.shade50,
            iconColor: Colors.green,
          ),
          const SizedBox(height: 12),
          _buildLargeActionCard(
            'Search Properties',
            'Explore residential and commercial properties',
            Icons.search,
            Colors.orange.shade50,
            iconColor: Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildLargeActionCard(String title, String subtitle, IconData icon, Color bgColor, {Color? iconColor}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        subtitle: Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: iconColor ?? PropeMangeColors.accentBlue, size: 28),
        ),
      ),
    );
  }

  Widget _buildSearchActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('YOUR PROPERTY SEARCH ACTIVITY'),
        const SizedBox(height: 8),
        Container(
          margin: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              _buildActivityItem(Icons.visibility_outlined, 'Viewed', 'Properties'),
              _buildVerticalDivider(),
              _buildActivityItem(Icons.star_outline, 'Shortlisted', 'Properties'),
              _buildVerticalDivider(),
              _buildActivityItem(Icons.phone_in_talk_outlined, 'Contacted', 'Properties'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActivityItem(IconData icon, String title, String subtitle) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20),
        child: Column(
          children: [
            Icon(icon, color: Colors.grey.shade600, size: 22),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
            Text(subtitle, style: TextStyle(color: Colors.grey.shade600, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildVerticalDivider() {
    return Container(
      height: 40,
      width: 1,
      color: Colors.grey.shade200,
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey.shade600,
          fontSize: 11,
          fontWeight: FontWeight.bold,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String title, {String? subtitle}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: Colors.grey.shade600, size: 22),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
        subtitle: subtitle != null ? Text(subtitle, style: TextStyle(color: Colors.grey.shade500, fontSize: 12)) : null,
        onTap: () {},
      ),
    );
  }

  Widget _buildRateOurApp() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Rate Our App', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: List.generate(5, (index) => Icon(Icons.star_outline, color: Colors.grey.shade400, size: 24)),
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.star_outline, size: 18),
                label: const Text('Rate App'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: PropeMangeColors.accentBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
