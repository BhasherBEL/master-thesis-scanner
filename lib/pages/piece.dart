import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';
import 'package:thesis_scanner/utils/colors.dart';
import 'package:thesis_scanner/widgets/player.dart';

class PiecePage extends StatelessWidget {
  final ArtPiece piece;
  final String Function(String) getFlag;
  const PiecePage({super.key, required this.piece, required this.getFlag});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              width: double.infinity,
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
                    child: Text(
                      piece.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (piece.audioUrl != null) AudioBar(audioAsset: piece.audioUrl!),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(24),
                children: [
                  // Image placeholder
                  Center(
                    child: Container(
                      width: 180,
                      height: 180,
                      color: Colors.grey[300],
                      child: const Icon(Icons.image, size: 100),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Text(
                        getFlag(piece.country),
                        style: const TextStyle(fontSize: 32),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          piece.author,
                          style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontSize: 18,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text(piece.date, style: const TextStyle(fontSize: 16)),
                      const SizedBox(width: 16),
                      Text(
                        piece.collection.title,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.blueGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  // Categories
                  Wrap(
                    spacing: 8,
                    children:
                        piece.categories
                            .map((cat) => Chip(label: Text(cat)))
                            .toList(),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
