import 'package:equatable/equatable.dart';

/// Review Entity - Core business object representing a user review
class ReviewEntity extends Equatable {
  final String id;
  final String userId;
  final String userName;
  final String userAvatar;
  final double rating;
  final String comment;
  final DateTime createdAt;
  final List<String> images;
  final int helpfulCount;
  final bool isVerifiedPurchase;

  const ReviewEntity({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userAvatar,
    required this.rating,
    required this.comment,
    required this.createdAt,
    this.images = const [],
    this.helpfulCount = 0,
    this.isVerifiedPurchase = false,
  });

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      final years = (difference.inDays / 365).floor();
      return '$years ${years == 1 ? 'year' : 'years'} ago';
    } else if (difference.inDays > 30) {
      final months = (difference.inDays / 30).floor();
      return '$months ${months == 1 ? 'month' : 'months'} ago';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} ${difference.inDays == 1 ? 'day' : 'days'} ago';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ${difference.inHours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} ${difference.inMinutes == 1 ? 'minute' : 'minutes'} ago';
    } else {
      return 'Just now';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        userName,
        userAvatar,
        rating,
        comment,
        createdAt,
        images,
        helpfulCount,
        isVerifiedPurchase,
      ];
}
