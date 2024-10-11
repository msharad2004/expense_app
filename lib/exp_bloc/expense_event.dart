part of 'expense_bloc.dart';

@immutable
abstract class ExpenseEvent {}

class AddExpenseEvent extends ExpenseEvent{
  ExpenseModel newExpense;
  AddExpenseEvent({required this.newExpense});
}
class FetchAllExpenseEvent extends ExpenseEvent{}
class UpdateExpenseEvent extends ExpenseEvent{
  ExpenseModel updateExpense;
  UpdateExpenseEvent({required this.updateExpense});
}
class DeleteExpenseEvent extends ExpenseEvent{
  int id;
  DeleteExpenseEvent({required this.id});
}