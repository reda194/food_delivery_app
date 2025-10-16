/// Spacing and Dimension System for Food Delivery App
/// Following 8px grid system for consistency
class AppDimensions {
  AppDimensions._();

  // ==================== SPACING SCALE (8px grid) ====================
  static const double space2 = 2.0;
  static const double space4 = 4.0;
  static const double space8 = 8.0;
  static const double space12 = 12.0;
  static const double space16 = 16.0;
  static const double space20 = 20.0;
  static const double space24 = 24.0;
  static const double space32 = 32.0;
  static const double space40 = 40.0;
  static const double space48 = 48.0;
  static const double space56 = 56.0;
  static const double space64 = 64.0;
  static const double space72 = 72.0;
  static const double space80 = 80.0;

  // ==================== SEMANTIC SPACING ====================
  /// Padding for screens/pages
  static const double screenPadding = space16;
  static const double screenPaddingSmall = space12;
  static const double screenPaddingLarge = space24;

  /// Spacing between sections
  static const double sectionSpacing = space24;
  static const double sectionSpacingSmall = space16;
  static const double sectionSpacingLarge = space32;

  /// Card padding
  static const double cardPadding = space16;
  static const double cardPaddingSmall = space12;
  static const double cardPaddingLarge = space20;

  /// List item spacing
  static const double listItemSpacing = space12;
  static const double listItemPadding = space16;

  // ==================== BORDER RADIUS ====================
  static const double radiusXS = 4.0;
  static const double radiusSM = 8.0;
  static const double radiusMD = 12.0;
  static const double radiusLG = 16.0;
  static const double radiusXL = 20.0;
  static const double radius2XL = 24.0;
  static const double radiusFull = 999.0; // Circular

  /// Component-specific radius
  static const double buttonRadius = radiusMD;
  static const double cardRadius = radiusLG;
  static const double chipRadius = radiusFull;
  static const double inputRadius = radiusMD;
  static const double dialogRadius = radiusXL;
  static const double bottomSheetRadius = radiusXL;
  static const double imageRadius = radiusMD;

  // ==================== ICON SIZES ====================
  static const double iconXS = 16.0;
  static const double iconSM = 20.0;
  static const double iconMD = 24.0;
  static const double iconLG = 32.0;
  static const double iconXL = 40.0;
  static const double icon2XL = 48.0;

  /// Component-specific icon sizes
  static const double iconButton = iconMD;
  static const double iconAppBar = iconMD;
  static const double iconBottomNav = iconMD;
  static const double iconCard = iconSM;
  static const double iconInput = iconSM;

  // ==================== BUTTON SIZES ====================
  static const double buttonHeightSmall = 36.0;
  static const double buttonHeightMedium = 48.0;
  static const double buttonHeightLarge = 56.0;

  static const double buttonPaddingHorizontalSmall = space16;
  static const double buttonPaddingHorizontalMedium = space24;
  static const double buttonPaddingHorizontalLarge = space32;

  /// Icon button size
  static const double iconButtonSize = 40.0;
  static const double iconButtonSizeSmall = 32.0;
  static const double iconButtonSizeLarge = 48.0;

  // ==================== INPUT FIELD SIZES ====================
  static const double inputHeight = 56.0;
  static const double inputHeightSmall = 48.0;
  static const double inputHeightLarge = 64.0;

  static const double inputPaddingHorizontal = space16;
  static const double inputPaddingVertical = space16;

  // ==================== CARD SIZES ====================
  /// Restaurant card dimensions
  static const double restaurantCardHeight = 240.0;
  static const double restaurantCardImageHeight = 140.0;

  /// Food item card dimensions
  static const double foodItemCardHeight = 260.0;
  static const double foodItemCardImageHeight = 160.0;
  static const double foodItemCardSmallWidth = 140.0;

  /// Category card dimensions
  static const double categoryCardSize = 80.0;
  static const double categoryCardImageSize = 48.0;

