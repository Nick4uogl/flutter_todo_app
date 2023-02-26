class Todo {
  String _id;
  String? description;
  bool isCompleted;

  Todo(this._id, {this.description, this.isCompleted = false});

  String get id => _id;

  set des(String desc) => description = desc;

  static List<Todo> getTodos() {
    return [Todo("1", description: "Do sport", isCompleted: false)];
  }
}
