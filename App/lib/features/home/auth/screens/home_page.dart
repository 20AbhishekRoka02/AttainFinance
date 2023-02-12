import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';

import '../../../../core/constants/constants.dart';
import '../../../auth/controller/auth_controller.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  int _page = 0;
  void onPageChanges(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(user.name),
      ),
      body: Constants.tabWidgets[_page],
      bottomNavigationBar: CupertinoTabBar(
        activeColor: Colors.black,
        backgroundColor: Colors.white38,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'My Expenses',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'New Expense',
          ),
        ],
        onTap: onPageChanges,
        currentIndex: _page,
      ),
    );
  }
}
