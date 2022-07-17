import 'package:conveneapp/core/button.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:conveneapp/features/club/controller/club_controller.dart';
import 'package:conveneapp/features/club/model/club_model.dart';
import 'package:conveneapp/theme/palette.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CreateClubPage extends StatelessWidget {
  static MaterialPageRoute<dynamic> route() => MaterialPageRoute(
        builder: (context) => const CreateClubPage(),
      );

  const CreateClubPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Create a Club",
            style: TextStyle(color: Palette.niceBlack)),
      ),
      body: CreateClubView(),
    );
  }
}

class CreateClubView extends ConsumerWidget {
  final TextEditingController nameController = TextEditingController();
  CreateClubView({
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
            const Text("Your club will need a club name",
                style: TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: "Club Name",
                border: OutlineInputBorder(),
              ),
            ),
            const Spacer(
              flex: 4,
            ),
            BigButton(
              child: const Text("Create"),
              onPressed: () async {
                final userId =
                    ref.watch(currentUserController).asData?.value.uid;

                if (userId != null) {
                  await ref.read(currentClubsController.notifier).addClub(
                        club: ClubModel(
                            name: nameController.text, members: [userId]),
                      );
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
