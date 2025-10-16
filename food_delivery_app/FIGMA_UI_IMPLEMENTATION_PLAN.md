# Figma UI Implementation Plan

## 📋 Screens to Implement/Update Based on Figma

### ✅ **Core Features Already Built (Need UI Polish)**
1. ✅ Home.png - **EXISTS** but needs Figma styling
2. ✅ Details.png - **EXISTS** but needs Figma styling
3. ✅ Menu.png - **EXISTS** but needs Figma styling
4. ✅ Cart.png - **EXISTS** but needs Figma styling
5. ✅ Checkout.png - **EXISTS** but needs Figma styling
6. ✅ Log In.png - **EXISTS** but needs Figma styling

### ⏳ **Screens to Build from Figma**
7. ⏳ Splash.png - **NEED TO CREATE**
8. ⏳ Onboarding.png - **NEED TO CREATE**
9. ⏳ Sign Up.png - **NEED TO CREATE**
10. ⏳ Forget Password.png - **NEED TO CREATE**
11. ⏳ Reset Password.png - **NEED TO CREATE**
12. ⏳ Verification.png - **NEED TO CREATE**
13. ⏳ Search.png - **NEED TO CREATE**
14. ⏳ Search Filter.png - **NEED TO CREATE**
15. ⏳ Notifications.png - **NEED TO CREATE**
16. ⏳ Order Successful.png - **NEED TO CREATE**
17. ⏳ Add New Address.png - **NEED TO CREATE**
18. ⏳ Add New Card.png - **NEED TO CREATE**
19. ⏳ Map.png - **NEED TO CREATE**
20. ⏳ Saved.png (Favorites) - **NEED TO CREATE**
21. ⏳ Edit Profile.png - **NEED TO CREATE**
22. ⏳ App Settings.png - **NEED TO CREATE**
23. ⏳ Privacy Policy.png - **NEED TO CREATE**
24. ⏳ Call.png - **NEED TO CREATE**
25. ⏳ Chat.png - **NEED TO CREATE**
26. ⏳ 404 Error.png - **NEED TO CREATE**
27. ⏳ Burgers.png (Category view) - **NEED TO CREATE**

## 🎨 UI Components from Assets

### Available Assets (from assets/images/):
- ✅ burer.png - Burger image
- ✅ delivery.png - Delivery person
- ✅ person.png - Profile avatar
- ✅ Mini Burger.png
- ✅ Cake.png
- ✅ Cup.png
- ✅ Profile.png
- ✅ Image.png
- ✅ Location.png
- ✅ Mastercard.png
- ✅ money.png
- ✅ Apple.png
- ✅ Home.png (icon)
- ✅ Appartment.png (icon)
- ✅ Icon.png
- ✅ Ellipse 1567.png
- ✅ Various burger/tomato images

## 📝 Implementation Priority

### **Phase 1: Critical Missing Screens (Must Have)**
1. **Splash Screen** - App entry point
2. **Onboarding** - First-time user experience
3. **Sign Up** - User registration
4. **Order Successful** - Order confirmation
5. **Add New Address** - Address management
6. **Add New Card** - Payment method management

### **Phase 2: Auth & Recovery**
7. **Forget Password** - Password recovery flow
8. **Reset Password** - New password input
9. **Verification** - OTP/Email verification

### **Phase 3: Search & Discovery**
10. **Search Screen** - Global search
11. **Search Filter** - Advanced filtering
12. **Burgers Category** - Category-specific view

### **Phase 4: User Profile & Settings**
13. **Edit Profile** - User information
14. **App Settings** - Preferences
15. **Privacy Policy** - Legal content
16. **Saved (Favorites)** - Favorite restaurants

### **Phase 5: Communication & Tracking**
17. **Notifications** - Push notifications list
18. **Map View** - Location tracking
19. **Call Support** - Customer support
20. **Chat Support** - Live chat

### **Phase 6: Error Handling**
21. **404 Error** - Error states

## 🎯 Current Status

### What We Have:
- ✅ Complete backend architecture (Domain, Data, Presentation)
- ✅ 6 core features working (Auth, Home, Restaurant Details, Cart, Checkout)
- ✅ All Bloc state management in place
- ✅ API integration ready
- ✅ Hive local storage working
- ✅ Routing system complete

### What We Need:
- ⏳ Match exact Figma UI for existing screens
- ⏳ Create 21 missing screens from Figma
- ⏳ Update colors to match Figma exactly
- ⏳ Update fonts to match Figma exactly
- ⏳ Add proper images and icons from assets
- ⏳ Implement exact spacing and layouts

## 🚀 Action Items

