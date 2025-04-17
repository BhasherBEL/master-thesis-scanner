import 'package:flutter/material.dart';
import 'package:thesis_scanner/art.dart';
import 'package:thesis_scanner/arts.dart';
import 'package:thesis_scanner/pages/section.dart';
import 'package:thesis_scanner/utils/colors.dart';

class ListPage extends StatefulWidget {
  const ListPage({super.key});

  @override
  State<ListPage> createState() => _ListPageState();
}

class _ListPageState extends State<ListPage> {
  int currentSection = 0;

  @override
  Widget build(BuildContext context) {
    final floor = floor6;

    return Column(
      children: [
        ListTile(
          title: Text(floor.title),
          tileColor: primaryColor,
          contentPadding: const EdgeInsets.symmetric(horizontal: 8),
          dense: true,
        ),
        ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: floor.sections.length,
          itemBuilder: (context, index) {
            final ArtSection section = floor.sections[index];

            return Column(
              children: [
                ListTile(
                  title: Text(section.title),
                  trailing:
                      currentSection == index
                          ? const Icon(Icons.my_location)
                          : null,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder:
                            (context) =>
                                SectionPage(floor: floor, section: section),
                      ),
                    );
                  },
                ),
                const Divider(),
              ],
            );
          },
        ),
      ],
    );
  }
}
