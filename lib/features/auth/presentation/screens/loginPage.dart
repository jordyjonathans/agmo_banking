import 'package:agmotest_banking/di/injector.dart';
import 'package:agmotest_banking/features/auth/presentation/providers/state/authState.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    final authState = ref.watch(authStateNotifier);
    final authViewModel = ref.read(authStateNotifier.notifier);

    ref.listen<AuthState>(authStateNotifier, (previous, current) {
      if (current.errorMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Error: ${current.passwordValidatinError ?? current.errorMessage}',
            ),
          ),
        );
        authViewModel.clearErrorMessage();
      } else if (current.status == AuthStatus.success &&
          previous?.status != AuthStatus.success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Login successful! Welcome ${current.currentUserEmail}!',
            ),
          ),
        );
        context.go('/home');
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Login Page')),
      body: Padding(
        padding: EdgeInsets.all(15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Email (jordy.sjarif@test.com)',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 5),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: 'Password (TestPass123)'),
              obscureText: true,
            ),
            SizedBox(height: 5),
            if (authState.status == AuthStatus.loading)
              const CircularProgressIndicator()
            else
              Column(
                children: [
                  ElevatedButton(
                    onPressed: () {
                      authViewModel.login(
                        _emailController.text,
                        _passwordController.text,
                      );
                    },
                    child: const Text('Login'),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
