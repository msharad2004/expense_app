import '../db/app_db.dart';

class UserModel {
  UserModel({
    required this.user_id,
    required this.user_name,
    required this.user_email,
    required this.user_pass,
  });

  int user_id;
  String user_name;
  String user_email;
  String user_pass;

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      user_id: map[AppDataBase.COLUMN_USER_ID],
      user_name: map[AppDataBase.COLUMN_USER_NAME],
      user_email: map[AppDataBase.COLUMN_USER_EMAIL],
      user_pass: map[AppDataBase.COLUMN_USER_PASS],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      AppDataBase.COLUMN_USER_NAME: user_pass,
      AppDataBase.COLUMN_USER_EMAIL: user_email,
      AppDataBase.COLUMN_USER_PASS: user_pass,
    };
  }
}