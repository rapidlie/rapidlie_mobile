import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rapidlie/core/constants/custom_colors.dart';
import 'package:rapidlie/core/constants/feature_constants.dart';
import 'package:rapidlie/core/utils/render_image.dart';
import 'package:rapidlie/core/widgets/app_bar_template.dart';
import 'package:rapidlie/features/events/models/event_model.dart';

class GuestListScreen extends StatefulWidget {
  final List<Invitation>? guests;
  GuestListScreen({Key? key, this.guests}) : super(key: key);

  @override
  State<GuestListScreen> createState() => _GuestListScreenState();
}

class _GuestListScreenState extends State<GuestListScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(80),
        child: AppBarTemplate(
          pageTitle: "Guest List",
          isSubPage: true,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: Container(
              height: MediaQuery.of(context).size.height,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.guests!.length,
                itemBuilder: (context, index) {
                  return guestListLayout(
                    userName: widget.guests![index].user.name,
                    eventStatus: widget.guests![index].status,
                    imageUrl: widget.guests![index].user.avatar,
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  guestListLayout(
      {required String? imageUrl,
      String? userName,
      required String eventStatus}) {
    return Container(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: FittedBox(
                    fit: BoxFit.contain,
                    child: ClipOval(
                      child: RenderImage(imageUrl: imageUrl!),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              SizedBox(
                width: 200,
                child: Text(
                  userName!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: inter14black500(context),
                ),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: eventStatus == "accepted"
                  ? CustomColors.acceptedContainerColor
                  : eventStatus == "declined"
                      ? CustomColors.rejectedContainerColor
                      : CustomColors.rejectedContainerColor,
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                eventStatus == "accepted"
                    ? "ACCEPTED"
                    : eventStatus == "declined"
                        ? "DECLINED"
                        : "PENDING",
                style: GoogleFonts.inter(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: eventStatus == "accepted"
                      ? CustomColors.acceptedTextColor
                      : eventStatus == "declined"
                          ? CustomColors.rejectedTextColor
                          : CustomColors.rejectedTextColor,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
