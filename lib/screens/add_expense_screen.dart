import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../Constants/elevated_button.dart';
import '../app_constants/content_constants.dart';
import '../app_widgets/expense_text_field.dart';
import '../exp_bloc/expense_bloc.dart';
import '../models/expense_modal.dart';

class AddExpenseScreen extends StatefulWidget {
  num balance;
  AddExpenseScreen({required this.balance});

  @override
  State<AddExpenseScreen> createState() => _AddExpenseState();
}

class _AddExpenseState extends State<AddExpenseScreen> {
  String selectedTransactionType = "Debit";
  DateTime expenseDate = DateTime.now();

  ///for default date
  String elevatedBtnName = "Choose Date";
  var selectedCatIndex = -1;

  final TextEditingController titleController = TextEditingController();
  final TextEditingController descController = TextEditingController();
  final TextEditingController amountController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? selectedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000, 2, 15),
      lastDate: DateTime.now(),
    );

    if (selectedDate != null) {
      setState(() {
        expenseDate = selectedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade400,
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 21),
            ExpenseTextField(
              label: "Name your expense",
              controller: titleController,
              iconData: Icons.abc,
            ),
            ExpenseTextField(
              label: "Add Description",
              controller: descController,
              iconData: Icons.abc,
            ),
            ExpenseTextField(
              label: "Enter amount",
              controller: amountController,
              iconData: Icons.money_sharp,
              keyboardType: TextInputType.number,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15, right: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 35,
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: DropdownButton(
                      dropdownColor: Colors.blue,
                      focusColor: Colors.white,
                      value: selectedTransactionType,
                      onChanged: (newValue) {
                        setState(() {
                          selectedTransactionType = newValue!;
                        });
                      },
                      items: ["Debit", "Credit"].map((type) {
                        return DropdownMenuItem(
                          value: type,
                          child: Text(
                            type,
                            style: const TextStyle(color: Colors.white),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(height: 11),
                  CstmButton(
                    name: "Choose Expense",
                    btnColor: Colors.white,
                    textColor: Colors.black,
                    mWidget: selectedCatIndex != -1
                        ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          AppConstants
                              .mCategories[selectedCatIndex].catImgPath,
                          width: 30,
                          height: 30,
                        ),
                        Text(
                          "  -  ${AppConstants.mCategories[selectedCatIndex]
                              .catTitle}",
                          style: const TextStyle(
                              fontSize: 18,
                              color: Colors.black,
                              fontWeight: FontWeight.w500),
                        )
                      ],
                    )
                        : null,
                    onTap: () {
                      showModalBottomSheet(
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(15))),
                          context: context,
                          builder: (context) {
                            return GridView.builder(
                                itemCount: AppConstants.mCategories.length,
                                gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 4),
                                itemBuilder: (context, index) {
                                  var eachCat = AppConstants.mCategories[index];
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        selectedCatIndex = index;
                                        //eachCat.catId;
                                        //select id instead
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: Colors.cyan.shade100,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(12),
                                        child: Image.asset(eachCat.catImgPath),
                                      ),
                                    ),
                                  );
                                });
                          });
                    },
                  ),
                  CstmButton(
                    name: DateFormat.yMMMMd().format(expenseDate),
                    btnColor: Colors.white,
                    textColor: Colors.purple,
                    onTap: () {
                      _selectDate(context);
                    },
                  ),
                  CstmButton(
                    name: "ADD Expense",
                    btnColor: Colors.black,
                    textColor: Colors.white,
                    onTap: () {

                      print(amountController.text.toString());

                      var mBalance = widget.balance;

                      if(selectedTransactionType=="Debit"){
                        mBalance -= int.parse(amountController.text.toString());
                      } else {
                        mBalance += int.parse(amountController.text.toString());
                      }

                      var newExpense = ExpenseModel(
                          expId: 0,
                          uId: 0,
                          expTitle: titleController.text.toString(),
                          expDesc: descController.text.toString(),
                          expTimeStamp: expenseDate.millisecondsSinceEpoch.toString(),
                          expAmt: int.parse(amountController.text.toString()),
                          expBal: mBalance,
                          expType: selectedTransactionType=="Debit" ? 0 : 1,
                          expCatType: selectedCatIndex
                      );

                      BlocProvider.of<ExpenseBloc>(context).add(AddExpenseEvent(newExpense: newExpense));
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}