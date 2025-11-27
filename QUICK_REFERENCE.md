# Quick Reference: What File Do I Need?

## 🎯 "I'm Starting a New Project"

**Start here:**
1. Copy `templates/spec.md` to your project root
2. Use prompts 1-3 from `prompts/boardroom-prompt-library.md` to fill it out
3. Copy the appropriate `.cursorrules` file based on your stack:

| Building... | Copy this file |
|-------------|---------------|
| Web app (React/Next.js) | `templates/.cursorrules-nextjs` |
| AI tool (Python/Streamlit) | `templates/.cursorrules-python` |
| Simple calculator/converter | `templates/.cursorrules-utility` |
| Multi-user SaaS | `templates/.cursorrules-saas` |

---

## 🔍 "I Need Help With..."

### Planning & Architecture
→ `prompts/boardroom-prompt-library.md` (Prompts 1-5)

### Writing Good Prompts
→ `prompts/boardroom-prompt-library.md` (All 20 prompts organized by task)

### Understanding User Needs
→ `worksheets/jtbd-worksheet.md`

### Managing API Keys
→ `checklists/secrets-management.md`

### Security Best Practices
→ `templates/universal-constraints.md` (principles)
→ `checklists/pre-launch-security.md` (verification)

### Debugging
→ `prompts/boardroom-prompt-library.md` (Prompts 11-13)

### UI/UX Polish
→ `prompts/boardroom-prompt-library.md` (Prompts 14-16)
→ `worksheets/jtbd-worksheet.md`

### Pre-Launch Checklist
→ `checklists/pre-launch-security.md`

---

## 📚 "What Chapter of the Book is This From?"

| File | Book Chapter |
|------|--------------|
| `templates/spec.md` | Chapter 4 |
| All `.cursorrules` files | Chapter 5 |
| `templates/universal-constraints.md` | Chapter 5 |
| `checklists/secrets-management.md` | Chapters 7, 10 |
| `worksheets/jtbd-worksheet.md` | Chapter 9 |
| `checklists/pre-launch-security.md` | Chapter 10 |
| `prompts/boardroom-prompt-library.md` | Appendix C |

---

## 🔧 "How Do I Actually Use These Files?"

### Templates → Copy & Customize
```bash
# Copy the file to your project
cp templates/spec.md ./spec.md

# Edit it for your specific project
# Don't just use the placeholder text!
```

### .cursorrules → Project Context
```bash
# Copy to your project root (exact filename)
cp templates/.cursorrules-nextjs ./.cursorrules

# Your AI tool (Cursor, Copilot) will read it automatically
# Customize the rules for your project
```

### Prompts → Copy & Paste
```markdown
# Open the file
# Find the prompt you need
# Copy it
# Paste into Claude/ChatGPT/Cursor
# Replace [brackets] with your specifics
```

### Checklists → Work Through Step-by-Step
```markdown
# Open the checklist
# Work through each item
# Check boxes as you complete them
# Don't skip any (they're all critical)
```

### Worksheets → Fill Out Before Building
```markdown
# Complete the worksheet
# Answer every question honestly
# Use insights to guide your design decisions
```

---

## ⚡ Common Workflows

### Workflow 1: Starting From Scratch
1. Fill out `worksheets/jtbd-worksheet.md` (understand the problem)
2. Use Architect prompts 1-3 from `prompts/` (design the solution)
3. Fill out `templates/spec.md` (document the plan)
4. Copy relevant `.cursorrules` file (configure AI assistant)
5. Build using implementation prompts 6-10 from `prompts/`
6. Polish using prompts 14-16 from `prompts/`
7. Complete `checklists/pre-launch-security.md` (before shipping)

### Workflow 2: Adding Features to Existing App
1. Update `spec.md` with new feature requirements
2. Use feature implementation prompts 6-10 from `prompts/`
3. Test immediately (don't build multiple features first)
4. Update `.cursorrules` if you discovered new anti-patterns

### Workflow 3: Debugging Issues
1. Use debug prompts 11-13 from `prompts/`
2. If same bug happens 3 times → add rule to `.cursorrules`
3. This is the "Discovery Loop" from Chapter 5

### Workflow 4: Security Audit
1. Work through `checklists/secrets-management.md`
2. Work through `checklists/pre-launch-security.md`
3. Review `templates/universal-constraints.md` for principles
4. Don't skip any items (they're all critical)

---

## 💡 Pro Tips

### On spec.md
- Fill it out BEFORE coding
- Update it as requirements change
- Reference it in every prompt: "Read @spec.md..."

### On .cursorrules
- Start with provided template
- Add project-specific rules as you go
- Delete rules that don't apply to your project
- Keep it under 100 lines (AI stops paying attention after that)

### On Prompts
- Don't copy-paste blindly
- Replace [brackets] with your specifics
- Combine multiple prompts for complex tasks
- Reference files with @filename (if your IDE supports it)

### On Checklists
- Complete before shipping, not after
- Check every box (don't skip "obvious" ones)
- If you can't check a box, you're not ready to ship

### On Worksheets
- Take them seriously (they save hours later)
- Answer honestly (don't just fill in what sounds good)
- Use insights to actually guide decisions

---

## 🚨 Critical Reminders

### NEVER Skip These Files:
1. `checklists/secrets-management.md` - Prevents expensive mistakes
2. `checklists/pre-launch-security.md` - Prevents catastrophic failures
3. `templates/spec.md` - Saves hours of confused AI conversations

### ALWAYS Customize These Files:
1. `.cursorrules` - Add your project-specific rules
2. `spec.md` - Replace ALL placeholder text
3. Prompts - Replace [brackets] with your actual values

### Reference Often:
1. `templates/universal-constraints.md` - Security principles
2. `prompts/boardroom-prompt-library.md` - When stuck on what to prompt
3. `worksheets/jtbd-worksheet.md` - When making design decisions

---

## 📞 "Something's Not Working"

### If AI isn't following your rules:
- Check that .cursorrules is in project root
- Verify filename is exactly `.cursorrules` (note the dot)
- Try explicitly referencing it: "Follow @.cursorrules"
- File might be too long (keep under 100 lines)

### If spec.md isn't helping:
- You might not be referencing it: use "@spec.md" in prompts
- It might be too vague: be more specific about data structures
- It might be incomplete: fill out ALL sections

### If checklists seem overwhelming:
- They're supposed to be comprehensive
- Work through one section at a time
- You're building production software (this is the minimum)

---

**Remember: These tools are only as good as you make them. Customize, adapt, and improve them for your specific needs.**
