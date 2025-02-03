import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:to_do_flutter_app/bloc/bloc.dart';
import 'package:to_do_flutter_app/services/firebase.dart';

class CreateEditTodoScreen extends StatefulWidget {
  const CreateEditTodoScreen({super.key});

  @override
  _CreateEditTodoScreenState createState() => _CreateEditTodoScreenState();
}

class _CreateEditTodoScreenState extends State<CreateEditTodoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final newTodo = Todo(
        id: '',
        title: _titleController.text,
        description: _descriptionController.text,
        isCompleted: false,
        createdAt: Timestamp.now(),
      );

      context.read<TodoBloc>().add(AddTodo(newTodo));
      
      // Clear the form
      _titleController.clear();
      _descriptionController.clear();
      FocusScope.of(context).unfocus();
    }
  }

  void _editTodo(Todo todo) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: TextEditingController(text: todo.title),
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => todo = Todo(
                id: todo.id,
                title: value,
                description: todo.description,
                isCompleted: todo.isCompleted,
                createdAt: todo.createdAt,
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: TextEditingController(text: todo.description),
              decoration: InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
                filled: true,
                fillColor: Colors.white,
              ),
              onChanged: (value) => todo = Todo(
                id: todo.id,
                title: todo.title,
                description: value,
                isCompleted: todo.isCompleted,
                createdAt: todo.createdAt,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                context.read<TodoBloc>().add(UpdateTodo(todo));
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlue[200], 
                padding: EdgeInsets.symmetric(vertical: 16),
              ),
              child: Text('Update Task'),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Todo List'),
        backgroundColor: Colors.lightBlue[100], 
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.grey[100]!],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            // Add Todo Form
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    spreadRadius: 2,
                    blurRadius: 5,
                  ),
                ],
              ),
              margin: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    TextFormField(
                      controller: _titleController,
                      decoration: InputDecoration(
                        labelText: 'Title',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter a title' : null,
                    ),
                    SizedBox(height: 16),
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: 'Description',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (value) => value!.isEmpty ? 'Enter a description' : null,
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: _saveTodo,
                      child: Text('Add Task'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlue[200], 
                        padding: EdgeInsets.symmetric(vertical: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Todo List
            Expanded(
              child: BlocBuilder<TodoBloc, TodoState>(
                builder: (context, state) {
                  if (state is TodoLoading) {
                    return Center(child: CircularProgressIndicator());
                  }
                  if (state is TodoError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is TodoLoaded) {
                    final todos = state.todos;
                    if (todos.isEmpty) {
                      return Center(child: Text('No tasks yet. Add your first task!'));
                    }
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: todos.length,
                      itemBuilder: (context, index) {
                        final todo = todos[index];
                        return Card(
                          color: Colors.white,
                          elevation: 2, 
                          margin: EdgeInsets.only(bottom: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: ListTile(
                            contentPadding: EdgeInsets.all(16),
                            title: Text(
                              todo.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                decoration: todo.isCompleted ? TextDecoration.lineThrough : null,
                                color: Colors.black87,
                              ),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(height: 8),
                                Text(
                                  todo.description,
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Created: ${DateFormat('MMM dd, yyyy HH:mm').format(todo.createdAt.toDate())}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.lightBlue[300]),
                                  onPressed: () => _editTodo(todo),
                                ),
                                Checkbox(
                                  value: todo.isCompleted,
                                  onChanged: (bool? value) {
                                    context.read<TodoBloc>().add(
                                      UpdateTodo(
                                        todo.copyWith(isCompleted: value ?? false),
                                      ),
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  }
                  return Container();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}