# APP: Focus Recipes

## 1. App Identity

### Core Concept
A "playlist" timer for deep work. Users select a Recipe (a sequence of timed phases) and the app guides them through it.

Vibe: High-end, calm, fluid (Headspace meets Pomodoro).

### Target User
Knowledge workers who struggle with task initiation and need structure to enter a flow state.

### Value Proposition
Unlike standard timers that just count down, Focus Recipes orchestrates energy levels through distinct phases (Focus, Decompress, Review).

---

## 2. Data Models

### Recipe
```typescript
{
  id: string;
  name: string;  // e.g., "The 90-Minute Deep Dive"
  description: string;  // e.g., "Perfect for morning creative work"
  phases: Phase[];
}
```

### Phase
```typescript
{
  name: string;  // e.g., "Deep Work", "Coffee Break"
  duration_seconds: number;
  theme_color: string;  // hex code, e.g., "#4F46E5"
  animation_type: 'breathing' | 'pulse' | 'static';
}
```

### Example Hardcoded Recipes
```typescript
const RECIPES = [
  {
    id: 'pomodoro',
    name: 'Classic Pomodoro',
    description: 'The standard 25-5-5-5 cycle',
    phases: [
      { name: 'Focus', duration_seconds: 1500, theme_color: '#EF4444', animation_type: 'breathing' },
      { name: 'Break', duration_seconds: 300, theme_color: '#10B981', animation_type: 'pulse' },
      { name: 'Focus', duration_seconds: 1500, theme_color: '#EF4444', animation_type: 'breathing' },
      { name: 'Long Break', duration_seconds: 900, theme_color: '#3B82F6', animation_type: 'static' }
    ]
  },
  {
    id: 'deep-dive',
    name: 'The 90-Minute Deep Dive',
    description: 'Extended focus for complex problems',
    phases: [
      { name: 'Warm Up', duration_seconds: 600, theme_color: '#F59E0B', animation_type: 'pulse' },
      { name: 'Deep Work', duration_seconds: 5400, theme_color: '#8B5CF6', animation_type: 'breathing' },
      { name: 'Decompress', duration_seconds: 900, theme_color: '#10B981', animation_type: 'pulse' }
    ]
  }
];
```

---

## 3. User Stories (What Happens, Not How)

### Feature 1: The Engine
**User Action:** User clicks "Start" on a recipe.

**System Response:** 
- Timer begins counting down from first phase duration
- Background color shifts to phase theme color
- Text breathes gently (Framer Motion animation)
- Phase name displays prominently

**Success Criteria:** 
- Timer tracks time using Date.now() delta (no drift)
- Auto-transitions to next phase when current phase completes
- Plays subtle sound on phase transition
- Shows progress (e.g., "Phase 2 of 4")

### Feature 2: The Thumb Zone
**User Action:** User holds phone in one hand.

**System Response:** 
- All primary controls (Pause, Skip, Reset) are in the bottom 30% of the screen
- Touch targets are 48x48px minimum
- Visual feedback on tap (scale animation)

**Success Criteria:** 
- User can control app without shifting grip
- No accidental taps (adequate spacing)
- Works in both portrait and landscape

### Feature 3: Persistence
**User Action:** User closes browser mid-session.

**System Response:**
- On return, show "Resume Session?" dialog
- If yes, restore to exact point in recipe
- If no, clear state and show recipe selection

**Success Criteria:**
- Uses localStorage to persist state
- Restores recipe ID, phase index, and time remaining
- Handles edge case of localStorage being full

---

## 4. Technical Stack & Constraints

### Stack
- **Context File:** `.cursorrules-utility`
- **Framework:** React 19 + Vite (Client-side only)
- **Language:** TypeScript 5.x
- **Styling:** Tailwind CSS 4.0 + Framer Motion
- **Icons:** Lucide React
- **Storage:** localStorage (for session persistence)
- **Deployment:** Vercel / Netlify (static hosting)

### Technical Constraints (What We MUST Do)
- ✅ MUST work offline (no server, no API calls)
- ✅ MUST use Date.now() delta tracking for timer precision
- ✅ MUST implement Framer Motion for breathing animations
- ✅ MUST follow Thumb Zone principle (controls in bottom 30%)
- ✅ MUST have touch targets of 48x48px minimum

### Anti-Patterns (What We NEVER Do)
- ❌ NEVER use setInterval for time tracking. ALWAYS use Date.now() delta.
- ❌ NEVER use complex state managers (Redux, Zustand). Use React Context or simple State.
- ❌ NEVER add user accounts (this is a utility tool, not a SaaS)
- ❌ NEVER make network requests (tool must work offline)
- ❌ NEVER store sensitive data in localStorage

---

## 5. Non-Goals (What This App Is NOT)

### Explicitly Out of Scope
- [ ] User authentication / accounts
- [ ] Cloud sync of recipes across devices
- [ ] Social features / sharing
- [ ] Statistics dashboard / analytics
- [ ] Notifications (push notifications)
- [ ] Mobile native app (web-first)

