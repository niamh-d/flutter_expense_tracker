import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

final formatter = DateFormat.yMd();

class NewExpense extends StatefulWidget {
  const NewExpense({super.key, required this.onAddExpense});

  final void Function(Expense) onAddExpense;

  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  ExpenseCategory _selectedCategory = ExpenseCategory.food;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: firstDate,
      lastDate: now,
    );
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _submitExpenseData() {
    final enteredAmount = double.tryParse(_amountController.text);
    final amountIsInvalid = enteredAmount == null || enteredAmount <= 0;

    if (_titleController.text.trim().isEmpty ||
        amountIsInvalid ||
        _selectedDate == null) {
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Invalid input'),
          content: const Text(
            'Please ensure a valid title, amount and date are entered',
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text('Ok')),
          ],
        ),
      );
      return;
    }

    widget.onAddExpense(
      Expense(
        date: _selectedDate!,
        title: _titleController.text,
        amount: enteredAmount,
        category: _selectedCategory,
      ),
    );
    Navigator.pop(context);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;

    return LayoutBuilder(
      builder: (ctx, constraints) {
        final width = constraints.maxWidth;
        final amountTextField = TextField(
          controller: _amountController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            prefixText: '\$ ',
            label: Text('Amount'),
          ),
        );
        final titleTextField = TextField(
          controller: _titleController,
          maxLength: 50,
          decoration: const InputDecoration(label: Text('Title')),
        );
        final datePickerRow = Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              _selectedDate == null
                  ? 'No date selected'
                  : formatter.format(_selectedDate!),
            ),
            IconButton(
              onPressed: _presentDatePicker,
              icon: const Icon(Icons.calendar_month),
            ),
          ],
        );

        final categoryDropdown = DropdownButton(
          value: _selectedCategory,
          items: ExpenseCategory.values
              .map(
                (c) => DropdownMenuItem(
                  value: c,
                  child: Text(c.name.toUpperCase()),
                ),
              )
              .toList(),
          onChanged: (value) {
            if (value == null) return;
            setState(() {
              _selectedCategory = value;
            });
          },
        );

        final closeBtn = TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        );
        final saveNewExpenseBtn = ElevatedButton(
          onPressed: _submitExpenseData,
          child: const Text('Save Expense'),
        );

        return SizedBox(
          height: double.infinity,
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.fromLTRB(16, 16, 16, keyboardSpace + 16),
              child: Column(
                children: [
                  if (width >= 600)
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: titleTextField),
                        const SizedBox(width: 24),
                        Expanded(child: amountTextField),
                      ],
                    )
                  else
                    titleTextField,
                  if (width >= 600)
                    Row(
                      children: [
                        categoryDropdown,
                        const SizedBox(width: 24),
                        Expanded(child: datePickerRow),
                      ],
                    )
                  else
                    Row(
                      children: [
                        Expanded(child: amountTextField),
                        const SizedBox(width: 16),
                        Expanded(child: datePickerRow),
                      ],
                    ),
                  const SizedBox(height: 16),
                  if (width >= 600)
                    Row(
                      children: [
                        const Spacer(),
                        closeBtn,
                        const SizedBox(width: 16),
                        saveNewExpenseBtn,
                      ],
                    )
                  else
                    Row(
                      children: [
                        categoryDropdown,
                        const Spacer(),
                        closeBtn,
                        const SizedBox(width: 16),
                        saveNewExpenseBtn,
                      ],
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
