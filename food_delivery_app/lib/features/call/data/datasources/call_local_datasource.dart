import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/call_session_model.dart';

abstract class CallLocalDataSource {
  Future<void> saveCallHistory(CallSessionModel callSession);
  Future<List<CallSessionModel>> getCallHistory();
  Future<void> clearCallHistory();
}

class CallLocalDataSourceImpl implements CallLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String callHistoryKey = 'call_history';

  CallLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> saveCallHistory(CallSessionModel callSession) async {
    final history = await getCallHistory();
    history.add(callSession);

    // Keep only last 50 calls
    if (history.length > 50) {
      history.removeRange(0, history.length - 50);
    }

    final jsonList = history.map((call) => call.toJson()).toList();
    await sharedPreferences.setString(
      callHistoryKey,
      jsonEncode(jsonList),
    );
  }

  @override
  Future<List<CallSessionModel>> getCallHistory() async {
    final jsonString = sharedPreferences.getString(callHistoryKey);

    if (jsonString == null || jsonString.isEmpty) {
      return [];
    }

    final jsonList = jsonDecode(jsonString) as List<dynamic>;
    return jsonList
        .map((json) => CallSessionModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<void> clearCallHistory() async {
    await sharedPreferences.remove(callHistoryKey);
  }
}
