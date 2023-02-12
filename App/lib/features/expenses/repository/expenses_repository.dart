import 'package:attainfinance/core/constants/firebase_constents.dart';
import 'package:attainfinance/core/failure.dart';
import 'package:attainfinance/models/expenses_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:intl/intl.dart';
import '../../../core/providers/firebase_providers.dart';
import '../../../core/typedef.dart';

final expenseRepositoryProvider = Provider((ref) {
  return ExpenseRepository(firestore: ref.watch(firestoreProvider));
});

class ExpenseRepository {
  final FirebaseFirestore _firestore;
  ExpenseRepository({required FirebaseFirestore firestore})
      : _firestore = firestore;

  FutureVoid addExpense(Expense expense) async {
    try {
      return right(
        _users
            .doc(expense.useremail)
            .collection(FirebaseConstants.expensesCollection.toString())
            .doc(expense.createdAt.toDate().toString())
            .set(
              expense.toMap(),
            ),
      );
    } on FirebaseException catch (e) {
      throw e.message!;
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _users =>
      _firestore.collection(FirebaseConstants.usersCollection);
}
