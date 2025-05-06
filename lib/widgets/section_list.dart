import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';
import 'package:thesis_scanner/consts.dart';
import 'package:thesis_scanner/pages/section.dart';
import 'package:thesis_scanner/utils/colors.dart';

class SectionList extends StatelessWidget {
  final ArtFloor floor;

  const SectionList({super.key, required this.floor});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
      itemCount: floor.sections.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final ArtSection section = floor.sections[index];
        final bool isCurrent = user.currentSection == section;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder:
                    (context) => SectionPage(floor: floor, section: section),
              ),
            );
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            decoration: BoxDecoration(
              color: isCurrent ? primaryColor.withOpacity(0.18) : Colors.white,
              border:
                  isCurrent ? Border.all(color: primaryColor, width: 2) : null,
            ),
            child: Stack(
              children: [
                Row(
                  children: [
                    Container(
                      height: 96,
                      width: 96,
                      margin: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child:
                            section.firstImage != null
                                ? Image.asset(
                                  section.firstImage!,
                                  fit: BoxFit.cover,
                                  width: 96,
                                  height: 96,
                                  errorBuilder:
                                      (context, error, stackTrace) => Container(
                                        color: Colors.grey[300],
                                        child: const Icon(
                                          Icons.image,
                                          size: 40,
                                        ),
                                      ),
                                )
                                : Container(
                                  color: Colors.grey[300],
                                  child: const Icon(Icons.image, size: 40),
                                ),
                      ),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              section.title,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: Color(0xFF22223B),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              section.pieces.isNotEmpty
                                  ? "${section.pieces.length} œuvre${section.pieces.length > 1 ? 's' : ''}"
                                  : "Aucune œuvre",
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.only(right: 16),
                      child: Icon(
                        Icons.chevron_right,
                        color: Colors.black38,
                        size: 28,
                      ),
                    ),
                  ],
                ),
                if (isCurrent)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: primaryColor,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        "Vous êtes ici",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
