import 'package:attainfinance/features/expenses/repository/expenses_repository.dart';
import 'package:attainfinance/models/expenses_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/utils.dart';
import '../../auth/controller/auth_controller.dart';

final expenseControllerProvider =
    StateNotifierProvider<ExpenseController, bool>((ref) {
  final expenseRepository = ref.watch(expenseRepositoryProvider);
  return ExpenseController(expenseRepository: expenseRepository, ref: ref);
});

class ExpenseController extends StateNotifier<bool> {
  final ExpenseRepository _expenseRepository;
  final Ref _ref;
  ExpenseController(
      {required ExpenseRepository expenseRepository, required Ref ref})
      : _expenseRepository = expenseRepository,
        _ref = ref,
        super(false);

  void addExpense(String title, String description, double cost,
      BuildContext context) async {
    state = true;
    final uid = _ref.read(userProvider)?.email ?? '';
    Expense expense = Expense(
      name: title,
      description: description,
      createdAt: Timestamp.now(),
      cost: cost,
      useremail: uid,
    );
    final res = await _expenseRepository.addExpense(expense);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      showSnackBar(context, 'Your Expense "$title" Added Successfully!');
    });
  }
}
