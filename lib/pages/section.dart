import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';
import 'package:thesis_scanner/utils/colors.dart';
import 'package:thesis_scanner/widgets/player.dart';

class SectionPage extends StatelessWidget {
  final ArtFloor floor;
  final ArtSection section;
  const SectionPage({required this.floor, required this.section, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              width: double.infinity,
              height: 80,
              color: primaryColor,
              child: Row(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(floor.title, style: const TextStyle(fontSize: 16)),
                        const SizedBox(height: 4),
                        Text(
                          section.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  const Icon(Icons.refresh),
                ],
              ),
            ),
            const AudioBar(audioAsset: "ciel.m4a"),
          ],
        ),
      ),
    );
  }
}
