# APP: Focus Recipes

## 1. App Identity

**Core Concept**  
A "playlist" timer for deep work. Users select a Recipe (a sequence of timed phases) and the app guides them through it. Think Headspace meets Pomodoro—calm, deliberate, designed for focus.

**Target User**  
Knowledge workers who struggle with task initiation and need structure to enter flow state. Writers, developers, designers who know what deep work feels like but need help getting there.

**Value Proposition**  
Unlike standard timers that just count down, Focus Recipes orchestrates your energy through distinct phases: Focus, Decompress, Review. Each phase has its own duration, color, and rhythm. The timer doesn't just measure time—it conducts your attention.

---

## 2. Data Models

### Recipe
```typescript
{
  id: string;
  name: string;
  description: string;
  phases: Phase[];
}
```

**Example:** "The 90-Minute Deep Dive" with phases for Warm Up, Deep Work, Decompress.

### Phase
```typescript
{
  name: string;
  duration_seconds: number;
  theme_color: string;  // hex code
  animation_type: 'breathing' | 'pulse' | 'static';
}
```

**Example:** { name: 'Deep Work', duration_seconds: 5400, theme_color: '#8B5CF6', animation_type: 'breathing' }

### Hardcoded Recipes (No Database)

**Recipe 1: Classic Pomodoro**
- Focus (25 min, red, breathing)
- Break (5 min, green, pulse)
- Focus (25 min, red, breathing)
- Long Break (15 min, blue, static)

**Recipe 2: The 90-Minute Deep Dive**
- Warm Up (10 min, amber, pulse)
- Deep Work (90 min, purple, breathing)
- Decompress (15 min, green, pulse)

**Recipe 3: Sprint & Reflect**
- Sprint (45 min, indigo, breathing)
- Reflect (10 min, teal, static)
- Break (5 min, green, pulse)

---

## 3. User Stories

### Story 1: Starting a Focus Session

**User Action:** User opens app, sees recipe grid, taps "The 90-Minute Deep Dive"

**System Response:**
- Timer starts immediately (no confirmation dialog)
- Background color shifts to first phase theme (amber)
- Phase name displays large and centered
- Countdown shows remaining time
- Gentle breathing animation begins

**Success Criteria:**
- Time-to-value under 10 seconds (open → focus)
- Timer uses Date.now() delta tracking (no drift)
- Auto-transitions to next phase at 0:00
- Visual feedback on every phase change
- Progress indicator shows current position (Phase 1 of 3)

### Story 2: Mid-Session Control

**User Action:** During deep work phase, user needs to pause

**System Response:**
- Tap pause button (bottom of screen)
- Timer freezes, animation stops
- "Paused" state is obvious
- Tap again to resume from exact moment

**Success Criteria:**
- All controls in bottom 30% of screen (thumb zone)
- Touch targets minimum 48x48px
- Pause state persists if user switches tabs
- No accidental taps (adequate spacing between buttons)

### Story 3: Session Interruption

**User Action:** User closes browser mid-session to take urgent call

**System Response:**
- On return, show simple prompt: "Resume session?"
- If yes: Restore exact point in recipe
- If no: Clear state, show recipe selector

**Success Criteria:**
- Uses localStorage to persist state
- Stores recipe ID, phase index, exact timestamp
- Handles localStorage full gracefully (clear old data)
- Works offline (no server needed)

---

## 4. Technical Stack & Constraints

### Stack
- **Framework:** React 19 + Vite
- **Language:** TypeScript 5.x
- **Styling:** Tailwind CSS 4.0
- **Animation:** Framer Motion
- **Icons:** Lucide React
- **Storage:** localStorage (session persistence only)
- **Deployment:** Vercel or Netlify (static hosting)

### Technical Constraints (MUST DO)

**MUST work offline**  
No server. No API calls. Pure client-side. This is a utility tool, not a web service.

**MUST use Date.now() delta tracking**  
Timer precision requires delta calculation. setInterval drifts. Date.now() doesn't.

**MUST implement breathing animations**  
Framer Motion for smooth, calming visual rhythm. Not decorative—functional. Reinforces focus state.

**MUST follow Thumb Zone principle**  
All primary controls in bottom 30% of screen. All touch targets 48x48px minimum. One-handed operation on mobile.

**MUST handle browser backgrounding**  
Timer continues when tab loses focus. Use Page Visibility API if implementing auto-pause feature.

### Anti-Patterns (NEVER DO)

**NEVER use setInterval for time tracking**  
Reason: Browser throttles inactive tabs, causing drift. Always use Date.now() delta.

