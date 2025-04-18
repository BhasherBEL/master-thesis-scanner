import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';

class NearMeList extends StatelessWidget {
  final List<ArtPiece> pieces;

  const NearMeList({super.key, required this.pieces});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 130,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 24),
        itemCount: pieces.length > 4 ? 4 : pieces.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          final piece = pieces[index];
          return Container(
            width: 100,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      topRight: Radius.circular(12),
                    ),
                    child:
                        (piece.image == null || piece.image!.isEmpty)
                            ? Container(
                              color: Colors.grey[300],
                              child: const Icon(Icons.image, size: 40),
                            )
                            : (piece.image!.startsWith('http'))
                            ? Image.network(
                              piece.image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 40),
                                  ),
                            )
                            : Image.asset(
                              piece.image!,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              errorBuilder:
                                  (context, error, stackTrace) => Container(
                                    color: Colors.red[300],
                                    child: const Icon(Icons.image, size: 40),
                                  ),
                            ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    piece.title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Color(0xFF22223B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
