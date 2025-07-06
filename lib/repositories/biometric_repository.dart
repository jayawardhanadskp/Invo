import 'package:local_auth/local_auth.dart';
import 'package:flutter/services.dart'; // Import for PlatformException
import 'package:local_auth/error_codes.dart' as auth_error; // Import for error codes

class BiometricRepository {
  final _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isAvailable = await _auth.isDeviceSupported();

    if (!canCheck || !isAvailable) {
      // You might want to log this or inform the user that biometrics are not available/supported
      print('Biometrics not available or device not supported.');
      return false;
    }

    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to unlock the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } on PlatformException catch (e) {
      if (e.code == auth_error.notEnrolled) {
        print('No biometrics enrolled.');
        // Guide user to device settings to set up biometrics
      } else if (e.code == auth_error.passcodeNotSet) {
        print('Device passcode not set.');
        // Guide user to device settings to set up a passcode
      } else if (e.code == auth_error.lockedOut || e.code == auth_error.permanentlyLockedOut) {
        print('Biometrics locked out. User needs to use PIN/pattern or unlock device.');
        // Inform user to try again later or use other methods
      } else {
        print('Authentication error: ${e.message}');
      }
      return false;
    } catch (e) {
      print('An unexpected error occurred: $e');
      return false;
    }
  }

  // You might also want a method to check available biometric types
  Future<List<BiometricType>> getAvailableBiometrics() async {
    try {
      return await _auth.getAvailableBiometrics();
    } on PlatformException catch (e) {
      print('Error getting available biometrics: ${e.message}');
      return [];
    }
  }
}

// import 'package:local_auth/local_auth.dart';

// class BiometricRepository {
//   final _auth = LocalAuthentication();

//   Future<bool> authenticate() async {
//     final canCheck = await _auth.canCheckBiometrics;
//     final isAvailable = await _auth.isDeviceSupported();

//     if (!canCheck || !isAvailable) return false;

//     try {
//       return await _auth.authenticate(
//         localizedReason: 'Please authenticate to unlock the app',
//         options: const AuthenticationOptions(
//           stickyAuth: true,
//           biometricOnly: true,
//         ),
//       );
//     } catch (e) {
//       return false;
//     }
//   }
// }