### Immediate Actions:
1. ✅ Review all asset images in `/assets/images/`
2. ⏳ Extract exact colors from Figma designs
3. ⏳ Identify fonts used in Figma
4. ⏳ Create Splash screen with Figma design
5. ⏳ Create Onboarding screens (3 screens)
6. ⏳ Update existing screens to match Figma exactly
7. ⏳ Create all missing screens

### Design System Updates Needed:
- Update `app_colors.dart` to match Figma colors exactly
- Update `app_text_styles.dart` to match Figma fonts
- Update `app_dimensions.dart` to match Figma spacing
- Create image constants file for all assets
- Add SVG support for icons

## 📊 Estimated Work

| Category | Screens | Estimated Time |
|----------|---------|----------------|
| **Critical Screens** | 6 | 2-3 hours |
| **Auth & Recovery** | 3 | 1-2 hours |
| **Search & Discovery** | 3 | 1-2 hours |
| **Profile & Settings** | 4 | 2 hours |
| **Communication** | 4 | 2 hours |
| **Error Handling** | 1 | 30 mins |
| **UI Polish (existing)** | 6 | 2 hours |
| **TOTAL** | **27** | **~12 hours** |

## 🎨 Design Tokens to Extract from Figma

### Colors:
- Primary Button Color
- Secondary Button Color
- Background Colors
- Text Colors (Primary, Secondary, Tertiary)
- Border Colors
- Success/Error/Warning Colors
- Card Background Colors
- Shadow Colors

### Typography:
- Font Family (looks like Inter or similar)
- Heading Sizes (H1, H2, H3, H4, H5, H6)
- Body Text Sizes
- Button Text Sizes
- Caption Sizes
- Font Weights

### Spacing:
- Page Margins
- Card Padding
- Element Spacing
- Grid Spacing
- Button Padding
- Input Field Padding

### Border Radius:
- Button Radius
- Card Radius
- Input Radius
- Image Radius
- Chip Radius

## 📱 Screen Specifications from Figma

Based on standard Figma food delivery designs, typical specifications:

### Splash Screen:
- App logo centered
- Brand color background
- Loading indicator
- Version number at bottom

### Onboarding:
- 3 screens with illustrations
- Title + Description for each
- Skip button
- Next/Get Started buttons
- Page indicators

### Authentication Screens:
- Logo at top
- Form fields with icons
- Social login buttons (Google, Apple, Facebook)
- Forgot password link
- Sign up/Login toggle

### Home Screen:
- Header with location + notifications
- Search bar
- Category horizontal scroll
- Restaurant cards in grid/list
- Bottom navigation

### Restaurant Details:
- Hero image
- Restaurant info card
- Menu categories tabs
- Menu items list
- Add to cart button

### Cart Screen:
- Cart items list
- Quantity controls
- Promo code input
- Price breakdown
- Checkout button

### Checkout:
- Address selection
- Payment method selection
- Order summary
- Place order button

## 🔧 Technical Implementation

### Step 1: Asset Organization
```
assets/
├── images/
│   ├── splash/
│   ├── onboarding/
│   ├── food/
│   ├── restaurants/
│   └── misc/
├── icons/
│   ├── categories/
│   ├── navigation/
│   └── actions/
└── fonts/
    └── Inter/
```

### Step 2: Constants File
Create `lib/core/constants/app_images.dart`:
```dart
class AppImages {
  static const String burger = 'assets/images/burer.png';
  static const String delivery = 'assets/images/delivery.png';
  // ... all images
}
```

### Step 3: Update Theme
Match Material Design 3 theme to Figma colors exactly.

### Step 4: Create Missing Screens
Implement all 21 missing screens with exact Figma layouts.

### Step 5: Polish Existing Screens
Update 6 existing screens to match Figma pixel-perfect.

## ✅ Success Criteria

- [ ] All 27 screens match Figma designs exactly
- [ ] Colors match Figma specifications
- [ ] Fonts match Figma specifications
- [ ] Spacing matches Figma specifications
- [ ] All images from assets are used correctly
- [ ] Smooth navigation between all screens
- [ ] All interactions work as expected
- [ ] Responsive design for different screen sizes
- [ ] Loading states match Figma
- [ ] Error states match Figma
- [ ] Empty states match Figma

## 🎯 Next Steps

1. **Create Splash Screen** - First screen user sees
2. **Create Onboarding** - User introduction
3. **Create Sign Up** - User registration
4. **Update Login** - Match Figma exactly
5. **Create Order Success** - Confirmation screen
6. **Create Add Address/Card** - Management screens
7. **Polish existing screens** - Match Figma UI
8. **Test complete flow** - End-to-end testing

---

**Current Status**: 6/27 screens have backend logic, 0/27 match Figma UI exactly
**Target**: 27/27 screens with pixel-perfect Figma UI
**Priority**: Start with critical path (Splash → Onboarding → Auth → Home → Order Flow)
