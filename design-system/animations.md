# Animations & Interactions
## Food Delivery App

---

## Animation Principles

### Duration Guidelines
- **Instant:** 0ms - No animation, immediate feedback
- **Fast:** 100-200ms - Micro-interactions (button press, toggle)
- **Normal:** 200-300ms - Standard transitions (screen changes, modals)
- **Moderate:** 300-500ms - Complex animations (collapse/expand)
- **Slow:** 500-1000ms - Hero animations (splash screen, success states)
- **Very Slow:** 1000ms+ - Ambient animations (background effects)

### Easing Functions
```css
/* Standard transitions */
--ease-in: cubic-bezier(0.4, 0, 1, 1);
--ease-out: cubic-bezier(0, 0, 0.2, 1);
--ease-in-out: cubic-bezier(0.4, 0, 0.2, 1);

/* Custom easing */
--ease-bounce: cubic-bezier(0.68, -0.55, 0.265, 1.55);
--ease-smooth: cubic-bezier(0.25, 0.46, 0.45, 0.94);
--ease-swift: cubic-bezier(0.55, 0, 0.1, 1);
```

### Performance Best Practices
- Animate only `transform` and `opacity` (GPU-accelerated)
- Avoid animating `width`, `height`, `top`, `left`
- Use `will-change` sparingly
- Prefer CSS animations over JavaScript when possible
- Use `requestAnimationFrame` for JS animations

---

## Screen Transitions

### Navigation Transitions

#### Push (Forward Navigation)
```css
/* Entering screen */
.screen-enter {
  transform: translateX(100%);
  opacity: 0;
}
.screen-enter-active {
  transform: translateX(0);
  opacity: 1;
  transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
}

/* Exiting screen */
.screen-exit {
  transform: translateX(0);
  opacity: 1;
}
.screen-exit-active {
  transform: translateX(-30%);
  opacity: 0.5;
  transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
}
```

**Duration:** 300ms
**Easing:** ease-in-out
**Usage:** Restaurant detail, Food detail, Checkout

#### Pop (Back Navigation)
```css
/* Entering screen (coming back) */
.screen-enter {
  transform: translateX(-30%);
  opacity: 0.5;
}
.screen-enter-active {
  transform: translateX(0);
  opacity: 1;
  transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
}

/* Exiting screen (leaving) */
.screen-exit {
  transform: translateX(0);
  opacity: 1;
}
.screen-exit-active {
  transform: translateX(100%);
  opacity: 0;
  transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
}
```

**Duration:** 300ms
**Easing:** ease-in-out

#### Fade
```css
.fade-enter {
  opacity: 0;
}
.fade-enter-active {
  opacity: 1;
  transition: opacity 200ms ease-in-out;
}
.fade-exit {
  opacity: 1;
}
.fade-exit-active {
  opacity: 0;
  transition: opacity 200ms ease-in-out;
}
```

**Duration:** 200ms
**Usage:** Tab switches, Profile sections

---

## Modal & Overlay Animations

### Bottom Sheet
```css
/* Backdrop */
.backdrop-enter {
  opacity: 0;
}
.backdrop-enter-active {
  opacity: 1;
  transition: opacity 300ms ease-out;
}

/* Sheet */
.sheet-enter {
  transform: translateY(100%);
}
.sheet-enter-active {
  transform: translateY(0);
  transition: transform 400ms cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

/* Exit */
.sheet-exit-active {
  transform: translateY(100%);
  transition: transform 300ms ease-in;
}
```

**Duration:** 400ms enter, 300ms exit
**Easing:** Bounce on enter, ease-in on exit
**Usage:** Food item detail, Filters, Options

### Center Modal
```css
.modal-enter {
  opacity: 0;
  transform: scale(0.9);
}
.modal-enter-active {
  opacity: 1;
  transform: scale(1);
  transition: all 300ms cubic-bezier(0.4, 0, 0.2, 1);
}
.modal-exit-active {
  opacity: 0;
  transform: scale(0.9);
  transition: all 200ms ease-in;
}
```

**Duration:** 300ms enter, 200ms exit
**Usage:** Confirmation dialogs, Alerts

### Drawer (Side Menu)
```css
.drawer-enter {
  transform: translateX(-100%);
}
.drawer-enter-active {
  transform: translateX(0);
  transition: transform 300ms cubic-bezier(0.4, 0, 0.2, 1);
}
.drawer-exit-active {
  transform: translateX(-100%);
  transition: transform 250ms ease-in;
}
```

