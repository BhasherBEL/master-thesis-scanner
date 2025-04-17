import 'package:thesis_scanner/art.dart';

final artAncien = ArtCollection("Art Ancien");

final floor6 = ArtFloor("6e étage, Le regard d'un amateur", [
  ArtSection("0. Introduction", null, []),
  ArtSection("1. Oeuvres de maîtres", null, []),
  ArtSection("2. Masques", null, []),
  ArtSection("3. Statues", null, []),
  ArtSection("4. Le paradis", null, [
    ArtPiece(
      "Le Paradis terrestre",
      artAncien,
      "XVIIe",
      "Jan Van Kessel",
      ["Tableau", "Arts plastiqes", "Peinture"],
      "Pays-Bas",
      "https://collections-museel.s-museum.be/document/le-paradis-terrestre-tableau/6089486240170b4a0c93a457",
      null,
    ),
  ]),
]);
