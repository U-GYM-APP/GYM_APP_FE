import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import 'calculate_nutrition_screen.dart'; // ✅ optional - link to other features

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Gym Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        flexibleSpace: const DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4facfe), Color(0xff00f2fe)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            tooltip: "Logout",
            onPressed: () async {
              await auth.logout();
              // ✅ Optional: Navigate back to login after logout
              Navigator.popUntil(context, (route) => route.isFirst);
            },
          ),
        ],
      ),

      // ====== Body Section ======
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff4facfe), Color(0xff00f2fe)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(60),
                  bottomRight: Radius.circular(60),
                ),
              ),
              child: Column(
                children: const [
                  Icon(Icons.fitness_center, size: 80, color: Colors.white),
                  SizedBox(height: 10),
                  Text(
                    "Welcome to Your Gym Dashboard 💪",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    "Track your goals, nutrition, and progress",
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40),

            // Action cards / navigation options
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  _buildDashboardCard(
                    context,
                    icon: Icons.calculate_outlined,
                    title: "Calculate Nutrition",
                    description:
                        "Get your daily calories, protein, carbs, and fiber.",
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (_) => const ProfileScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildDashboardCard(
                    context,
                    icon: Icons.person_outline,
                    title: "Profile & Goals",
                    description:
                        "View and update your fitness goals easily.",
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Coming Soon!")),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  _buildDashboardCard(
                    context,
                    icon: Icons.logout,
                    title: "Logout",
                    description: "Sign out from your account safely.",
                    onTap: () async {
                      await auth.logout();
                      Navigator.popUntil(context, (route) => route.isFirst);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ===== Reusable Dashboard Card Widget =====
  Widget _buildDashboardCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String description,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Container(
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [Color(0xff4facfe), Color(0xff00f2fe)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              padding: const EdgeInsets.all(12),
              child: Icon(icon, size: 30, color: Colors.white),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: const TextStyle(color: Colors.black54, fontSize: 13),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios,
                size: 18, color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
