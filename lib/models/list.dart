final String tableNameLists = "Lists";

class ListsTableFields {
  static final List<String> values = [id, name];
  static final String id = "id";
  static final String name = "name";
}

class Lists {
  final int? id;
  final String? name;

  const Lists(
      {this.id,
      this.name}); //listeden bir nesne oluş. bu iki değişkene değer ataması isteniliyor
  Lists copy({int? id, String? name}) {
    return Lists(
        id: id ?? this.id, name: name ?? this.name); //?? boş değilse demek
  }

  Map<String, Object?> toJson() => {
        ListsTableFields.id: id,
        ListsTableFields.name: name,
      };
  static Lists fromJson(Map<String, Object?> json) => Lists(
        id: json[ListsTableFields.id] as int?,
        name: json[ListsTableFields.name] as String?,
      );
}
