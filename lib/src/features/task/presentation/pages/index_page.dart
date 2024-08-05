import 'package:flutter/material.dart';
import 'package:maecha_tasks/src/features/task/presentation/widgets/bottom_navigation_bar.dart';

class IndexPage extends StatefulWidget {
  const IndexPage({super.key});

  @override
  State<IndexPage> createState() => _IndexPageState();
}

class _IndexPageState extends State<IndexPage> {
  int selectedIndex = 0;

  void onItemTapped(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: bottomNavigationBar(context,selectedIndex,onItemTapped),
      body: Center(
        child: getPage(selectedIndex),
      ),
    );
  }
}
