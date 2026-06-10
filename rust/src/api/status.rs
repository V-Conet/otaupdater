
/// Update Button Status
pub enum UpdateButtStatus {
  /// Idle, e.g. First time starting the app,
  // idle,
  
  /// No Update Available
  NoUpdate,

  /// Update Available, but not downloaded yet
  UpdateAvailable,

  /// Downloading Update
  Downloading,

  /// Update Downloaded and ready to install
  ReadyToInstall,
}