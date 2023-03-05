import 'package:flutter/material.dart';
import 'dart:math' as math;

class Todo with Style {
  String _id;
  String? description;
  bool isCompleted;

  Todo(this._id, {this.description, this.isCompleted = false});

  factory Todo.createTodo(
      {required String id,
      required String description,
      bool isCompleted = false,
      bool isImportant = false}) {
    if (isImportant) {
      return ImmidiateToDo(id, description, isCompleted);
    } else {
      return LongTermToDo(id, description, isCompleted);
    }
  }

  String get id => _id;

  set des(String desc) => description = desc;

  static List<Todo> getTodos() {
    return [Todo("1", description: "Do sport", isCompleted: false)];
  }
}

class LongTermToDo extends Todo {
  LongTermToDo(String id, String description, bool isCompleted)
      : super(id, description: description, isCompleted: isCompleted);
}

class ImmidiateToDo extends Todo {
  ImmidiateToDo(String id, String description, bool isCompleted)
      : super(id, description: description, isCompleted: isCompleted);
}

mixin Style {
  Color getColor() {
    return Color((math.Random().nextDouble() * 0xFFFFFF).toInt())
        .withOpacity(0.3);
  }
}
