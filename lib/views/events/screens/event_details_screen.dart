import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EventDetailsScreeen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            bottom: PreferredSize(
              preferredSize: Size.fromHeight(20),
              child: Container(
                color: Colors.white,
                width: double.maxFinite,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, bottom: 20, top: 20),
                  child: Text(
                    "Eugene weds Jedidah",
                    style: TextStyle(
                      color: Colors.black,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                      fontSize: 18.0,
                    ),
                  ),
                ),
              ),
            ),
            centerTitle: false,
            backgroundColor: Colors.white,
            expandedHeight: 450,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.asset(
                "assets/images/dansoman.jpeg",
                width: double.maxFinite,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              height: Get.height,
              color: Colors.white,
              child: Column(
                children: [
                  Text(
                    '',
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