  // ==================== APP BAR ====================
  static const double appBarHeight = 56.0;
  static const double appBarHeightLarge = 64.0;
  static const double appBarElevation = 0.0;

  // ==================== BOTTOM NAV BAR ====================
  static const double bottomNavBarHeight = 64.0;
  static const double bottomNavIconSize = iconMD;

  // ==================== AVATAR SIZES ====================
  static const double avatarXS = 24.0;
  static const double avatarSM = 32.0;
  static const double avatarMD = 40.0;
  static const double avatarLG = 56.0;
  static const double avatarXL = 72.0;
  static const double avatar2XL = 96.0;

  /// Profile avatar
  static const double avatarProfile = avatar2XL;
  static const double avatarRestaurant = avatarLG;
  static const double avatarUserReview = avatarMD;

  // ==================== ELEVATION ====================
  static const double elevationNone = 0.0;
  static const double elevationXS = 1.0;
  static const double elevationSM = 2.0;
  static const double elevationMD = 4.0;
  static const double elevationLG = 8.0;
  static const double elevationXL = 12.0;

  /// Component-specific elevation
  static const double cardElevation = elevationSM;
  static const double buttonElevation = elevationXS;
  static const double dialogElevation = elevationXL;
  static const double bottomSheetElevation = elevationLG;

  // ==================== DIVIDER ====================
  static const double dividerThickness = 1.0;
  static const double dividerIndent = space16;

  // ==================== FOOD DELIVERY SPECIFIC ====================
  /// Rating badge
  static const double ratingBadgeSize = 48.0;
  static const double ratingBadgeIconSize = iconSM;

  /// Delivery badge
  static const double deliveryBadgeHeight = 28.0;

  /// Cart item
  static const double cartItemHeight = 100.0;
  static const double cartItemImageSize = 80.0;

  /// Order tracking
  static const double orderStatusIndicatorSize = 40.0;
  static const double orderTimelineLineWidth = 2.0;

  /// Search bar
  static const double searchBarHeight = 48.0;

  /// Filter chip
  static const double filterChipHeight = 36.0;

  /// Discount badge
  static const double discountBadgeHeight = 24.0;

  /// Quantity selector
  static const double quantitySelectorHeight = 32.0;
  static const double quantitySelectorButtonSize = 28.0;

  // ==================== RESPONSIVE BREAKPOINTS ====================
  static const double mobileMaxWidth = 600;
  static const double tabletMaxWidth = 900;
  static const double desktopMaxWidth = 1200;

  /// Maximum content width for large screens
  static const double maxContentWidth = 1200;

  // ==================== ANIMATIONS ====================
  /// Animation durations (in milliseconds)
  static const int animationDurationFast = 150;
  static const int animationDurationMedium = 300;
  static const int animationDurationSlow = 500;

  /// Splash screen animation
  static const int splashDuration = 2000;

  /// Loading indicator
  static const double loadingIndicatorSize = 40.0;
  static const double loadingIndicatorSizeSmall = 24.0;
  static const double loadingIndicatorSizeLarge = 56.0;

  // ==================== MINIMUM TOUCH TARGET ====================
  /// Minimum touch target size for accessibility (Material Design guideline)
  static const double minTouchTarget = 48.0;
  static const double minTouchTargetSmall = 40.0;

  // ==================== SAFE AREA PADDING ====================
  /// Additional padding for safe areas (notches, status bar)
  static const double safeAreaTopPadding = 44.0; // iOS
  static const double safeAreaBottomPadding = 34.0; // iOS home indicator

  // ==================== IMAGE ASPECT RATIOS ====================
  static const double aspectRatioSquare = 1.0;
  static const double aspectRatioRestaurantCard = 16 / 9;
  static const double aspectRatioFoodItem = 4 / 3;
  static const double aspectRatioBanner = 21 / 9;
}
