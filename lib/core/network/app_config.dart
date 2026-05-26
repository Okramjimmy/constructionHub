/// Central app configuration.
///
/// Set [kBaseUrl] to your backend host:
///   - Android emulator → http://10.0.2.2:8000
///   - iOS simulator / macOS → http://localhost:8000
///   - Remote staging → https://api.yourdomain.com
library;

const String kBaseUrl = 'http://13.214.237.209:8000/api/v1';

/// Timeout durations for all API requests.
const Duration kConnectTimeout = Duration(seconds: 15);
const Duration kReceiveTimeout = Duration(seconds: 30);
const Duration kSendTimeout = Duration(seconds: 60);