### Why These Are Out:
This is a **utility tool**, not a platform. Adding these features would:
- Require backend infrastructure (increases complexity)
- Slow down time-to-value (now < 10 seconds)
- Violate the "works offline" principle
- Add maintenance burden

---

## 6. Edge Cases & Guardrails

### What Happens When...
- **User closes browser mid-session?** → Persist to localStorage, offer resume on return
- **User has no internet?** → App works perfectly (client-side only)
- **User switches tabs?** → Timer continues in background (use Page Visibility API for pause option)
- **User's phone locks?** → Timer continues but cannot play audio (browser limitation, document in UI)
- **localStorage is full?** → Gracefully degrade, show toast: "Cannot save progress"

### Error States
- **Timer drift detected** (rare): Reset to server time if available, or continue with best effort
- **Animation lag**: Reduce animation complexity on low-end devices (detect via performance API)
- **Invalid localStorage data**: Clear and start fresh, don't crash

---

## 7. Design Philosophy

### Visual Aesthetic
**Minimalist brutalism**: black, white, one accent color per phase. High contrast. Large touch targets. Full-screen timer display.

**Inspiration:** Headspace (calm), Apple Timer (simplicity), Arc browser (polish)

### Interaction Patterns
- **Immediate feedback**: Every tap shows visual response (scale, color change)
- **No confirmation dialogs**: Use undo instead of "Are you sure?"
- **Progressive disclosure**: Hide complexity until needed (settings behind tap)
- **Breathing animations**: Reinforce calm/focus state

### Performance Targets
- Initial load: < 2 seconds
- Interaction response: < 100ms
- Bundle size: < 100kb gzipped
- 60fps animations

---

## 8. Success Metrics (How We Know It Works)

### Technical Success
- [ ] App loads without errors
- [ ] Timer accuracy within ±1 second over 60 minutes
- [ ] No console errors or warnings
- [ ] Lighthouse score > 90 (Performance, Accessibility)
- [ ] Works offline (test with network disabled)

### User Success
- [ ] User can start a recipe in < 10 seconds
- [ ] User can control timer one-handed on mobile
- [ ] Timer completes full recipe without drift
- [ ] User understands current phase without reading labels

---

## 9. Implementation Notes

### The Timer Math (Critical)
```typescript
// ❌ WRONG: setInterval drifts over time
let remaining = 1500;
setInterval(() => remaining--, 1000);

// ✅ CORRECT: Date.now() delta tracking
const startTime = Date.now();
const endTime = startTime + (1500 * 1000);

function updateTimer() {
  const now = Date.now();
  const remaining = Math.max(0, Math.floor((endTime - now) / 1000));
  // Update UI
  if (remaining > 0) {
    requestAnimationFrame(updateTimer);
  }
}
```

### The Breathing Animation
```typescript
<motion.div
  animate={{
    scale: [1, 1.05, 1],
  }}
  transition={{
    duration: 4,
    repeat: Infinity,
    ease: "easeInOut"
  }}
>
  {phaseDisplay}
</motion.div>
```

### LocalStorage Schema
```typescript
interface TimerState {
  recipeId: string;
  currentPhaseIndex: number;
  phaseStartTime: number;  // Unix timestamp
  isPaused: boolean;
}

// Save
localStorage.setItem('timer-state', JSON.stringify(state));

// Load
const saved = localStorage.getItem('timer-state');
const state = saved ? JSON.parse(saved) : null;
```

---

## 10. Prompts for Building

### Initial Build Prompt (to Carpenter AI in IDE)
```
Read @spec.md for full requirements.
Reference @.cursorrules for code standards.

First, create /lib/recipes.ts with the hardcoded RECIPES array from the spec.

Then, create a custom React hook called useRecipeTimer that:
1. Accepts a Recipe object
2. Tracks current phase index and time remaining using Date.now() delta
3. Auto-transitions to next phase when timer hits zero
4. Exposes controls: start, pause, reset, skip
5. Persists state to localStorage

Do NOT build UI components yet. We're building the engine first.
Test the hook in isolation before proceeding.
```

### UI Build Prompt
```
Now build the UI components:

1. RecipeSelector: Grid of recipe cards (name, description, duration)
2. TimerDisplay: Full-screen phase name, countdown, progress indicator
3. Controls: Bottom-fixed bar with Pause, Skip, Reset (Thumb Zone compliant)

Use Framer Motion for breathing animation on active phase.
Follow Tailwind mobile-first approach.
All touch targets must be 48x48px minimum.
```

---

## Notes for the AI Builder

**This spec is your constitution. When in doubt, refer back to this document.**

- If a feature isn't explicitly listed here, don't build it.
- If a constraint says "NEVER," that means never.
- If something is unclear, ask for clarification before implementing.

**Your job is to follow this blueprint precisely, not to improve upon it.**

The user has thought through the architecture, constraints, and edge cases. Trust the spec.
