import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:ui';
import 'package:thesis_scanner/art.dart';
import 'package:thesis_scanner/consts.dart';
import 'package:thesis_scanner/user.dart';

class NearMeList extends StatelessWidget {
  final List<ArtPiece> pieces;
  final void Function(ArtPiece) onPieceTap;

  const NearMeList({super.key, required this.pieces, required this.onPieceTap});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<User>.value(
      value: user,
      child: Consumer<User>(
        builder: (context, user, _) {
          final currentSectionPieces =
              user.currentSection == null
                  ? <ArtPiece>[]
                  : pieces
                      .where((p) => user.currentSection!.pieces.contains(p))
                      .toList();
          final otherPieces =
              user.currentSection == null
                  ? pieces
                  : pieces
                      .where((p) => !user.currentSection!.pieces.contains(p))
                      .toList();

          currentSectionPieces.sort(
            (a, b) => user
                .getDistance(a.x, a.y)
                .compareTo(user.getDistance(b.x, b.y)),
          );
          otherPieces.sort(
            (a, b) => user
                .getDistance(a.x, a.y)
                .compareTo(user.getDistance(b.x, b.y)),
          );

          final sortedPieces = [...currentSectionPieces, ...otherPieces];
          return SizedBox(
            height: 260,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              itemCount: sortedPieces.length > 10 ? 10 : sortedPieces.length,
              separatorBuilder: (context, index) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final piece = sortedPieces[index];
                return Container(
                  width: 225,
                  height: 400,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        Positioned.fill(
                          child:
                              (piece.image == null || piece.image!.isEmpty)
                                  ? Container(
                                    color: Colors.grey[300],
                                    child: const Icon(Icons.image, size: 160),
                                  )
                                  : (piece.image!.startsWith('http'))
                                  ? Image.network(
                                    piece.image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.grey[300],
                                              child: const Icon(
                                                Icons.image,
                                                size: 80,
                                              ),
                                            ),
                                  )
                                  : Image.asset(
                                    piece.image!,
                                    fit: BoxFit.cover,
                                    width: double.infinity,
                                    height: double.infinity,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                              color: Colors.red[300],
                                              child: const Icon(
                                                Icons.image,
                                                size: 160,
                                              ),
                                            ),
                                  ),
                        ),
                        if (user.currentSection != null &&
                            user.currentSection!.pieces.contains(piece))
                          Positioned(
                            top: 10,
                            right: 10,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.green,
                                shape: BoxShape.circle,
                              ),
                              padding: const EdgeInsets.all(6),
                              child: const Icon(
                                Icons.flag,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                        Positioned(
                          top: 180,
                          left: 6,
                          right: 6,
                          bottom: 6,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(16),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                              child: Container(
                                color: Colors.white.withOpacity(0.5),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 10,
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            piece.title,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                              color: Color(0xFF22223B),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          piece.date,
                                          style: const TextStyle(
                                            fontSize: 12,
                                            color: Color(0xFF22223B),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.directions_walk,
                                              size: 13,
                                              color: Color(0xFF22223B),
                                            ),
                                            const SizedBox(width: 4),
                                            Text(
                                              '${user.getRoundedDistance(piece.x, piece.y)} Steps away',
                                              style: const TextStyle(
                                                fontSize: 12,
                                                color: Color(0xFF22223B),
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextButton(
                                          onPressed: () => onPieceTap(piece),
                                          style: TextButton.styleFrom(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 8,
                                              vertical: 0,
                                            ),
                                            minimumSize: const Size(0, 0),
                                            tapTargetSize:
                                                MaterialTapTargetSize
                                                    .shrinkWrap,
                                          ),
                                          child: const Text(
                                            'Detail',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Color(0xFF22223B),
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