**Duration:** 300ms enter, 250ms exit
**Usage:** Side navigation menu

---

## Component Animations

### Button

#### Press Animation
```css
.button:active {
  transform: scale(0.95);
  transition: transform 100ms ease-in-out;
}
```

#### Ripple Effect
```css
@keyframes ripple {
  0% {
    transform: scale(0);
    opacity: 0.5;
  }
  100% {
    transform: scale(2);
    opacity: 0;
  }
}

.button::after {
  content: '';
  position: absolute;
  width: 100%;
  height: 100%;
  border-radius: inherit;
  animation: ripple 600ms ease-out;
}
```

**Duration:** 100ms press, 600ms ripple
**Usage:** All buttons

### Add to Cart Button
```css
@keyframes addToCart {
  0% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
  }
}

.button-add:active {
  animation: addToCart 300ms ease-in-out;
}
```

**Duration:** 300ms
**Usage:** Add to cart actions

### Heart/Favorite
```css
@keyframes heartBeat {
  0%, 100% {
    transform: scale(1);
  }
  25% {
    transform: scale(1.3);
  }
  50% {
    transform: scale(0.9);
  }
  75% {
    transform: scale(1.2);
  }
}

.heart.active {
  animation: heartBeat 500ms ease-in-out;
  fill: var(--color-primary);
}
```

**Duration:** 500ms
**Usage:** Favorite/like actions

---

## List & Card Animations

### List Item Entry (Stagger)
```css
.list-item {
  opacity: 0;
  transform: translateY(20px);
  animation: listItemEnter 300ms ease-out forwards;
}

.list-item:nth-child(1) { animation-delay: 0ms; }
.list-item:nth-child(2) { animation-delay: 50ms; }
.list-item:nth-child(3) { animation-delay: 100ms; }
.list-item:nth-child(4) { animation-delay: 150ms; }

@keyframes listItemEnter {
  to {
    opacity: 1;
    transform: translateY(0);
  }
}
```

**Duration:** 300ms per item
**Delay:** 50ms stagger
**Usage:** Restaurant list, Food items

### Card Hover (Desktop)
```css
.card {
  transition: all 200ms ease-out;
}

.card:hover {
  transform: translateY(-4px);
  box-shadow: var(--shadow-lg);
}
```

**Duration:** 200ms
**Usage:** Restaurant cards, Food cards

### Swipe to Delete
```css
.list-item {
  transform: translateX(0);
  transition: transform 300ms ease-out;
}

.list-item.swiping {
  transform: translateX(-80px);
}

.list-item.deleted {
  opacity: 0;
  transform: translateX(-100%);
  transition: all 300ms ease-in;
}
```

**Duration:** 300ms
**Usage:** Cart items, Saved addresses

---

## Loading Animations

### Spinner
```css
@keyframes spin {
  to {
    transform: rotate(360deg);
  }
}

.spinner {
  animation: spin 1s linear infinite;
}
```

**Duration:** 1000ms (continuous)
**Usage:** Loading states

### Pulse (Skeleton Loader)
```css
@keyframes pulse {
  0%, 100% {
    opacity: 1;
  }
  50% {
    opacity: 0.4;
  }
}

.skeleton {
  background: linear-gradient(90deg, #f0f0f0 25%, #e0e0e0 50%, #f0f0f0 75%);
  background-size: 200% 100%;
  animation: pulse 1.5s ease-in-out infinite;
}
```

**Duration:** 1500ms (continuous)
**Usage:** Content loading placeholders

### Shimmer
```css
@keyframes shimmer {
  0% {
    background-position: -200% 0;
  }
  100% {
    background-position: 200% 0;
  }
}

.shimmer {
  background: linear-gradient(
    90deg,
    #f0f0f0 0%,
    #f8f8f8 20%,
    #f0f0f0 40%,
    #f0f0f0 100%
  );
  background-size: 200% auto;
  animation: shimmer 2s linear infinite;
}
```

**Duration:** 2000ms (continuous)
**Usage:** Card loading states

### Progress Bar
```css
@keyframes progress {
  0% {
    width: 0%;
  }
  100% {
    width: 100%;
  }
}

.progress-bar {
  animation: progress 30s linear forwards;
}
```

**Duration:** Variable (based on actual progress)
**Usage:** Order preparation status

---

## Success & Feedback Animations

