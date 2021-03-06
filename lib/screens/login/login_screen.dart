import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_bloc/repositories/auth/auth_repository.dart';
import 'package:insta_bloc/screens/login/cubit/login_cubit.dart';
import 'package:insta_bloc/screens/screens.dart';
import 'package:insta_bloc/screens/signup/signup_screen.dart';
import 'package:insta_bloc/screens/widgets/widgets.dart';

class LoginScreen extends StatelessWidget {
  static const String routeName = '/login';
  static Route route() {
    return PageRouteBuilder(
        settings: const RouteSettings(name: routeName),
        transitionDuration: Duration(seconds: 0),
        pageBuilder: (context, _, __) => BlocProvider<LoginCubit>(
            create: (_) =>
                LoginCubit(authRepository: context.read<AuthRepository>()),
            child: LoginScreen()));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<LoginCubit, LoginState>(
          listener: (context, state) {
            if (state.status == LoginStatus.error) {
              showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(message: state.failure.message));
            } else if (state.status == LoginStatus.success) {
              Navigator.of(context).pushNamed(NavScreen.routeName);
            }
          },
          builder: (context, state) {
            return Scaffold(
              resizeToAvoidBottomInset: false,
              body: Center(
                  child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Card(
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Instagram',
                            style: TextStyle(
                                fontSize: 28.0, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            onChanged: (value) =>
                                context.read<LoginCubit>().emailChanged(value),
                            validator: (value) => !value!.contains('@')
                                ? 'Please enter a valid email'
                                : null,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Password',
                            ),
                            obscureText: true,
                            onChanged: (value) => context
                                .read<LoginCubit>()
                                .passwordChanged(value),
                            validator: (value) => value!.length < 6
                                ? 'Must be at least 6 characters'
                                : null,
                          ),
                          SizedBox(
                            height: 28,
                          ),
                          RaisedButton(
                            onPressed: () => _submitForm(context,
                                state.status == LoginStatus.submitting),
                            elevation: 1,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: Text('Log In'),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          RaisedButton(
                            onPressed: () => Navigator.of(context)
                                .pushNamed(SignupScreen.routeName),
                            elevation: 1,
                            color: Colors.grey[200],
                            textColor: Colors.black,
                            child: Text('No account ? Sign Up'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
            );
          },
        ),
      ),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState!.validate() && !isSubmitting) {
      context.read<LoginCubit>().loginWithCredentials();
    }
  }
}
