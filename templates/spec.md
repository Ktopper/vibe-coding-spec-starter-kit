# APP: [Your App Name]

## 1. App Identity

### Core Concept
[One paragraph describing the vision. Who is this for? What job does it do? What is the emotional tone?]

Example:
"Focus Recipes is a client-side timer for people who struggle with task initiation. High-contrast UI. No accounts, no cloud sync. Just open the page and start. The aesthetic is minimalist brutalism: black, white, one accent color."

### Target User
[Be specific. Not "users" but "freelance designers who forget to invoice" or "anxious people who need to break down overwhelming tasks."]

### Value Proposition
[The one thing this app does better than alternatives. The reason someone would use this over something else.]

---

## 2. Data Models

### [Entity Name 1]
```
- id: string
- name: string
- [field_name]: [type]
```

### [Entity Name 2]
```
- id: string
- [field_name]: [type]
- [relationship]: reference to [Entity Name 1]
```

**Design Notes:**
- [Any important relationships between entities]
- [Cascade behaviors or business rules]
- [Why this structure vs alternatives]

---

## 3. User Stories (What Happens, Not How)

### Feature 1: [Feature Name]
**User Action:** [What the user does]
**System Response:** [What happens as a result]
**Success Criteria:** [How we know it worked]

Example:
"**Feature 1: Recipe Selection**
User Action: The user sees a list of pre-defined recipes (Pomodoro, Deep Work, Quick Task). They click one.
System Response: The timer loads with the correct phases and displays the first phase.
Success Criteria: Timer shows correct phase name, duration, and begins countdown."

### Feature 2: [Feature Name]
**User Action:** 
**System Response:** 
**Success Criteria:** 

### Feature 3: [Feature Name]
**User Action:** 
**System Response:** 
**Success Criteria:** 

---

## 4. Technical Stack & Constraints

### Stack
- **Context File:** [e.g., .cursorrules-nextjs]
- **Framework:** [e.g., Next.js 15 (App Router)]
- **Language:** [e.g., TypeScript]
- **Styling:** [e.g., Tailwind CSS]
- **Components:** [e.g., Shadcn/ui]
- **Icons:** [e.g., Lucide React]
- **Database:** [e.g., Supabase / None (client-side only)]
- **Auth:** [e.g., Supabase Auth / None]
- **Deployment:** [e.g., Vercel]

### Technical Constraints (What We MUST Do)
- [ ] [e.g., Must work offline]
- [ ] [e.g., Must be under 50kb initial bundle]
- [ ] [e.g., Must use Server Components by default]

### Anti-Patterns (What We NEVER Do)
- ❌ [e.g., NEVER use the Pages Router. ALWAYS use App Router.]
- ❌ [e.g., NEVER use useEffect for data fetching. ALWAYS use Server Components.]
- ❌ [e.g., NEVER hardcode API keys. ALWAYS use environment variables.]
- ❌ [e.g., Timer must use Date.now() delta tracking, NOT setInterval drift.]

---

## 5. Non-Goals (What This App Is NOT)

### Explicitly Out of Scope
- [ ] [e.g., User accounts / authentication]
- [ ] [e.g., Cloud sync across devices]
- [ ] [e.g., Mobile native apps]
- [ ] [e.g., Real-time collaboration]

### Future Considerations (Not Now, Maybe Later)
- [ ] [Features that might come later but aren't essential for MVP]

---

## 6. Edge Cases & Guardrails

### What Happens When...
- User closes browser mid-session? → [e.g., Progress is lost (acceptable for MVP)]
- User has no internet? → [e.g., App still works (client-side only)]
- User tries to [action]? → [Expected behavior]

### Error States
- [Scenario]: [How we handle it]
- [Scenario]: [How we handle it]

---

## 7. Design Philosophy

### Visual Aesthetic
[e.g., "Minimalist brutalism: black, white, one accent color. High contrast. Large touch targets."]

### Interaction Patterns
[e.g., "Immediate feedback. No confirmation dialogs. Undo instead of 'Are you sure?'"]

### Performance Targets
- Initial load: [e.g., < 2 seconds]
- Interaction response: [e.g., < 100ms]
- Bundle size: [e.g., < 100kb]

---

## 8. Success Metrics (How We Know It Works)

### Technical Success
- [ ] App loads without errors
- [ ] All core features functional
- [ ] No console errors or warnings
- [ ] Passes accessibility audit (Lighthouse)

### User Success
- [ ] User can complete core workflow in < 30 seconds
- [ ] [Specific metric for your app]
- [ ] [Specific metric for your app]

---

## Notes for the AI Builder

**This spec is your constitution. When in doubt, refer back to this document.**

If a feature isn't explicitly listed here, don't build it.
If a constraint says "NEVER," that means never.
If something is unclear, ask for clarification before implementing.

**Your job is to follow this blueprint precisely, not to improve upon it.**
