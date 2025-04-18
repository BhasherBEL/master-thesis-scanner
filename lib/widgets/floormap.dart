import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';

class FloorMap extends StatelessWidget {
  final ArtFloor floor;
  final void Function(ArtSection)? onSectionTap;
  final void Function(ArtPiece)? onPieceTap;

  const FloorMap({
    super.key,
    required this.floor,
    this.onSectionTap,
    this.onPieceTap,
  });

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: (floor.x1 - floor.x0) / (floor.y1 - floor.y0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          double width = constraints.maxWidth;
          double height = constraints.maxHeight;

          double mapX(double x) =>
              (x - floor.x0) / (floor.x1 - floor.x0) * width;
          double mapY(double y) =>
              height - ((y - floor.y0) / (floor.y1 - floor.y0) * height);

          return Stack(
            children: [
              ...floor.sections.map((section) {
                final left = mapX(section.x0);

                final right = mapX(section.x1);
                final y0 = mapY(section.y0);
                final y1 = mapY(section.y1);
                final top = y1 < y0 ? y1 : y0;
                final height = (y1 - y0).abs();
                return Positioned(
                  left: left,
                  top: top,
                  width: (right - left).abs(),
                  height: height,
                  child: GestureDetector(
                    onTap:
                        onSectionTap != null
                            ? () => onSectionTap!(section)
                            : null,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.15),
                        border: Border.all(color: Colors.blue, width: 1),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Center(
                        child: Text(
                          section.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              }),

              ...floor.sections.expand((section) => section.pieces).map((
                piece,
              ) {
                final x = mapX(piece.x);
                final y = mapY(piece.y);
                return Positioned(
                  left: x - 8,
                  top: y - 8,
                  width: 16,
                  height: 16,
                  child: GestureDetector(
                    onTap: onPieceTap != null ? () => onPieceTap!(piece) : null,
                    child: Tooltip(
                      message: piece.title,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.circle,
                          size: 12,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
