import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sqflite/sqflite.dart';
import '../models/expense_modal.dart';
import '../models/user_modal.dart';

class AppDataBase {
  AppDataBase._();

  static final AppDataBase instance = AppDataBase._();

  Database? myDb;

  static final String LOGIN_UID = "UID";

  /// Table
  static final String EXPENSE_TABLE = "expense";
  static final String USER_TABLE = "users";

  /// User table Column
  static final String COLUMN_USER_ID = "uId";
  static final String COLUMN_USER_NAME = "uName";
  static final String COLUMN_USER_EMAIL = "uEmail";
  static final String COLUMN_USER_PASS = "uPass";

  /// Expense Table Column
  static final String COLUMN_EXPENSE_ID = "expId";
  static final String COLUMN_EXPENSE_TITLE = "expTitle";
  static final String COLUMN_EXPENSE_DESC = "expDesc";
  static final String COLUMN_EXPENSE_TIMESTAMP = "expTimeStap";
  static final String COLUMN_EXPENSE_AMOUNT = "expAmount";
  static final String COLUMN_EXPENSE_BALANCE = "expBalance";
  static final String COLUMN_EXPENSE_TYPE = "expType";
  static final String COLUMN_EXPENSE_CAT_TYPE = "expCatType";

  Future<Database> getDb() async {
    if (myDb != null) {
      return myDb!;
    } else {
      myDb = await initDb();
      return myDb!;
    }
  }

  Future<Database> initDb() async {
    var docDirectory = await getApplicationDocumentsDirectory();

    var dbPath = join(docDirectory.path, "expense.db");

    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        /// User Table
        db.execute(
            "create table $USER_TABLE ( $COLUMN_USER_ID integer primary key autoincrement, $COLUMN_USER_NAME text, $COLUMN_USER_EMAIL text, $COLUMN_USER_PASS text)");

        /// Expense Table
        db.execute(
            "create table $EXPENSE_TABLE ( $COLUMN_EXPENSE_ID integer primary key autoincrement, $COLUMN_USER_ID integer, $COLUMN_EXPENSE_TITLE text, $COLUMN_EXPENSE_DESC text, $COLUMN_EXPENSE_TIMESTAMP text, $COLUMN_EXPENSE_AMOUNT real, $COLUMN_EXPENSE_BALANCE real, $COLUMN_EXPENSE_TYPE integer, $COLUMN_EXPENSE_CAT_TYPE integer )");
      },
    );
  }

  Future<int> getUID() async {
    var prefs = await SharedPreferences.getInstance();
    var uid = prefs.getInt(LOGIN_UID);
    return uid ?? 0;
  }

  Future<bool> createAccount(UserModel newUser) async {
    var check = await checkIfAlreadyExsits(newUser.user_email);

    if (!check) {
      var db = await getDb();
      db.insert(USER_TABLE, newUser.toMap());
      return true;
    } else {
      return false;
    }
  }

  Future<bool> checkIfAlreadyExsits(String email) async {
    var db = await getDb();
    var data = await db
        .query(USER_TABLE, where: "$COLUMN_USER_EMAIL = ?", whereArgs: [email]);

    return data.isNotEmpty;
  }

  Future<bool> authenticateUser(String email, String pass) async {
    var db = await getDb();

    var data = await db.query(USER_TABLE,
        where: "$COLUMN_USER_EMAIL = ? and $COLUMN_USER_PASS = ?",
        whereArgs: [email, pass]);

    return data.isNotEmpty;
  }

  ///expense

  Future<bool> addExpense(ExpenseModel newExpense) async{
    var db = await getDb();

    int rowsEffected = await db.insert(EXPENSE_TABLE, newExpense.toMap());

    return rowsEffected>0;
  }

  Future<List<ExpenseModel>> fetchAllExpense() async{
    var db = await getDb();
    var data = await db.query(EXPENSE_TABLE, orderBy: "$COLUMN_EXPENSE_TIMESTAMP DESC");

    List<ExpenseModel> listExp = [];

    for(Map<String,dynamic> eachExp in data){
      listExp.add(ExpenseModel.fromMap(eachExp));
    }

    return listExp;
  }
}