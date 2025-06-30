// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:invo/blocs/auth/auth_bloc.dart';
import 'package:invo/pages/main_page.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({super.key});

  @override
  State<SigninPage> createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  @override
  void initState() {
    super.initState();
    // context.read<AuthBloc>().add(AuthCheckRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          } else if (state is AuthRegisterSucess) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage()),
            );
          } 
          // else if (state is AuthFailure) {
          //   ScaffoldMessenger.of(context).showSnackBar(
          //     SnackBar(content: Text('Sign-in failed: ${state.error}')),
          //   );
          // }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthFailure) {
            return Container(
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
                      'Welcome to Invo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      'Smart, secure, and simple invoicing.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                SvgPicture.asset(
                  'assets/svg/spalshlogo.svg',
                  color: Colors.white,
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
                          context.read<AuthBloc>().add(SignInWithGoogle());
                        },
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
          );
          }

          

          return Container(
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
                      'Welcome to Invo',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    Text(
                      'Smart, secure, and simple invoicing.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 70),
                SvgPicture.asset(
                  'assets/svg/spalshlogo.svg',
                  color: Colors.white,
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
                          context.read<AuthBloc>().add(SignInWithGoogle());
                        },
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
          );
        },
      ),
    );
  }
}
