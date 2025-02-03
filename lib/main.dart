import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart'; // Importing Bloc
import 'package:to_do_flutter_app/bloc/bloc.dart';
import 'package:to_do_flutter_app/firebase_options.dart';
import 'package:to_do_flutter_app/screen/main_screen.dart';
import 'package:to_do_flutter_app/screen/to_do_edit_screen.dart'; // Importing TodoBloc
import 'package:to_do_flutter_app/screen/to_do_list_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TodoBloc(), // Providing TodoBloc
      child: MaterialApp(
        title: 'To-Do App',
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: {
          '/': (context) => const MainScreen(),
          '/create_edit_todo': (context) => const CreateEditTodoScreen(),
          '/todo_details': (context) => const TodoListScreen(),
        },
      ),
    );
  }
}
