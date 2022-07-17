import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:conveneapp/features/club/controller/club_controller.dart';
import 'package:conveneapp/features/club/model/club_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class JoinClubPage extends StatelessWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const JoinClubPage(),
      );

  const JoinClubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Join a Club", style: TextStyle(color: Palette.niceBlack)),
      ),
      body: JoinClubView(),
    );
  }
}

class JoinClubView extends ConsumerWidget {
  final TextEditingController clubIdController = TextEditingController();
  JoinClubView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            const Spacer(
              flex: 2,
            ),
            Center(
              child: Image(
                image: const AssetImage("assets/defaultstates/team.png"),
                height: (MediaQuery.of(context).size.height * 0.3),
              ),
            ),
            const Spacer(),
            const Text("Ask Club Member for Club ID", style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            TextField(
              controller: clubIdController,
              decoration: const InputDecoration(
                labelText: "Club ID",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(
              flex: 4,
            ),
            BigButton(
              child: const Text("Join"),
              onPressed: () async {
                final userId = ref.watch(currentUserController).asData?.value.uid;
                if (userId != null) {
                  ClubModel club =
                      await ref.read(currentClubsController.notifier).getClub(clubId: clubIdController.text);
                  await ref.read(currentClubsController.notifier).addMember(club: club, memberId: userId);
                }
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
    );
  }
}
