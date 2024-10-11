import 'package:expense/screens/stats_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../app_constants/content_constants.dart';
import '../date_utils.dart';
import '../exp_bloc/expense_bloc.dart';
import '../models/expense_modal.dart';
import '../provider/theme_provider.dart';
import '../ui_helper.dart';
import 'add_expense_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  double mWidth = 0.0;
  double mHeight = 0.0;
  MediaQueryData? mq;
  num lastBalance = 0.0;

  List<ExpenseModel> allExpenses = [];

  @override
  void initState() {
    super.initState();
    BlocProvider.of<ExpenseBloc>(context).add(FetchAllExpenseEvent());
  }

  @override
  Widget build(BuildContext context) {
    getWidthHeight();
    var isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.grey.shade400,
      appBar: AppBar(
        title: const Text("Add Expense"),
        backgroundColor: isDark ? Colors.grey : Colors.blue,
      ),
      drawer: Drawer(
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 21),
              TextButton.icon(
                onPressed: () async {
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (ctx) => LoginScreen()));
                  var prefs = await SharedPreferences.getInstance();
                  prefs.setBool(LoginScreen.LOGIN_PREFS_KEY, false);
                },
                icon: const Icon(
                  Icons.logout,
                  color: Colors.blue,
                ),
                label: const Text(
                  "Log out",
                  style: TextStyle(color: Colors.blue),
                ),
              ),
              SwitchListTile(
                  title: Text("Dark Mode"),
                  subtitle: Text("Control theme of App from here"),
                  value: context.watch<ThemeProvider>().themeValue,
                  onChanged: (value) {
                    context.read<ThemeProvider>().themeValue = value;
                    Navigator.pop(context);
                  })
            ],
          ),
        ),
      ),
      body: BlocBuilder<ExpenseBloc, ExpenseState>(
        builder: (_, state) {
          if (state is ExpenseLoadingState) {
            return Center(
              child: CircularProgressIndicator(
                color: isDark ? Colors.grey : Colors.black,
              ),
            );
          }

          if (state is ExpenseErrorState) {
            return Center(
              child: Text(state.errorMsg),
            );
          }

          if (state is ExpenseLoadedState) {
            allExpenses = state.mData;
            if (state.mData.isNotEmpty) {
              updateBalance(state.mData);
              var dateWiseExpenses = filterDayWiseExpenses(state.mData);

              return mq!.orientation == Orientation.landscape
                  ? landscapeLay(dateWiseExpenses, isDark)
                  : portraitLay(dateWiseExpenses, isDark);
            } else {
              return Center(
                child: Text(
                  "No Expense yet!!\n Start adding today.",
                  style: mTextStyle25(),
                ),
              );
            }
          }

          return Container();
        },
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            backgroundColor: isDark ? Colors.white : Colors.black,
            child: Icon(
              Icons.stacked_bar_chart,
              color: isDark ? Colors.black : Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => StatsPage(mData: allExpenses),
                  ));
            },
          ),
          FloatingActionButton(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
            backgroundColor: isDark ? Colors.white : Colors.black,
            child: Icon(
              Icons.add,
              color: isDark ? Colors.black : Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddExpenseScreen(balance: lastBalance),
                  ));
            },
          ),
        ],
      ),
    );
  }

  void updateBalance(List<ExpenseModel> mData) {
    var lastTransactionId = -1;
    for (ExpenseModel exp in mData) {
      if (exp.expId > lastTransactionId) {
        lastTransactionId = exp.expId;
      }
    }
    print(lastTransactionId);
    var lastExpenseBal = mData
        .firstWhere((element) => element.expId == lastTransactionId)
        .expBal;
    lastBalance = lastExpenseBal;
  }

  void getWidthHeight() {
    mq = MediaQuery.of(context);
    mWidth = mq!.size.width;
    mHeight = mq!.size.height;
    print("Width : $mWidth, Height: $mHeight");
  }

  Widget portraitLay(List<DateWiseExpenseModel> dateWiseExpenses, bool isDark) {
    return Column(
      children: [
        Expanded(child: balanceHeader()),
        Expanded(
          flex: 2,
          child: mainLay(dateWiseExpenses, isDark),
        ),
      ],
    );
  }

  Widget landscapeLay(
      List<DateWiseExpenseModel> dateWiseExpenses, bool isDark) {
    return Row(
      children: [
        Expanded(
          flex: 3,
          child: balanceHeader(),
        ),
        Expanded(
          flex: 2,
          child: LayoutBuilder(
            builder: (_, constraints) {
              print(
                  "internal width : ${constraints.maxWidth}, internal height : ${constraints.maxHeight}");
              return mainLay(dateWiseExpenses, isDark,
                  isLandscape: constraints.maxWidth > 500 ? true : false);
            },
          ),
        ),
      ],
    );
  }

  Widget balanceHeader() {
    return Container(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Your Balance till now:'),
            Text(
              '$lastBalance',
              style: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget mainLay(List<DateWiseExpenseModel> dateWiseExpenses, bool isDark,
      {isLandscape = false}) {
    return ListView.builder(
        itemCount: dateWiseExpenses.length,
        itemBuilder: (_, parentIndex) {
          var eachItem = dateWiseExpenses[parentIndex];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('${eachItem.date}'),
                    Text('${eachItem.totalAmt}')
                  ],
                ),
                Divider(
                  color: isDark ? Colors.white : Colors.black,
                ),
                isLandscape
                    ? GridView.builder(
                    gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                        maxCrossAxisExtent: 70, crossAxisSpacing: 11),
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: eachItem.allTransactions.length,
                    itemBuilder: (_, childIndex) {
                      var eachTrans = eachItem.allTransactions[childIndex];

                      return GridTile(
                        child: Image.asset(
                            AppConstants.mCategories[eachTrans.expCatType]
                                .catImgPath,
                            width: 40,
                            height: 40),
                        header: Text(eachTrans.expTitle),
                        footer: Text(eachTrans.expAmt.toString()),
                      );
                    })
                    : ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: eachItem.allTransactions.length,
                    itemBuilder: (_, childIndex) {
                      var eachTrans = eachItem.allTransactions[childIndex];
                      return ListTile(
                        leading: Image.asset(AppConstants
                            .mCategories[eachTrans.expCatType].catImgPath),
                        title: Text(eachTrans.expTitle),
                        subtitle: Text(eachTrans.expDesc),
                        trailing: Column(
                          children: [
                            Text(eachTrans.expAmt.toString()),

                            ///balance will be added here
                            Text(eachTrans.expBal.toString()),
                          ],
                        ),
                      );
                    })
              ],
            ),
          );
        });
  }

  List<DateWiseExpenseModel> filterDayWiseExpenses(
      List<ExpenseModel> allExpenses) {
    //dateWiseExpenses.clear();
    List<DateWiseExpenseModel> dateWiseExpenses = [];

    var listUniqueDates = [];

    for (ExpenseModel eachExp in allExpenses) {
      var mDate = DateTimeUtils.getFormattedDateFromMilli(
          int.parse(eachExp.expTimeStamp));

      if (!listUniqueDates.contains(mDate)) {
        ///not contains
        listUniqueDates.add(mDate);
      }
    }

    print(listUniqueDates);

    for (String date in listUniqueDates) {
      List<ExpenseModel> eachDateExp = [];
      var totalAmt = 0.0;

      for (ExpenseModel eachExp in allExpenses) {
        var mDate = DateTimeUtils.getFormattedDateFromMilli(
            int.parse(eachExp.expTimeStamp));

        if (date == mDate) {
          eachDateExp.add(eachExp);

          if (eachExp.expType == 0) {
            ///debit
            totalAmt -= eachExp.expAmt;
          } else {
            ///credit
            totalAmt += eachExp.expAmt;
          }
        }
      }

      ///for today
      var formattedTodayDate =
      DateTimeUtils.getFormattedDateFromDateTime(DateTime.now());

      if (formattedTodayDate == date) {
        date = "Today";
      }

      ///for Yesterday
      var formattedYesterdayDate = DateTimeUtils.getFormattedDateFromDateTime(
          DateTime.now().subtract(Duration(days: 1)));

      if (formattedYesterdayDate == date) {
        date = "Yesterday";
      }

      dateWiseExpenses.add(DateWiseExpenseModel(
          date: date,
          totalAmt: totalAmt.toString(),
          allTransactions: eachDateExp));
    }

    return dateWiseExpenses;
  }

