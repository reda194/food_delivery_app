import '../../../../core/services/supabase_service.dart';
import '../models/call_session_model.dart';

abstract class CallRemoteDataSource {
  Future<void> logCallSession(CallSessionModel callSession);
  Future<List<CallSessionModel>> getCallHistoryFromServer(String userId);
}

class CallRemoteDataSourceImpl implements CallRemoteDataSource {
  final SupabaseService supabaseService;

  CallRemoteDataSourceImpl({required this.supabaseService});

  @override
  Future<void> logCallSession(CallSessionModel callSession) async {
    try {
      await supabaseService.client
          .from('call_logs')
          .insert(callSession.toJson());
    } catch (e) {
      // Silently fail - call logging is not critical
      // In production, you might want to log this error
    }
  }

  @override
  Future<List<CallSessionModel>> getCallHistoryFromServer(
      String userId) async {
    try {
      final response = await supabaseService.client
          .from('call_logs')
          .select()
          .eq('user_id', userId)
          .order('start_time', ascending: false)
          .limit(50);

      return (response as List)
          .map((json) => CallSessionModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }
}
