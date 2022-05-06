import 'package:flutter/material.dart';

class RegistrationScreen extends StatelessWidget {
  const RegistrationScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Form(
          child: Center(
            child: ListView(
              shrinkWrap: true,
              padding: const EdgeInsets.all(16),
              children: [
                //email address
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Email'),
                    hintText: 'user@mail.com',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 8),

                //password
                TextFormField(
                  decoration: const InputDecoration(
                    label: Text('Password'),
                    hintText: 'asdf1123@#',
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),

                const SizedBox(height: 16),

                //button
                ElevatedButton(onPressed: () {}, child: const Text('Register'))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
