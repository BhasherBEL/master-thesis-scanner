import 'package:thesis_scanner/art.dart';

final artAncien = ArtCollection("Art Ancien");

final floor6 = ArtFloor("6e étage, Le regard d'un amateur", 0, 0, 35.417, 9.812, [
  ArtSection("0. Introduction", null, 13.25, 6.312, 21.75, 9.312, []),
  ArtSection("1. Oeuvres de maîtres", null, 29.25, 0.5, 34.917, 9.312, []),
  ArtSection("2. Masques", null, 24.25, 0.5, 28.75, 9.312, []),
  ArtSection("3. Statues", null, 13.25, 0.5, 21.75, 3.812, []),
  ArtSection("4. Le paradis", null, 0.5, 4.812, 5.75, 9.312, [
    ArtPiece(
      "Le Paradis terrestre",
      artAncien,
      "XVIIe",
      "Jan Van Kessel",
      ["Tableau", "Arts plastiqes", "Peinture"],
      "Pays-Bas",
      "https://collections-museel.s-museum.be/document/le-paradis-terrestre-tableau/6089486240170b4a0c93a457",
      "assets/pieces/le-paradis-terrestre.jpg",
      "ciel.m4a",
      2,
      5,
    ),
  ]),
]);
