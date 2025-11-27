# 🎯 BOARDROOM PROMPT LIBRARY

**22 curated prompts for every stage of AI-assisted development**

Based on the Boardroom Strategy: Architect AI plans, Carpenter AI implements.

---

## 📚 TABLE OF CONTENTS

1. [Strategic Planning (Architect)](#strategic-planning-architect)
2. [Implementation (Carpenter)](#implementation-carpenter)
3. [Debugging & Refinement](#debugging--refinement)
4. [Security & Optimization](#security--optimization)
5. [Recovery & Maintenance](#recovery--maintenance)

---

## 🏛️ STRATEGIC PLANNING (Architect)

### Prompt #1: The Architect
**When to use:** Starting a new project or feature  
**Purpose:** High-level planning without implementation

```
You are an Architect AI. Your job is to PLAN, not implement.

Based on spec.md, create a detailed implementation plan for [feature/app].

Include:
1. File structure (which files need to be created/modified)
2. Component hierarchy (if applicable)
3. Data flow (how data moves through the system)
4. External dependencies (APIs, libraries, services)
5. Potential gotchas (edge cases, security concerns)

Do NOT write any code. Only provide the architectural blueprint.
```

---

### Prompt #2: The JTBD Analyst
**When to use:** Before writing spec.md  
**Purpose:** Clarify what problem you're solving

```
Help me define the Jobs To Be Done (JTBD) for my app idea.

My idea: [describe your app in 2-3 sentences]

Ask me clarifying questions about:
1. WHO will use this?
2. WHEN will they use it?
3. WHAT job does it accomplish?
4. WHY existing solutions fail?

Do NOT suggest features. Only help me crystallize the core job.
```

---

### Prompt #3: The Stack Selector
**When to use:** Choosing your tech stack  
**Purpose:** Match stack to requirements

```
Based on these requirements, recommend a tech stack:

Requirements:
- [List your requirements, e.g., "needs AI integration", "real-time updates", "mobile-first"]

Constraints:
- [List constraints, e.g., "must be free tier compatible", "I know Python", "ship in 1 week"]

For each recommendation, explain:
1. Why this stack fits
2. What tradeoffs exist
3. Learning curve estimate
4. Deployment complexity
```

---

## 🔨 IMPLEMENTATION (Carpenter)

### Prompt #4: The Builder
**When to use:** Implementing a planned feature  
**Purpose:** Turn architecture into code

```
You are a Carpenter AI. Implement this feature exactly as specified.

Specification: [paste relevant section from spec.md]
Architecture: [paste plan from Architect AI]

Requirements:
- Follow .cursorrules exactly
- Match the spec precisely
- Include error handling
- Add inline comments for complex logic

Implement now.
```

---

### Prompt #5: The Component Creator
**When to use:** Building a new UI component  
**Purpose:** Create isolated, reusable components

```
Create a [component name] component with these specifications:

Props:
- [List required props and types]

Behavior:
- [Describe expected behavior]

Styling:
- [Describe visual requirements]

Constraints from .cursorrules:
- [Paste relevant constraints]

Make it production-ready: proper types, error handling, accessibility.
```

---

### Prompt #6: The API Integrator
**When to use:** Connecting to external APIs  
**Purpose:** Secure, robust API integration

```
Integrate [API name] with these requirements:

Endpoint: [API endpoint]
Authentication: [auth method]
Expected response: [describe response structure]

Must include:
1. Error handling (network failures, API errors, rate limits)
2. Cost tracking (if applicable)
3. Retry logic with exponential backoff
4. Secure credential management (use environment variables)

Follow the secrets-management.md guidelines.
```

---

### Prompt #7: The Database Designer
**When to use:** Creating database schema  
**Purpose:** Secure, scalable data modeling

```
Design a database schema for [feature/app] with these entities:

Entities: [list entities, e.g., "users, recipes, sessions"]

Relationships:
- [Describe relationships]

Requirements:
- Must support Row-Level Security (RLS)
- User data must be isolated
- Queries must be efficient for [describe scale]

Provide:
1. SQL schema
2. RLS policies
3. Sample queries
4. Security considerations
```

---

## 🐛 DEBUGGING & REFINEMENT

### Prompt #8: The Detective
**When to use:** Something's broken, unclear why  
**Purpose:** Systematic debugging

```
I have a bug. Help me debug systematically.

Symptom: [describe what's happening]
Expected: [describe what should happen]
Context: [relevant code/files]

Walk me through:
1. Hypothesis (what might be wrong)
2. Test (how to verify hypothesis)
3. Fix (if hypothesis is correct)

Do NOT guess. Use the scientific method.
```

---

### Prompt #9: The Optimizer
**When to use:** Code works but feels slow  
**Purpose:** Performance optimization

```
Optimize this [component/function/query]:

[Paste code]

Current performance: [describe current behavior]
Target performance: [describe desired behavior]

Constraints:
- Must maintain current functionality
- Must not sacrifice readability
- Must not introduce security vulnerabilities

Show before/after comparison with explanation.
```

---

### Prompt #10: The Refactorer
**When to use:** Code works but is messy  
**Purpose:** Improve code quality without breaking things

```
Refactor this code to improve [readability/maintainability/testability]:

[Paste code]

Requirements:
- Behavior must remain identical
- Follow .cursorrules patterns
- Extract reusable logic
- Improve naming

Show the refactored version with a summary of changes.
```

---

## 🛡️ SECURITY & OPTIMIZATION

### Prompt #11: The Security Auditor
**When to use:** Before deployment  
**Purpose:** Find security vulnerabilities

```
Audit this [component/API/database schema] for security issues:

[Paste code/schema]

Check for:
1. Authentication bypasses
2. Authorization failures (can users access others' data?)
3. Input validation gaps
4. SQL injection risks
5. XSS vulnerabilities
6. Exposed secrets

Use the pre-launch-security.md checklist as a guide.
```

---

### Prompt #12: The RLS Validator
**When to use:** Implementing Row-Level Security  
**Purpose:** Verify RLS policies are correct

```
Validate these RLS policies:

[Paste RLS policies]

For each policy, verify:
1. Does it prevent User A from accessing User B's data?
2. Does it allow users to access their own data?
3. Are there edge cases where it fails?
4. Is it performant at scale?

Provide test queries to verify each policy.
```

---

### Prompt #13: The Cost Calculator
**When to use:** Using paid APIs (OpenAI, etc.)  
**Purpose:** Estimate and control costs

```
Calculate the cost of this API usage:

API: [API name and pricing model]
Current usage pattern: [describe how you're calling it]
Expected volume: [requests per day/week/month]

Provide:
1. Cost per request
2. Daily/monthly estimates
3. Optimization suggestions
4. Alert thresholds

Include code for real-time cost tracking.
```

---

## 🔄 RECOVERY & MAINTENANCE

### Prompt #14: The Version Control Helper
**When to use:** Git operations and history  
**Purpose:** Proper version control practices

```
Help me [commit/branch/merge/revert] with best practices.

Current situation: [describe current state]
Goal: [what you want to achieve]

Provide:
1. Exact git commands
2. Commit message (if applicable)
3. Potential risks
4. Rollback strategy
```

---

### Prompt #15: The Deployment Guide
**When to use:** Deploying to production  
**Purpose:** Safe, repeatable deployments

```
Create a deployment checklist for [platform, e.g., Vercel, Render]:

App: [description]
Stack: [your stack]
Environment variables: [list them]

Include:
1. Pre-deployment checklist
2. Deployment steps
3. Post-deployment verification
4. Rollback procedure
5. Monitoring setup
```

---

### Prompt #16: The Documentation Writer
**When to use:** Need to document your code  
**Purpose:** Clear, maintainable documentation

```
Document this [file/component/API]:

[Paste code]

Create:
1. README section explaining purpose
2. Inline comments for complex logic
3. API documentation (if applicable)
4. Usage examples

Keep it concise and maintainable.
```

---

### Prompt #17: The Test Generator
**When to use:** Need to add tests  
**Purpose:** Comprehensive test coverage

```
Generate tests for:

[Paste code]

Test types needed:
- [Unit/Integration/E2E]

Coverage requirements:
1. Happy path
2. Edge cases
3. Error conditions
4. Security boundaries (if applicable)

Use [testing framework] and follow .cursorrules patterns.
```

---

## 🚨 EMERGENCY PROMPTS

### Prompt #18: The Rollback Specialist
**When to use:** Production is broken  
**Purpose:** Quick recovery

```
PRODUCTION EMERGENCY

What's broken: [describe issue]
When it broke: [timestamp/deployment]
Impact: [who's affected]

Provide:
1. Immediate rollback steps
2. Verification that rollback worked
3. Root cause analysis
4. Prevention strategy

Be concise. Speed matters.
```

---

### Prompt #19: The Dependency Doctor
**When to use:** Package/dependency issues  
**Purpose:** Resolve dependency conflicts

```
I have a dependency issue:

Error: [paste error message]
Environment: [Node version, package manager, OS]
Current dependencies: [paste relevant package.json section]

Provide:
1. Root cause
2. Resolution steps
3. Commands to run
4. Verification method
```

---

### Prompt #20: The Migration Manager
**When to use:** Database schema changes  
**Purpose:** Safe data migrations

```
Create a migration for:

Change: [describe schema change]
Current schema: [paste current schema]
Data to preserve: [describe existing data]

Provide:
1. Migration SQL (up and down)
2. Data transformation logic
3. Rollback procedure
4. Testing checklist

Ensure zero data loss.
```

---

## 🎭 SPECIAL SITUATION PROMPTS

### Prompt #21: The Context Refresh
**When to use:** AI starts ignoring your rules  
**Purpose:** Reset AI context to spec

```
CONTEXT REFRESH

You have drifted from the specification. Let's reset.

Re-read:
1. spec.md in its entirety
2. .cursorrules file
3. The last 3 changes I requested

Now, acknowledge:
- What the core job of this app is
- What constraints you must follow
- What we're currently working on

Only proceed after confirming understanding.
```

---

### Prompt #22: The System Poet
**When to use:** Feeling overwhelmed or lost  
**Purpose:** Step back and reframe

```
I'm stuck. Help me step back and see the big picture.

Current situation: [describe where you are]
What I've tried: [list attempts]
What's not working: [describe frustration]

Help me:
1. Reframe the problem
2. Identify what I'm missing
3. Suggest a completely different approach
4. Break it into smaller steps

Be creative. Challenge my assumptions.
```

---

## 📋 HOW TO USE THIS LIBRARY

### 1. Copy-Paste, Don't Memorize
These prompts are templates. Customize with your context.

### 2. Follow the Boardroom Strategy
- **Architect prompts** → Planning, no code
- **Carpenter prompts** → Implementation, actual code
- Never mix them in one session

### 3. Chain Prompts for Complex Work
Example flow:
1. Use Prompt #1 (Architect) → Get plan
2. Use Prompt #4 (Builder) → Implement
3. Use Prompt #11 (Security Auditor) → Verify
4. Use Prompt #15 (Deployment Guide) → Ship

### 4. Customize for Your Stack
Replace placeholders:
- `[testing framework]` → Jest, Pytest, etc.
- `[API name]` → OpenAI, Stripe, etc.
- `[platform]` → Vercel, Render, etc.

### 5. Save Your Best Variations
When you find a prompt variation that works great, save it.

---

## 🎯 PROMPT EFFECTIVENESS TIPS

### DO:
- ✅ Be specific about constraints
- ✅ Reference spec.md and .cursorrules
- ✅ Ask for explanations, not just code
- ✅ Request verification steps
- ✅ Break complex requests into steps

### DON'T:
- ❌ Ask Architect to implement
- ❌ Ask Carpenter to redesign
- ❌ Skip security considerations
- ❌ Ignore errors and push forward
- ❌ Accept "I'll add that later" responses

---

## 📚 RELATED RESOURCES

- **spec.md template** → Your app constitution
- **.cursorrules templates** → Stack-specific constraints
- **pre-launch-security.md** → Security checklist
- **blueprints/** → Example apps using these prompts

---

## 🎓 LEARNING PATH

### Week 1: Strategic Prompts
Focus on Prompts #1-3 (planning before building)

### Week 2: Implementation Prompts
Master Prompts #4-7 (turning plans into code)

### Week 3: Debugging Prompts
Practice Prompts #8-10 (fixing and refining)

### Week 4: Advanced Prompts
Explore Prompts #11-22 (security, deployment, recovery)

---

**Remember:** These prompts are tools, not scripts. Adapt them to your needs. The goal is clear communication with AI, not rigid adherence.

**Now go build something amazing! 🚀**

---

**Version:** 1.0.0  
**Last Updated:** November 27, 2024  
**Status:** Production Ready  
**Contributors:** Based on "Vibe Coding Done Right" methodology
