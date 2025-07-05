class SessionState {
  final bool showWarningDialog;
  final String? currentRoute;
  final int inactivityRemainingSeconds;
  final int warningDialogRemainingSeconds;

  SessionState({
    this.showWarningDialog = false,
    this.currentRoute,
    this.inactivityRemainingSeconds = 30,
    this.warningDialogRemainingSeconds = 5,
  });

  SessionState copyWith({
    bool? showWarningDialog,
    String? currentRoute,
    int? inactivityRemainingSeconds,
    int? warningDialogRemainingSeconds,
  }) {
    return SessionState(
      showWarningDialog: showWarningDialog ?? this.showWarningDialog,
      currentRoute: currentRoute ?? this.currentRoute,
      inactivityRemainingSeconds:
          inactivityRemainingSeconds ?? this.inactivityRemainingSeconds,
      warningDialogRemainingSeconds:
          warningDialogRemainingSeconds ?? this.warningDialogRemainingSeconds,
    );
  }
}
