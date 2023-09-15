
class CommunitySnippet {

  final String from;
  final String id;
  final String name;
  final String content;
  final String language;
  final String description;
  //DateTime timestamp; // Firebase: Timestamp currently not allowed in arrays

  CommunitySnippet({required this.from, required this.id, required this.name, required this.content, required this.language, required this.description});
}