# Bloc Action Listener

This package extends the capabilities of Bloc and Cubit, adding the functionality to send and process UI actions, akin to the `BlocListener`.

### Why use this package?

In many instances, you may want your UI to respond to actions that aren't necessarily tied to a state change. For example, you might want to:

* Display a dialog
* Show a snackbar
* Navigate to a different screen or route

With the "Bloc Action Listener", you can achieve this more conveniently.

## Getting Started

### 1. Define your actions
You can create the actions as needed. These will be dispatched and can be listened to in the UI.

```
abstract class ExampleAction {}

class ShowTestDialogAction extends ExampleAction {
  final String title;
  final String content;

  ShowTestDialogAction({
    required this.title,
    required this.content,
  });
}

class ShowSnackbarAction extends ExampleAction {
  final String content;

  ShowSnackbarAction({required this.content});
}
```

### 2. Extend your Bloc or Cubit
Use the `BlocActionsMixin` to extend your Bloc or Cubit. This mixin provides the `addAction()` method which allows you to dispatch the defined actions.

```
class ExampleCubit extends Cubit<ExampleState> with BlocActionsMixin<ExampleState, ExampleAction> {
  ExampleCubit() : super(ExampleInitial());

  void onShowTestDialogPressed() {
    addAction(
      ShowTestDialogAction(
        title: 'Test dialog',
        content: 'Test dialog message',
      ),
    );
  }

  void onShowTestSnackbarPressed() {
    addAction(ShowSnackbarAction(content: 'Test snackbar message'));
  }
}
```
## 3. Listen and process actions in the UI
Using the `BlocActionListener` widget, you can respond to the dispatched actions in the UI.

```
BlocActionListener<ExampleCubit, ExampleAction>(
  actionListener: (context, action) {
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
);
```
