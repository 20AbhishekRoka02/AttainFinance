import 'package:attainfinance/features/expenses/controller/expense_controller.dart';
import 'package:attainfinance/features/expenses/widgets/expense_overview_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/errorText.dart';
import '../../../core/common/loder.dart';

class MyExpenses extends ConsumerWidget {
  const MyExpenses({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userExpensesProvider).when(
        data: (expenses) => ListView.builder(
            itemCount: expenses.length,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              final expense = expenses[index];
              return ExpenseOverviewCard(
                title: expense.name,
                description: expense.description,
                createdAt: expense.createdAt,
                onTap: () {},
              );
            }),
        error: (error, stackTrace) => ErrorText(error: error.toString()),
        loading: () => const Loader());
  }
}
