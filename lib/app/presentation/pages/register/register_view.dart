import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_bloc_boilerplate/app/presentation/pages/register/bloc/register_bloc.dart';
import 'package:flutter_bloc_boilerplate/app/presentation/styles/app_style.dart';
import 'package:flutter_bloc_boilerplate/app/presentation/styles/theme.dart';
import 'package:flutter_bloc_boilerplate/app/router/app_route_config.dart';
import 'package:formz/formz.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: const RegisterFormView(),
    );
  }
}

class RegisterFormView extends StatefulWidget {
  const RegisterFormView({super.key});

  @override
  State<RegisterFormView> createState() => _RegisterFormViewState();
}

class _RegisterFormViewState extends State<RegisterFormView> {
  final _emailFocusNode = FocusNode();
  final _passwordFocusNode = FocusNode();
  final _confirmPasswordFocusNode = FocusNode();
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _emailFocusNode.addListener(() {
      if (!_emailFocusNode.hasFocus) {
        context.read<RegisterBloc>().add(RegisterEmailUnfocused());
      }
    });

    _passwordFocusNode.addListener(() {
      if (!_passwordFocusNode.hasFocus) {
        context.read<RegisterBloc>().add(RegisterPasswordUnfocused());
      }
    });

    _confirmPasswordFocusNode.addListener(() {
      if (!_confirmPasswordFocusNode.hasFocus) {
        context.read<RegisterBloc>().add(RegisterConfirmPasswordUnfocused());
      }
    });

    _nameFocusNode.addListener(() {
      if (!_nameFocusNode.hasFocus) {
        context.read<RegisterBloc>().add(RegisterNameUnfocused());
      }
    });
  }

  @override
  void dispose() {
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    _confirmPasswordFocusNode.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isValid = context.select((RegisterBloc bloc) => bloc.state.isValid);
    return BlocConsumer<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          debugPrint('from view ${state.toastMessage.toString()}');
          kSnackBarError(context, state.toastMessage.toString());
        } else if (state.status.isSuccess) {
          kSnackBarSuccess(context, 'Your Account for Sleek Properties LLC was Created Successfully');
          Navigator.of(context).pushReplacementNamed(AppRouter.homeRoute);
        }
      },
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Create Account'),
          ),
          body: AbsorbPointer(
            absorbing: state.status.isInProgress ? true : false,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(ThemeProvider.scaffoldPadding),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextFormField(
                      initialValue: state.name.value,
                      focusNode: _nameFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Full Name',
                        errorText: state.email.displayError != null
                            ? 'Required - Please ensure the name entered is valid'
                            : null,
                        labelStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                        errorStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontFamily: 'medium',
                      ),
                      keyboardType: TextInputType.name,
                      onChanged: (value) {
                        context
                            .read<RegisterBloc>()
                            .add(RegisterNameChanged(name: value));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: state.email.value,
                      focusNode: _emailFocusNode,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        errorText: state.email.displayError != null
                            ? 'Required - Please ensure the email entered is valid'
                            : null,
                        labelStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                        errorStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontFamily: 'medium',
                      ),
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (value) {
                        context
                            .read<RegisterBloc>()
                            .add(RegisterEmailChanged(email: value));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: state.password.value,
                      focusNode: _passwordFocusNode,
                      decoration: InputDecoration(
                        helperMaxLines: 2,
                        labelText: 'Password',
                        errorMaxLines: 2,
                        errorText: state.password.displayError != null
                            ? 'Required - Please ensure the Password entered is valid'
                            : null,
                        labelStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                        errorStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontFamily: 'medium',
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        context
                            .read<RegisterBloc>()
                            .add(RegisterPasswordChanged(password: value));
                      },
                      textInputAction: TextInputAction.next,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      initialValue: state.confirmedPassword.value,
                      focusNode: _confirmPasswordFocusNode,
                      decoration: InputDecoration(
                        helperMaxLines: 2,
                        labelText: 'Confirm Password',
                        errorMaxLines: 2,
                        errorText: state.confirmedPassword.displayError != null
                            ? 'Required - Please ensure the Confirm Password entered is valid'
                            : null,
                        labelStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                        errorStyle: TextStyle(
                          fontSize:
                              Theme.of(context).textTheme.labelMedium?.fontSize,
                          fontFamily: 'medium',
                        ),
                      ),
                      style: TextStyle(
                        fontSize:
                            Theme.of(context).textTheme.labelLarge?.fontSize,
                        fontFamily: 'medium',
                      ),
                      obscureText: true,
                      onChanged: (value) {
                        context.read<RegisterBloc>().add(
                            RegisterConfirmPasswordChanged(password: value));
                      },
                      textInputAction: TextInputAction.done,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: isValid
                            ? () => context
                                .read<RegisterBloc>()
                                .add(RegisterFormSubmitted())
                            : null,
                        style: ElevatedButton.styleFrom(
                          minimumSize: const Size.fromHeight(40),
                          backgroundColor: Theme.of(context).primaryColor,
                          foregroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          textStyle: TextStyle(
                              fontFamily: 'semibold',
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.fontSize),
                        ),
                        label: const Text('Sign Up'),
                        icon: state.status.isInProgress
                            ? Container(
                                width: 24,
                                height: 24,
                                padding: const EdgeInsets.all(2.0),
                                child: const CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 3,
                                ),
                              )
                            : const Icon(Icons.login_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
