import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:insta_bloc/repositories/auth/auth_repository.dart';
import 'package:insta_bloc/screens/signup/cubit/signup_cubit.dart';
import 'package:insta_bloc/screens/widgets/widgets.dart';

import '../screens.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';
  static Route route() {
    return MaterialPageRoute(
        settings: const RouteSettings(name: routeName),
        builder: (context) => BlocProvider<SignupCubit>(
            create: (_) =>
                SignupCubit(authRepository: context.read<AuthRepository>()),
            child: SignupScreen()));
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.status == SignupStatus.error) {
              showDialog(
                  context: context,
                  builder: (context) => ErrorDialog(
                        message: state.failure.message,
                      ));
            } else if (state.status == SignupStatus.success) {
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
                              hintText: 'Username',
                            ),
                            onChanged: (value) => context
                                .read<SignupCubit>()
                                .usernameChanged(value),
                            validator: (value) => value!.trim().isEmpty
                                ? 'Please enter a valid email'
                                : null,
                          ),
                          SizedBox(
                            height: 16,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Email',
                            ),
                            onChanged: (value) =>
                                context.read<SignupCubit>().emailChanged(value),
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
                                .read<SignupCubit>()
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
                                state.status == SignupStatus.submitting),
                            elevation: 1,
                            color: Theme.of(context).primaryColor,
                            textColor: Colors.white,
                            child: Text('Sign Up'),
                          ),
                          SizedBox(
                            height: 12,
                          ),
                          RaisedButton(
                            onPressed: () => Navigator.pop(context),
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
      context.read<SignupCubit>().signupWithCredentials();
    }
  }
}
