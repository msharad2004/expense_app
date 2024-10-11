import 'dart:math';

import 'package:d_chart/commons/config_render.dart';
import 'package:d_chart/commons/data_model.dart';
import 'package:d_chart/ordinal/bar.dart';
import 'package:d_chart/ordinal/pie.dart';
import 'package:flutter/material.dart';
import '../Model/expense_model.dart';
import '../app_constants/content_constants.dart';
import '../models/cat_modal.dart';
import '../models/expense_modal.dart';

class StatsPage extends StatefulWidget {
  List<ExpenseModel> mData;

  StatsPage({required this.mData});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<CatWiseExpenseModel> catWiseData = [];
  List<OrdinalGroup> listOrdinalGrp = [];
  List<OrdinalData> listOrdinalData = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterCatWiseData();
  }

  @override
  Widget build(BuildContext context) {
    var isDark = Theme.of(context).brightness==Brightness.dark;
    return Scaffold(
      appBar: AppBar(
        title: Text('Stats'),
      ),
      body: Column(
        children: [
          Expanded(
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: DChartBarO(
                fillColor: (_, __, index){
                  if(index!%2==0){
                    return Colors.grey;
                  } else {
                    return Colors.blue;
                  }

                },
                groupList: listOrdinalGrp,
              ),
            ),
          ),
          Expanded(child: AspectRatio(
            aspectRatio: 16 / 9,
            child: DChartPieO(
              data: listOrdinalData,
              configRenderPie: const ConfigRenderPie(
                arcWidth: 30,
              ),
            ),
          ),),
          Expanded(
            child: ListView.builder(
                itemCount: catWiseData.length,
                itemBuilder: (_, parentIndex) {
                  var eachItem = catWiseData[parentIndex];
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('${eachItem.catName}'),
                            Text('${eachItem.totalAmt}')
                          ],
                        ),
                        Divider(
                          color: isDark ? Colors.white : Colors.black,
                        ),
                        ListView.builder(
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
                }),
          ),
        ],
      ),
    );
  }

  void filterCatWiseData() {
    for (CategoryModel eachCat in AppConstants.mCategories) {
      var catName = eachCat.catTitle;
      var eachCatAmt = 0.0;
      List<ExpenseModel> catTrans = [];

      for (ExpenseModel eachExp in widget.mData) {
        if ((eachExp.expCatType+1) == eachCat.catId) {
          catTrans.add(eachExp);

          if (eachExp.expType == 0) {
            ///debit
            eachCatAmt -= eachExp.expAmt;
          } else {
            ///credit
            eachCatAmt += eachExp.expAmt;
          }
        }
      }

      if(catTrans.isNotEmpty) {
        catWiseData.add(CatWiseExpenseModel(
            catName: catName,
            totalAmt: eachCatAmt.toString(),
            allTransactions: catTrans));

        listOrdinalData.add(OrdinalData(
            domain: catName,
            measure: eachCatAmt.isNegative ? eachCatAmt*-1 : eachCatAmt,
            color: Colors.blue
        ));
      }
    }
    listOrdinalGrp.add(OrdinalGroup(id: "1", data: listOrdinalData));
  }
}