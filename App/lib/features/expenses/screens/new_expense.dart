import 'package:attainfinance/core/common/loder.dart';
import 'package:attainfinance/features/expenses/controller/expense_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/common/form_field_decoration.dart';

final formKey1 = GlobalKey<FormState>();

class NewExpense extends ConsumerStatefulWidget {
  const NewExpense({Key? key}) : super(key: key);

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _NewExpenseState();
}

class _NewExpenseState extends ConsumerState<ConsumerStatefulWidget> {
  final titleController = TextEditingController();
  final costController = TextEditingController();
  final descriptionController = TextEditingController();

  void addExpense() {
    ref.read(expenseControllerProvider.notifier).addExpense(
          titleController.text,
          descriptionController.text,
          costController.value as double,
          context,
        );
  }

  @override
  void dispose() {
    titleController.dispose();
    costController.dispose();
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(expenseControllerProvider);
    return Form(
      key: formKey1,
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          reverse: true,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Title can't be left empty.";
                  }
                  return null;
                },
                controller: titleController,
                decoration: textFormDecoration.copyWith(
                  labelText: 'Title',
                  hintText: 'Expense Name',
                ),
                maxLength: 40,
              ),
              TextFormField(
                controller: descriptionController,
                decoration: textFormDecoration.copyWith(
                  labelText: 'Description',
                  hintText: 'Enter the Description',
                ),
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              TextFormField(
                validator: (value) {
                  if (value!.isEmpty) {
                    return "Cost can't be left empty.";
                  }
                  return null;
                },
                controller: costController,
                keyboardType: TextInputType.number,
                decoration: textFormDecoration.copyWith(
                  labelText: 'Cost',
                  hintText: 'Expense Cost in INR',
                ),
              ),
              isLoading
                  ? const Loader()
                  : Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30),
                      child: Material(
                        color: Colors.purple,
                        borderRadius: BorderRadius.circular(25),
                        child: MaterialButton(
                          minWidth: double.infinity,
                          onPressed: () {
                            if (formKey1.currentState!.validate()) {
                              addExpense();
                            }
                          },
                          child: const Text(
                            'Add',
                            style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
