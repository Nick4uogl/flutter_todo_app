import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:todo_app/models/todo.dart';

const List<String> list = <String>['Important', 'Long-term'];

const primaryColor = Color(0xFF151026);

void main() {
  runApp(const ToDoApp());
}

class ToDoApp extends StatelessWidget {
  const ToDoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: primaryColor,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final todolist = Todo.getTodos();
  final myController = TextEditingController();
  String dropdownValue = list.first;

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(24.0),
        child: AppBar(
            titleSpacing: 30,
            title: const Text(
              'by Микола Пилипчук',
              style: TextStyle(fontSize: 12),
            ),
            backgroundColor: const Color(0xFF53DD6C)),
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Create Task To Do",
              style: TextStyle(fontSize: 24),
            ),
            CreateItem(addItem: _addItem, controller: myController),
            DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Color(0xFF53DD6C)),
              underline: Container(
                height: 2,
                color: const Color(0xFF53DD6C),
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 25),
            for (Todo toDo in todolist)
              ToDoItem(
                  todo: toDo,
                  toggleCompleted: _toggleCompleted,
                  deleteItem: _deleteItem)
          ],
        ),
      ),
    );
  }

  void _toggleCompleted(Todo todo) {
    assert(todo.isCompleted, "isCompleted is false");
    setState(() {
      todo.isCompleted = !todo.isCompleted;
    });
  }

  void _deleteItem(String id) {
    setState(() {
      todolist.removeWhere((element) => element.id == id);
    });
  }

  void _addItem(String id, String description) {
    setState(() {
      if (dropdownValue == 'Important') {
        todolist.add(Todo.createTodo(
            id: id,
            description: description,
            isCompleted: false,
            isImportant: true));
      } else {
        todolist.add(Todo(id, description: description));
      }
    });
  }
}

class ToDoItem extends StatelessWidget {
  const ToDoItem(
      {super.key,
      required this.todo,
      required this.toggleCompleted,
      required this.deleteItem});

  final Todo todo;
  final toggleCompleted;
  final deleteItem;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      child: ListTile(
        onTap: () {
          toggleCompleted(todo);
          print("clicked");
        },
        tileColor: todo.getColor(),
        title: Text(todo.description!,
            style: TextStyle(
                color: todo is ImmidiateToDo ? Colors.red : primaryColor,
                fontWeight:
                    todo is ImmidiateToDo ? FontWeight.bold : FontWeight.normal,
                decoration:
                    todo.isCompleted ? TextDecoration.lineThrough : null)),
        leading: Icon(
            todo.isCompleted ? Icons.check_box : Icons.check_box_outline_blank,
            color: const Color(0xFF53DD6C)),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => deleteItem(todo.id),
          splashColor: Colors.white,
          highlightColor: Colors.white,
        ),
      ),
    );
  }
}

class CreateItem extends StatelessWidget {
  const CreateItem({super.key, this.addItem, this.controller});
  final addItem;
  final controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 15),
      padding: const EdgeInsets.only(left: 15.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: controller,
            decoration: InputDecoration(
              contentPadding: const EdgeInsets.only(top: 20),
              hintText: "Add new item",
              border: InputBorder.none,
              suffixIcon: IconButton(
                onPressed: () => addItem(createUuid(), controller.text),
                icon: const Icon(Icons.add_circle, color: Color(0xFF53DD6C)),
                iconSize: 40,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

createUuid() {
  const uuid = Uuid();
  //Create UUID version-4
  return uuid.v4();
}
