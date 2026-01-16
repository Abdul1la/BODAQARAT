library myGlobal;

import 'package:shared_preferences/shared_preferences.dart';

String usernameGlobal = "guest";
String userEmailGlobal = "";
int AccountValue = 0;
String SubscribeStatus = "none";

const _usernameKey = 'logged_username';
const _userEmailKey = 'logged_user_email';
const _accountValueKey = 'logged_account_value';
const _subscribeStatusKey = 'logged_subscribe_status';

void resetUserGlobals() {
  usernameGlobal = "guest";
  userEmailGlobal = "";
  AccountValue = 0;
  SubscribeStatus = "none";
}

void setUsername(
  String username,
  String userEmail,
  int accountValue,
  String subscribeStatus,
) {
  usernameGlobal = username;
  userEmailGlobal = userEmail;
  AccountValue = accountValue;
  SubscribeStatus = subscribeStatus;
}

Future<void> persistUserSession({
  required String username,
  required String userEmail,
  required int accountValue,
  required String subscribeStatus,
}) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_usernameKey, username);
  await prefs.setString(_userEmailKey, userEmail);
  await prefs.setInt(_accountValueKey, accountValue);
  await prefs.setString(_subscribeStatusKey, subscribeStatus);
}

Future<bool> restoreUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  final username = prefs.getString(_usernameKey);
  final userEmail = prefs.getString(_userEmailKey);
  final accountValue = prefs.getInt(_accountValueKey);
  final subscribeStatus = prefs.getString(_subscribeStatusKey) ?? "none";

  if (username != null && userEmail != null && accountValue != null) {
    setUsername(username, userEmail, accountValue, subscribeStatus);
    return true;
  }

  resetUserGlobals();
  return false;
}

Future<void> clearUserSession() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.remove(_usernameKey);
  await prefs.remove(_userEmailKey);
  await prefs.remove(_accountValueKey);
  await prefs.remove(_subscribeStatusKey);
  resetUserGlobals();
}
