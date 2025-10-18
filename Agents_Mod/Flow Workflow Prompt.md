
# Ultimate Project Analysis & User Flow Workflow Prompt

```
You are a senior Flutter architect and UX analyst specializing in comprehensive project analysis, user flow mapping, and application integration validation.

**MISSION:**
Analyze my ENTIRE Flutter project by reading ALL files, understand user behavior patterns, map complete user journeys, and create comprehensive workflows that ensure full application integration.

---

## **PHASE 1: PROJECT FILE ANALYSIS**

### **1.1 Grant File Access Request**

I'm giving you access to read ALL files in my Flutter project:

**Project Structure:**
```
/my_flutter_project/
├── lib/
├── assets/
├── test/
├── pubspec.yaml
└── [all other files]
```

**Files to Analyze:**

1. **Core Files:**
   - [ ] main.dart
   - [ ] All route/navigation files
   - [ ] All BLoC/state management files
   - [ ] All repository files
   - [ ] All model files

2. **Feature Files:**
   - [ ] All screen/page files
   - [ ] All widget files
   - [ ] All use case files

3. **Configuration Files:**
   - [ ] pubspec.yaml
   - [ ] Constants files
   - [ ] Config files
   - [ ] Environment files

4. **Asset Files:**
   - [ ] Images inventory
   - [ ] Icons inventory
   - [ ] Fonts list

**READ ALL FILES AND CREATE:**
- Complete file inventory
- Dependency map between files
- Import relationship diagram
- Dead code detection

---

## **PHASE 2: USER BEHAVIOR ANALYSIS**

### **2.1 User Personas Identification**

Based on code analysis, identify:

```
User Persona 1: [Name]
- Entry Point: [Which screen]
- Primary Goals: [What they want to achieve]
- Available Actions: [List all possible actions]
- Expected Paths: [Common navigation flows]
- Edge Cases: [Unusual scenarios]

User Persona 2: [Name]
- [Same structure]

[Continue for all user types]
```

### **2.2 User Action Mapping**

For EACH screen, map:

```
Screen: [ScreenName]

Available User Actions:
1. [Action] → Triggers: [Event/Function] → Navigates to: [Destination]
2. [Action] → Triggers: [Event/Function] → Updates state: [State change]
3. [Action] → Triggers: [Event/Function] → API call: [Endpoint]
...

User Inputs:
- TextFields: [Count and validation rules]
- Buttons: [Count and actions]
- Gestures: [Tap, swipe, long-press locations]
- Toggles/Switches: [State changes]

Exit Points:
- Navigation to: [List of possible destinations]
- Pop/Back: [Where user returns]
- Deep links: [External triggers]
```

---

## **PHASE 3: COMPLETE USER FLOW MAPPING**

### **3.1 Primary User Journeys**

Create detailed flow for each user goal:

```
USER JOURNEY 1: [e.g., "New User Registration"]

Step-by-Step Flow:
1. Entry Point: [Screen/Action]
   ├─ User sees: [UI elements]
   ├─ User can: [Available actions]
   └─ Data collected: [Input fields]

2. Validation Phase:
   ├─ Client-side validation: [Rules]
   ├─ Error handling: [Error screens/messages]
   └─ Success path: [Next screen]

3. API Interaction:
   ├─ Endpoint called: [API]
   ├─ Loading state: [UI shown]
   ├─ Success response: [Next action]
   └─ Error response: [Fallback]

4. Navigation Path:
   ├─ On success: [Destination screen]
   ├─ On failure: [Stay/Redirect]
   └─ Alternative paths: [Other options]

5. State Changes:
   ├─ BLoC events triggered: [List]
   ├─ State updated: [What changes]
   └─ UI reflects: [Visual changes]

[Continue until journey completes]

ALTERNATIVE PATHS:
- Path A: [If user does X]
- Path B: [If user does Y]
- Path C: [If error occurs]

EDGE CASES:
- Network failure: [Behavior]
- Session timeout: [Behavior]
- Invalid data: [Behavior]
- Back button pressed: [Behavior]
```

### **3.2 Navigation Workflow Diagram**

Create text-based flowchart:

```
[Splash Screen]
    ↓
[Check Authentication]
    ├─ Authenticated → [Home Screen]
    │                      ├─ Tab 1 → [Screen A] → [Screen A1]
    │                      │                     └─ [Screen A2]
    │                      ├─ Tab 2 → [Screen B] → [Screen B1]
    │                      ├─ Tab 3 → [Screen C]
    │                      └─ Profile → [Profile Screen]
    │                                      ├─ Edit → [Edit Profile]
    │                                      ├─ Settings → [Settings]
    │                                      └─ Logout → [Login]
    │
    └─ Not Authenticated → [Onboarding]
                               ├─ Skip → [Login]
                               └─ Continue → [Onboarding 2]
                                                └─ [Onboarding 3]
                                                    └─ [Register/Login]

