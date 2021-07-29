class LinkItem {
  LinkItem({required this.name, required this.url});

  final String name;
  final String url;

  factory LinkItem.fromMap(Map<String, dynamic> data, String id) {
    return LinkItem(name: id, url: data['url']);
  }

  Map<String, dynamic> toMap() {
    return {
      'url': url,
    };
  }
}