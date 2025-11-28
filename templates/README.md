# .cursorrules Templates
## "God Mode" Context Files for AI-Assisted Development

These templates implement the **5 Triggers framework** and **Discovery Loop** from Chapter 5: Context Engineering.

---

## 📦 What's Included

### 1. **god-mode-nextjs.cursorrules**
For Next.js + React + TypeScript projects

**Covers:**
- Next.js 15 App Router patterns
- React 19 best practices
- TypeScript type safety
- Tailwind CSS 4 styling
- Server Components vs Client Components
- Server Actions with Zod validation
- Security and accessibility

**Use for:** Web apps, SaaS platforms, client-facing applications

---

### 2. **god-mode-python.cursorrules**
For Python + Streamlit + FastAPI projects

**Covers:**
- Python 3.11+ modern syntax
- Streamlit 1.x patterns (session state, caching, forms)
- FastAPI REST API design
- Type hints and Pydantic validation
- OpenAI API integration best practices
- Security and error handling

**Use for:** Data apps, AI wrappers, dashboards, internal tools

---

### 3. **universal-constraints.md**
Stack-agnostic security rules

**Covers:**
- Secrets management (NEVER hardcode API keys)
- Input validation (SQL injection prevention)
- Authentication & authorization
- Rate limiting patterns
- Error handling
- Accessibility
- Deployment checklist

**Use for:** Every project, alongside stack-specific rules

---

## 🚀 How to Use

### Step 1: Choose Your Template

Pick the template that matches your tech stack:
- Building with Next.js? → Use `god-mode-nextjs.cursorrules`
- Building with Python? → Use `god-mode-python.cursorrules`
- Security rules apply to everything? → Use `universal-constraints.md`

### Step 2: Copy to Your Project

**For Cursor:**
```bash
cp god-mode-nextjs.cursorrules /path/to/your/project/.cursorrules
```

**For GitHub Copilot:**
```bash
mkdir -p /path/to/your/project/.github
cp god-mode-nextjs.cursorrules /path/to/your/project/.github/copilot-instructions.md
```

**For Windsurf:**
```bash
cp god-mode-nextjs.cursorrules /path/to/your/project/.windsurfrules
```

**For any IDE (manual reference):**
```bash
cp god-mode-nextjs.cursorrules /path/to/your/project/project-instructions.md
# Then reference it: "@project-instructions.md"
```

### Step 3: Customize

**Required:**
- Replace `[PROJECT_NAME]` with your actual project name
- Update version numbers if using different versions
- Add project-specific rules as you discover them

**Optional:**
- Remove rules that don't apply to your project
- Merge with `universal-constraints.md` for comprehensive coverage
- Add team-specific preferences

### Step 4: Commit

```bash
git add .cursorrules
git commit -m "Add context engineering rules"
```

Now your AI assistant reads these rules automatically on every interaction.

---

## 🎯 The 5 Triggers Framework

Each template implements the 5 psychological triggers that shape AI behavior:

### 1. **Identity** 
Sets the AI's persona and expertise level
```
You are a Senior Full-Stack Engineer with expertise in...
```

### 2. **Time-Lock**
Forces planning before implementation
```
Before writing any code:
1. Understand the problem completely
2. Identify edge cases
3. Plan your approach
4. Then implement
```

### 3. **Guardrails**
Sets hard boundaries on what AI can modify
```
NEVER modify files in /node_modules
NEVER delete configuration files
```

### 4. **Behavior**
Encodes your architectural preferences
```
ALWAYS use functional components with hooks
ALWAYS use Server Components for data fetching
```

### 5. **Anti-Patterns**
Bans specific problematic approaches
```
NEVER use setInterval for timers (causes drift)
NEVER hardcode API keys in source files
```

---

## 🔄 The Discovery Loop

Don't write all rules on day one. **Grow your .cursorrules through pain.**

### The Three-Strike Rule

**Strike 1:** AI makes a mistake → Correct it in the prompt  
**Strike 2:** AI makes same mistake again → Notice pattern  
**Strike 3:** AI makes mistake third time → Add rule to `.cursorrules`

### Example

**Strike 1:** AI uses `setInterval` for timer, causes drift  
→ You correct: "Use Date.now() delta instead"

**Strike 2:** Next feature, AI uses `setInterval` again  
→ You correct again, make mental note

**Strike 3:** Third time, same mistake  
→ Add to `.cursorrules`: "NEVER use setInterval for timers. ALWAYS use Date.now() delta tracking."

**Result:** Bug prevented permanently. No more corrections needed.

---

## 📏 Best Practices

### Keep It Focused
- Aim for < 100 lines (AI attention span limit)
- Only keep rules that prevent recurring issues
- Delete obvious rules after a few months

### Be Specific
- ❌ Bad: "Write clean code"
- ✅ Good: "ALWAYS use functional components, NEVER use class components"

