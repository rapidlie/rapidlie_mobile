import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/features/events/blocs/create_bloc/create_event_bloc.dart';
import 'package:rapidlie/features/events/blocs/get_bloc/event_bloc.dart';

class FifthSheetContentWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CreateEventBloc, CreateEventState>(
      builder: (context, state) {
        if (state is CreateEventLoading) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state is CreateEventSuccessful) {
          context.read<PrivateEventBloc>().add(GetPrivateEvents());
          context.read<PublicEventBloc>().add(GetPublicEvents());
          context.read<InvitedEventBloc>().add(GetInvitedEvents());

          context.read<PrivateEventBloc>().invalidateCache();
          context.read<PublicEventBloc>().invalidateCache();
          context.read<InvitedEventBloc>().invalidateCache();

          Future.delayed(Duration(seconds: 2), () {
            BlocProvider.of<CreateEventBloc>(context).add(ResetCreateEvent());
            /* Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => BottomNavScreen(currentIndex: 1)),
            ); */

            context.go('/bottom_nav', extra: 0);
          });
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset("assets/images/success_view.png"),
                SizedBox(height: 20),
                Text(
                  "You did it!!",
                  style: GoogleFonts.inter(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          );
        }
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset("assets/images/failed_view.png"),
              SizedBox(height: 20),
              Text(
                "Oops.. Something went wrong. Please try again",
                style: GoogleFonts.inter(
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
