import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';
import 'package:thesis_scanner/pages/piece.dart';
import 'package:thesis_scanner/utils/colors.dart';
import 'package:thesis_scanner/widgets/player.dart';
import 'package:thesis_scanner/widgets/small_player.dart';

class SectionPage extends StatelessWidget {
  final ArtFloor floor;
  final ArtSection section;
  const SectionPage({required this.floor, required this.section, super.key});

  String getFlag(String country) {
    switch (country) {
      case "Pays-Bas":
        return "🇳🇱";
      default:
        return "❓";
    }
  }

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
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: section.pieces.length,
                itemBuilder: (context, index) {
                  final piece = section.pieces[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder:
                              (context) =>
                                  PiecePage(piece: piece, getFlag: getFlag),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Picture (placeholder)
                            Container(
                              width: 64,
                              height: 64,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 40),
                            ),
                            const SizedBox(width: 12),
                            // Main info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        piece.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      if (piece.audioUrl != null)
                                        SmallPlayer(
                                          audioAsset: piece.audioUrl!,
                                        ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Text(
                                        getFlag(piece.country),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        piece.author,
                                        style: const TextStyle(
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black54,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Text(
                                        piece.date,
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                      const SizedBox(width: 12),
                                      Text(
                                        piece.collection.title,
                                        style: const TextStyle(
                                          fontSize: 12,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
                separatorBuilder: (context, index) => const Divider(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
