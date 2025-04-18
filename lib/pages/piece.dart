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
    final hasAudio = piece.audioUrl != null && piece.audioUrl!.isNotEmpty;
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              color: primaryColor,
              padding: const EdgeInsets.only(left: 8, top: 8, bottom: 18),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                      size: 28,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      piece.title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        letterSpacing: 1.1,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            if (hasAudio)
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: AudioBar(audioAsset: piece.audioUrl!),
              ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                children: [
                  // Main rectangular card (no border radius, no shadow)
                  Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Big image at the top
                        piece.image != null && piece.image!.isNotEmpty
                            ? Image.asset(
                              piece.image!,
                              width: double.infinity,
                              height: 280,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    height: 280,
                                    width: double.infinity,
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 100),
                                  ),
                            )
                            : Container(
                              height: 280,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 100),
                            ),
                        Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Title
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      piece.title,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22,
                                        color: Color(0xFF22223B),
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Author and flag
                              Row(
                                children: [
                                  Text(
                                    getFlag(piece.country),
                                    style: const TextStyle(fontSize: 24),
                                  ),
                                  const SizedBox(width: 6),
                                  Expanded(
                                    child: Text(
                                      piece.author,
                                      style: const TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.black54,
                                        fontSize: 16,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              // Date and collection
                              Row(
                                children: [
                                  Text(
                                    piece.date,
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: Colors.blueGrey,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      piece.collection.title,
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.blueGrey,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 14),
                              // Categories
                              if (piece.categories.isNotEmpty)
                                Wrap(
                                  spacing: 8,
                                  runSpacing: 4,
                                  children:
                                      piece.categories
                                          .map((cat) => Chip(label: Text(cat)))
                                          .toList(),
                                ),
                              if (piece.categories.isNotEmpty)
                                const SizedBox(height: 14),
                              // Description
                              if (piece.description.isNotEmpty)
                                Text(
                                  piece.description,
                                  style: const TextStyle(
                                    fontSize: 15,
                                    color: Color(0xFF22223B),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
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
