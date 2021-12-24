class News {
  final String title, author, content;
  final String? imageUrl, category;
  final bool isFavourite;

  const News(
      {required this.title,
      required this.author,
      required this.content,
      this.category,
      this.imageUrl = null,
      this.isFavourite = false});

  Map<String, Object?> toJson() => {
        'title': title,
        'author': author,
        'content': content,
        'category': category,
        'imageUrl': imageUrl,
        'isFavourite': isFavourite ? 1 : 0
      };

  static News fromJson(Map<String, Object?> json) => News(
      title: json['title'] as String,
      author: json['author'] as String,
      content: json['content'] as String,
      category: json['category'] as String,
      imageUrl: json['imageUrl'] as String?,
      isFavourite: json['isFavourite'] == 1);
}

final List<String> NewsColumns = [
  'title',
  'author',
  'content',
  'category',
  'imageUrl',
  'isFavourite'
];
final NewsTableName = "NEWS";
