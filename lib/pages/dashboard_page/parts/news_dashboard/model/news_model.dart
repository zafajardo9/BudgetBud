class NewsModel {
  String id;
  final String author;
  final String title;
  final String description;
  final String url;
  final String imageUrl;
  final DateTime publishedAt;

  NewsModel({
    required this.id,
    required this.author,
    required this.title,
    required this.description,
    required this.url,
    required this.imageUrl,
    required this.publishedAt,
  });

  factory NewsModel.fromJson(Map<String, dynamic> json) {
    return NewsModel(
      id: json['id'] ?? '',
      author: json['author'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      url: json['url'] ?? '',
      imageUrl: json['urlToImage'] ?? '',
      publishedAt: DateTime.parse(json['publishedAt'] ?? ''),
    );
  }
}