[For EVERY screen in the app]
```

---

## **PHASE 4: INTEGRATION ANALYSIS**

### **4.1 Component Integration Check**

Verify integration between:

```
1. SCREEN ↔ BLoC INTEGRATION
   Screen: [Name]
   ├─ BLoC used: [BlocName]
   ├─ Events triggered: [List]
   ├─ States listened: [List]
   ├─ Integration status: ✅ Complete / ⚠️ Incomplete / ❌ Missing
   └─ Issues found: [List if any]

2. BLoC ↔ REPOSITORY INTEGRATION
   BLoC: [Name]
   ├─ Repositories used: [List]
   ├─ Use cases called: [List]
   ├─ Data flow: [Describe]
   └─ Integration status: [Status]

3. REPOSITORY ↔ API INTEGRATION
   Repository: [Name]
   ├─ Endpoints called: [List]
   ├─ Models used: [List]
   ├─ Error handling: [Present/Missing]
   └─ Integration status: [Status]

4. NAVIGATION INTEGRATION
   ├─ All routes defined: [Yes/No]
   ├─ Deep linking: [Configured/Missing]
   ├─ Route guards: [Present/Missing]
   └─ Back navigation: [Handled/Issues]

5. STATE PERSISTENCE
   ├─ Local storage: [Implementation]
   ├─ State restoration: [Yes/No]
   ├─ Session management: [Status]
   └─ Cache strategy: [Describe]
```

### **4.2 Data Flow Analysis**

```
COMPLETE DATA JOURNEY:

Example: User Login Flow

UI Layer:
  LoginScreen (TextFields for email/password)
    ↓ User taps "Login"
  
Presentation Layer:
  LoginBloc receives: LoginButtonPressed event
  ├─ Validates input
  ├─ Emits: LoginLoading state
    ↓
  
Domain Layer:
  LoginUseCase.execute(email, password)
  ├─ Calls: AuthRepository.login()
    ↓
  
Data Layer:
  AuthRepositoryImpl
  ├─ Calls: RemoteDataSource.login()
  ├─ API Request: POST /auth/login
  ├─ Receives: UserModel
  ├─ Saves token: LocalDataSource.saveToken()
  └─ Returns: User entity
    ↓ Back up the chain
  
Presentation Layer:
  LoginBloc receives: User entity
  ├─ Emits: LoginSuccess(user)
    ↓
  
UI Layer:
  LoginScreen listens to LoginSuccess
  ├─ Navigates to: HomeScreen
  └─ Displays: Success message

[Create this for EVERY major feature]
```

---

## **PHASE 5: USER PATH SCENARIOS**

### **5.1 Happy Path Scenarios**

```
SCENARIO 1: Complete Registration to First Purchase

User Actions Sequence:
1. Opens app → Sees splash → Auto-navigates to onboarding
2. Swipes through onboarding (3 screens)
3. Taps "Get Started" → Navigates to registration
4. Fills form (name, email, password)
5. Taps "Sign Up" → API call → Success
6. Receives verification email
7. Verifies email → Navigates to home
8. Browses products → Taps product → Sees details
9. Adds to cart → Navigates to cart
10. Proceeds to checkout → Fills shipping info
11. Selects payment method → Completes payment
12. Sees success screen → Returns to home

Files Involved:
- splash_screen.dart
- onboarding_bloc.dart
- registration_screen.dart
- auth_repository.dart
- home_screen.dart
- product_details_screen.dart
- cart_bloc.dart
- checkout_screen.dart
- payment_bloc.dart

State Changes:
- AppState: unauthenticated → authenticated
- CartState: empty → hasItems
- OrderState: pending → completed

Integration Points Tested:
✅ Navigation flow complete
✅ State management working
✅ API calls successful
✅ Data persistence working
✅ UI updates correctly
```

### **5.2 Alternative Path Scenarios**

```
SCENARIO 2A: Registration with Validation Errors

[Same format, different path]

SCENARIO 2B: User Abandons Cart

[Same format, different path]

SCENARIO 2C: Network Error During Checkout

[Same format, different path]

[Create 10-15 scenarios covering all features]
```

---

## **PHASE 6: INTEGRATION VALIDATION**

### **6.1 Missing Integration Detection**

```
DETECTED ISSUES:

CRITICAL ISSUES:
❌ Issue 1: [Screen X] navigates to [Screen Y] but route not defined
   Location: [File:Line]
   Fix: Add route in app_router.dart

❌ Issue 2: [BLoC X] calls [Repository Y] but repository not injected
   Location: [File:Line]
   Fix: Add to dependency injection

WARNING ISSUES:
⚠️ Issue 3: [Screen X] doesn't handle error state from [BLoC Y]
   Location: [File:Line]
   Recommendation: Add error handling UI

⚠️ Issue 4: Back button on [Screen X] doesn't pop to expected screen
   Location: [File:Line]
   Recommendation: Use Navigator.pop with result

OPTIMIZATION OPPORTUNITIES:
💡 Opportunity 1: [Screen X] and [Screen Y] have duplicate code
   Suggestion: Create shared widget

💡 Opportunity 2: Multiple screens call same API without caching
   Suggestion: Implement caching layer
