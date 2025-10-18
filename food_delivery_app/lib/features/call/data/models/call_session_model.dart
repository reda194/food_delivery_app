import '../../domain/entities/call_session_entity.dart';

class CallSessionModel extends CallSessionEntity {
  const CallSessionModel({
    required super.id,
    required super.orderId,
    required super.driverName,
    required super.driverPhoneNumber,
    required super.driverImageUrl,
    required super.callType,
    required super.startTime,
    super.endTime,
    super.duration,
  });

  factory CallSessionModel.fromJson(Map<String, dynamic> json) {
    return CallSessionModel(
      id: json['id'] as String,
      orderId: json['order_id'] as String,
      driverName: json['driver_name'] as String,
      driverPhoneNumber: json['driver_phone_number'] as String,
      driverImageUrl: json['driver_image_url'] as String? ?? '',
      callType: CallType.values.firstWhere(
        (e) => e.toString() == 'CallType.${json['call_type']}',
        orElse: () => CallType.voice,
      ),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: json['end_time'] != null
          ? DateTime.parse(json['end_time'] as String)
          : null,
      duration: json['duration'] != null
          ? Duration(seconds: json['duration'] as int)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_id': orderId,
      'driver_name': driverName,
      'driver_phone_number': driverPhoneNumber,
      'driver_image_url': driverImageUrl,
      'call_type': callType.toString().split('.').last,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'duration': duration?.inSeconds,
    };
  }

  CallSessionModel copyWith({
    String? id,
    String? orderId,
    String? driverName,
    String? driverPhoneNumber,
    String? driverImageUrl,
    CallType? callType,
    DateTime? startTime,
    DateTime? endTime,
    Duration? duration,
  }) {
    return CallSessionModel(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      driverName: driverName ?? this.driverName,
      driverPhoneNumber: driverPhoneNumber ?? this.driverPhoneNumber,
      driverImageUrl: driverImageUrl ?? this.driverImageUrl,
      callType: callType ?? this.callType,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      duration: duration ?? this.duration,
    );
  }
}
