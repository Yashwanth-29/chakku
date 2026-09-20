import 'package:flutter/material.dart';
import '../../database/database_helper.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterUserScreen extends StatefulWidget {
  const RegisterUserScreen({super.key});

  @override
  State<RegisterUserScreen> createState() => _RegisterUserScreenState();
}

class _RegisterUserScreenState extends State<RegisterUserScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool hidePassword = true;
  bool isLoading = false;

  Future<void> registerUser() async {
    if (nameController.text.trim().isEmpty ||
        emailController.text.trim().isEmpty ||
        passwordController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    final db = await DatabaseHelper.instance.database;

    // Check if email already exists
    final existing = await db.query(
      'users',
      where: 'email=?',
      whereArgs: [emailController.text.trim()],
    );

    if (existing.isNotEmpty) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Email already registered"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    await db.insert('users', {
      'name': nameController.text.trim(),
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    });

    setState(() {
      isLoading = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Account created successfully"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pop(context);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Create Account"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CustomTextField(
              controller: nameController,
              label: "Full Name",
              icon: Icons.person,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              controller: emailController,
              label: "Email",
              icon: Icons.email,
            ),

            const SizedBox(height: 20),

            CustomTextField(
              controller: passwordController,
              label: "Password",
              icon: Icons.lock,
              obscureText: hidePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  hidePassword
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed: () {
                  setState(() {
                    hidePassword = !hidePassword;
                  });
                },
              ),
            ),

            const SizedBox(height: 30),

            isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: "CREATE ACCOUNT",
                    icon: Icons.person_add,
                    onPressed: registerUser,
                  ),
          ],
        ),
      ),
    );
  }
}