**NEVER add complex state management**  
Reason: React Context or simple useState is sufficient. No Redux. No Zustand. Overkill for this scope.

**NEVER require user accounts**  
Reason: This is a utility tool, not a SaaS. Authentication would violate "works offline" and add friction.

**NEVER make network requests**  
Reason: Tool must work on airplane, in basement, during internet outage. Zero dependencies on connectivity.

**NEVER store sensitive data in localStorage**  
Reason: localStorage is not encrypted. Timer state is fine. Personal notes are not.

---

## 5. Non-Goals

### Out of Scope

**User authentication & accounts**  
Why: Adds complexity, requires backend, violates offline principle. Users don't need identity for a timer.

**Cloud sync across devices**  
Why: Requires backend, authentication, conflict resolution. Beyond scope of utility tool.

**Social features & sharing**  
Why: This is a personal focus tool, not a social platform. Sharing sessions adds no value to core job.

**Statistics dashboard & analytics**  
Why: Would require data persistence, charting libraries, analysis features. Belongs in SaaS version, not utility.

**Push notifications**  
Why: Browser notification APIs are unreliable. Audio cues at phase transitions are sufficient.

**Native mobile app**  
Why: Web-first approach. PWA capabilities sufficient. Native app is 10x more maintenance.

### Why These Are Out

This is a **utility tool**. Adding these features would:
- Require backend infrastructure (against offline principle)
- Slow time-to-value from 10 seconds to 10 minutes
- Add ongoing maintenance burden
- Transform simple tool into complex platform

If user needs these features, they need a different product.

---

## 6. Edge Cases & Guardrails

### Scenario: User closes browser mid-session

**Expected Behavior:** Persist state to localStorage. On return, show "Resume session?" with Yes/No options.

**Implementation:** Save { recipeId, phaseIndex, startTimestamp, isPaused } every second.

### Scenario: User has no internet connection

**Expected Behavior:** App works perfectly. All assets cached. No error messages about connectivity.

**Implementation:** Vite builds everything into static bundle. No external dependencies at runtime.

### Scenario: User switches to another tab

**Expected Behavior:** Timer continues counting in background. Optional: Detect via Page Visibility API and show "Paused (backgrounded)" state.

**Implementation:** Date.now() delta continues regardless of tab focus. Add visibility listener if auto-pause desired.

### Scenario: User's phone locks during session

**Expected Behavior:** Timer continues. Audio notifications won't play (browser limitation). Document this in UI: "Keep screen on for audio cues."

**Implementation:** Can't override iOS/Android screen lock. Accept this limitation.

### Scenario: localStorage quota exceeded

**Expected Behavior:** Show toast: "Cannot save progress. Clear browser data." Don't crash app.

**Implementation:** Wrap localStorage.setItem in try/catch. Log error. Continue functioning without persistence.

### Scenario: Timer drift detected (rare)

**Expected Behavior:** Continue with best-effort accuracy. Don't reset or show error.

**Implementation:** Date.now() delta is already drift-proof. Only edge case is system clock changes (very rare).

---

## 7. Design Philosophy

### Visual Aesthetic

**Minimalist brutalism:** Black text, white backgrounds, one bold accent color per phase. High contrast. Large typography. Zero decorative elements.

**Inspiration:** 
- Headspace (calm, focused)
- Apple Timer (simple, clear)
- Arc browser (polished, delightful)

### Interaction Principles

**Immediate feedback:** Every tap shows visual response (scale animation, color shift). No dead clicks.

**No confirmation dialogs:** Use undo patterns instead of "Are you sure?" interruptions. If user taps Reset, just reset—provide brief undo window.

**Progressive disclosure:** Hide advanced features until needed. Settings behind single tap. No overwhelming feature lists.

**Breathing animations:** Reinforce calm state. Not decorative—functional. Slow, gentle rhythm matches focus breathing.

### Performance Targets

- Initial load: < 2 seconds
- Interaction response: < 100ms
- Bundle size: < 100kb gzipped
- Animations: 60fps minimum
- Lighthouse score: > 90 across all categories

---

## 8. Success Metrics

### Technical Success Criteria

- [ ] App loads without console errors
- [ ] Timer accuracy within ±1 second over 60 minutes
- [ ] No console warnings in production build
- [ ] Lighthouse Performance score > 90
- [ ] Lighthouse Accessibility score > 90
- [ ] Works offline (test with DevTools network disabled)
- [ ] Animations maintain 60fps on mobile

### User Success Criteria

