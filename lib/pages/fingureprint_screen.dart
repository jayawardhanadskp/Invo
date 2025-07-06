import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invo/blocs/biometric/biometric_bloc.dart';
import 'package:invo/pages/main_page.dart';

class FingureprintScreen extends StatefulWidget {
  const FingureprintScreen({super.key});

  @override
  State<FingureprintScreen> createState() => _FingureprintScreenState();
}

class _FingureprintScreenState extends State<FingureprintScreen> {
  // A flag to track if the initial automatic authentication has been attempted.
  // This helps us decide if the fingerprint icon should be a "tap to retry" or just informative.
  bool _initialAuthAttempted = false;
  String _fingerprintMessage = 'Tap to unlock with fingerprint';

  @override
  void initState() {
    super.initState();
    // Dispatch the authentication event immediately when the screen loads
    // This will bring up the native biometric prompt automatically.
    _attemptBiometricAuth();
  }

  bool _authInProgress = false;
  bool _screenActive = true;

void _attemptBiometricAuth({bool fromUser = false}) async {
  if (_authInProgress || !_screenActive) return;

  _authInProgress = true;
  context.read<BiometricBloc>().add(AuthenticateBiometric());
}

@override
void dispose() {
  _screenActive = false;
  super.dispose();
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BiometricBloc, BiometricState>(
  listener: (context, state) async {
    if (state is BiometricSuccess) {
      setState(() {
        _fingerprintMessage = 'Authentication successful!';
      });
      // Navigate after short delay
      await Future.delayed(const Duration(milliseconds: 1500));
      if (mounted) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => MainPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) =>
                FadeTransition(opacity: animation, child: child),
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      }
    } else if (state is BiometricFailure) {
      setState(() {
        _fingerprintMessage = 'Authentication failed. Retrying...';
      });
      // Automatically retry after delay
      await Future.delayed(const Duration(seconds: 1));
      _authInProgress = false; // Mark as done to allow retry
      _attemptBiometricAuth();
    } else if (state is BiometricUnavailable) {
      setState(() {
        _fingerprintMessage = 'Biometrics unavailable.';
      });
      _authInProgress = false; // Stop retrying
    } else if (state is BiometricLoading) {
      setState(() {
        _fingerprintMessage = 'Scanning fingerprint...';
      });
    }
  },

        child: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color.fromARGB(255, 29, 33, 71),
                Color.fromARGB(255, 6, 9, 40),
                Color(0xFF01031A),
              ],
              stops: [0.0, 0.6, 1.0],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const SizedBox(height: 100),
                  const Text(
                    ' Unlock Your Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Use your fingerprint or enter your password to continue.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
              const SizedBox(height: 70),
              // Make the fingerprint icon tapable for retries
              GestureDetector(
                onTap: _attemptBiometricAuth, // This now handles initial and retries
                child: Column(
                  children: [
                    BlocBuilder<BiometricBloc, BiometricState>(
                      builder: (context, state) {
                        return SvgPicture.asset(
                          'assets/svg/fingureprint.svg',
                          colorFilter: ColorFilter.mode(
                            (state is BiometricFailure || state is BiometricUnavailable)
                                ? Colors.red // Indicate failure
                                : Colors.white, // Default or loading
                            BlendMode.srcIn,
                          ),
                          height: 96, // Give it a fixed size
                          width: 96,
                        );
                      },
                    ),
                    const SizedBox(height: 15),
                    Text(
                      _fingerprintMessage, // Dynamic message
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 70),
              Column(
                children: [
                  Center(
                    child: ElevatedButton.icon(
                      icon: SvgPicture.asset('assets/svg/googleg.svg'),
                      label: const Text(
                        'Sign in with Google',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      onPressed: () {
                        // Handle Google Sign-in logic here
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            const Color.fromARGB(50, 101, 82, 193),
                        padding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 22,
                        ),
                        fixedSize: const Size(220, 45),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30.0),
                    child: Text(
                      'We use your Google account to keep things secure—no passwords needed.',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w200,
                        fontSize: 11,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}