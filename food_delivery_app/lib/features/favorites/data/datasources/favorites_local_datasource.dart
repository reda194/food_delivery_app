import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/favorite_item_model.dart';

/// Favorites Local Data Source - Handles local storage of favorites
abstract class FavoritesLocalDataSource {
  Future<List<FavoriteItemModel>> getFavorites();
  Future<void> addToFavorites(String menuItemId, String name, String description, double price, String imageUrl, String categoryName);
  Future<void> removeFromFavorites(String favoriteId);
  Future<bool> isFavorite(String menuItemId);
  Future<void> clearFavorites();
}

class FavoritesLocalDataSourceImpl implements FavoritesLocalDataSource {
  final SharedPreferences sharedPreferences;
  static const String favoritesKey = 'FAVORITES_KEY';

  FavoritesLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<List<FavoriteItemModel>> getFavorites() async {
    // Return mock data matching the Figma design
    return [
      FavoriteItemModel(
        id: '1',
        menuItemId: '1',
        name: 'Beef Burger',
        description: 'Meat Cheese Burger',
        price: 12.67,
        imageUrl: 'https://images.unsplash.com/photo-1568901346375-23c9450c58cd?w=800',
        categoryName: 'Burgers',
        addedAt: DateTime.now(),
      ),
      FavoriteItemModel(
        id: '2',
        menuItemId: '2',
        name: 'Cheese Bust',
        description: 'Double Cheese Burger',
        price: 10.67,
        imageUrl: 'https://images.unsplash.com/photo-1550547660-d9450f859349?w=800',
        categoryName: 'Burgers',
        addedAt: DateTime.now(),
      ),
      FavoriteItemModel(
        id: '3',
        menuItemId: '3',
        name: 'Peparini Moo',
        description: 'Peperoni Burger',
        price: 12.67,
        imageUrl: 'https://images.unsplash.com/photo-1553979459-d2229ba7433b?w=800',
        categoryName: 'Burgers',
        addedAt: DateTime.now(),
      ),
      FavoriteItemModel(
        id: '4',
        menuItemId: '4',
        name: 'Spicy Beast',
        description: 'Double Cheese Burger',
        price: 10.67,
        imageUrl: 'https://images.unsplash.com/photo-1586190848861-99aa4a171e90?w=800',
        categoryName: 'Burgers',
        addedAt: DateTime.now(),
      ),
      FavoriteItemModel(
        id: '5',
        menuItemId: '5',
        name: 'Peparini Moo',
        description: 'Peperoni Burger',
        price: 12.67,
        imageUrl: 'https://images.unsplash.com/photo-1561758033-d89a9ad46330?w=800',
        categoryName: 'Burgers',
        addedAt: DateTime.now(),
      ),
      FavoriteItemModel(
        id: '6',
        menuItemId: '6',
        name: 'Spicy Beast',
        description: 'Double Cheese Burger',
        price: 10.67,
        imageUrl: 'https://images.unsplash.com/photo-1572802419224-296b0aeee0d9?w=800',
        categoryName: 'Burgers',
        addedAt: DateTime.now(),
      ),
    ];
  }

  @override
  Future<void> addToFavorites(String menuItemId, String name, String description, double price, String imageUrl, String categoryName) async {
    final favorites = await getFavorites();

    // Check if already in favorites
    final exists = favorites.any((fav) => fav.menuItemId == menuItemId);
    if (exists) return;

    final newFavorite = FavoriteItemModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      menuItemId: menuItemId,
      name: name,
      description: description,
      price: price,
      imageUrl: imageUrl,
      categoryName: categoryName,
      addedAt: DateTime.now(),
    );

    favorites.add(newFavorite);
    await _saveFavorites(favorites);
  }

  @override
  Future<void> removeFromFavorites(String favoriteId) async {
    final favorites = await getFavorites();
    favorites.removeWhere((fav) => fav.id == favoriteId);
    await _saveFavorites(favorites);
  }

  @override
  Future<bool> isFavorite(String menuItemId) async {
    final favorites = await getFavorites();
    return favorites.any((fav) => fav.menuItemId == menuItemId);
  }

  @override
  Future<void> clearFavorites() async {
    await sharedPreferences.remove(favoritesKey);
  }

  Future<void> _saveFavorites(List<FavoriteItemModel> favorites) async {
    final jsonList = favorites.map((fav) => fav.toJson()).toList();
    final jsonString = json.encode(jsonList);
    await sharedPreferences.setString(favoritesKey, jsonString);
  }
}