- [ ] User starts focus session in < 10 seconds
- [ ] User controls timer one-handed on mobile
- [ ] Timer completes full recipe without drift
- [ ] User understands current phase without reading
- [ ] Phase transitions feel smooth, not jarring
- [ ] User can pause/resume without confusion

---

## 9. Implementation Notes

### The Timer Engine (Critical)

**WRONG approach:**
```typescript
let remaining = 1500;
setInterval(() => remaining--, 1000);  // DRIFTS over time
```

**CORRECT approach:**
```typescript
const startTime = Date.now();
const endTime = startTime + (durationSeconds * 1000);

function updateTimer() {
  const now = Date.now();
  const remaining = Math.max(0, Math.floor((endTime - now) / 1000));
  
  if (remaining > 0) {
    requestAnimationFrame(updateTimer);
  } else {
    transitionToNextPhase();
  }
}
```

**Why this works:** Date.now() is immune to browser throttling. Always accurate.

### The Breathing Animation

```typescript
<motion.div
  animate={{ scale: [1, 1.05, 1] }}
  transition={{
    duration: 4,
    repeat: Infinity,
    ease: "easeInOut"
  }}
>
  <h1>{phaseName}</h1>
  <p>{formatTime(remaining)}</p>
</motion.div>
```

**Design note:** 4-second cycle matches natural breathing rhythm. Don't speed this up.

### LocalStorage Schema

```typescript
interface TimerState {
  recipeId: string;
  currentPhaseIndex: number;
  phaseStartTime: number;  // Unix timestamp
  isPaused: boolean;
}

// Save on every tick
localStorage.setItem('timer-state', JSON.stringify(state));

// Load on mount
const saved = localStorage.getItem('timer-state');
const state = saved ? JSON.parse(saved) : null;
```

---

## 10. Build Prompts

### Prompt 1: Build the Engine First

```
Read this entire spec.md file.
Reference .cursorrules-utility for code standards.

First task: Create /lib/recipes.ts with the hardcoded RECIPES array.
Include all three recipes from section 2 (Pomodoro, Deep Dive, Sprint & Reflect).

Second task: Create a custom React hook called useRecipeTimer.
This hook should:
- Accept a Recipe object as input
- Track current phase index
- Calculate time remaining using Date.now() delta (NOT setInterval)
- Auto-transition to next phase when timer reaches zero
- Expose these controls: start(), pause(), reset(), skipPhase()
- Persist state to localStorage on every update

Do NOT build UI components yet.
Test the hook in isolation with console logs.
Show me the hook implementation when done.
```

### Prompt 2: Build the UI Components

```
Now build three UI components:

1. RecipeSelector component
   - Grid layout of recipe cards
   - Show recipe name, description, total duration
   - Tap to select and start

2. TimerDisplay component
   - Full-screen phase name (large, centered)
   - Countdown timer (formatted as MM:SS)
   - Progress indicator (Phase X of Y)
   - Apply phase theme_color to background
   - Implement Framer Motion breathing animation

3. Controls component
   - Fixed to bottom of screen (Thumb Zone)
   - Three buttons: Pause/Resume, Skip, Reset
   - Touch targets 48x48px minimum
   - Visual feedback on tap (scale animation)

Use Tailwind mobile-first approach.
Follow Thumb Zone principle (controls in bottom 30%).
Apply Framer Motion breathing to active timer display.
```

### Prompt 3: Add Polish

```
Add these finishing touches:

1. Resume Session Dialog
   - Check localStorage on mount
   - If saved state exists, show modal: "Resume session?"
   - Yes button restores exact timer state
   - No button clears localStorage and shows selector

2. Phase Transition Effects
   - Smooth color transitions (300ms ease)
   - Brief haptic feedback if supported
   - Optional: Subtle sound (single chime)

3. Accessibility
   - Add ARIA labels to all buttons
   - Ensure color contrast > 4.5:1
   - Test keyboard navigation
   - Add reduced-motion media query support

4. Error Handling
   - Wrap localStorage in try/catch
   - Show toast if storage fails
   - Gracefully degrade to no-persistence mode
```

---

## Notes for the AI

This spec is your contract. When in doubt, refer back to this document.

**If a feature isn't explicitly listed here, don't build it.**  
**If a constraint says NEVER, that means never.**  
**If something is unclear, ask before implementing.**

Your job is to follow this blueprint precisely, not to improve upon it. The user has already thought through the architecture, constraints, and edge cases.

Trust the spec. Build what's specified. Nothing more, nothing less.