/*List<MonthWiseExpenseModel> filterMonthWiseExpenses(
      List<ExpenseModel> allExpenses) {
    List<MonthWiseExpenseModel> monthWiseExpenses = [];

    var listUniqueMonths = [];

    for (ExpenseModel eachExp in allExpenses) {
      var mMonth = DateTimeUtils.getFormattedMonthFromMilli(
          int.parse(eachExp.expTimeStamp));

      if (!listUniqueMonths.contains(mMonth)) {
        ///not contains
        listUniqueMonths.add(mMonth);
      }
    }

    print(listUniqueMonths);

    for (String month in listUniqueMonths) {
      List<ExpenseModel> thisMonthExpenses = [];
      num thisMonthBal = 0.0;

      for (ExpenseModel eachExp in allExpenses) {
        var mMonth = DateTimeUtils.getFormattedMonthFromMilli(
            int.parse(eachExp.expTimeStamp));

        if (month == mMonth) {
          thisMonthExpenses.add(eachExp);

          if (eachExp.expType == 0) {
            ///debit
            thisMonthBal -= eachExp.expAmt;
          } else {
            ///credit
            thisMonthBal += eachExp.expAmt;
          }
        }
      }

      monthWiseExpenses.add(MonthWiseExpenseModel(
          month: month,
          totalAmt: thisMonthBal.toString(),
          allTransactions: thisMonthExpenses));
    }

    return monthWiseExpenses;
  }*/
}