### Success Checkmark
```css
@keyframes checkmark {
  0% {
    stroke-dashoffset: 100;
  }
  100% {
    stroke-dashoffset: 0;
  }
}

@keyframes scaleIn {
  0% {
    transform: scale(0);
    opacity: 0;
  }
  50% {
    transform: scale(1.2);
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

.success-icon {
  animation: scaleIn 500ms cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.success-icon path {
  stroke-dasharray: 100;
  animation: checkmark 500ms 300ms ease-out forwards;
}
```

**Duration:** 500ms icon + 500ms checkmark
**Usage:** Order success, Payment success

### Confetti
```css
@keyframes confetti-fall {
  0% {
    transform: translateY(-100vh) rotate(0deg);
    opacity: 1;
  }
  100% {
    transform: translateY(100vh) rotate(360deg);
    opacity: 0;
  }
}

.confetti {
  animation: confetti-fall 3s ease-out forwards;
}
```

**Duration:** 3000ms
**Usage:** Order placed celebration

### Toast/Snackbar
```css
@keyframes slideUp {
  from {
    transform: translateY(100%);
    opacity: 0;
  }
  to {
    transform: translateY(0);
    opacity: 1;
  }
}

@keyframes slideDown {
  from {
    transform: translateY(0);
    opacity: 1;
  }
  to {
    transform: translateY(100%);
    opacity: 0;
  }
}

.toast {
  animation: slideUp 300ms ease-out;
}

.toast.exit {
  animation: slideDown 300ms ease-in;
}
```

**Duration:** 300ms enter/exit
**Display:** 3000ms (auto-dismiss)
**Usage:** Success messages, Errors, Notifications

---

## Scroll Animations

### Parallax Header
```javascript
// Pseudo-code
onScroll = (scrollY) => {
  headerImage.style.transform = `translateY(${scrollY * 0.5}px)`;
  headerOverlay.style.opacity = Math.min(scrollY / 200, 1);
};
```

**Usage:** Restaurant detail header

### Fade In on Scroll
```css
.fade-in-scroll {
  opacity: 0;
  transform: translateY(30px);
  transition: all 600ms ease-out;
}

.fade-in-scroll.visible {
  opacity: 1;
  transform: translateY(0);
}
```

**Duration:** 600ms
**Usage:** Long content pages

### Sticky Header Collapse
```css
.header {
  height: 80px;
  transition: height 300ms ease-out, box-shadow 300ms ease-out;
}

.header.collapsed {
  height: 60px;
  box-shadow: var(--shadow-md);
}
```

**Duration:** 300ms
**Usage:** App bar on scroll

---

## Micro-interactions

### Quantity Stepper
```css
.quantity-change {
  animation: pop 200ms ease-out;
}

@keyframes pop {
  0%, 100% {
    transform: scale(1);
  }
  50% {
    transform: scale(1.2);
  }
}
```

**Duration:** 200ms
**Usage:** Quantity +/- buttons

### Rating Stars
```css
@keyframes starFill {
  0% {
    transform: scale(0);
  }
  50% {
    transform: scale(1.2);
  }
  100% {
    transform: scale(1);
  }
}

.star.filling {
  animation: starFill 300ms ease-out;
}
```

**Duration:** 300ms per star
**Delay:** 100ms stagger
**Usage:** Rating interactions

### Toggle Switch
```css
.toggle-switch {
  transition: background-color 200ms ease-out;
}

.toggle-switch .thumb {
  transition: transform 200ms cubic-bezier(0.68, -0.55, 0.265, 1.55);
}

.toggle-switch.on .thumb {
  transform: translateX(20px);
}
```

**Duration:** 200ms
**Usage:** Settings toggles

### Accordion Expand/Collapse
```css
.accordion-content {
  max-height: 0;
  overflow: hidden;
  transition: max-height 400ms ease-in-out;
}

.accordion-content.expanded {
  max-height: 500px;
}

.accordion-icon {
  transition: transform 300ms ease-out;
}

.accordion.expanded .accordion-icon {
  transform: rotate(180deg);
}
```

**Duration:** 400ms content, 300ms icon
**Usage:** FAQ, Menu sections

---

## Pull to Refresh

### Pull Animation
```css
@keyframes pullDown {
  0% {
    transform: translateY(-100px);
  }
  100% {
    transform: translateY(0);
  }
}

.pull-indicator {
  animation: pullDown 300ms ease-out;
}
```

### Refresh Spinner
```css
@keyframes refreshSpin {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(720deg);
  }
}

.refresh-spinner {
  animation: refreshSpin 1s ease-out;
}
```

