import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/password/blocs/change_password_bloc/change_password_bloc.dart';
import 'package:rapidlie/features/password/blocs/change_password_bloc/change_password_event.dart';
import 'package:rapidlie/features/password/blocs/change_password_bloc/change_password_state.dart';
import 'package:rapidlie/l10n/app_localizations.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({Key? key}) : super(key: key);

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  bool obscureOPText = true;
  bool obscureNPText = true;
  var language;

  @override
  void initState() {
    super.initState();
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.changePassword,
          isSubPage: true,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 30),
          child: BlocConsumer<ChangePasswordBloc, ChangePasswordState>(
            listener: (context, state) {
              if (state is ChangePasswordLoadingState) {
              } else if (state is ChangePasswordSuccessState) {
                context.go(
                  '/login',
                );
              } else {
                AppSnackbars.show(context, "Old password is wrong");
              }
            },
            builder: (context, state) {
              return Container(
                height: height,
                child: Column(
                  children: [
                    Column(
                      children: [
                        TextFieldTemplate(
                          hintText: language.oldPassword,
                          controller: oldPasswordController,
                          obscureText: obscureOPText,
                          width: width,
                          height: 50,
                          textInputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          enabled: true,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureOPText = !obscureOPText;
                              });
                            },
                            child: Icon(
                              obscureOPText ? Icons.lock : Icons.lock_open,
                            ),
                          ),
                        ),
                        textBoxSpace(),
                        TextFieldTemplate(
                          hintText: language.newPassword,
                          controller: newPasswordController,
                          obscureText: obscureNPText,
                          width: width,
                          height: 50,
                          textInputType: TextInputType.visiblePassword,
                          textInputAction: TextInputAction.next,
                          enabled: true,
                          suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                obscureNPText = !obscureNPText;
                              });
                            },
                            child: Icon(
                              obscureNPText ? Icons.lock : Icons.lock_open,
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 30.0,
                        ),
                        ButtonTemplate(
                          loading: state is ChangePasswordLoadingState,
                          buttonName: language.changePassword,
                          buttonType: ButtonType.elevated,
                          buttonAction: () {
                            if (newPasswordController.text.isEmpty ||
                                oldPasswordController.text.isEmpty) {
                              AppSnackbars.showError(
                                context,
                                language.requiredFields,
                              );
                            } else {
                              context.read<ChangePasswordBloc>().add(
                                    SubmitChangePasswordEvent(
                                      oldPassword: oldPasswordController.text,
                                      newPassword: newPasswordController.text,
                                    ),
                                  );
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 50,
                    )
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
