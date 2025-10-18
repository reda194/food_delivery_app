# Figma Design Extraction Checklist
## Food Delivery App UI Kit

**Figma URL:** https://www.figma.com/design/Wfb3Udja4xew8kp0kfw741/Food-Delivery-App-UI-KIT?node-id=0-1&m=dev

---

## Phase 1: Setup & Access

### Prerequisites
- [ ] Figma account created
- [ ] Access to Figma file confirmed (view or edit permissions)
- [ ] Figma Personal Access Token generated (for API access)
- [ ] Dev Mode enabled in Figma
- [ ] Figma desktop app installed (optional, but recommended)
- [ ] Design system folder structure created locally

### File Inspection
- [ ] Open Figma file in browser
- [ ] Identify all pages in the file
- [ ] Count total number of frames/screens
- [ ] Note organization structure (pages, sections, components)
- [ ] Check for component library/design system page
- [ ] Identify if components use variants
- [ ] Check for style definitions (colors, text styles)

---

## Phase 2: Design Tokens Extraction

### 2.1 Colors

**File:** `tokens/colors.json`

- [ ] **Primary Colors**
  - [ ] Primary 50 (lightest shade)
  - [ ] Primary 100
  - [ ] Primary 200
  - [ ] Primary 300
  - [ ] Primary 400
  - [ ] Primary 500 (main brand color)
  - [ ] Primary 600
  - [ ] Primary 700
  - [ ] Primary 800
  - [ ] Primary 900 (darkest shade)

- [ ] **Secondary Colors**
  - [ ] Secondary 50-900 (same as primary)

- [ ] **Accent Colors**
  - [ ] Accent 50-900 (if applicable)

