import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/core/widgets/button_template.dart';
import 'package:rapidlie/core/widgets/textfield_template.dart';
import 'package:rapidlie/features/register/presentation/pages/register_screen.dart';
import 'package:rapidlie/features/settings/blocs/delete_account_bloc/delete_account_bloc.dart';

class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({Key? key}) : super(key: key);

  static const String routeName = "/delete-account";

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  late TextEditingController emailController;
  bool loading = false;
  @override
  void initState() {
    emailController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: "Delete Account",
          isSubPage: true,
        ),
      ),
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: BlocConsumer<DeleteAccountBloc, DeleteAccountState>(
          listener: (context, state) {
            if (state is DeleteAccountSuccessState) {
              Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
            } else if (state is DeleteAccountErrorState) {}
          },
          builder: (context, state) {
            return Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Column(
                children: [
                  Text(
                    "We respect your decision to delete your account. Please note that once you initiate the deletion process, it will take 30 days to completely clear all your associated data from our systems. During this period, your account will be deactivated, and you won’t have access to it.",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Text(
                    "If you are sure you want to delete your account, enter your email in the box and click the button below.",
                    style: GoogleFonts.inter(
                      fontSize: 14,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
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
                    buttonName: "Submit",
                    buttonWidth: width,
                    buttonAction: () {
                      BlocProvider.of<DeleteAccountBloc>(context).add(
                        SubmitDeleteAccountEvent(
                            email: emailController.text.toString()),
                      );
                    },
                    loading: loading,
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
