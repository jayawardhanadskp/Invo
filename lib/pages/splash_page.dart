import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:invo/blocs/auth/auth_bloc.dart';
import 'package:invo/pages/main_page.dart';
import 'package:invo/pages/signin_page.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  SplashPageState createState() => SplashPageState();
}

class SplashPageState extends State<SplashPage> with TickerProviderStateMixin {
  late AnimationController _fadeController;
  late AnimationController _scaleController;
  late AnimationController _slideController;

  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    context.read<AuthBloc>().add(AuthCheckRequested());

    // Set status bar to transparent
    SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );

    // Initialize animation controllers
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );

    _scaleController = AnimationController(
      duration: Duration(milliseconds: 1200),
      vsync: this,
    );

    _slideController = AnimationController(
      duration: Duration(milliseconds: 1000),
      vsync: this,
    );

    // Initialize animations
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation = Tween<Offset>(
      begin: Offset(0, 0.3),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutBack),
    );

    // Start animations
    _startAnimations();

    // Navigate to home after 3 seconds
    // Timer(Duration(seconds: 3), () {
    //   Navigator.of(context).pushReplacement(
    //     PageRouteBuilder(
    //       pageBuilder: (context, animation, secondaryAnimation) => HomePage(),
    //       transitionsBuilder: (context, animation, secondaryAnimation, child) {
    //         return FadeTransition(opacity: animation, child: child);
    //       },
    //       transitionDuration: Duration(milliseconds: 500),
    //     ),
    //   );
    // });
  }

  void _startAnimations() async {
    await Future.delayed(Duration(milliseconds: 300));
    _fadeController.forward();

    await Future.delayed(Duration(milliseconds: 200));
    _scaleController.forward();

    await Future.delayed(Duration(milliseconds: 100));
    _slideController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthSuccess || state is AuthRegisterSucess) {
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
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign-in failed: ${state.error}')),
            );
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => SigninPage()),
            );
          } else if (state is AuthInitial) {
            Timer(Duration(milliseconds: 1500), () {
              Navigator.of(context).pushReplacement(
                PageRouteBuilder(
                  pageBuilder:
                      (context, animation, secondaryAnimation) => SigninPage(),
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
          child: SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Animated logo
                  AnimatedBuilder(
                    animation: _fadeController,
                    builder: (context, child) {
                      return FadeTransition(
                        opacity: _fadeAnimation,
                        child: ScaleTransition(
                          scale: _scaleAnimation,
                          child: SlideTransition(
                            position: _slideAnimation,
                            child: SvgPicture.asset(
                              'assets/svg/spalshlogo.svg',
                            ),
                            // Container(
                            //   child: Row(
                            //     mainAxisAlignment: MainAxisAlignment.center,
                            //     children: [
                            //       // Cube icon
                            //       Container(
                            //         width: 50,
                            //         height: 50,
                            //         margin: EdgeInsets.only(right: 12),
                            //         decoration: BoxDecoration(
                            //           color: Colors.white.withOpacity(0.9),
                            //           borderRadius: BorderRadius.circular(8),
                            //           boxShadow: [
                            //             BoxShadow(
                            //               color: Colors.black.withOpacity(0.3),
                            //               blurRadius: 10,
                            //               offset: Offset(0, 5),
                            //             ),
                            //           ],
                            //         ),
                            //         child: Icon(
                            //           Icons.view_in_ar_outlined,
                            //           color: Color(0xFF6B46C1),
                            //           size: 28,
                            //         ),
                            //       ),
                            //       // INVO text
                            //       Text(
                            //         'INVO',
                            //         style: TextStyle(
                            //           fontSize: 48,
                            //           fontWeight: FontWeight.bold,
                            //           color: Colors.white,
                            //           letterSpacing: 2.0,
                            //           shadows: [
                            //             Shadow(
                            //               color: Colors.black.withOpacity(0.3),
                            //               offset: Offset(0, 2),
                            //               blurRadius: 4,
                            //             ),
                            //           ],
                            //         ),
                            //       ),
                            //     ],
                            //   ),
                            // ),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 20),

                  // Loading indicator
                  // AnimatedBuilder(
                  //   animation: _fadeController,
                  //   builder: (context, child) {
                  //     return FadeTransition(
                  //       opacity: _fadeAnimation,
                  //       child: Container(
                  //         margin: EdgeInsets.only(top: 30),
                  //         child: SizedBox(
                  //           width: 30,
                  //           height: 30,
                  //           child: CircularProgressIndicator(
                  //             strokeWidth: 3,
                  //             valueColor: AlwaysStoppedAnimation<Color>(
                  //               Colors.white.withOpacity(0.8),
                  //             ),
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   },
                  // ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
