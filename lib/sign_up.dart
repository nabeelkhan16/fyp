import 'package:flutter/material.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sign Up'),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
      ),
      backgroundColor: Colors.blueGrey[900],
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,

            colors: [
              
              Colors.blue.shade900,
              Colors.blue.shade800,
              Colors.blue.shade700,
              Colors.blue.shade600,

            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Sign Up',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 35.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  cursorColor: Colors.blue.shade900,
                  decoration: InputDecoration(
                    hintText: 'Email',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.person, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  cursorColor: Colors.blue.shade900,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20.0),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  obscureText: true,
                  cursorColor: Colors.blue.shade900,
                  decoration: InputDecoration(
                    hintText: 'Confirm Password',
                    hintStyle: const TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.1),
                    prefixIcon: const Icon(Icons.lock, color: Colors.white),
                  ),
                ),
                const SizedBox(height: 20.0),
                ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 15.0),
                    textStyle: const TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  child: Text('Sign Up', style: TextStyle(color: Colors.blue.shade900)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
