// A stateless widget displaying the club name in the app bar

import 'package:conveneapp/features/club/model/club_model.dart';
import 'package:conveneapp/features/club/view/members_page.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ClubPage extends ConsumerWidget {
  final ClubModel club;
  const ClubPage({Key? key, required this.club}) : super(key: key);

  static MaterialPageRoute<dynamic> route(ClubModel club) => MaterialPageRoute(
        builder: (context) => ClubPage(club: club),
      );
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(club.name, style: const TextStyle(color: Palette.niceBlack)),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, MembersPage.route(club));
            },
            icon: const Icon(Icons.people),
          ),
        ],
      ),
      body: const Center(
        child: Text('Club'),
      ),
    );
  }
}
