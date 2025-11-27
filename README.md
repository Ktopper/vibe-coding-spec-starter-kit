# Vibe Coding Done Right - Starter Kit

**Companion repository for "Vibe Coding Done Right: The Micro-App Playbook for Creators Who Ship"**

This repository contains all the templates, prompts, checklists, and resources referenced throughout the book—production-ready files you can use immediately to build secure, scalable micro-apps with AI.

---

## 📦 What's Inside

### 🏗️ App Blueprints (`/blueprints`)
Don't copy my code—generate your own using these battle-tested specifications:

- **focus-recipes.md** - The Client-Side Logic App (Chapter 6)
- **resume-roaster.md** - The AI Wrapper App (Chapter 7)
- **saas-foundation.md** - The Multiplayer SaaS (Chapter 8)

Each blueprint is a complete specification ready to drag into Cursor and say "Build this."

### Templates (`/templates`)
Ready-to-use configuration files for different project types:

- **spec.md** - The golden specification template (Chapter 4)
- **.cursorrules-nextjs** - Next.js + TypeScript configuration (Chapter 5)
- **.cursorrules-python** - Python + Streamlit configuration (Chapter 5)
- **.cursorrules-utility** - Client-side utility tool configuration (Chapter 5)
- **.cursorrules-saas** - Full-stack SaaS configuration (Chapter 5)
- **universal-constraints.md** - Stack-agnostic security rules (Chapter 5)

### Prompts (`/prompts`)
Battle-tested prompts organized by task type:

- **boardroom-prompt-library.md** - 22 prompts for every development stage (Appendix C)
  - Strategic planning (Architect prompts)
  - Database design
  - Feature implementation
  - Debugging & refinement
  - UI/UX polish
  - Security audits

### Checklists (`/checklists`)
Essential verification checklists:

- **pre-launch-security.md** - 15-point security verification (Chapter 10)
- **secrets-management.md** - API key protection workflow (Chapter 7, 10)

### Worksheets (`/worksheets`)
Frameworks for better decision-making:

- **jtbd-worksheet.md** - Jobs To Be Done analysis (Chapter 9)

---

## 🚀 Quick Start

### 1. Choose Your Stack

**Building a web app or SaaS?**
```bash
cp templates/.cursorrules-nextjs .cursorrules
cp templates/spec.md spec.md
```

**Building a data/AI tool?**
```bash
cp templates/.cursorrules-python .cursorrules
cp templates/spec.md spec.md
```

**Building a simple utility?**
```bash
cp templates/.cursorrules-utility .cursorrules
cp templates/spec.md spec.md
```

### 2. Fill Out Your Spec

Edit `spec.md` to define:
- App identity (who, what, why)
- Data models
- User stories
- Technical constraints
- Non-goals (scope control)

### 3. Start Building

Your `.cursorrules` file will automatically guide the AI to follow best practices specific to your stack.

---

## 🔄 Using With Different AI IDEs

**Good news:** These `.cursorrules` files work with multiple AI coding assistants!

### Supported IDEs:
- ✅ **Cursor** (native format)
- ✅ **Windsurf** (copy as `.windsurfrules`)
- ✅ **Cline** (VSCode extension)
- ✅ **GitHub Copilot** (copy to `.github/copilot-instructions.md`)
- ✅ **Continue** (VSCode extension)

### Quick Setup Script

Use the included deployment script to set up rules for any IDE:

```bash
# Deploy to all IDEs
./setup-ide-rules.sh nextjs --all-ides

# Deploy to specific IDE only
./setup-ide-rules.sh saas --windsurf
```

**📘 See [CROSS_IDE_GUIDE.md](CROSS_IDE_GUIDE.md) for complete instructions.**

---

## 📖 How to Use This Repository

### For Each New Project:

1. **Start with Planning** (Chapter 4)
   - Use prompts from `/prompts/boardroom-prompt-library.md`
   - Fill out `/templates/spec.md`
   - Interview the Architect AI before coding

2. **Set Up Context** (Chapter 5)
   - Copy appropriate `.cursorrules` file to your project
   - Customize for your specific needs
   - Reference `/templates/universal-constraints.md` for security rules

3. **Build Features** (Chapters 6-8)
   - Use implementation prompts from prompt library
   - Follow the S.P.E.C. method (Specify, Plan, Execute, Checkpoint)
   - Commit after each working feature

4. **Polish** (Chapter 9)
   - Complete `/worksheets/jtbd-worksheet.md` to understand user needs
   - Apply UI/UX principles from the book
   - Test on real devices

5. **Ship Securely** (Chapter 10)
   - Work through `/checklists/pre-launch-security.md`
   - Follow `/checklists/secrets-management.md` rigorously
   - Deploy with confidence

---

## 🎯 File Usage Guide

### When to Use Each Template

