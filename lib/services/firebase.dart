import 'package:cloud_firestore/cloud_firestore.dart';

class Todo {
  String id;
  String title;
  String description;
  bool isCompleted;
  Timestamp createdAt;

  Todo({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createdAt,
  });

  factory Todo.fromFirestore(DocumentSnapshot doc) {
    Map data = doc.data() as Map;
    return Todo(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      isCompleted: data['isCompleted'] ?? false,
      createdAt: data['createdAt'] ?? Timestamp.now(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'createdAt': createdAt,
    };
  }

 static Future<List<Todo>> fromDocument(QuerySnapshot<Map<String, dynamic>> querySnapshot) async {
  List<Todo> todos = [];
  
  for (var doc in querySnapshot.docs) {
    todos.add(Todo.fromFirestore(doc));
  }
  
  return todos;
}


  // Updated copyWith method to return a non-nullable Todo
  Todo copyWith({required bool isCompleted}) {
    return Todo(
      id: id,
      title: title,
      description: description,
      isCompleted: isCompleted,
      createdAt: createdAt,
    );
  }
}
