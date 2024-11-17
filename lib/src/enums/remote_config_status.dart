/// The status of the last fetch operation.
///
/// This enum represents the possible states of a remote config fetch operation:
/// * [notFetched] - No fetch has been attempted yet
/// * [success] - The last fetch was successful
/// * [failure] - The last fetch failed
/// * [throttled] - The fetch was throttled due to frequent requests
enum RemoteConfigStatus {
  /// No fetch operation has been attempted yet
  notFetched,
  
  /// The last fetch operation was successful
  success,
  
  /// The last fetch operation failed
  failure,
  
  /// The fetch was throttled due to frequent requests
  throttled,
} 