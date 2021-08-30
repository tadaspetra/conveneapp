import 'package:conveneapp/apis/firebase/auth.dart';
import 'package:conveneapp/features/authentication/controller/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Dashboard extends ConsumerStatefulWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends ConsumerState<Dashboard> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: ref.watch(currentUserController).when(
          data: (data) {
            return Text("Hi ${data.name}");
          },
          loading: () {
            return const Text("loading");
          },
          error: (error, stack) {
            return const Text("error");
          },
        ),
        actions: [
          IconButton(
            onPressed: () => AuthApi().signOut(),
            icon: const Icon(
              Icons.logout,
            ),
          )
        ],
      ),
      body: const Center(
        child: Text("dashboard"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
