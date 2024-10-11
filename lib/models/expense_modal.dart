import '../db/app_db.dart';

class DateWiseExpenseModel {
  String date;
  String totalAmt;
  List<ExpenseModel> allTransactions;

  DateWiseExpenseModel({
    required this.date,
    required this.totalAmt,
    required this.allTransactions});
}

class MonthWiseExpenseModel {
  String month;
  String totalAmt;
  List<ExpenseModel> allTransactions;

  MonthWiseExpenseModel({
    required this.month,
    required this.totalAmt,
    required this.allTransactions});
}

class CatWiseExpenseModel{
  String catName;
  String totalAmt;
  List<ExpenseModel> allTransactions;

  CatWiseExpenseModel({
    required this.catName,
    required this.totalAmt,
    required this.allTransactions});
}

class ExpenseModel {
  ExpenseModel({
    required this.expId,
    required this.uId,
    required this.expTitle,
    required this.expDesc,
    required this.expTimeStamp,
    required this.expAmt,
    required this.expBal,
    required this.expType,
    required this.expCatType,
  });

  int expId;
  int uId;
  String expTitle;
  String expDesc;
  String expTimeStamp;
  num expAmt;
  num expBal;
  int expType;
  int expCatType;

  factory ExpenseModel.fromMap(Map<String, dynamic> map) {
    return ExpenseModel(
      expId: map[AppDataBase.COLUMN_EXPENSE_ID],
      uId: map[AppDataBase.COLUMN_USER_ID],
      expTitle: map[AppDataBase.COLUMN_EXPENSE_TITLE],
      expDesc: map[AppDataBase.COLUMN_EXPENSE_DESC],
      expTimeStamp: map[AppDataBase.COLUMN_EXPENSE_TIMESTAMP],
      expAmt: map[AppDataBase.COLUMN_EXPENSE_AMOUNT],
      expBal: map[AppDataBase.COLUMN_EXPENSE_BALANCE],
      expType: map[AppDataBase.COLUMN_EXPENSE_TYPE],
      expCatType: map[AppDataBase.COLUMN_EXPENSE_CAT_TYPE],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppDataBase.COLUMN_USER_ID: uId,
      AppDataBase.COLUMN_EXPENSE_TITLE: expTitle,
      AppDataBase.COLUMN_EXPENSE_DESC: expDesc,
      AppDataBase.COLUMN_EXPENSE_TIMESTAMP: expTimeStamp,
      AppDataBase.COLUMN_EXPENSE_AMOUNT: expAmt,
      AppDataBase.COLUMN_EXPENSE_BALANCE: expBal,
      AppDataBase.COLUMN_EXPENSE_TYPE: expType,
      AppDataBase.COLUMN_EXPENSE_CAT_TYPE: expCatType,
    };
  }
}