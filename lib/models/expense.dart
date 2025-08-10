import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/material.dart';

const uuid = Uuid();
final formatter = DateFormat.yMd();

enum ExpenseCategory { food, home, leisure, bills, transport, travel }

const categoryIcons = {
  ExpenseCategory.food: Icons.dining,
  ExpenseCategory.home: Icons.home,
  ExpenseCategory.leisure: Icons.sports_tennis,
  ExpenseCategory.bills: Icons.electric_bolt,
  ExpenseCategory.transport: Icons.directions_car,
  ExpenseCategory.travel: Icons.flight,
};

class Expense {
  Expense({
    required this.title,
    required this.amount,
    required this.date,
    required this.category,
  }) : id = uuid.v4();

  final String id;
  final String title;
  final double amount;
  final DateTime date;
  final ExpenseCategory category;

  get formattedDate => formatter.format(date);
}