| File | Project Type | When to Use |
|------|-------------|-------------|
| `.cursorrules-nextjs` | Full-stack web apps, SaaS | Multi-page apps, user auth, database |
| `.cursorrules-python` | Data analysis, AI wrappers | Processing data, AI API integration |
| `.cursorrules-utility` | Simple tools | Client-side only, no backend |
| `.cursorrules-saas` | Multi-user applications | User accounts, subscription billing |
| `spec.md` | ALL projects | Before writing any code |
| `universal-constraints.md` | ALL projects | Reference for security best practices |

### Prompt Library Organization

The `/prompts/boardroom-prompt-library.md` is organized by workflow stage:

1. **Architect Prompts** (1-5): Use in browser with Claude/ChatGPT for strategic planning
2. **Carpenter Prompts** (6-10): Use in IDE (Cursor/Copilot) for implementation
3. **Debug Prompts** (11-13): For fixing bugs and optimization
4. **Polish Prompts** (14-16): For UI/UX refinement
5. **Security Prompts** (17-19): Before deployment
6. **Review Prompts** (20): Before merging features

---

## 🔐 Critical Security Reminders

### The Cardinal Rules (from Chapter 7, 10)

1. **NEVER hardcode API keys** - Use environment variables always
2. **NEVER commit .env files** - Add to .gitignore before first commit
3. **NEVER skip RLS policies** - Enable on ALL user-data tables (SaaS only)
4. **ALWAYS validate input** - Client-side is UX, server-side is security
5. **ALWAYS set spending limits** - Prevent runaway API costs

See `/checklists/pre-launch-security.md` for the complete 15-point verification.

---

## 💡 Pro Tips

### Customizing Templates

**Don't just copy-paste.** Every project is unique:

1. Copy the relevant template
2. Read through each section
3. Delete rules that don't apply
4. Add project-specific constraints
5. Update as you discover new patterns

### The Discovery Loop (Chapter 5)

Templates grow through experience:

1. AI makes a mistake
2. You correct it
3. Happens again? Add a rule to `.cursorrules`
4. AI learns your preferences permanently

**Three strikes → permanent rule**

### Combining Resources

Complex tasks benefit from multiple resources:

```
1. Use Architect prompt (planning)
2. Fill out spec.md
3. Copy relevant .cursorrules
4. Use Carpenter prompts (building)
5. Reference security checklist
6. Complete JTBD worksheet (design)
7. Use polish prompts (refinement)
```

---

## 📚 Book Chapter Reference

These files map directly to book chapters:

- **Chapter 4 (S.P.E.C. Method)** → `spec.md` template
- **Chapter 5 (Context Engineering)** → All `.cursorrules` files
- **Chapter 7 (AI Wrapper)** → `secrets-management.md`
- **Chapter 9 (Design)** → `jtbd-worksheet.md`
- **Chapter 10 (Security)** → `pre-launch-security.md`
- **Appendix C** → `boardroom-prompt-library.md`

---

## 🤝 Contributing

Found a better way to structure a .cursorrules file? Discovered a security pattern the checklist missed? Create an issue or pull request.

**This is a living repository.** As tools evolve and best practices improve, these templates will be updated.

---

## ⚠️ Important Notes

### On AI Tools

These templates are designed to work with:
- Cursor (primary)
- GitHub Copilot
- Windsurf
- Other AI coding assistants that support context files

**Tool-specific syntax may vary.** Adapt as needed for your preferred tool.

### On Security

**These templates provide a foundation, not a guarantee.**

- Security is an ongoing process
- New vulnerabilities emerge constantly
- Always stay informed about your stack's security updates
- When in doubt, consult security professionals

### On Customization

**These are starting points, not endpoints.**

- Your project will have unique requirements
- Your team will have specific preferences
- Your stack might need additional constraints

**Customize freely. Just maintain the security principles.**

---

## 🎓 Learning Path

### If You're New to AI-Assisted Development:

1. Read Chapters 1-5 of the book (foundation)
2. Copy `spec.md` and `.cursorrules-utility` (simplest stack)
3. Build a simple calculator or converter tool
4. Work through `prompts/boardroom-prompt-library.md` (1-10 first)
5. Graduate to more complex projects

### If You're Experienced:

1. Skim the templates to see the patterns
2. Customize `.cursorrules` for your preferred stack
3. Add your own anti-patterns from past projects
4. Contribute improvements back to the community

---

## 📞 Support

**Found an issue?** Open a GitHub issue with:
- Which template/file
- What went wrong
- What you expected
- Your environment (OS, tool version, etc.)

**Want to share your success?** We'd love to see what you build!

---

## 📄 License

These templates are provided as-is for use with the book "Vibe Coding Done Right."

**You may:**
- Use them in your personal and commercial projects
- Modify them to suit your needs
- Share them with your team

**You may not:**
- Repackage and sell these templates separately
- Claim them as your own original work

---

## 🚢 Happy Shipping!

Remember: **The best app is the one that ships.**

These templates exist to help you build faster, more securely, and with more confidence. But they're tools, not magic.

**The real magic?**
- Your understanding of the user's problem
- Your judgment in making trade-offs
- Your discipline in following best practices
- Your willingness to iterate and improve

**Now go build something.**

---

*From the author of "Vibe Coding Done Right: The Micro-App Playbook for Creators Who Ship"*
