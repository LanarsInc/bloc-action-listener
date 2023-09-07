import 'package:bloc_action_listener/bloc_action_listener.dart';
import 'package:bloc_action_listener/bloc_actions_mixin.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

abstract base class ExampleAction {}

final class ShowTestDialogAction extends ExampleAction {
  final String title;
  final String content;

  ShowTestDialogAction({
    required this.title,
    required this.content,
  });
}

final class ShowSnackbarAction extends ExampleAction {
  final String content;

  ShowSnackbarAction({required this.content});
}

@immutable
abstract class ExampleState {}

class ExampleInitial extends ExampleState {}

class ExampleCubit extends Cubit<ExampleState> with BlocActionsMixin<ExampleState, ExampleAction> {
  ExampleCubit() : super(ExampleInitial());

  void onShowTestDialogPressed() {
    addAction(
      ShowTestDialogAction(
        title: 'Test dialog',
        content: "Test dialog message",
      ),
    );
  }

  void onShowTestSnackbarPressed() {
    addAction(ShowSnackbarAction(content: "Test snackbar message"));
  }
}

void main() {
  runApp(const App());
}

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: HomePage());
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (_) => ExampleCubit(),
        child: BlocActionListener<ExampleCubit, ExampleAction>(
          listener: (context, action) {
            if (action is ShowTestDialogAction) {
              final title = action.title;
              final content = action.content;
              showDialog(
                context: context,
                builder: (context) => AlertDialog(title: Text(title), content: Text(content)),
              );
            }
            if (action is ShowSnackbarAction) {
              final content = action.content;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(content)));
            }
          },
          child: Builder(builder: (context) {
            final cubit = context.read<ExampleCubit>();
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ElevatedButton(
                    onPressed: cubit.onShowTestDialogPressed,
                    child: const Text("Show test dialog"),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cubit.onShowTestSnackbarPressed,
                    child: const Text("Show test snackbar"),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
