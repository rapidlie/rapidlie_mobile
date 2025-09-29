import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/app_snackbars.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/settings/blocs/delete_account_bloc/delete_account_bloc.dart';
import 'package:rapidlie/l10n/app_localizations.dart';
import 'package:rapidlie/l10n/app_localizations_de.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late TextEditingController emailController;
  bool loading = false;
  var language;
  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    language = AppLocalizations.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: language.deleteAccount,
          isSubPage: true,
        ),
      ),
      body: SingleChildScrollView(
        child: BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
          listener: (context, state) {
            print(state.toString());
            if (state is DeleteAccountSuccessState) {
              context.goNamed('register');
            } else if (state is DeleteAccountErrorState) {
              AppSnackbars.showError(
                  context, "Failed, please try again later!");
            }
          },
          builder: (context, state) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    language.deleteAccountMessage1,
                    style: inter14Black400(context),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    language.deleteAccountMessage2,
                    style: inter14Black400(context),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  TextFieldTemplate(
                    hintText: "Email",
                    controller: emailController,
                    obscureText: false,
                    width: width,
                    height: 50.0,
                    textInputType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.done,
                    enabled: true,
                  ),
                  SizedBox(
                    height: 24,
                  ),
                  ButtonTemplate(
                    buttonName: language.submit,
                    buttonType: ButtonType.elevated,
                    buttonAction: () {
                      BlocProvider.of<DeleteAccountBloc>(context).add(
                        SubmitDeleteAccountEvent(
                            email: emailController.text.toString()),
                      );
                    },
                    loading: state is DeleteAccountLoadingState,
                  )
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