```

### **6.2 Test Coverage Recommendations**

```
REQUIRED INTEGRATION TESTS:

Test Suite 1: Authentication Flow
- [ ] Test: New user registration → Verification → Login
- [ ] Test: Existing user login → Navigate to home
- [ ] Test: Login with invalid credentials → Show error
- [ ] Test: Password reset flow → Email → New password → Login
- [ ] Files to test: [List]

Test Suite 2: Main User Journey
- [ ] Test: Browse → Select → Cart → Checkout → Payment
- [ ] Test: Browse → Select → Add to wishlist → View wishlist
- [ ] Test: Search → Filter → Select → Details
- [ ] Files to test: [List]

Test Suite 3: State Persistence
- [ ] Test: Add to cart → Kill app → Reopen → Cart retained
- [ ] Test: Logout → Login → Previous state restored
- [ ] Files to test: [List]

[Create comprehensive test plan]
```

---

## **PHASE 7: WORKFLOW DOCUMENTATION**

### **7.1 Complete User Flow Documentation**

```
USER FLOW DOCUMENTATION

1. ONBOARDING FLOW
   Entry: App launch (first time)
   Exit: Registration/Login screen
   Duration: ~30 seconds
   Screens: 3
   User actions: Swipe, Skip, Get Started
   Files: [List all files involved]
   Integration: [List all integrations]

2. AUTHENTICATION FLOW
   [Same structure]

3. MAIN APP FLOW
   [Same structure]

[For every major flow]
```

### **7.2 Developer Handoff Document**

```
DEVELOPER GUIDE: User Flow Implementation

Feature: [Name]

How User Flow Works:
1. User starts at: [Screen]
2. User interaction triggers: [Event]
3. BLoC processes: [Logic]
4. Repository calls: [API/DB]
5. State updates: [Changes]
6. UI reflects: [New screen/data]

Code Locations:
- UI: lib/features/[feature]/presentation/pages/
- BLoC: lib/features/[feature]/presentation/bloc/
- Repository: lib/features/[feature]/data/repositories/
- Models: lib/features/[feature]/data/models/

To Add New Step in Flow:
1. Add event in: [file]
2. Handle in BLoC: [file]
3. Update UI: [file]
4. Add route: [file]
5. Update tests: [file]
```

---

## **DELIVERABLES**

Provide comprehensive documentation:

1. ✅ **Complete File Inventory** (all files with purpose)
2. ✅ **User Persona Profiles** (3-5 personas)
3. ✅ **User Flow Diagrams** (text-based flowcharts)
4. ✅ **Navigation Map** (all possible paths)
5. ✅ **Integration Status Report** (what's connected, what's missing)
6. ✅ **Data Flow Documentation** (end-to-end)
7. ✅ **User Scenarios** (10-15 detailed scenarios)
8. ✅ **Issue Detection Report** (bugs, missing integrations)
9. ✅ **Test Plan** (integration tests needed)
10. ✅ **Developer Handoff Document** (how to modify flows)
11. ✅ **Mermaid Diagrams Code** (for visual flowcharts)
12. ✅ **API Endpoint Map** (all API calls per screen)
13. ✅ **State Management Overview** (all state changes)
14. ✅ **Performance Bottlenecks** (if any detected)
15. ✅ **Security Considerations** (per user flow)

---

## **ANALYSIS DEPTH REQUIREMENTS**

**For Each Screen:**
- All user actions available
- All navigation paths from this screen
- All state changes triggered
- All API calls made
- All error scenarios
- All data displayed
- All input validations

**For Each User Flow:**
- Step-by-step user journey
- Alternative paths
- Error handling paths
- Data flow diagram
- Integration points
- Testing scenarios

**For Integration:**
- Screen ↔ BLoC connections
- BLoC ↔ Repository connections
- Repository ↔ API connections
- State ↔ UI synchronization
- Navigation ↔ State management
- Dependency injection setup

---

## **START ANALYSIS**

I'm providing access to my project files:

**Project Location:** [Path or zip file]

**Project Type:** 
- [ ] E-commerce app
- [ ] Social media app
- [ ] Finance app
- [ ] Other: [Specify]

**Priority User Flows:**
1. [Most important user journey]
2. [Second most important]
3. [Third most important]

**Known Issues:** [List any current problems]

**Analysis Focus:** 
- [ ] Complete workflow mapping
- [ ] Integration validation
- [ ] User experience optimization
- [ ] Performance analysis
- [ ] All of the above

**BEGIN COMPREHENSIVE ANALYSIS NOW**
```

---

## **Quick Version for Immediate Analysis:**

```
Analyze my entire Flutter project:

READ ALL FILES in my project and:

1. Map every possible user path from app start to completion
2. Create flowcharts for all user journeys
3. Identify all integration points between components
4. Detect missing connections or broken flows
5. Document complete workflows
6. Suggest integration tests needed

Project files: [Attach or provide path]

Deliver:
- Complete navigation map
- User flow documentation
- Integration status report
- Test scenarios
- Issue detection
```
