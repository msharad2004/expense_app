import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

import '../db/app_db.dart';
import '../models/expense_modal.dart';

part 'expense_event.dart';
part 'expense_state.dart';

class ExpenseBloc extends Bloc<ExpenseEvent, ExpenseState> {
  AppDataBase db;
  ExpenseBloc({required this.db}) : super(ExpenseInitialState()) {

    on<AddExpenseEvent>((event, emit) async{
      emit(ExpenseLoadingState());
      var check = await db.addExpense(event.newExpense);
      if(check){
        var mExp = await db.fetchAllExpense();
        emit(ExpenseLoadedState(mData: mExp));
      } else{
        emit(ExpenseErrorState(errorMsg: "Expense Not added!!"));
      }
    });

    on<FetchAllExpenseEvent>((event, emit) async{
      emit(ExpenseLoadingState());
      var mExp = await db.fetchAllExpense();
      emit(ExpenseLoadedState(mData: mExp));
    });

  }
}