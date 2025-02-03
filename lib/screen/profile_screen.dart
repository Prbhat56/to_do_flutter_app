import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:to_do_flutter_app/bloc/bloc.dart';
import 'package:to_do_flutter_app/services/firebase.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        backgroundColor: Colors.lightBlue[100],
        elevation: 0,
      ),
      body: BlocBuilder<TodoBloc, TodoState>(
        builder: (context, state) {
          if (state is TodoLoaded) {
            final todos = state.todos;
            final totalTasks = todos.length;
            final completedTasks = todos.where((todo) => todo.isCompleted).length;
            final pendingTasks = totalTasks - completedTasks;

            return Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.white, Colors.blue[50]!],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Card(
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            CircleAvatar(
                              radius: 50,
                              backgroundColor: Colors.lightBlue[100],
                              child: Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.lightBlue[300],
                              ),
                            ),
                            const SizedBox(height: 20),
                            Text(
                              'Task Statistics',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue[700],
                              ),
                            ),
                            const SizedBox(height: 20),
                            _buildStatRow(
                              icon: Icons.list,
                              label: 'Total Tasks',
                              value: totalTasks.toString(),
                              color: Colors.blue[300]!,
                            ),
                            _buildStatRow(
                              icon: Icons.check_circle,
                              label: 'Completed Tasks',
                              value: completedTasks.toString(),
                              color: Colors.green[300]!,
                            ),
                            _buildStatRow(
                              icon: Icons.pending,
                              label: 'Pending Tasks',
                              value: pendingTasks.toString(),
                              color: Colors.orange[300]!,
                            ),
                            const SizedBox(height: 20),
                            _buildProgressIndicator(
                              totalTasks: totalTasks,
                              completedTasks: completedTasks,
                            ),
                            const SizedBox(height: 20),
                            _buildTaskList(todos),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildStatRow({
    required IconData icon,
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Icon(icon, color: color, size: 30),
          const SizedBox(width: 15),
          Text(
            label,
            style: TextStyle(fontSize: 16, color: Colors.blue[700]),
          ),
          const Spacer(),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator({
    required int totalTasks,
    required int completedTasks,
  }) {
    final progress = totalTasks > 0 ? completedTasks / totalTasks : 0.0;

    return Column(
      children: [
        Text(
          'Task Completion Progress',
          style: TextStyle(
            fontSize: 16,
            color: Colors.blue[700],
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        LinearProgressIndicator(
          value: progress,
          backgroundColor: Colors.blue[100],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.green[300]!),
          minHeight: 10,
        ),
        const SizedBox(height: 10),
        Text(
          '${(progress * 100).toStringAsFixed(1)}% Complete',
          style: TextStyle(
            fontSize: 14,
            color: Colors.blue[600],
          ),
        ),
      ],
    );
  }

  Widget _buildTaskList(List<Todo> todos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Recent Tasks',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.blue[700],
          ),
        ),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: todos.length > 5 ? 5 : todos.length,
          itemBuilder: (context, index) {
            final todo = todos[index];
            return ListTile(
              title: Text(
                todo.title,
                style: TextStyle(
                  decoration: todo.isCompleted 
                    ? TextDecoration.lineThrough
                    : TextDecoration.none,
                  color: todo.isCompleted 
                    ? Colors.grey 
                    : Colors.black,
                ),
              ),
              trailing: Icon(
                todo.isCompleted 
                  ? Icons.check_circle 
                  : Icons.circle_outlined,
                color: todo.isCompleted 
                  ? Colors.green 
                  : Colors.grey,
              ),
            );
          },
        ),
      ],
    );
  }
}