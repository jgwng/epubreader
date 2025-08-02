class NovelRead{
  int? id;
  double? percentage;
  String? bookTitle;
  String? bookAuthor;
  String? cfi;

  NovelRead({
    this.id,
    this.percentage,
    this.bookTitle,
    this.bookAuthor,
    this.cfi,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'percentage': percentage,
      'bookTitle': bookTitle,
      'bookAuthor': bookAuthor,
      'cfi': cfi,
    };
  }

  factory NovelRead.fromMap(Map<String, dynamic> map) {
    return NovelRead(
      id: map['id'],
      percentage: map['percentage']  as double,
      bookTitle: map['bookTitle'],
      bookAuthor: map['bookAuthor'],
      cfi: map['cfi'],
     );
  }
}