import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';
import 'package:thesis_scanner/arts.dart';
import 'package:thesis_scanner/audio_manager.dart';
import 'package:thesis_scanner/consts.dart';
import 'package:thesis_scanner/pages/piece.dart';
import 'package:thesis_scanner/pages/section.dart';
import 'package:thesis_scanner/widgets/floormap.dart';
import 'package:thesis_scanner/widgets/near_me_list.dart';
import 'package:thesis_scanner/widgets/player.dart';
import 'package:thesis_scanner/widgets/section_list.dart';
import 'package:thesis_scanner/utils/colors.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  @override
  void initState() {
    super.initState();
    localization.addListener(_onLocalizationChanged);
    AudioManager().addListener(_onAudioManagerChanged);
  }

  @override
  void dispose() {
    localization.removeListener(_onLocalizationChanged);
    AudioManager().removeListener(_onAudioManagerChanged);
    super.dispose();
  }

  void _onLocalizationChanged() {
    if (!mounted) return;
    setState(() {});
  }

  void _onAudioManagerChanged() {
    if (!mounted) return;
    setState(() {});
  }

  String? get currentAudio => AudioManager().currentAudio;

  @override
  Widget build(BuildContext context) {
    final floor = floor6;

    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: Column(
        children: [
          if (currentAudio != null) AudioBar(audioAsset: currentAudio!),
          if (!localization.isEnabled)
            Container(
              width: double.infinity,
              height: 60,
              color: Colors.grey[300],
              child: const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Bluetooth is not enabled.',
                      style: TextStyle(
                        color: Color(0xFFB00020),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Some functions may not work as expected.',
                      style: TextStyle(
                        color: Color(0xFFB00020),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          Expanded(
            child: CustomScrollView(
              slivers: [
                SliverAppBar(
                  backgroundColor: primaryColor,
                  pinned: true,
                  expandedHeight: 110,
                  flexibleSpace: LayoutBuilder(
                    builder: (context, constraints) {
                      const double minExtent = kToolbarHeight;
                      const double maxExtent = 140;
                      final double t = ((constraints.maxHeight - minExtent) /
                              (maxExtent - minExtent))
                          .clamp(0.0, 1.0);

                      return FlexibleSpaceBar(
                        title: Row(
                          children: [
                            const Icon(
                              Icons.museum,
                              size: 24,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (t > 0.5)
                                    Text(
                                      "Musée Virtuel",
                                      style: TextStyle(
                                        color: Colors.white.withOpacity(0.95),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        letterSpacing: 1.1,
                                      ),
                                    ),
                                  Text(
                                    floor.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      letterSpacing: 1.2,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),

                            IconButton(
                              icon: const Icon(
                                Icons.info_outline,
                                color: Colors.white,
                                size: 20,
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder:
                                      (context) => AlertDialog(
                                        title: const Text(
                                          "À propos de ce plan",
                                        ),
                                        content: const Text(
                                          "Explorez les différentes sections du musée en utilisant la carte interactive ou la liste ci-dessous.",
                                        ),
                                        actions: [
                                          TextButton(
                                            onPressed:
                                                () => Navigator.pop(context),
                                            child: const Text("Fermer"),
                                          ),
                                        ],
                                      ),
                                );
                              },
                            ),
                          ],
                        ),
                        titlePadding: const EdgeInsetsDirectional.only(
                          start: 16,
                          bottom: 16,
                          end: 8,
                        ),
                        background: null,
                      );
                    },
                  ),
                ),
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const SizedBox(height: 8),
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
                            onSectionTap: (section) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => SectionPage(
                                        floor: floor,
                                        section: section,
                                      ),
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
                        decoration: const BoxDecoration(
                          color: Colors.transparent,
                        ),
                        child: SectionList(floor: floor),
                      ),
                    ],
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
