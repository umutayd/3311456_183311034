import 'package:flutter/material.dart';
import 'package:kelimekartlari/models/user_model.dart';
import 'package:kelimekartlari/pages/login_page.dart';
import 'package:kelimekartlari/pages/temprory.dart';
import 'package:kelimekartlari/service/auth_service.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);
    return StreamBuilder<User?>(
      builder: (_, AsyncSnapshot<User?> snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          final User? user = snapshot.data;
          return user == null ? const LoginPage() : TemproryPage();
        } else {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
      },
      stream: authService.user,
    );
  }
}
