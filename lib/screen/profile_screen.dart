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
            final activeTasks = todos.where((todo) => !todo.isCompleted).length;

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
                              label: 'Active Tasks',
                              value: activeTasks.toString(),
                              color: Colors.orange[300]!,
                            ),
                            const SizedBox(height: 20),
                            _buildProgressIndicator(
                              totalTasks: totalTasks,
                              completedTasks: completedTasks,
                            ),
                            const SizedBox(height: 20),
                            _buildTaskLists(todos),
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

  Widget _buildTaskLists(List<Todo> todos) {
    final activeTasks = todos.where((todo) => !todo.isCompleted).toList();
    final completedTasks = todos.where((todo) => todo.isCompleted).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildTaskSection('Active Tasks', activeTasks, Colors.orange),
        const SizedBox(height: 20),
        _buildTaskSection('Completed Tasks', completedTasks, Colors.green),
      ],
    );
  }

  Widget _buildTaskSection(String title, List<Todo> tasks, MaterialColor color) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: color[700],
          ),
        ),
        const SizedBox(height: 10),
        tasks.isEmpty
            ? Center(
                child: Text(
                  'No ${title.toLowerCase()}',
                  style: TextStyle(color: color[300]),
                ),
              )
            : ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: tasks.length > 5 ? 5 : tasks.length,
                itemBuilder: (context, index) {
                  final todo = tasks[index];
                  return ListTile(
                    title: Text(
                      todo.title,
                      style: TextStyle(
                        color: title == 'Active Tasks' ? Colors.black : Colors.grey,
                        decoration: title == 'Completed Tasks'
                            ? TextDecoration.lineThrough
                            : TextDecoration.none,
                      ),
                    ),
                    trailing: Icon(
                      title == 'Active Tasks'
                          ? Icons.circle_outlined
                          : Icons.check_circle,
                      color: title == 'Active Tasks' ? Colors.orange : Colors.green,
                    ),
                  );
                },
              ),
      ],
    );
  }
}