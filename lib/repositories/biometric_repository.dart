import 'package:local_auth/local_auth.dart';

class BiometricRepository {
  final _auth = LocalAuthentication();

  Future<bool> authenticate() async {
    final canCheck = await _auth.canCheckBiometrics;
    final isAvailable = await _auth.isDeviceSupported();

    if (!canCheck || !isAvailable) return false;

    try {
      return await _auth.authenticate(
        localizedReason: 'Please authenticate to unlock the app',
        options: const AuthenticationOptions(
          stickyAuth: true,
          biometricOnly: true,
        ),
      );
    } catch (e) {
      return false;
    }
  }
}
