import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tugas_resep/views/login_page.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _isPasswordVisible = false;
  bool _isconfirmPasswordVisible = false;

  void _register() async {
    String username = _usernameController.text;
    String password = _passwordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (username.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi Gagal: Data tidak boleh kosong"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (password != confirmPassword) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Registrasi Gagal: Password tidak cocok"),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString("username", username);
    await prefs.setString("password", password);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Registrasi Berhasil!"),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Login Page"),
      //   backgroundColor: Colors.orange,
      //   foregroundColor: Colors.white,
      // ),
      backgroundColor: const Color(0xFFFDF0D5),
      body: LayoutBuilder(
        builder: (context, constrainst) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constrainst.maxHeight),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.restaurant_menu, color: Colors.orange),
                        Text(
                          "Selamat Datang!",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "Registrasi untuk menjelajahi ribuan resep",
                          style: TextStyle(color: Colors.blueGrey),
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Username"),
                        _inputField(
                          "Username",
                          false,
                          _usernameController,
                          Icon(Icons.person, color: Colors.orange),
                          null,
                          _isPasswordVisible,
                        ),
                        SizedBox(height: 20),
                        Text("Password"),
                        _inputField(
                          "Password",
                          true,
                          _passwordController,
                          Icon(Icons.lock, color: Colors.orange),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: _isPasswordVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                          _isPasswordVisible,
                        ),
                        SizedBox(height: 20),
                        Text("Confirm Password"),
                        _inputField(
                          "Confirm Password",
                          true,
                          _confirmPasswordController,
                          Icon(Icons.lock, color: Colors.orange),
                          IconButton(
                            onPressed: () {
                              setState(() {
                                _isconfirmPasswordVisible =
                                    !_isconfirmPasswordVisible;
                              });
                            },
                            icon: _isconfirmPasswordVisible
                                ? Icon(Icons.visibility)
                                : Icon(Icons.visibility_off),
                          ),
                          _isconfirmPasswordVisible,
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _register,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            minimumSize: Size(double.infinity, 45),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text("Register"),
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Sudah punya akun?",
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                            SizedBox(width: 3),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => LoginPage(),
                                  ),
                                );
                              },
                              child: Text(
                                "Login",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

Widget _inputField(
  String hintText,
  bool obscureText,
  TextEditingController controller,
  Icon prefixIcon,
  IconButton? suffixIcon,
  bool isVisible,
) {
  return TextField(
    controller: controller,
    obscureText: obscureText ? !isVisible : false,
    decoration: InputDecoration(
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      hintText: hintText,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.orange),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(12)),
        borderSide: BorderSide(color: Colors.orange),
      ),
    ),
  );
}
