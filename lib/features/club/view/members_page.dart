// A stateless widget displaying the club name in the app bar

import 'package:conveneapp/features/authentication/model/user_info.dart';
import 'package:conveneapp/features/club/model/club_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MembersPage extends ConsumerWidget {
  final ClubModel club;
  final List<UserInfo> members;
  const MembersPage({Key? key, required this.club, required this.members})
      : super(key: key);

  static MaterialPageRoute<dynamic> route(
          ClubModel club, List<UserInfo> members) =>
      MaterialPageRoute(
        builder: (context) => MembersPage(
          club: club,
          members: members,
        ),
      );

  void _copyClubId(BuildContext context) {
    Clipboard.setData(ClipboardData(text: club.id));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
      content: Text("Club ID Copied!"),
    ));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title:
            const Text("Members", style: TextStyle(color: Palette.niceBlack)),
        actions: [
          IconButton(
            onPressed: () {
              _copyClubId(context);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: Center(
        child: ListView.builder(
          itemCount: members.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    members[index].name ?? '',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(members[index].email),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
