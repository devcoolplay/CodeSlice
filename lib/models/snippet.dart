
/// Snippet model to store a snippet's properties.

class Snippet {

  final String id;
  final String name;
  final String content;
  final String language;
  final String description;
  final String path;
  final DateTime timestamp;

  Snippet({required this.id, required this.name, required this.content, required this.language, required this.description, required this.timestamp, required this.path});
}