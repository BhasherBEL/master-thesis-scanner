class ArtFloor {
  final String title;
  final double x0;
  final double y0;
  final double x1;
  final double y1;
  final List<ArtSection> sections;

  ArtFloor(this.title, this.x0, this.y0, this.x1, this.y1, this.sections);
}

class ArtSection {
  final String title;
  final String? audioUrl;
  final double x0;
  final double y0;
  final double x1;
  final double y1;
  final List<ArtPiece> pieces;

  ArtSection(
    this.title,
    this.audioUrl,
    this.x0,
    this.y0,
    this.x1,
    this.y1,
    this.pieces,
  );
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
  final double x;
  final double y;

  ArtPiece(
    this.title,
    this.collection,
    this.date,
    this.author,
    this.categories,
    this.country,
    this.link,
    this.audioUrl,
    this.x,
    this.y,
  );
}

class ArtCollection {
  final String title;

  ArtCollection(this.title);
}
