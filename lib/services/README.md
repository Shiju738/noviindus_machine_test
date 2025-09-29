# API Services Documentation

This directory contains the API services for the Flutter application.

## Files

### `api_service.dart`
- Base API service configuration using Dio
- Handles base URL and common headers
- Manages authentication token in headers

### `auth_service.dart`
- Login API implementation
- Token storage and management
- User authentication state management
- Logout functionality

## Usage

### Login API
The login API calls the endpoint `api/Login` with the following structure:

```dart
// Login request
final result = await AuthService.login(
  username: 'test_user',
  password: '12345678',
);

// Response structure
{
  'success': bool,
  'message': String,
  'data': {
    'token': String, // JWT token for authentication
    'user': Map<String, dynamic>, // User data
    'message': String
  }
}
```

### Token Management
- Tokens are automatically stored in SharedPreferences
- Tokens are automatically added to API headers
- Tokens persist across app restarts
- Use `AuthService.logout()` to clear tokens

### API Endpoints
- **Base URL**: `https://flutter-amr.noviindus.in/api/`
- **Login Endpoint**: `POST /Login`
- **Request Format**: FormData with `username` and `password` fields
- **Test Credentials**: username: `test_user`, password: `12345678`

## Error Handling
The service handles various error scenarios:
- Network timeouts
- Connection errors
- Server errors
- Invalid credentials

## Dependencies
- `dio: ^5.7.0` - HTTP client
- `shared_preferences: ^2.2.2` - Local storage
- `get: ^4.6.6` - State management and navigation