**Duration:** 300ms pull, 1000ms spinner
**Usage:** Restaurant list refresh

---

## Map Animations

### Marker Drop
```css
@keyframes markerDrop {
  0% {
    transform: translateY(-100px) scale(0);
    opacity: 0;
  }
  80% {
    transform: translateY(5px) scale(1);
  }
  100% {
    transform: translateY(0) scale(1);
    opacity: 1;
  }
}

.map-marker {
  animation: markerDrop 500ms cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
```

**Duration:** 500ms
**Usage:** Restaurant markers on map

### Delivery Route Draw
```css
@keyframes drawRoute {
  0% {
    stroke-dashoffset: 1000;
  }
  100% {
    stroke-dashoffset: 0;
  }
}

.delivery-route {
  stroke-dasharray: 1000;
  animation: drawRoute 2s ease-in-out forwards;
}
```

**Duration:** 2000ms
**Usage:** Delivery tracking route

---

## Splash Screen Animation

### Logo Animation
```css
@keyframes logoEnter {
  0% {
    transform: scale(0.5);
    opacity: 0;
  }
  50% {
    transform: scale(1.1);
  }
  100% {
    transform: scale(1);
    opacity: 1;
  }
}

.splash-logo {
  animation: logoEnter 800ms cubic-bezier(0.68, -0.55, 0.265, 1.55);
}
```

**Duration:** 800ms
**Usage:** App launch

---

## Empty State Animations

### Illustration Float
```css
@keyframes float {
  0%, 100% {
    transform: translateY(0);
  }
  50% {
    transform: translateY(-20px);
  }
}

.empty-state-illustration {
  animation: float 3s ease-in-out infinite;
}
```

**Duration:** 3000ms (continuous)
**Usage:** Empty cart, No results

---

## Order Tracking Animations

### Status Progress
```css
@keyframes progressStep {
  0% {
    width: 0%;
  }
  100% {
    width: 100%;
  }
}

.progress-line {
  animation: progressStep 1s ease-out forwards;
}
```

**Duration:** 1000ms per step
**Usage:** Order status timeline

### Driver Moving
```css
@keyframes moveDriver {
  0% {
    transform: translateX(0) translateY(0);
  }
  100% {
    transform: translateX(var(--end-x)) translateY(var(--end-y));
  }
}

.driver-marker {
  animation: moveDriver 2s linear forwards;
}
```

**Duration:** 2000ms
**Usage:** Real-time driver location updates

---

## Accessibility Considerations

### Prefers Reduced Motion
```css
@media (prefers-reduced-motion: reduce) {
  * {
    animation-duration: 0.01ms !important;
    animation-iteration-count: 1 !important;
    transition-duration: 0.01ms !important;
  }
}
```

**Implementation:** Always respect user preferences

### Focus Indicators
```css
:focus-visible {
  outline: 2px solid var(--color-primary);
  outline-offset: 2px;
  transition: outline-offset 200ms ease-out;
}
```

**Duration:** 200ms

---

## Animation Library Recommendations

### React
- **Framer Motion** - Declarative animations
- **React Spring** - Physics-based animations
- **React Transition Group** - Simple transitions

### React Native
- **Reanimated 2** - High-performance animations
- **Moti** - Framer Motion for React Native
- **Lottie** - JSON-based animations

### CSS-only
- **Animate.css** - Ready-to-use animations
- **Hover.css** - Hover effects

---

## Performance Metrics

### Target Performance
- **First paint:** < 100ms
- **Time to interactive:** < 1000ms
- **Animation FPS:** 60fps (no jank)

### Monitoring
```javascript
// Log animation performance
const observer = new PerformanceObserver((list) => {
  for (const entry of list.getEntries()) {
    console.log('Animation duration:', entry.duration);
  }
});
observer.observe({ entryTypes: ['measure'] });
```

---

## Implementation Checklist

- [ ] Extract animation timings from Figma prototype
- [ ] Define easing curves
- [ ] Create animation tokens/variables
- [ ] Implement screen transitions
- [ ] Add component micro-interactions
- [ ] Create loading states
- [ ] Add success/error animations
- [ ] Implement scroll effects
- [ ] Test on low-end devices
- [ ] Verify 60fps performance
- [ ] Test with reduced motion preference
- [ ] Add animation documentation
- [ ] Create animation component library

---

## Notes

**Last Updated:** 2025-10-11
**Framework:** To be determined
**Animation Library:** To be decided
**Performance Target:** 60fps on mid-range devices
