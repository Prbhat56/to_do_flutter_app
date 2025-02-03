import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:to_do_flutter_app/services/firebase.dart';

// Event classes
abstract class TodoEvent {}

class AddTodo extends TodoEvent {
  final Todo todo;
  AddTodo(this.todo);
}

class UpdateTodo extends TodoEvent {
  final Todo todo;
  UpdateTodo(this.todo);
}

class DeleteTodo extends TodoEvent {
  final Todo todo;
  DeleteTodo(this.todo);
}

// State classes
abstract class TodoState {}

class TodoLoading extends TodoState {}

class TodoLoaded extends TodoState {
  final List<Todo> todos;
  TodoLoaded(this.todos);
}

class TodoError extends TodoState {
  final String message;
  TodoError(this.message);
}

// Bloc class
class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  TodoBloc() : super(TodoLoading()) {
    on<AddTodo>(_onAddTodo);
    on<UpdateTodo>(_onUpdateTodo);
    on<DeleteTodo>(_onDeleteTodo);
  }

  Future<void> _onAddTodo(AddTodo event, Emitter<TodoState> emit) async {
    try {
      // Add the new Todo to Firestore
      await _firestore.collection('todos').add({
        'title': event.todo.title,
        'description': event.todo.description,
        'isCompleted': event.todo.isCompleted,
        'createdAt': event.todo.createdAt,
      });

      // Fetch updated list of todos
      final todos = await _fetchTodosFromFirestore();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to add todo'));
    }
  }

  Future<void> _onUpdateTodo(UpdateTodo event, Emitter<TodoState> emit) async {
    try {
      // Update the todo in Firestore
      await _firestore.collection('todos').doc(event.todo.id).update({
        'title': event.todo.title,
        'description': event.todo.description,
        'isCompleted': event.todo.isCompleted,
        'createdAt': event.todo.createdAt,
      });

      // Fetch updated list of todos
      final todos = await _fetchTodosFromFirestore();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to update todo'));
    }
  }

  Future<void> _onDeleteTodo(DeleteTodo event, Emitter<TodoState> emit) async {
    try {
      // Delete the todo from Firestore
      await _firestore.collection('todos').doc(event.todo.id).delete();
      
      // Fetch updated list of todos
      final todos = await _fetchTodosFromFirestore();
      emit(TodoLoaded(todos));
    } catch (e) {
      emit(TodoError('Failed to delete todo'));
    }
  }

  Future<List<Todo>> _fetchTodosFromFirestore() async {
    final snapshot = await _firestore.collection('todos').get();
    return Future.wait(
      snapshot.docs.map((doc) => Future.value(Todo.fromFirestore(doc))).toList(),
    );
  }
}