# [Component Name]

## Overview
**Type:** [Atom/Molecule/Organism]
**Category:** [Input/Navigation/Display/Feedback]
**Purpose:** [Brief description of component's function]

---

## Variants

### Size Variants
- **Small (sm)**
  - Use case: [When to use]
  - Dimensions: [Width x Height]

- **Medium (md) - Default**
  - Use case: [When to use]
  - Dimensions: [Width x Height]

- **Large (lg)**
  - Use case: [When to use]
  - Dimensions: [Width x Height]

### Style Variants
- **Primary**
  - Use case: [Main actions]
  - Visual: [Description]

- **Secondary**
  - Use case: [Secondary actions]
  - Visual: [Description]

- **Tertiary/Text**
  - Use case: [Less prominent actions]
  - Visual: [Description]

- **Outlined**
  - Use case: [Alternative style]
  - Visual: [Description]

### Color Variants
- **Default**
- **Success**
- **Warning**
- **Error**
- **Info**

---

## States

### Default
```json
{
  "background": "#______",
  "text": "#______",
  "border": "#______",
  "borderWidth": "",
  "borderRadius": "",
  "shadow": "",
  "opacity": "1"
}
```

### Hover
```json
{
  "background": "#______",
  "text": "#______",
  "border": "#______",
  "transform": "",
  "transition": ""
}
```

### Active/Pressed
```json
{
  "background": "#______",
  "text": "#______",
  "border": "#______",
  "transform": "scale(0.98)",
  "transition": ""
}
```

### Focus
```json
{
  "outline": "",
  "outlineOffset": "",
  "boxShadow": ""
}
```

### Disabled
```json
{
  "background": "#______",
  "text": "#______",
  "opacity": "0.4",
  "cursor": "not-allowed"
}
```

### Loading
```json
{
  "background": "#______",
  "text": "transparent",
  "spinner": "visible",
  "cursor": "wait"
}
```

---

## Visual Specifications

### Dimensions
```json
{
  "sm": {
    "height": "",
    "minWidth": "",
    "padding": {
      "x": "",
      "y": ""
    }
  },
  "md": {
    "height": "",
    "minWidth": "",
    "padding": {
      "x": "",
      "y": ""
    }
  },
  "lg": {
    "height": "",
    "minWidth": "",
    "padding": {
      "x": "",
      "y": ""
    }
  }
}
```

### Typography
```json
{
  "sm": {
    "fontSize": "",
    "fontWeight": "",
    "lineHeight": "",
    "letterSpacing": ""
  },
  "md": {
    "fontSize": "",
    "fontWeight": "",
    "lineHeight": "",
    "letterSpacing": ""
  },
  "lg": {
    "fontSize": "",
    "fontWeight": "",
    "lineHeight": "",
    "letterSpacing": ""
  }
}
```

### Spacing
```json
{
  "gap": "",
  "iconGap": "",
  "padding": {
    "x": "",
    "y": ""
  }
}
```

### Borders
```json
{
  "width": "",
  "style": "solid",
  "radius": "",
  "color": {
    "default": "#______",
    "hover": "#______",
    "focus": "#______"
  }
}
```

### Shadows
```json
{
  "default": "",
  "hover": "",
  "active": "",
  "focus": ""
}
```

---

## Props/Parameters

### Required Props
| Prop | Type | Description |
|------|------|-------------|
| [name] | [type] | [description] |

### Optional Props
| Prop | Type | Default | Description |
|------|------|---------|-------------|
| size | 'sm' \| 'md' \| 'lg' | 'md' | Component size |
| variant | 'primary' \| 'secondary' \| 'outlined' | 'primary' | Visual variant |
| disabled | boolean | false | Disabled state |
| loading | boolean | false | Loading state |
| fullWidth | boolean | false | Take full container width |
| icon | ReactNode | null | Optional icon |
| iconPosition | 'left' \| 'right' | 'left' | Icon placement |

### Event Handlers
| Handler | Parameters | Description |
|---------|-----------|-------------|
| onClick | (event) => void | Click/tap handler |
| onHover | (event) => void | Hover handler |
| onFocus | (event) => void | Focus handler |
| onBlur | (event) => void | Blur handler |

---

## Usage Examples

### Basic Usage
```jsx
<ComponentName>
  Text content
</ComponentName>
```

### With Props
```jsx
<ComponentName
  size="lg"
  variant="primary"
  icon={<Icon />}
  onClick={handleClick}
>
  Text content
</ComponentName>
```

### All Variants
```jsx
<ComponentName variant="primary">Primary</ComponentName>
<ComponentName variant="secondary">Secondary</ComponentName>
<ComponentName variant="outlined">Outlined</ComponentName>
```

### States
```jsx
<ComponentName disabled>Disabled</ComponentName>
<ComponentName loading>Loading</ComponentName>
```

---

## Composition

### Sub-components
- **[SubComponent1]:** [Description]
- **[SubComponent2]:** [Description]

### Parent Components
Where this component is typically used:
- [Parent component 1]
- [Parent component 2]

### Child Components
Components this can contain:
- [Child component 1]
- [Child component 2]

---

## Interactions

### Click/Tap
- **Action:** [What happens]
- **Visual feedback:** [Animation/transition]
- **Duration:** [ms]

### Hover
- **Desktop only:** [Yes/No]
- **Visual feedback:** [Animation/transition]
- **Duration:** [ms]

### Focus
- **Keyboard navigation:** [Tab order]
- **Visual indicator:** [Outline/ring]
- **Focus trap:** [Yes/No - for modals]

### Long Press
- **Mobile only:** [Yes/No]
- **Action:** [What happens]
- **Duration:** [ms before trigger]

---

## Animations

### Transitions
```css
{
  property: "all",
  duration: "200ms",
  timingFunction: "cubic-bezier(0.4, 0, 0.2, 1)"
}
```

### Hover Animation
```css
{
  transform: "translateY(-2px)",
  boxShadow: "[elevated shadow]"
}
```

### Press Animation
```css
{
  transform: "scale(0.98)"
}
```

### Loading Animation
```css
{
  spinner: {
    animation: "spin 1s linear infinite"
  }
}
```

---

## Accessibility

### ARIA Attributes
```html
role="[role]"
aria-label="[label]"
aria-pressed="[state]"
aria-disabled="[state]"
aria-busy="[loading state]"
```

### Keyboard Support
| Key | Action |
|-----|--------|
| Tab | Focus component |
| Enter/Space | Activate |
| Escape | Cancel/close (if applicable) |

### Screen Reader
- **Label:** [What's announced]
- **State changes:** [What's announced on state change]
- **Loading:** [What's announced during loading]

### Focus Management
- **Focus visible:** [Clear indicator]
- **Focus trap:** [For modal components]
- **Auto-focus:** [When appropriate]

### Touch Targets
- **Minimum size:** 44x44pt
- **Spacing:** Adequate space between targets
- **Hit area:** Extends beyond visual bounds if needed

### Color Contrast
- **Text:** [Ratio] (WCAG AA requirement: 4.5:1)
- **Non-text:** [Ratio] (WCAG AA requirement: 3:1)
- **States:** All states meet contrast requirements

---

## Responsive Behavior

### Mobile (< 640px)
- [Size adjustments]
- [Touch-specific behaviors]
- [Layout changes]

### Tablet (640px - 1024px)
- [Size adjustments]
- [Hover states]
- [Layout changes]

### Desktop (> 1024px)
- [Size adjustments]
- [Hover states]
- [Keyboard navigation]

---

## Theme Support

### Light Theme
```json
{
  "background": "#______",
  "text": "#______",
  "border": "#______"
}
```

### Dark Theme
```json
{
  "background": "#______",
  "text": "#______",
  "border": "#______"
}
```

### Custom Theme
- [Props for customization]
- [CSS variables used]

---

## Assets Required

### Icons
- [Icon name and size]

### Images
- [Image name and size]

### Fonts
- [Font family and weights]

---

## Dependencies

### External Libraries
- [Library name and version]

### Internal Dependencies
- [Other components used]
- [Utilities/hooks used]

---

## Performance

### Optimization
- **Memoization:** [Yes/No - components to memoize]
- **Lazy loading:** [Yes/No - for heavy components]
- **Code splitting:** [Yes/No]

### Bundle Size
- **Estimated size:** [KB]
- **Tree-shakeable:** [Yes/No]

---

## Testing

### Unit Tests
- [ ] Renders correctly
- [ ] Props work as expected
- [ ] All variants render
- [ ] All states work
- [ ] Event handlers fire
- [ ] Accessibility attributes present

### Visual Tests
- [ ] Matches design
- [ ] All variants match
- [ ] All states match
- [ ] Responsive behavior works

### Integration Tests
- [ ] Works within parent components
- [ ] Interacts correctly with other components
- [ ] Theme changes work

---

## Browser Support

- Chrome: [Version]
- Firefox: [Version]
- Safari: [Version]
- Edge: [Version]
- Mobile Safari: [Version]
- Chrome Android: [Version]

---

## Known Issues & Limitations

- [Issue 1]
- [Issue 2]

---

## Related Components

- [Similar component 1]
- [Similar component 2]
- [Complementary component]

---

## Figma Reference

**Component ID:** [Node ID from Figma]
**Variants:** [Link to variants]
**Link:** [Direct link to component]
**Last Updated:** [Date]

---

## Implementation Notes

[Any special considerations, gotchas, or implementation details]

---

## Version History

- **v1.0.0** - [Date] - Initial implementation
- **v1.1.0** - [Date] - [Changes]

---

## Implementation Status

- [ ] Design specs extracted
- [ ] Variants identified
- [ ] States documented
- [ ] Props defined
- [ ] Code implemented
- [ ] Styled correctly
- [ ] Interactions added
- [ ] Accessibility verified
- [ ] Tests written
- [ ] Documentation complete
- [ ] Storybook stories added
- [ ] Review complete
