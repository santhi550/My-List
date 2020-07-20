class Lists {
  final int list_id;
  final String list_name;
  static final columns = ["list_id", "list_name"];
  Lists(this.list_id, this.list_name);
  factory Lists.fromMap(Map<String, dynamic> data) {
    return Lists(
      data['list_id'],
      data['list_name'],
    );
  }
  Map<String, dynamic> toMap() => {
        "list_id": list_id,
        "list_name": list_name,
      };
}
