abstract class ActionsStreamable<Action extends Object?> {
  /// The current [stream] of actions.
  Stream<Action> get actions;
}
