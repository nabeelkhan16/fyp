import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:trash_collector/blocs/authentication/authentication_bloc.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text('Sign Up', style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.blue.shade900,
        leading: Container(
          margin: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.1),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: InkWell(onTap: () => Navigator.pop(context), child: const Icon(Icons.arrow_back, color: Colors.white)),
        ),
      ),
      backgroundColor: Colors.blueGrey[900],
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
         if(state is AuthenticationError) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
         
        },
        child: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            return Container(
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
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 20.0),
                        TextFormField(
                          key: GlobalKey<FormState>(),
                          controller: _emailController,
                          style: const TextStyle(color: Colors.white),
                          validator: (value) {
                            if (value!.isEmpty) {
                              return 'Please enter email';
                            }
                            return null;
                          },
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
                          controller: _passwordController,
                          validator: (value) => value!.isEmpty ? 'Password can\'t be empty' : null,
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
                          controller: _confirmPasswordController,
                          style: const TextStyle(color: Colors.white),
                          validator: (value) => value!.isEmpty ? 'Password can\'t be empty' : null,
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
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              if (_confirmPasswordController.text != _passwordController.text) {
                                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Password does not match')));
                              }
                              BlocProvider.of<AuthenticationBloc>(context)
                                  .add(AuthenticateWithCredentials(_emailController.text, _passwordController.text));
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('INVALID CREDENTIALS')));
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 15.0),
                            textStyle: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          child: state is AuthenticationLoading
                              ? const CircularProgressIndicator.adaptive()
                              : Text('Sign Up', style: TextStyle(color: Colors.blue.shade900)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