### Update Monthly
- Prune obsolete rules (AI learned them)
- Update version numbers
- Add new discoveries from recent bugs

### Version Lock When Needed
- Specify framework versions if patterns changed
- Example: "Next.js 15 App Router, NOT Pages Router"
- Prevents AI from using outdated patterns

---

## 🎓 Chapter Reference

These templates implement concepts from:
- **Chapter 5:** Context Engineering
  - The 5 Triggers framework
  - The Discovery Loop
  - The 100-Line Rule
  - Monthly maintenance

Learn the full methodology in the book for deeper understanding.

---

## 💡 Usage Examples

### Example 1: Starting a New Next.js Project

```bash
# Copy template
cp templates/cursorrules/god-mode-nextjs.cursorrules .cursorrules

# Customize
sed -i 's/\[PROJECT_NAME\]/MyAwesomeApp/g' .cursorrules

# Commit
git add .cursorrules
git commit -m "Add AI context engineering"

# Start coding
# Open Cursor, start prompting - AI automatically follows rules
```

### Example 2: Adding Universal Security

```bash
# Copy both templates
cp templates/cursorrules/god-mode-nextjs.cursorrules .cursorrules
cp templates/cursorrules/universal-constraints.md .

# Reference in prompts
# "Read @.cursorrules and @universal-constraints.md before implementing"
```

### Example 3: Multi-Language Project

```bash
# Python backend
cp templates/cursorrules/god-mode-python.cursorrules backend/.cursorrules

# Next.js frontend
cp templates/cursorrules/god-mode-nextjs.cursorrules frontend/.cursorrules

# Each folder has its own context
```

---

## 🔧 Customization Guide

### For Your Team

Add team-specific conventions:
```
# TEAM CONVENTIONS

## Code Review
- All PRs require 2 approvals
- Run tests before requesting review

## Naming
- Feature branches: feature/TICKET-123-description
- Commit messages: type(scope): description
```

### For Your Company

Add company policies:
```
# COMPANY POLICIES

## Legal
- NEVER store PII without encryption
- ALWAYS include terms of service acceptance

## Branding
- Use company color palette: #1234AB, #5678CD
- Follow design system at design.company.com
```

### For Your Project

Add project-specific rules discovered through bugs:
```
# PROJECT-SPECIFIC

## Our Auth Flow
- Use @/lib/auth/getSession not @/lib/getUser
- Redirect to /onboarding for new users, not /dashboard

## Our Database
- NEVER query without tenant_id filter
- ALWAYS use RLS policies, not app-level checks
```

---

## ⚠️ Common Mistakes

### Mistake 1: Too Generic
❌ "Write good code"  
✅ "ALWAYS use TypeScript strict mode. NEVER use `any` type."

### Mistake 2: Too Long
- File exceeds 200 lines
- AI starts ignoring rules
- **Solution:** Keep < 100 lines, be selective

### Mistake 3: Never Updated
- Rules written 6 months ago
- Framework updated, rules outdated
- **Solution:** Monthly audit and prune

### Mistake 4: Not Using Discovery Loop
- Trying to write perfect rules on day 1
- Rules don't reflect actual pain points
- **Solution:** Add rules after 3rd occurrence of bug

---

## 📊 Before & After

### Before .cursorrules

**You:** "Build a user profile component"  
**AI:** Uses class components, inline styles, no TypeScript  
**You:** "No, use functional components, Tailwind, and TypeScript"  
**AI:** Fixes it  
**Next feature...**  
**AI:** Uses class components again  
**You:** (frustrated) "I said functional components!"

### After .cursorrules

**You:** "Build a user profile component"  
**AI:** Uses functional components, Tailwind, full TypeScript, follows your conventions  
**You:** "Perfect!"  
**Next feature...**  
**AI:** Still follows your conventions automatically

---

## 🚀 Success Metrics

You'll know your .cursorrules is working when:
- ✅ AI generates code in your style on first try
- ✅ You stop correcting the same mistakes
- ✅ New team members onboard faster (AI teaches them your conventions)
- ✅ Code review comments decrease (AI follows standards)
- ✅ Fewer bugs from preventable anti-patterns

---

## 🤝 Contributing

Found a useful rule? Share it!

1. Add to your `.cursorrules` using Discovery Loop
2. Test it prevents the bug
3. Share in community Discord or GitHub

Good rules benefit everyone.

---

## 📚 Further Reading

- Book: "Vibe Coding Done Right" - Chapter 5: Context Engineering
- Documentation: Your IDE's context file documentation
- Community: #vibe-coding-done-right on Discord

---

## ⚖️ License

MIT License - Use these templates however you want

---

## 🙏 Credits

Created from real projects and thousands of hours debugging AI-generated code.

Based on the S.P.E.C. Method and System Poet philosophy from "Vibe Coding Done Right."

---

**Remember:** The best .cursorrules file is the one you actually maintain. Start simple, grow through pain, prune monthly.

**Now go build something.** 🚀
