import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    context.read<AuthBloc>().add(AuthCheckRequested());
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Google Sign-In')),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthRegisterSucess) {
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => MainPage()));
          } else if (state is AuthFailure) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Sign-in failed: ${state.error}')),
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is AuthFailure) {
            return Center(child: Text('Error: ${state.error}'));
          }

          // if (state is AuthSuccess) {
          //   return Center(child: Text('Welcome ${state.user.email}'));
          // }

          return Center(
            child: ElevatedButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Sign in with Google'),
              onPressed: () {
                context.read<AuthBloc>().add(SignInWithGoogle());
              },
            ),
          );
        },
      ),
    );
  }
}