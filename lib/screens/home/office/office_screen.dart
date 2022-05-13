import 'package:campus_assistant/screens/home/office/stuff_list.dart';
import 'package:flutter/material.dart';

import '../../../models/user_model.dart';
import 'cr_list.dart';

class OfficeScreen extends StatelessWidget {
  static const routeName = 'office_screen';

  const OfficeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserModel userModel =
        ModalRoute.of(context)!.settings.arguments as UserModel;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('CR & Office Stuff'),
          centerTitle: true,
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Class Representative'),
              Tab(text: 'Office Stuff'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            //cr list
            CrList(userModel: userModel),

            // stuff list
            StuffList(userModel: userModel),
          ],
        ),
      ),
    );
  }
}
