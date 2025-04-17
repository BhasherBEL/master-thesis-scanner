class ArtFloor {
  final String title;
  final List<ArtSection> sections;

  ArtFloor(this.title, this.sections);
}

class ArtSection {
  final String title;
  final String? audioUrl;
  final List<ArtPiece> pieces;

  ArtSection(this.title, this.audioUrl, this.pieces);
}

class ArtPiece {
  final String title;
  final ArtCollection collection;
  final String date;
  final String author;
  final List<String> categories;
  final String country;
  final String link;
  final String? audioUrl;

  ArtPiece(
    this.title,
    this.collection,
    this.date,
    this.author,
    this.categories,
    this.country,
    this.link,
    this.audioUrl,
  );
}

class ArtCollection {
  final String title;

  ArtCollection(this.title);
}
