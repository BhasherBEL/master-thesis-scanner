import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';
import 'package:thesis_scanner/arts.dart';
import 'package:thesis_scanner/pages/piece.dart';
import 'package:thesis_scanner/pages/section.dart';
import 'package:thesis_scanner/widgets/floormap.dart';
import 'package:thesis_scanner/widgets/near_me_list.dart';
import 'package:thesis_scanner/widgets/section_list.dart';
import 'package:thesis_scanner/utils/colors.dart';

class ListPage extends StatelessWidget {
  const ListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final floor = floor6;

    final ArtSection currentSection = floor.sections.firstWhere(
      (s) => s.pieces.isNotEmpty,
      orElse: () => floor.sections.first,
    );

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            backgroundColor: primaryColor,
            pinned: true,
            expandedHeight: 140,
            flexibleSpace: FlexibleSpaceBar(
              background: Padding(
                padding: const EdgeInsets.only(
                  top: 0,
                  left: 24,
                  right: 24,
                  bottom: 0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Icon(Icons.museum, size: 36, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Musée Virtuel",
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.95),
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              letterSpacing: 1.1,
                            ),
                          ),
                          Text(
                            floor.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                              letterSpacing: 1.2,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.info_outline, color: Colors.white),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder:
                              (context) => AlertDialog(
                                title: const Text("À propos de ce plan"),
                                content: const Text(
                                  "Explorez les différentes sections du musée en utilisant la carte interactive ou la liste ci-dessous.",
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Fermer"),
                                  ),
                                ],
                              ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Plan du musée",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF22223B),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.all(16),
                    child: FloorMap(
                      floor: floor,
                      currentSection: currentSection,
                      onSectionTap: (section) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    SectionPage(floor: floor, section: section),
                          ),
                        );
                      },
                      onPieceTap: (piece) {},
                    ),
                  ),
                ),
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Près de moi",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF22223B),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                NearMeList(
                  pieces:
                      floor.sections
                          .expand((section) => section.pieces)
                          .toList(),
                  currentSection: currentSection,
                  onPieceTap: (piece) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) => PiecePage(
                              piece: piece,
                              getFlag: (country) {
                                switch (country) {
                                  case "Pays-Bas":
                                    return "🇳🇱";
                                  default:
                                    return "❓";
                                }
                              },
                            ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 18),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Toutes les sections",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xFF22223B),
                      ),
                      textAlign: TextAlign.left,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.only(top: 8),
                  decoration: const BoxDecoration(color: Colors.transparent),
                  child: SectionList(
                    floor: floor,
                    currentSection: currentSection,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
