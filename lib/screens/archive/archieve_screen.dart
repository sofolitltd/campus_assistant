import 'package:campus_assistant/screens/archive/library_screen.dart';
import 'package:campus_assistant/screens/archive/research_screen.dart';
import 'package:flutter/material.dart';

import '../../utils/constants.dart';

class ArchiveScreen extends StatefulWidget {
  const ArchiveScreen({Key? key}) : super(key: key);

  @override
  State<ArchiveScreen> createState() => _ArchiveScreenState();
}

class _ArchiveScreenState extends State<ArchiveScreen> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: kArchive.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Archive'),
          bottom:
              TabBar(tabs: kArchive.map((item) => Tab(text: item)).toList()),
        ),
        body: const TabBarView(
          children: [
            LibraryScreen(),
            ResearchScreen(),
          ],
        ),
      ),
    );
  }
}
