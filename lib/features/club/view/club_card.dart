import 'package:conveneapp/core/text.dart';
import 'package:conveneapp/features/club/model/personal_club_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';

class ClubCard extends StatelessWidget {
  final PersonalClubModel club;
  const ClubCard({Key? key, required this.club}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 8),
      padding: const EdgeInsets.all(10.0),
      decoration:
          BoxDecoration(color: Theme.of(context).cardColor, borderRadius: const BorderRadius.all(Radius.circular(20))),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.only(right: 10),
            child: CircleAvatar(
              backgroundColor: Palette.niceBlack,
              radius: 24,
              child: Builder(
                builder: (context) {
                  return Text(club.name.substring(0, 1));
                },
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 8.0, bottom: 8.0, right: 10.0, left: 5),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(child: CustomText(text: club.name)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
