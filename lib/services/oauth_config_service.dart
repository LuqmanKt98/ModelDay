import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class OAuthConfigService {
  static const String _webClientId =
      'YOUR_WEB_CLIENT_ID'; // Will be configured via backend
  static const String _androidClientId =
      'YOUR_ANDROID_CLIENT_ID'; // Will be configured via backend
  static const String _iosClientId =
      'YOUR_IOS_CLIENT_ID'; // Will be configured via backend

  // Manual OAuth Configuration
  static const String manualOAuthClientId = _webClientId;
  static const String manualOAuthClientSecret = 'YOUR_CLIENT_SECRET'; // Will be handled by backend

  // OAuth Endpoints
  static const String authEndpoint = 'https://accounts.google.com/o/oauth2/v2/auth';
  static const String tokenEndpoint = 'https://oauth2.googleapis.com/token';
  static const String userInfoEndpoint = 'https://www.googleapis.com/oauth2/v2/userinfo';

  // Redirect URIs
  static const String webRedirectUri = 'http://localhost:3000/__/auth/handler';
  static const String mobileRedirectUri = 'com.example.newFlutter://oauth';

  // OAuth Scopes
  static const List<String> oauthScopes = [
    'openid',
    'email',
    'profile',
    'https://www.googleapis.com/auth/calendar'
  ];

  /// Get the appropriate Google Sign-In configuration for the current platform
  static GoogleSignIn getGoogleSignInInstance() {
    if (kIsWeb) {
      return GoogleSignIn(
        clientId: _webClientId,
        scopes: [
          'email',
          'profile',
          'openid',
          'https://www.googleapis.com/auth/calendar',
        ],
      );
    } else {
      // For mobile platforms
      return GoogleSignIn(
        serverClientId:
            _webClientId, // Use web client ID for server authentication
        scopes: [
          'email',
          'profile',
          'openid',
          'https://www.googleapis.com/auth/calendar',
        ],
        // The client ID is automatically picked up from the configuration files
        // (google-services.json for Android, GoogleService-Info.plist for iOS)
      );
    }
  }

  /// Get client ID for the current platform
  static String getClientId() {
    if (kIsWeb) {
      return _webClientId;
    } else if (defaultTargetPlatform == TargetPlatform.android) {
      return _androidClientId;
    } else if (defaultTargetPlatform == TargetPlatform.iOS) {
      return _iosClientId;
    } else {
      return _webClientId; // Fallback for other platforms
    }
  }

  /// Check if the current platform supports OAuth
  static bool isPlatformSupported() {
    return kIsWeb ||
        defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS;
  }

  /// Get platform-specific OAuth configuration
  static Map<String, dynamic> getPlatformConfig() {
    return {
      'platform': kIsWeb ? 'web' : defaultTargetPlatform.name,
      'clientId': getClientId(),
      'scopes': ['email', 'profile', 'openid'],
      'supported': isPlatformSupported(),
    };
  }
}
