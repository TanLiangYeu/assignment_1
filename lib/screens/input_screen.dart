import 'package:flutter/material.dart';
import 'package:assignment_1/screens/poster_screen.dart';
import 'package:assignment_1/services/image_generation_service.dart';
import 'dart:typed_data';
import 'dart:convert';

Future<String> getTravelRecommendation({
  required String destination,
  required String duration,
  required String budget,
  required String participants,
  required String travelType,
}) async {
  await Future.delayed(const Duration(seconds: 2));

  return jsonEncode({
    "itinerary":
        "Day 1: Arrival and hotel check-in\nDay 2: City tour\nDay 3: Beach and relaxation\nDay 4: Adventure activities\nDay 5: Departure",
    "estimated_cost": "RM${int.parse(budget) + 500}",
    "tips": [
      "Book early for cheaper flights",
      "Try local food specialties",
      "Pack light for easy travel",
      "Bring a camera for scenic spots"
    ]
  });
}

class InputScreen extends StatefulWidget {
  const InputScreen({super.key, required this.title});

  final String title;

  @override
  State<InputScreen> createState() => _InputScreenState();
}

class _InputScreenState extends State<InputScreen> {
  final TextEditingController _tripDurationController = TextEditingController();
  final TextEditingController _travelBudgetController = TextEditingController();
  final TextEditingController _numberOfParticipantsController = TextEditingController();
  final TextEditingController _destinationOfChoiceController = TextEditingController();

  String selectedTravelType = "Budget";
  final List<String> travelTypes = ["Budget", "Mid-Range", "Luxury"];
  bool isLoading = false;

  Future<void> _generatePoster(String prompt, String aiTravelJson) async {
    Uint8List generatedPoster =
        await ImageGenerationService.generateImage(prompt);

    if (mounted) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PosterScreen(
            image: generatedPoster,
            travelSuggestion: aiTravelJson,
          ),
        ),
      );
    }
  }

  @override
  void dispose() {
    _tripDurationController.dispose();
    _travelBudgetController.dispose();
    _numberOfParticipantsController.dispose();
    _destinationOfChoiceController.dispose();
    super.dispose();
  }

  void _onGenerate() async {
    String tripDuration = _tripDurationController.text;
    String travelBudget = _travelBudgetController.text;
    String numberOfParticipants = _numberOfParticipantsController.text;
    String destinationOfChoice = _destinationOfChoiceController.text;

    if (tripDuration.isEmpty ||
        travelBudget.isEmpty ||
        numberOfParticipants.isEmpty ||
        destinationOfChoice.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() => isLoading = true);

    String posterPrompt =
        "A beautiful travel poster of $destinationOfChoice "
        "for a $tripDuration-day trip, budget RM$travelBudget, "
        "$numberOfParticipants people, $selectedTravelType travel style. "
        "Include scenic views, vibrant colors, cinematic lighting, and modern design.";

    String aiTravelJson = await getTravelRecommendation(
      destination: destinationOfChoice,
      duration: tripDuration,
      budget: travelBudget,
      participants: numberOfParticipants,
      travelType: selectedTravelType,
    );

    await _generatePoster(posterPrompt, aiTravelJson);

    setState(() => isLoading = false);
  }

  InputDecoration _inputStyle(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.green),
      filled: true,
      fillColor: Colors.grey[100],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('Travel Planner'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            const SizedBox(height: 10),
            const Text(
              "Plan Your Dream Trip ✈️",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    TextField(
                      controller: _tripDurationController,
                      keyboardType: TextInputType.number,
                      decoration:
                          _inputStyle('Trip Duration (Days)', Icons.date_range),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _travelBudgetController,
                      keyboardType: TextInputType.number,
                      decoration:
                          _inputStyle('Travel Budget (RM)', Icons.attach_money),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _numberOfParticipantsController,
                      keyboardType: TextInputType.number,
                      decoration: _inputStyle('Participants', Icons.people),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _destinationOfChoiceController,
                      decoration:
                          _inputStyle('Destination', Icons.travel_explore),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedTravelType,
                      decoration: _inputStyle('Type of Travel', Icons.flight),
                      items: travelTypes.map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(type),
                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedTravelType = value!;
                        });
                      },
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 30),
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    height: 55,
                    child: ElevatedButton(
                      onPressed: _onGenerate,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text(
                        "Generate Travel Poster",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}