- [ ] **Neutral/Gray Colors**
  - [ ] White (#FFFFFF)
  - [ ] Gray 50 (lightest)
  - [ ] Gray 100
  - [ ] Gray 200
  - [ ] Gray 300
  - [ ] Gray 400
  - [ ] Gray 500
  - [ ] Gray 600
  - [ ] Gray 700
  - [ ] Gray 800
  - [ ] Gray 900 (darkest)
  - [ ] Black (#000000 or near-black)

- [ ] **Semantic Colors**
  - [ ] Success (light, default, dark, text)
  - [ ] Warning (light, default, dark, text)
  - [ ] Error (light, default, dark, text)
  - [ ] Info (light, default, dark, text)

- [ ] **Background Colors**
  - [ ] Background primary
  - [ ] Background secondary
  - [ ] Background tertiary
  - [ ] Surface
  - [ ] Card
  - [ ] Overlay
  - [ ] Modal backdrop

- [ ] **Text Colors**
  - [ ] Text primary
  - [ ] Text secondary
  - [ ] Text tertiary
  - [ ] Text disabled
  - [ ] Text inverse (on dark backgrounds)
  - [ ] Text link
  - [ ] Text placeholder

- [ ] **Border Colors**
  - [ ] Border default
  - [ ] Border light
  - [ ] Border dark
  - [ ] Border focus
  - [ ] Border error
  - [ ] Border success
  - [ ] Border warning

- [ ] **Special Colors**
  - [ ] Food category colors (if different per category)
  - [ ] Gradient colors
  - [ ] Shadow colors

**Extraction Method:**
1. Select any element in Figma
2. In Dev Mode, click on color value
3. Copy hex code
4. Paste into colors.json
5. Repeat for all unique colors

---

### 2.2 Typography

**File:** `tokens/typography.json`

- [ ] **Font Families**
  - [ ] Primary font family name
  - [ ] Secondary font family (if used)
  - [ ] Monospace font (if used)
  - [ ] Google Fonts or custom fonts URL
  - [ ] Font weights available
  - [ ] License information

- [ ] **Font Sizes**
  - [ ] Extra small (caption, helper text)
  - [ ] Small (body small, labels)
  - [ ] Base/Medium (body text)
  - [ ] Large (subheadings)
  - [ ] Extra large (headings)
  - [ ] 2XL, 3XL, 4XL, 5XL, 6XL (hero text)

- [ ] **Text Styles - Display**
  - [ ] Display large (font, size, weight, line-height, spacing)
  - [ ] Display medium
  - [ ] Display small

- [ ] **Text Styles - Headings**
  - [ ] H1 (font, size, weight, line-height, spacing)
  - [ ] H2
  - [ ] H3
  - [ ] H4
  - [ ] H5
  - [ ] H6

- [ ] **Text Styles - Body**
  - [ ] Body large
  - [ ] Body medium
  - [ ] Body small

- [ ] **Text Styles - Labels**
  - [ ] Label large
  - [ ] Label medium
  - [ ] Label small

- [ ] **Text Styles - Buttons**
  - [ ] Button large
  - [ ] Button medium
  - [ ] Button small

- [ ] **Text Styles - Utility**
  - [ ] Caption
  - [ ] Overline
  - [ ] Tooltip

- [ ] **Line Heights**
  - [ ] For each text style
  - [ ] Document ratio (e.g., 1.5 = 150%)

- [ ] **Letter Spacing**
  - [ ] For headings (often negative)
  - [ ] For body text (usually 0)
  - [ ] For buttons/labels

**Extraction Method:**
1. Select text element in Figma
2. In Dev Mode or right panel, note:
   - Font family
   - Font size (px)
   - Font weight (number)
   - Line height (px or %)
   - Letter spacing (px or em)
3. Record in typography.json

---

### 2.3 Spacing

**File:** `tokens/spacing.json`

- [ ] **Identify Base Unit**
  - [ ] 4px or 8px system
  - [ ] Document decision

- [ ] **Spacing Scale**
  - [ ] 0 (0px)
  - [ ] 1 (4px)
  - [ ] 2 (8px)
  - [ ] 3 (12px)
  - [ ] 4 (16px)
  - [ ] 5 (20px)
  - [ ] 6 (24px)
  - [ ] 8 (32px)
  - [ ] 10 (40px)
  - [ ] 12 (48px)
  - [ ] 16 (64px)
  - [ ] 20 (80px)
  - [ ] 24 (96px)
  - [ ] 32 (128px)

- [ ] **Component Spacing**
  - [ ] Button padding (X and Y for each size)
  - [ ] Input padding
  - [ ] Card padding
  - [ ] Modal padding
  - [ ] List item gaps

- [ ] **Layout Spacing**
  - [ ] Container padding (mobile, tablet, desktop)
  - [ ] Section gaps
  - [ ] Grid gaps
  - [ ] Column gutters

**Extraction Method:**
1. Select element in Figma
2. In Dev Mode, check Auto Layout properties
3. Note padding values (top, right, bottom, left)
4. Note gap between items
5. Record consistent values in spacing.json

---

### 2.4 Shadows

**File:** `tokens/shadows.json`

- [ ] **Elevation Levels**
  - [ ] Level 0 (none)
  - [ ] Level 1 (subtle - cards at rest)
  - [ ] Level 2 (medium - cards on hover)
  - [ ] Level 3 (high - dropdowns, menus)
  - [ ] Level 4 (highest - modals, dialogs)

- [ ] **For Each Shadow:**
  - [ ] X offset (px)
  - [ ] Y offset (px)
  - [ ] Blur radius (px)
  - [ ] Spread radius (px)
  - [ ] Color (hex + opacity)
  - [ ] CSS value (complete)

- [ ] **Component-Specific Shadows**
  - [ ] Card shadow (default, hover, active)
  - [ ] Button shadow
  - [ ] Dropdown shadow
  - [ ] Modal shadow
  - [ ] Floating action button shadow

- [ ] **Inner Shadows**
  - [ ] If used (inputs, pressed states)

**Extraction Method:**
1. Select element with shadow in Figma
2. In Dev Mode or Effects panel, note:
   - Type (Drop Shadow or Inner Shadow)
   - X, Y offsets
   - Blur
   - Spread
   - Color and opacity
3. Convert to CSS format: `X Y blur spread rgba(r,g,b,a)`
4. Record in shadows.json

---

### 2.5 Borders

**File:** `tokens/borders.json`

- [ ] **Border Radius**
  - [ ] None (0)
  - [ ] XS (2-4px)
  - [ ] SM (4-8px)
  - [ ] MD (8-12px)
  - [ ] LG (12-16px)
  - [ ] XL (16-24px)
  - [ ] 2XL (24-32px)
  - [ ] Full (9999px or 50%)

- [ ] **Component Border Radius**
  - [ ] Button radius (sm, md, lg)
  - [ ] Input radius
  - [ ] Card radius
  - [ ] Image radius
  - [ ] Modal radius
  - [ ] Chip/badge radius

- [ ] **Border Width**
  - [ ] Default (1px)
  - [ ] Medium (2px)
  - [ ] Thick (4px)

- [ ] **Border Styles**
  - [ ] Solid (most common)
  - [ ] Dashed (if used)
  - [ ] Dotted (if used)

**Extraction Method:**
1. Select element in Figma
2. In Dev Mode or right panel, check Corner Radius
3. Check Stroke (border) width and style
4. Record in borders.json

---

## Phase 3: Screen Documentation

**Folder:** `screens/`

For EACH screen in the Figma file, create a markdown file using the template.

### Expected Screens (Check off as documented):

#### Authentication Flow
- [ ] Splash screen (`splash-screen.md`)
- [ ] Onboarding slide 1 (`onboarding-1.md`)
- [ ] Onboarding slide 2 (`onboarding-2.md`)
- [ ] Onboarding slide 3 (`onboarding-3.md`)
- [ ] Login (`login.md`)
- [ ] Sign up (`signup.md`)
- [ ] Forgot password (`forgot-password.md`)
- [ ] OTP verification (`otp-verification.md`)
- [ ] Reset password (`reset-password.md`)

#### Main App - Home Tab
- [ ] Home/Dashboard (`home.md`)
- [ ] Restaurant listing (`restaurant-listing.md`)
- [ ] Restaurant detail (`restaurant-detail.md`)
- [ ] Food item detail (`food-item-detail.md`)
- [ ] Category listing (`category-listing.md`)

#### Main App - Search Tab
- [ ] Search screen (`search.md`)
- [ ] Search results (`search-results.md`)

#### Main App - Cart & Checkout
- [ ] Cart screen (`cart.md`)
- [ ] Checkout screen (`checkout.md`)
- [ ] Add address (`add-address.md`)
- [ ] Select address (`select-address.md`)
- [ ] Add payment method (`add-payment.md`)
- [ ] Select payment method (`select-payment.md`)
- [ ] Order success (`order-success.md`)

#### Main App - Order Tracking
- [ ] Order tracking (`order-tracking.md`)
- [ ] Order history (`order-history.md`)
- [ ] Order detail (`order-detail.md`)
- [ ] Rate order (`rate-order.md`)

#### Main App - Profile Tab
- [ ] Profile screen (`profile.md`)
- [ ] Edit profile (`edit-profile.md`)
- [ ] Saved addresses (`saved-addresses.md`)
- [ ] Payment methods (`payment-methods.md`)
- [ ] Favorites (`favorites.md`)
- [ ] Notifications screen (`notifications.md`)
- [ ] Settings (`settings.md`)
- [ ] Help & Support (`help-support.md`)
- [ ] FAQs (`faqs.md`)

#### Additional Screens
- [ ] (Add any additional screens found)
- [ ] (Add any additional screens found)
- [ ] (Add any additional screens found)

### For Each Screen Document:
- [ ] Screen name and purpose
- [ ] Layout structure (header, content, footer)
- [ ] Dimensions (width, height)
- [ ] Components used
- [ ] Colors used (reference token names)
- [ ] Typography used (reference token names)
- [ ] Spacing values
- [ ] Interactive elements
- [ ] States (loading, empty, error)
- [ ] Animations/transitions
- [ ] Assets required (images, icons)
- [ ] Figma frame ID and link

---

## Phase 4: Component Documentation

**Folder:** `components/`

For EACH unique component, create a markdown file using the template.

### Core Components (Check off as documented):

#### Input Components
- [ ] Button (`button.md`)
  - [ ] All variants (primary, secondary, outlined, text)
  - [ ] All sizes (sm, md, lg)
  - [ ] All states (default, hover, active, disabled, loading)
- [ ] Text Input (`text-input.md`)
- [ ] Email Input (`email-input.md`)
- [ ] Password Input (`password-input.md`)
- [ ] Search Input (`search-input.md`)
- [ ] Textarea (`textarea.md`)
- [ ] Checkbox (`checkbox.md`)
- [ ] Radio Button (`radio-button.md`)
- [ ] Toggle/Switch (`toggle.md`)
- [ ] Dropdown/Select (`dropdown.md`)
- [ ] Date Picker (`date-picker.md`)
- [ ] Time Picker (`time-picker.md`)
- [ ] Slider (`slider.md`)

#### Display Components
- [ ] Card (`card.md`)
- [ ] Restaurant Card (`restaurant-card.md`)
- [ ] Food Card (`food-card.md`)
- [ ] Order Card (`order-card.md`)
- [ ] Avatar (`avatar.md`)
- [ ] Badge (`badge.md`)
- [ ] Chip (`chip.md`)
- [ ] Tag (`tag.md`)
- [ ] Divider (`divider.md`)
- [ ] Image (`image.md`)
- [ ] Icon (`icon.md`)
- [ ] Logo (`logo.md`)

#### Navigation Components
- [ ] App Bar/Header (`app-bar.md`)
- [ ] Bottom Navigation (`bottom-navigation.md`)
- [ ] Tab Bar (`tab-bar.md`)
- [ ] Breadcrumbs (`breadcrumbs.md`)
- [ ] Drawer/Side Menu (`drawer.md`)
- [ ] Link (`link.md`)

#### Feedback Components
- [ ] Alert (`alert.md`)
- [ ] Toast/Snackbar (`toast.md`)
- [ ] Dialog/Modal (`dialog.md`)
- [ ] Bottom Sheet (`bottom-sheet.md`)
- [ ] Tooltip (`tooltip.md`)
- [ ] Progress Bar (`progress-bar.md`)
- [ ] Spinner/Loader (`spinner.md`)
- [ ] Skeleton Loader (`skeleton.md`)

#### List Components
- [ ] List (`list.md`)
- [ ] List Item (`list-item.md`)
- [ ] Restaurant List Item (`restaurant-list-item.md`)
- [ ] Food List Item (`food-list-item.md`)
- [ ] Order List Item (`order-list-item.md`)

#### Layout Components
- [ ] Container (`container.md`)
- [ ] Grid (`grid.md`)
- [ ] Stack (`stack.md`)
- [ ] Spacer (`spacer.md`)

#### Specialized Components
- [ ] Rating Stars (`rating.md`)
- [ ] Review Card (`review-card.md`)
- [ ] Quantity Stepper (`quantity-stepper.md`)
- [ ] Price Display (`price.md`)
- [ ] Countdown Timer (`timer.md`)
- [ ] Map View (`map.md`)
- [ ] Filter Panel (`filter-panel.md`)
- [ ] Sort Options (`sort-options.md`)
- [ ] Promo Code Input (`promo-code.md`)
- [ ] Empty State (`empty-state.md`)
- [ ] Error State (`error-state.md`)

#### Additional Components Found
- [ ] (Add any unique components found)
- [ ] (Add any unique components found)
- [ ] (Add any unique components found)

### For Each Component Document:
- [ ] Component name and type
- [ ] All variants
- [ ] All sizes
- [ ] All states (default, hover, active, focus, disabled, loading)
- [ ] Visual specifications (dimensions, colors, typography, spacing)
- [ ] Props/parameters
- [ ] Usage examples
- [ ] Interactions and animations
- [ ] Accessibility requirements
- [ ] Related components
- [ ] Figma component ID and link

---

## Phase 5: Asset Extraction

**Folder:** `assets/`

### Icons
- [ ] Export all unique icons as SVG
- [ ] Name files descriptively (kebab-case)
- [ ] Organize by category (navigation, food, actions, etc.)
- [ ] Document in `icon-inventory.md`
- [ ] Optimize SVGs (remove unnecessary attributes)
- [ ] Ensure icons use currentColor for fills/strokes

### Images
- [ ] Identify all images used in design
- [ ] Export at appropriate resolutions (1x, 2x, 3x for mobile)
- [ ] Choose correct format:
  - [ ] JPG for photos
  - [ ] PNG for images with transparency
  - [ ] WebP for modern browsers (smaller file size)
- [ ] Optimize images (compress without quality loss)
- [ ] Document dimensions and usage

### Illustrations
- [ ] Export illustrations as SVG (if possible)
- [ ] Alternative: PNG with transparency
- [ ] Document usage (onboarding, empty states, etc.)

### Logos
- [ ] Export logo in multiple formats (SVG, PNG)
- [ ] Export in multiple sizes
- [ ] Export color variations (full color, white, black)
- [ ] Export with transparent background

### Screenshots (for Reference)
- [ ] Take screenshot of each screen (for dev reference)
- [ ] Organize by screen name

---

## Phase 6: Navigation & Flows

**File:** `navigation-flows.md`

- [ ] Document all user flows:
  - [ ] Onboarding flow
  - [ ] Login/signup flow
  - [ ] Browse to order flow
  - [ ] Checkout flow
  - [ ] Order tracking flow
  - [ ] Profile management flow

- [ ] Document navigation structure:
  - [ ] Tab navigation (bottom bar)
  - [ ] Stack navigation (screen hierarchy)
  - [ ] Modal navigation
  - [ ] Deep links

- [ ] Document screen transitions:
  - [ ] Push/pop animations
  - [ ] Modal animations
  - [ ] Tab switch animations
  - [ ] Duration and easing

- [ ] Create flow diagrams (Mermaid or visual)

---

## Phase 7: Animations & Interactions

**File:** `animations.md`

- [ ] **Screen Transitions**
  - [ ] Push forward animation
  - [ ] Pop back animation
  - [ ] Fade transition
  - [ ] Modal entry/exit

- [ ] **Component Animations**
  - [ ] Button press
  - [ ] Button ripple
  - [ ] Heart/favorite animation
  - [ ] Add to cart animation

- [ ] **Loading States**
  - [ ] Spinner
  - [ ] Skeleton loader
  - [ ] Progress bar
  - [ ] Shimmer effect

- [ ] **Success/Error States**
  - [ ] Checkmark animation
  - [ ] Error shake
  - [ ] Toast slide in/out

- [ ] **Scroll Effects**
  - [ ] Parallax header
  - [ ] Sticky header collapse
  - [ ] Fade in on scroll

- [ ] **Micro-interactions**
  - [ ] Toggle switch
  - [ ] Quantity stepper
  - [ ] Star rating fill
  - [ ] Accordion expand/collapse

- [ ] Document for each:
  - [ ] Duration (ms)
  - [ ] Easing function
  - [ ] Properties animated
  - [ ] CSS or library needed

---

## Phase 8: Responsive Behavior

**File:** Create separate section in relevant docs or new `responsive.md`

- [ ] Define breakpoints:
  - [ ] Mobile (< 640px)
  - [ ] Tablet (640px - 1024px)
  - [ ] Desktop (> 1024px)

- [ ] Document responsive behavior for each screen:
  - [ ] Layout changes
  - [ ] Hidden/shown elements
  - [ ] Font size adjustments
  - [ ] Spacing adjustments
  - [ ] Image sizes

- [ ] Document responsive components:
  - [ ] Grid columns (1 col mobile, 2 col tablet, 3+ desktop)
  - [ ] Navigation (bottom bar mobile, sidebar desktop)
  - [ ] Modal (full screen mobile, centered desktop)

---

## Phase 9: Accessibility

**File:** Create `accessibility.md` or document in each component

- [ ] Color contrast ratios (WCAG AA minimum):
  - [ ] Text: 4.5:1
  - [ ] Large text: 3:1
  - [ ] UI components: 3:1

- [ ] Touch target sizes:
  - [ ] Minimum: 44x44pt (iOS) or 48x48dp (Android)

- [ ] Keyboard navigation:
  - [ ] Tab order documented
  - [ ] Focus indicators defined
  - [ ] Keyboard shortcuts documented

- [ ] Screen reader support:
  - [ ] ARIA labels documented
  - [ ] Heading hierarchy defined
  - [ ] Alternative text for images

- [ ] Reduced motion support:
  - [ ] Note animations that can be disabled

---

## Phase 10: Dark Mode (If Applicable)

**File:** Create `dark-mode.md` or add to `colors.json`

- [ ] Check if Figma has dark mode designs
- [ ] Document dark mode color palette:
  - [ ] Background colors (darker)
  - [ ] Text colors (lighter)
  - [ ] Border colors
  - [ ] Shadow colors (or adjust opacity)

- [ ] Document components with dark mode variants
- [ ] Define theme switching mechanism

---

## Phase 11: Quality Assurance

### Completeness Check
- [ ] All screens documented
- [ ] All components documented
- [ ] All design tokens extracted
- [ ] All assets exported
- [ ] Navigation flows mapped
- [ ] Animations documented

### Consistency Check
- [ ] Token naming consistent
- [ ] Color values match across docs
- [ ] Spacing follows scale
- [ ] Typography follows scale
- [ ] Components use defined tokens

### Cross-Reference Check
- [ ] Screens reference components
- [ ] Components reference tokens
- [ ] No orphaned assets
- [ ] All links work (Figma links)

### Validation
- [ ] Token JSON files are valid JSON
- [ ] Markdown files render correctly
- [ ] Images/icons load correctly
- [ ] File naming conventions followed

---

## Phase 12: Handoff Preparation

### Documentation Review
- [ ] All markdown files complete
- [ ] All JSON files complete
- [ ] README created with overview
- [ ] Extraction guide included

### Developer Handoff Package
- [ ] Design tokens (5 JSON files)
- [ ] Screen documentation (all .md files)
- [ ] Component documentation (all .md files)
- [ ] Assets (icons, images, illustrations)
- [ ] Navigation flows
- [ ] Animation specifications
- [ ] Figma file link and access instructions

### Code Generation Preparation
- [ ] Identify framework (React, React Native, Flutter, etc.)
- [ ] Choose styling approach (Tailwind, CSS-in-JS, Styled Components)
- [ ] Set up token transformation (Style Dictionary, Theo)
- [ ] Plan component library structure

---

## Phase 13: Implementation Planning

**File:** Create `implementation-plan.md`

- [ ] **Tech Stack Decision**
  - [ ] Framework: React / React Native / Flutter / Vue / etc.
  - [ ] Styling: Tailwind / CSS-in-JS / Styled Components / SCSS
  - [ ] State management: Redux / Context / Zustand / etc.
  - [ ] Routing: React Router / Next.js / Expo Router / etc.

- [ ] **Build Order Priority**
  1. [ ] Design token setup
  2. [ ] Core components (Button, Input, Card, etc.)
  3. [ ] Layout components
  4. [ ] Authentication screens
  5. [ ] Home/browse screens
  6. [ ] Cart/checkout screens
  7. [ ] Profile screens
  8. [ ] Animations and polish

- [ ] **Milestones**
  - [ ] Week 1: Design system setup, core components
  - [ ] Week 2: Authentication flow
  - [ ] Week 3: Main app screens
  - [ ] Week 4: Polish and optimization

---

## Extraction Status Summary

### Overall Progress
- [ ] Phase 1: Setup & Access (0/8 items)
- [ ] Phase 2: Design Tokens (0/5 token files)
- [ ] Phase 3: Screens (0/30+ screens)
- [ ] Phase 4: Components (0/50+ components)
- [ ] Phase 5: Assets (0/3 categories)
- [ ] Phase 6: Navigation (0/1 file)
- [ ] Phase 7: Animations (0/1 file)
- [ ] Phase 8: Responsive (0/1 file)
- [ ] Phase 9: Accessibility (0/1 file)
- [ ] Phase 10: Dark Mode (0/1 file, if applicable)
- [ ] Phase 11: Quality Assurance (0/4 checks)
- [ ] Phase 12: Handoff Preparation (0/3 deliverables)
- [ ] Phase 13: Implementation Planning (0/1 file)

### Files Created
- [x] `FIGMA_EXTRACTION_GUIDE.md`
- [x] `EXTRACTION_CHECKLIST.md` (this file)
- [x] `tokens/colors.json` (template)
- [x] `tokens/typography.json` (template)
- [x] `tokens/spacing.json` (template)
- [x] `tokens/shadows.json` (template)
- [x] `tokens/borders.json` (template)
- [x] `screens/_SCREEN_TEMPLATE.md`
- [x] `components/_COMPONENT_TEMPLATE.md`
- [x] `navigation-flows.md` (template)
- [x] `animations.md` (template)
- [x] `assets/icon-inventory.md` (template)
- [ ] All actual screen docs (pending extraction)
- [ ] All actual component docs (pending extraction)
- [ ] Actual design tokens (pending extraction)
- [ ] Actual assets (pending export)

---

## Next Steps

1. **Get Figma Access:**
   - Open Figma file
   - Ensure you can view all pages and components
   - Enable Dev Mode

2. **Start Extraction:**
   - Begin with Phase 2 (Design Tokens)
   - Move to Phase 3 (Screens)
   - Then Phase 4 (Components)
   - Continue through all phases

3. **Use Templates:**
   - Copy `_SCREEN_TEMPLATE.md` for each screen
   - Copy `_COMPONENT_TEMPLATE.md` for each component
   - Fill in all sections with actual Figma data

4. **Export Assets:**
   - Export all icons, images, illustrations
   - Optimize and organize

5. **Review & Validate:**
   - Cross-check all data
   - Ensure consistency
   - Validate JSON files

6. **Handoff:**
   - Package all documentation
   - Provide to development team
   - Begin code generation

---

## Estimated Time

- **Setup & Access:** 30 minutes
- **Design Tokens:** 2-3 hours
- **Screens (30 screens):** 6-8 hours (15-20 min per screen)
- **Components (50 components):** 8-10 hours (10-15 min per component)
- **Assets Export:** 2-3 hours
- **Navigation & Animations:** 2-3 hours
- **Quality Assurance:** 2-3 hours
- **Total:** 22-30 hours (3-4 working days)

---

## Tools & Resources

### Required Tools
- Figma (browser or desktop app)
- Code editor (VS Code, Sublime, etc.)
- JSON validator
- Markdown previewer

### Recommended Tools
- SVGO (SVG optimization)
- ImageOptim (image compression)
- Figma plugins:
  - Design Tokens
  - Iconify
  - Measure
- Style Dictionary (token transformation)
- Mermaid (flow diagrams)

### Reference
- Figma Dev Mode docs: https://help.figma.com/hc/en-us/articles/360055203533
- Design Tokens spec: https://design-tokens.github.io/community-group/format/
- WCAG Guidelines: https://www.w3.org/WAI/WCAG21/quickref/

---

**Last Updated:** 2025-10-11
**Status:** Ready for extraction
**Estimated Completion:** TBD
