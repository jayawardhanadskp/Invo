import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class PinRepository {
  final _storage = FlutterSecureStorage();
  static const _pinKey = 'user_app_pin';

  Future<void> savePin(String pin) async {
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<bool> checkPin(String inputPin) async {
    final savedPin = await _storage.read(key: _pinKey);
    return savedPin == inputPin;
  }

  Future<bool> hasPin() async {
    return await _storage.read(key: _pinKey) != null;
  }
}


// import '../services/biometric_service.dart';
// import '../services/pin_service.dart';
// import 'pin_screen.dart';

// final biometricService = BiometricService();
// final pinService = PinService();

// if (state is AuthSuccess || state is AuthRegisterSucess) {
//   final didAuth = await biometricService.authenticate();

//   if (didAuth) {
//     Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => MainPage()));
//   } else {
//     final hasPin = await pinService.hasPin();
//     if (hasPin) {
//       Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => PinScreen()));
//     } else {
//       // Optional: force biometric or block
//       ScaffoldMessenger.of(context).showSnackBar(SnackBar(
//         content: Text('Authentication required to continue.'),
//       ));
//     }
//   }
// }

