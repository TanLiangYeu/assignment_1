import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:convert';

class PosterScreen extends StatelessWidget {
  const PosterScreen({
    super.key,
    required this.image,
    this.travelSuggestion,
  });

  final Uint8List image;
  final String? travelSuggestion;

  Widget buildTips(List tips) {
    return Wrap(
      spacing: 8,
      runSpacing: 4,
      children: tips
          .map((tip) => Chip(
                label: Text(
                  tip,
                  style: const TextStyle(fontSize: 14),
                ),
                backgroundColor: Colors.green[50],
              ))
          .toList(),
    );
  }

  Widget buildCard({required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(12),
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> decoded = {};
    if (travelSuggestion != null && travelSuggestion!.isNotEmpty) {
      try {
        decoded = jsonDecode(travelSuggestion!);
      } catch (e) {
        debugPrint("Error parsing travelSuggestion JSON: $e");
      }
    }

    final String itinerary = decoded['itinerary'] ?? '';
    final String cost = decoded['estimated_cost'] ?? '';
    final List tips = decoded['tips'] ?? [];

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
        title: const Text('TRAVEL POSTER'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              elevation: 8,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: Image.memory(
                image,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(height: 20),

            if (decoded.isNotEmpty) ...[
              buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Itinerary",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                    const SizedBox(height: 4),
                    Text(itinerary, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Estimated Cost",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                    const SizedBox(height: 4),
                    Text(cost, style: const TextStyle(fontSize: 16)),
                  ],
                ),
              ),

              buildCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Travel Tips",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.green[800]),
                    ),
                    const SizedBox(height: 8),
                    buildTips(tips),
                  ],
                ),
              ),
            ] else
              const Center(
                child: Text(
                  "No travel suggestions available.",
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
              ),
          ],
        ),
      ),
    );
  }
}