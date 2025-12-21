import 'package:flutter/material.dart';
import 'package:fruits_ecommerce_app/Data_Storage/auth_data.dart';
import 'package:fruits_ecommerce_app/Screens/welcome_page.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
    Color primaryOrange = Color(0xFFFFA451);
    Color lightOrange = Color(0xFFFFE3C7);
   bool isLogin = true;
   bool isHidden = true;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  void submit() {
    if (isLogin) {
      // LOGIN
      if (emailController.text == AuthData.email &&
          passwordController.text == AuthData.password) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => WelcomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Invalid email or password")),
        );
      }
    } else {
      // SIGNUP
      if (firstNameController.text.isEmpty ||
          lastNameController.text.isEmpty ||
          emailController.text.isEmpty ||
          passwordController.text.isEmpty ||
          confirmPasswordController.text.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please fill in all fields")),
        );
        return;
      }

      if (passwordController.text !=
          confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Passwords do not match")),
        );
        return;
      }

      AuthData.firstName = firstNameController.text;
      AuthData.lastName = lastNameController.text;
      AuthData.email = emailController.text;
      AuthData.password = passwordController.text;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created. Please login")),
      );

      setState(() {
        isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              primaryOrange,
              lightOrange
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(28),
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  /// Toggle
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () => setState(() => isLogin = true),
                        child: Text(
                          "Sign in",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                isLogin ? FontWeight.bold : FontWeight.normal,
                            color: isLogin
                                ? lightOrange
                                : Colors.grey,
                          ),
                        ),
                      ),
                      SizedBox(width: 20),
                      GestureDetector(
                        onTap: () => setState(() => isLogin = false),
                        child: Text(
                          "Sign up",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight:
                                !isLogin ? FontWeight.bold : FontWeight.normal,
                            color: !isLogin
                                ? lightOrange
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 20),

                  /// Signup extra fields
                  if (!isLogin) ...[
                    TextField(
                      controller: firstNameController,
                      decoration: _inputStyle("First Name"),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: lastNameController,
                      decoration: _inputStyle("Last Name"),
                    ),
                    SizedBox(height: 12),
                  ],

                  /// Email
                  TextField(
                    controller: emailController,
                    decoration: _inputStyle("Email"),
                  ),
                  SizedBox(height: 12),

                  /// Password
                  TextField(
                    controller: passwordController,
                    obscureText: isHidden,
                    decoration: _passwordStyle("Password"),
                  ),

                  if (!isLogin) ...[
                    SizedBox(height: 12),
                    TextField(
                      controller: confirmPasswordController,
                      obscureText: isHidden,
                      decoration:
                          _passwordStyle("Confirm Password"),
                    ),
                  ],

                  SizedBox(height: 22),

                  /// Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryOrange,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      onPressed: submit,
                      child: Text(
                        isLogin ? "Login" : "Create Account",
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  InputDecoration _inputStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Color(0xFFFFEAEA),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }

  InputDecoration _passwordStyle(String hint) {
    return InputDecoration(
      hintText: hint,
      filled: true,
      fillColor: Color(0xFFFFEAEA),
      suffixIcon: IconButton(
        icon: Icon(isHidden
            ? Icons.visibility_off
            : Icons.visibility),
        onPressed: () {
          setState(() {
            isHidden = !isHidden;
          });
        },
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide.none,
      ),
    );
  }
}
