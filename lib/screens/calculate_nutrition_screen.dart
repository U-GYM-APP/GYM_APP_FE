import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/auth_provider.dart';
import '../constants/api_constants.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _ageController = TextEditingController();
  final _heightController = TextEditingController();
  final _weightController = TextEditingController();

  String? _gender;
  String? _activity;
  String? _goal;

  Map<String, dynamic>? _nutritionResults;
  bool _loading = false;

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 500));
    _fadeAnimation =
        CurvedAnimation(parent: _animationController, curve: Curves.easeInOut);
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) return;

    final auth = Provider.of<AuthProvider>(context, listen: false);
    final token = auth.accessToken;

    if (token == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You must log in first!')),
      );
      return;
    }

    setState(() => _loading = true);

    try {
      final response = await http.post(
        Uri.parse('${baseUrl}calculate-nutrition/'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "age": int.parse(_ageController.text),
          "gender": _gender,
          "height": double.parse(_heightController.text),
          "weight": double.parse(_weightController.text),
          "activity_level": _activity,
          "goal": _goal,
        }),
      );

      if (response.statusCode == 200) {
        setState(() {
          _nutritionResults = jsonDecode(response.body);
        });
        _animationController.forward(from: 0);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed: ${response.statusCode}')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon),
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      filled: true,
      fillColor: Colors.grey[100],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Nutrition Calculator",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff4facfe), Color(0xff00f2fe)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "Enter your details to get your personalized daily nutrition breakdown.",
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),

              // Age
              TextFormField(
                controller: _ageController,
                decoration: _inputDecoration("Age", Icons.cake),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter your age" : null,
              ),
              const SizedBox(height: 15),

              // Gender
              DropdownButtonFormField<String>(
                value: _gender,
                decoration: _inputDecoration("Gender", Icons.person),
                items: const [
                  DropdownMenuItem(value: "male", child: Text("Male")),
                  DropdownMenuItem(value: "female", child: Text("Female")),
                ],
                onChanged: (v) => setState(() => _gender = v),
                validator: (v) => v == null ? "Select gender" : null,
              ),
              const SizedBox(height: 15),

              // Height
              TextFormField(
                controller: _heightController,
                decoration: _inputDecoration("Height (cm)", Icons.height),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter your height" : null,
              ),
              const SizedBox(height: 15),

              // Weight
              TextFormField(
                controller: _weightController,
                decoration: _inputDecoration("Weight (kg)", Icons.monitor_weight),
                keyboardType: TextInputType.number,
                validator: (v) => v!.isEmpty ? "Enter your weight" : null,
              ),
              const SizedBox(height: 15),

              // Activity Level
              DropdownButtonFormField<String>(
                value: _activity,
                decoration: _inputDecoration("Activity Level", Icons.fitness_center),
                items: const [
                  DropdownMenuItem(value: "sedentary", child: Text("Low (Sedentary)")),
                  DropdownMenuItem(value: "lightly_active", child: Text("Lightly Active")),
                  DropdownMenuItem(value: "moderately_active", child: Text("Moderately Active")),
                  DropdownMenuItem(value: "very_active", child: Text("Very Active")),
                ],
                onChanged: (v) => setState(() => _activity = v),
                validator: (v) => v == null ? "Select activity level" : null,
              ),
              const SizedBox(height: 15),

              // Goal
              DropdownButtonFormField<String>(
                value: _goal,
                decoration: _inputDecoration("Goal", Icons.flag),
                items: const [
                  DropdownMenuItem(value: "weight_loss", child: Text("Lose Weight")),
                  DropdownMenuItem(value: "maintain", child: Text("Maintain Weight")),
                  DropdownMenuItem(value: "muscle_gain", child: Text("Gain Muscle")),
                ],
                onChanged: (v) => setState(() => _goal = v),
                validator: (v) => v == null ? "Select goal" : null,
              ),
              const SizedBox(height: 25),

              // Button
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff4facfe),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 3,
                  ),
                  onPressed: _loading ? null : _saveProfile,
                  child: _loading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Calculate Nutrition",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),

              const SizedBox(height: 30),

              // Results Section
              if (_nutritionResults != null)
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Your Nutrition Breakdown",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      _buildNutritionCard(
                          "Calories", _nutritionResults!["calories"], Icons.local_fire_department),
                      _buildNutritionCard(
                          "Protein", _nutritionResults!["protein"], Icons.egg_outlined),
                      _buildNutritionCard(
                          "Carbs", _nutritionResults!["carbs"], Icons.rice_bowl),
                      _buildNutritionCard(
                          "Fats", _nutritionResults!["fats"], Icons.bubble_chart_outlined),
                      _buildNutritionCard(
                          "Fiber", _nutritionResults!["fiber"], Icons.grass_outlined),
                    ],
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNutritionCard(String label, dynamic value, IconData icon) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: const Color(0xff4facfe).withOpacity(0.15),
          child: Icon(icon, color: const Color(0xff4facfe)),
        ),
        title: Text(label,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 16)),
        trailing: Text(
          value.toString(),
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.black87,
            fontSize: 16,
          ),
        ),
      ),
    );
  }
}
