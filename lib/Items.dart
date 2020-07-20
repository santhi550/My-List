class Items {
  final int id;
  final int list_id;
  final String item_name;
  final int quantity;
  final String units;
  static final columns = ["id", "list_id", "item_name", "quantity", "units"];
  Items(this.id, this.list_id, this.item_name, this.quantity, this.units);
  factory Items.fromMap(Map<String, dynamic> data) {
    return Items(
      data['id'],
      data['list_id'],
      data['item_name'],
      data['quantity'],
      data['units'],
    );
  }
  Map<String, dynamic> toMap() => {
        "id": id,
        "list_id": list_id,
        "item_name": item_name,
        "quantity": quantity,
        "units": units,
      };
}
