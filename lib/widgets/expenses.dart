import 'package:flutter/material.dart';

import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<Expenses> createState() => _ExpensesState();
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _expenses = [
    Expense(
      date: DateTime.now(),
      title: 'Coffee',
      amount: 4.50,
      category: ExpenseCategory.food,
    ),
    Expense(
      date: DateTime.now(),
      title: 'Lunch',
      amount: 30.50,
      category: ExpenseCategory.leisure,
    ),
    Expense(
      date: DateTime.now(),
      title: 'Bus ticket',
      amount: 10.50,
      category: ExpenseCategory.transport,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const Text('Chart of expenses'),
          Expanded(child: ExpensesList(expenses: _expenses)),
        ],
      ),
    );
  }
}
