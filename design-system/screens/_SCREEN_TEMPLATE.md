# [Screen Name]

## Overview
**Type:** [Modal/Full Screen/Bottom Sheet]
**Purpose:** [Brief description of what this screen does]
**Entry Points:** [How users navigate to this screen]
**Exit Points:** [How users leave this screen]

---

## Layout Structure

### Dimensions
- **Width:** [px or responsive]
- **Height:** [px or responsive]
- **Safe Area:** [Top/Bottom insets for mobile]

### Grid System
- **Columns:** [Number of columns]
- **Gutter:** [Space between columns]
- **Margin:** [Left/Right padding]

### Sections
1. **Header/App Bar**
   - Height: [px]
   - Position: [Fixed/Sticky/Static]
   - Components: [Back button, Title, Actions]

2. **Content Area**
   - Scroll behavior: [Vertical/Horizontal/None]
   - Layout: [List/Grid/Custom]

3. **Footer/Bottom Navigation**
   - Height: [px]
   - Position: [Fixed/Static]
   - Components: [Buttons, Navigation]

---

## Components Breakdown

### Primary Components
| Component | Variant | Quantity | Notes |
|-----------|---------|----------|-------|
| [Component name] | [Variant] | [Count] | [Special properties] |

### Interactive Elements
- **Buttons:**
  - Primary: [Count and purpose]
  - Secondary: [Count and purpose]
  - Icon: [Count and purpose]

- **Forms:**
  - Text inputs: [Count]
  - Dropdowns: [Count]
  - Checkboxes: [Count]
  - Radio buttons: [Count]

- **Navigation:**
  - Tabs: [Count]
  - Links: [Count]
  - Gestures: [Swipe/Scroll/etc.]

---

## Design Tokens Used

### Colors
```json
{
  "background": "#______",
  "surface": "#______",
  "primary": "#______",
  "secondary": "#______",
  "text": {
    "primary": "#______",
    "secondary": "#______"
  },
  "border": "#______",
  "accent": "#______"
}
```

### Typography
```json
{
  "heading": {
    "font": "",
    "size": "",
    "weight": "",
    "lineHeight": ""
  },
  "body": {
    "font": "",
    "size": "",
    "weight": "",
    "lineHeight": ""
  },
  "caption": {
    "font": "",
    "size": "",
    "weight": "",
    "lineHeight": ""
  }
}
```

### Spacing
```json
{
  "screenPadding": "",
  "sectionGap": "",
  "itemGap": "",
  "contentPadding": ""
}
```

### Shadows
- **Card shadow:** [Value]
- **App bar shadow:** [Value]
- **Modal shadow:** [Value]

### Border Radius
- **Cards:** [Value]
- **Buttons:** [Value]
- **Images:** [Value]

---

## States & Variations

### Loading State
- Skeleton loaders: [Yes/No]
- Spinner: [Yes/No]
- Progressive loading: [Description]

### Empty State
- Illustration: [Yes/No - Description]
- Message: [Text]
- Action: [Button text and behavior]

### Error State
- Error message: [Text]
- Icon: [Yes/No]
- Retry button: [Yes/No]

### Success State
- Confirmation message: [Text]
- Duration: [Time before dismissal]

---

## Interactions & Animations

### Screen Transitions
- **Entry:** [Animation type - slide/fade/scale]
- **Exit:** [Animation type]
- **Duration:** [ms]
- **Easing:** [cubic-bezier or name]

### Scroll Behavior
- **Header:** [Collapse/Fixed/Hide on scroll]
- **Parallax:** [Yes/No - Elements affected]
- **Pull to refresh:** [Yes/No]

### Micro-interactions
- **Button press:** [Animation]
- **Item selection:** [Visual feedback]
- **Swipe actions:** [Left/Right behaviors]
- **Long press:** [Action]

### Gestures
- **Tap:** [Actions]
- **Swipe:** [Left/Right/Up/Down actions]
- **Pinch:** [Zoom behavior]
- **Drag:** [Reorder/dismiss]

---

## Data Requirements

### API Endpoints
- [Endpoint URL and method]
- [Response structure]

### Local Storage
- [Cached data]
- [User preferences]

### Real-time Updates
- [WebSocket connections]
- [Polling intervals]

---

## User Flows

### Primary Flow
1. [Step 1]
2. [Step 2]
3. [Step 3]

### Alternative Flows
1. **[Scenario name]:**
   - [Steps]

### Edge Cases
1. **No data:** [Behavior]
2. **Network error:** [Behavior]
3. **Authentication required:** [Redirect]

---

## Accessibility

### Screen Reader
- **Heading structure:** [H1, H2, etc.]
- **Labels:** [All interactive elements labeled]
- **Announcements:** [Dynamic content announcements]

### Keyboard Navigation
- **Tab order:** [Logical flow]
- **Focus indicators:** [Visible]
- **Shortcuts:** [Any keyboard shortcuts]

### Touch Targets
- **Minimum size:** [44x44pt minimum]
- **Spacing:** [Adequate spacing between targets]

### Color Contrast
- **Text:** [Ratio - must meet WCAG AA]
- **Interactive elements:** [Ratio]

---

## Responsive Behavior

### Mobile (< 640px)
- [Layout changes]
- [Component adjustments]
- [Hidden/shown elements]

### Tablet (640px - 1024px)
- [Layout changes]
- [Component adjustments]

### Desktop (> 1024px)
- [Layout changes]
- [Component adjustments]
- [Additional features]

---

## Assets Required

### Images
- [Image name, size, format]

### Icons
- [Icon name, size, color]

### Illustrations
- [Illustration name, format]

### Fonts
- [Font family, weights used]

---

## Performance Considerations

### Initial Load
- **Critical path:** [Assets]
- **Code splitting:** [Lazy loaded components]
- **Image optimization:** [Format, size]

### Runtime
- **List virtualization:** [For long lists]
- **Memoization:** [Components to memoize]
- **Debouncing:** [Search, filters]

---

## Testing Scenarios

### Unit Tests
- [ ] Component renders correctly
- [ ] Button actions trigger expected behavior
- [ ] Form validation works
- [ ] State updates correctly

### Integration Tests
- [ ] API calls succeed
- [ ] Navigation works
- [ ] Data flows correctly

### E2E Tests
- [ ] Complete user flow works
- [ ] Error scenarios handled
- [ ] Different device sizes work

---

## Notes & Special Considerations

[Any additional notes, gotchas, or special requirements]

---

## Figma Reference

**Frame ID:** [Node ID from Figma]
**Page:** [Page name in Figma]
**Link:** [Direct link to frame]
**Last Updated:** [Date]

---

## Implementation Status

- [ ] Design tokens extracted
- [ ] Components identified
- [ ] Assets exported
- [ ] Code scaffolded
- [ ] Styling implemented
- [ ] Interactions added
- [ ] Tests written
- [ ] Accessibility verified
- [ ] Performance optimized
- [ ] Review complete
