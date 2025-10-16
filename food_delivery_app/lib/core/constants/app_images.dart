/// App Images - Centralized image asset constants
class AppImages {
  AppImages._();

  // ==================== BASE PATH ====================
  static const String _basePath = 'assets/images/';

  // ==================== FOOD ITEMS ====================
  static const String burger = '${_basePath}burer.png';
  static const String miniBurger = '${_basePath}Mini Burger.png';
  static const String cake = '${_basePath}Cake.png';
  static const String cup = '${_basePath}Cup.png';
  static const String tomatoSlice = '${_basePath}36158041-stock-vector-a-slice-of-tomato-removebg-preview 1.png';

  // Kindpng food items
  static const String food1 = '${_basePath}kindpng_3352876 1.png';
  static const String food2 = '${_basePath}kindpng_3352876 2.png';
  static const String food3 = '${_basePath}kindpng_3352876 3.png';
  static const String food4 = '${_basePath}kindpng_3352876 4.png';
  static const String food5 = '${_basePath}kindpng_3352876 5.png';
  static const String food6 = '${_basePath}kindpng_3352876 6.png';

  static const String food7 = '${_basePath}kindpng_423366 1.png';
  static const String food8 = '${_basePath}kindpng_423366 2.png';
  static const String food9 = '${_basePath}kindpng_423366 3.png';

  // ==================== PEOPLE ====================
  static const String delivery = '${_basePath}delivery.png';
  static const String person = '${_basePath}person.png';
  static const String profile = '${_basePath}Profile.png';

  // ==================== ICONS ====================
  static const String location = '${_basePath}Location.png';
  static const String homeIcon = '${_basePath}Home.png';
  static const String appartmentIcon = '${_basePath}Appartment.png';
  static const String icon = '${_basePath}Icon.png';
  static const String ellipse = '${_basePath}Ellipse 1567.png';

  // ==================== PAYMENT ====================
  static const String mastercard = '${_basePath}Mastercard.png';
  static const String money = '${_basePath}money.png';
  static const String apple = '${_basePath}Apple.png';

  // ==================== MISC ====================
  static const String genericImage = '${_basePath}Image.png';
  static const String vector = '${_basePath}Vector.png';

  // ==================== PLACEHOLDER ====================
  static const String placeholder = '${_basePath}Image.png';
  static const String restaurantPlaceholder = '${_basePath}Image.png';
  static const String foodPlaceholder = '${_basePath}burer.png';
  static const String profilePlaceholder = '${_basePath}person.png';

  // ==================== HELPER METHODS ====================
  /// Get random food image for demos
  static String getRandomFoodImage(int index) {
    final foods = [
      burger,
      miniBurger,
      cake,
      cup,
      food1,
      food2,
      food3,
      food4,
      food5,
      food6,
    ];
    return foods[index % foods.length];
  }

  /// Get food by category
  static List<String> getFoodByCategory(String category) {
    switch (category.toLowerCase()) {
      case 'burgers':
        return [burger, miniBurger, food1, food2];
      case 'desserts':
        return [cake, food3, food4];
      case 'drinks':
        return [cup, food5];
      default:
        return [burger, cake, cup, food1, food2, food3];
    }
  }
}
