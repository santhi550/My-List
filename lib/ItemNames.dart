class ItemNames {
  final int id;
  final String item_name;
  static final columns = ["id", "item_name"];
  ItemNames(this.id, this.item_name);
  factory ItemNames.fromMap(Map<String, dynamic> data) {
    return ItemNames(
      data['id'],
      data['item_name'],
    );
  }
  Map<String, dynamic> toMap() => {
        "id": id,
        "item_name": item_name,
      };
}
