import 'package:equatable/equatable.dart';
import 'menu_item_entity.dart';
import 'review_entity.dart';

/// Restaurant Details Entity - Extended restaurant information
class RestaurantDetailsEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final double rating;
  final int reviewCount;
  final int deliveryTime;
  final double deliveryFee;
  final double minimumOrder;
  final List<String> cuisines;
  final String imageUrl;
  final List<String> images;
  final bool isFeatured;
  final bool isOpen;
  final String phoneNumber;
  final String address;
  final double latitude;
  final double longitude;

  // Opening Hours
  final Map<String, OpeningHours> openingHours;

  // Menu Categories
  final List<MenuCategory> menuCategories;

  // Popular Items
  final List<MenuItemEntity> popularItems;

  // Recent Reviews
  final List<ReviewEntity> recentReviews;

  // Additional Info
  final bool acceptsCash;
  final bool acceptsCards;
  final bool hasDelivery;
  final bool hasPickup;
  final List<String> tags;

  const RestaurantDetailsEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.deliveryFee,
    required this.minimumOrder,
    required this.cuisines,
    required this.imageUrl,
    this.images = const [],
    this.isFeatured = false,
    this.isOpen = true,
    required this.phoneNumber,
    required this.address,
    required this.latitude,
    required this.longitude,
    this.openingHours = const {},
    this.menuCategories = const [],
    this.popularItems = const [],
    this.recentReviews = const [],
    this.acceptsCash = true,
    this.acceptsCards = true,
    this.hasDelivery = true,
    this.hasPickup = false,
    this.tags = const [],
  });

  String get openingStatus {
    if (!isOpen) return 'Closed';

    final now = DateTime.now();
    final dayName = _getDayName(now.weekday);
    final todayHours = openingHours[dayName];

    if (todayHours == null || !todayHours.isOpen) {
      return 'Closed today';
    }

    return 'Open until ${todayHours.closeTime}';
  }

  String _getDayName(int weekday) {
    switch (weekday) {
      case 1: return 'Monday';
      case 2: return 'Tuesday';
      case 3: return 'Wednesday';
      case 4: return 'Thursday';
      case 5: return 'Friday';
      case 6: return 'Saturday';
      case 7: return 'Sunday';
      default: return 'Monday';
    }
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        rating,
        reviewCount,
        deliveryTime,
        deliveryFee,
        minimumOrder,
        cuisines,
        imageUrl,
        images,
        isFeatured,
        isOpen,
        phoneNumber,
        address,
        latitude,
        longitude,
        openingHours,
        menuCategories,
        popularItems,
        recentReviews,
        acceptsCash,
        acceptsCards,
        hasDelivery,
        hasPickup,
        tags,
      ];
}

/// Opening Hours Value Object
class OpeningHours extends Equatable {
  final bool isOpen;
  final String openTime;
  final String closeTime;

  const OpeningHours({
    required this.isOpen,
    required this.openTime,
    required this.closeTime,
  });

  @override
  List<Object?> get props => [isOpen, openTime, closeTime];
}

/// Menu Category Value Object
class MenuCategory extends Equatable {
  final String id;
  final String name;
  final int itemCount;

  const MenuCategory({
    required this.id,
    required this.name,
    required this.itemCount,
  });

  @override
  List<Object?> get props => [id, name, itemCount];
}
