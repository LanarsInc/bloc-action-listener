library bloc_action_listener;

import 'dart:async';

import 'package:bloc_action_listener/bloc_base.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/single_child_widget.dart' show SingleChildState, SingleChildStatefulWidget;

typedef BlocWidgetActionListener<A> = void Function(BuildContext context, A action);

class BlocActionListener<B extends ActionsStreamable<A>, A> extends BlocActionListenerBase<B, A> {
  const BlocActionListener({
    required BlocWidgetActionListener<A> listener,
    Key? key,
    B? bloc,
    Widget? child,
  }) : super(key: key, child: child, listener: listener, bloc: bloc);
}

abstract class BlocActionListenerBase<B extends ActionsStreamable<A>, A>
    extends SingleChildStatefulWidget {
  const BlocActionListenerBase({
    required this.listener,
    Key? key,
    this.bloc,
    this.child,
  }) : super(key: key, child: child);

  /// The widget which will be rendered as a descendant of the
  /// [BlocActionListenerBase].
  final Widget? child;

  /// The [bloc] whose `actions` will be listened to.
  /// When a new action is added from [bloc], the [listener] will be called
  final B? bloc;

  /// A [BlocWidgetActionListener] listener that will be called on each new `action`.
  /// This [listener] should be used for any code that needs to be execute
  final BlocWidgetActionListener<A> listener;

  @override
  SingleChildState<BlocActionListenerBase<B, A>> createState() => _BlocListenerBaseState<B, A>();
}

class _BlocListenerBaseState<B extends ActionsStreamable<A>, A>
    extends SingleChildState<BlocActionListenerBase<B, A>> {
  StreamSubscription<A>? _subscription;
  late B _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = widget.bloc ?? context.read<B>();
    _subscribe();
  }

  @override
  void didUpdateWidget(BlocActionListenerBase<B, A> oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldBloc = oldWidget.bloc ?? context.read<B>();
    final currentBloc = widget.bloc ?? oldBloc;
    if (oldBloc != currentBloc) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = currentBloc;
      }
      _subscribe();
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final bloc = widget.bloc ?? context.read<B>();
    if (_bloc != bloc) {
      if (_subscription != null) {
        _unsubscribe();
        _bloc = bloc;
      }
      _subscribe();
    }
  }

  @override
  Widget buildWithChild(BuildContext context, Widget? child) {
    assert(
      child != null,
      '''${widget.runtimeType} used outside of MultiBlocListener must specify a child''',
    );
    if (widget.bloc == null) {
      // Trigger a rebuild if the bloc reference has changed.
      // See https://github.com/felangel/bloc/issues/2127.
      context.select<B, bool>((bloc) => identical(_bloc, bloc));
    }
    return child!;
  }

  @override
  void dispose() {
    _unsubscribe();
    super.dispose();
  }

  void _subscribe() {
    _subscription = _bloc.actions.listen((state) {
      widget.listener(context, state);
    });
  }

  void _unsubscribe() {
    _subscription?.cancel();
    _subscription = null;
  }
}
