import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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
  @override
  void initState() {
    super.initState();
    context.read<BiometricBloc>().add(AuthenticateBiometric());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<BiometricBloc, BiometricState>(
        listener: (context, state) {
          if (state is BiometricSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Authentication Successful!')),
            );
            Timer(Duration(milliseconds: 1500), () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) => MainPage(),
                  transitionsBuilder: (
                    context,
                    animation,
                    secondaryAnimation,
                    child,
                  ) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                  transitionDuration: Duration(milliseconds: 500),
                ),
              );
            });
          } else if (state is BiometricFailure) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          } else if (state is BiometricUnavailable) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Container(
          decoration: BoxDecoration(
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
                  Text(
                    ' Unlock Your Account',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
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
              Column(
                children: [
                  SvgPicture.asset(
                    'assets/svg/fingureprint.svg',
                    color: Colors.white,
                  ),
                  const SizedBox(height: 15),
                  Text(
                    'Tap to unlock with fingerprint',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
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
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color.fromARGB(50, 101, 82, 193),
                        padding: EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 22,
                        ),
                        fixedSize: Size(220, 45),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30.0),
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
