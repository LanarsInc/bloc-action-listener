import 'dart:async';

import 'package:bloc_action_listener/bloc_base.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

mixin BlocActionsMixin<State, Action> on BlocBase<State> implements ActionsStreamable<Action> {
  final _actions = StreamController<Action>.broadcast();

  @override
  Stream<Action> get actions => _actions.stream;

  @protected
  void addAction(Action action) {
    if (!isClosed && !_actions.isClosed) _actions.add(action);
  }

  @mustCallSuper
  @override
  Future<void> close() async {
    await _actions.close();
    return super.close();
  }
}
