final String tableNameLists = "Lists";

class ListsTableFields {
  //liste tablomuzun alanları
  static final List<String> values = [id, name];
  static final String id = "id"; //dizilerimiz (değişkenden çekmek için)
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
        id: id ?? this.id,
        name: name ?? this.name); //?? boş değilse demek, değer atarız
  }

  Map<String, Object?> toJson() => {
        //veri tabanında sorgu yazarken Json olarak göndermek için.
        ListsTableFields.id: id,
        ListsTableFields.name: name,
      };
  static Lists fromJson(Map<String, Object?> json) => Lists(
        id: json[ListsTableFields.id] as int?, // cast işlemi yapılmış oldu.
        name: json[ListsTableFields.name] as String?,
      );
}
