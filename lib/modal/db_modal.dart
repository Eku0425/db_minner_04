class Quote {
  final String category;
  final String quote;
  final String author;
  String isLiked;

  Quote({
    required this.category,
    required this.quote,
    required this.author,
    required this.isLiked,
  });

  factory Quote.fromJson(Map json) {
    return Quote(
      category: json['cate'],
      quote: json['quote'],
      author: json['author'],
      isLiked: json['like'],
    );
  }

  Map toJson() {
    return {
      'cate': category,
      'quote': quote,
      'author': author,
      'like': isLiked,
    };
  }
}
