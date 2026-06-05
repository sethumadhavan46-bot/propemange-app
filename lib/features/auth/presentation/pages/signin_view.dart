import 'package:flutter/material.dart';

class SignInView extends StatefulWidget {
  const SignInView({super.key});

  @override
  State<SignInView> createState() => _SignInViewState();
}

class _SignInViewState extends State<SignInView> {
  bool _isAgent = false;
  bool _agreedToTerms = false;

  void _handleSignIn() {
    if (!_agreedToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please agree to the Terms & Conditions'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Login successful!'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 2),
      ),
    );

    Future.delayed(const Duration(seconds: 1), () {
      if (mounted) {
        Navigator.pop(context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD), // Light blue background
      body: Stack(
        children: [
          // Top Branding Section
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.5,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const Text(
                    'propeMange',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFF1B1B1B),
                      letterSpacing: -1,
                    ),
                  ),
                  const SizedBox(height: 30),
                  // Image Decoration Stack
                  SizedBox(
                    height: 180,
                    width: double.infinity,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        // Main Circular Image
                        Container(
                          width: 200,
                          height: 180,
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                            image: DecorationImage(
                              image: NetworkImage('https://images.unsplash.com/photo-1560518883-ce09059eeffa?ixlib=rb-4.0.3&auto=format&fit=crop&w=400&q=80'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        // Floating Property Card 1
                        Positioned(
                          left: 40,
                          bottom: 20,
                          child: _buildFloatingCard('https://images.unsplash.com/photo-1512917774080-9991f1c4c750?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'),
                        ),
                        // Floating Property Card 2
                        Positioned(
                          right: 40,
                          top: 20,
                          child: _buildFloatingCard('https://images.unsplash.com/photo-1613490493576-7fde63acd811?ixlib=rb-4.0.3&auto=format&fit=crop&w=200&q=80'),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '10 lac+ property listings to',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B1B1B)),
                  ),
                  const Text(
                    'choose on propeMange',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1B1B1B)),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Search properties and contact sellers for FREE',
                    style: TextStyle(fontSize: 14, color: Colors.black54),
                  ),
                ],
              ),
            ),
          ),

          // Bottom Sheet Section
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.55,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFFF5F7F9),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Text(
                          'Verified By ',
                          style: TextStyle(fontSize: 16, color: Colors.black87),
                        ),
                        Image.network(
                          'https://upload.wikimedia.org/wikipedia/commons/e/e5/Truecaller_logo.png',
                          height: 18,
                          errorBuilder: (context, error, stackTrace) => const Text('truecaller', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Truecaller Card
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: Colors.blue.shade50,
                            child: const Text('AV', style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 18)),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: const [
                                    Text('+91 9500628792', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                    SizedBox(width: 4),
                                    Icon(Icons.check_circle, color: Colors.blue, size: 18),
                                  ],
                                ),
                                const Text('Aravind V', style: TextStyle(color: Colors.grey, fontSize: 14)),
                                const Text('aravind22052005@gmail.com', style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          const Icon(Icons.edit, color: Colors.grey, size: 24),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text('Are you a Real Estate Agent?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(child: _buildRoleButton('Yes', _isAgent)),
                        const SizedBox(width: 12),
                        Expanded(child: _buildRoleButton('No', !_isAgent)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        Checkbox(
                          value: _agreedToTerms,
                          onChanged: (val) => setState(() => _agreedToTerms = val ?? false),
                          activeColor: const Color(0xFF0078DB),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                        ),
                        Expanded(
                          child: Wrap(
                            children: const [
                              Text('I agree to the ', style: TextStyle(fontSize: 12)),
                              Text('Terms & Conditions', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
                              Text(' and ', style: TextStyle(fontSize: 12)),
                              Text('Privacy Policy', style: TextStyle(fontSize: 12, color: Colors.blue, fontWeight: FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    if (!_agreedToTerms)
                      const Padding(
                        padding: EdgeInsets.only(left: 48.0),
                        child: Text(
                          'This is required for creating an account',
                          style: TextStyle(color: Colors.red, fontSize: 11),
                        ),
                      ),
                    const SizedBox(height: 32),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _handleSignIn,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _agreedToTerms ? const Color(0xFF81D4FA) : Colors.grey.shade300,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          elevation: 0,
                        ),
                        child: const Text('Done', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Close button
          Positioned(
            top: 40,
            left: 16,
            child: IconButton(
              icon: const Icon(Icons.close, color: Colors.black87),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFloatingCard(String imageUrl) {
    return Container(
      width: 100,
      height: 120,
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
      padding: const EdgeInsets.all(4),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(imageUrl, height: 60, width: 92, fit: BoxFit.cover),
          ),
          const SizedBox(height: 4),
          const Text('Property', style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
          const Text('Listing', style: TextStyle(fontSize: 8, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildRoleButton(String label, bool isSelected) {
    return InkWell(
      onTap: () => setState(() => _isAgent = (label == 'Yes')),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: isSelected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? Colors.blue : Colors.grey.shade300),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black87,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
