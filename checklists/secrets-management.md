# Secrets Management Checklist
## The Cardinal Rule: Never Hardcode API Keys

This checklist ensures your API keys, database credentials, and other secrets are properly protected from the moment you create them.

---

## 📋 PRE-BUILD (Before Writing Any Code)

### Step 1: Create Your Secrets File
**Local Development:**

```bash
# For Next.js / Node projects
touch .env.local

# For Python / Streamlit projects
touch .env
mkdir -p .streamlit && touch .streamlit/secrets.toml
```

**Add your secrets:**
```bash
# .env.local (Node/Next.js)
OPENAI_API_KEY=sk-proj-your-key-here
DATABASE_URL=postgresql://...
SUPABASE_KEY=your-key-here

# .streamlit/secrets.toml (Python/Streamlit)
OPENAI_API_KEY = "sk-proj-your-key-here"
DATABASE_URL = "postgresql://..."
```

---

### Step 2: Protect from Git (IMMEDIATELY)
**Before your first commit, add to .gitignore:**

```bash
# .gitignore
.env
.env.local
.env*.local
.streamlit/secrets.toml
*.key
*.pem
secrets/
```

**Verify it's working:**
```bash
# Should NOT show .env files
git status

# Explicitly test
echo "TEST_SECRET=test123" >> .env.local
git status  # Should still not show .env.local
```

---

### Step 3: Test Secret Loading
**Node/Next.js:**
```javascript
// test-secrets.js
require('dotenv').config({ path: '.env.local' });

console.log('Testing secret loading...');
console.log('API Key loaded:', process.env.OPENAI_API_KEY ? '✓ Yes' : '✗ No');
console.log('First 10 chars:', process.env.OPENAI_API_KEY?.substring(0, 10));

// Run: node test-secrets.js
```

**Python/Streamlit:**
```python
# test_secrets.py
import os
from dotenv import load_dotenv

load_dotenv()

print("Testing secret loading...")
print(f"API Key loaded: {'✓ Yes' if os.getenv('OPENAI_API_KEY') else '✗ No'}")
print(f"First 10 chars: {os.getenv('OPENAI_API_KEY', '')[:10]}")

# Run: python test_secrets.py
```

---

## 💻 DURING DEVELOPMENT

### Step 4: Load Secrets Correctly in Code

**Next.js (App Router):**
```typescript
// Server Component or Server Action
const apiKey = process.env.OPENAI_API_KEY;

// Client Component (public vars only)
const publicUrl = process.env.NEXT_PUBLIC_SUPABASE_URL;

// ❌ NEVER expose private keys to client
// ❌ NEVER use NEXT_PUBLIC_ prefix for secrets
```

**Python/Streamlit:**
```python
import streamlit as st
import os

# Option 1: st.secrets (recommended for Streamlit)
api_key = st.secrets["OPENAI_API_KEY"]

# Option 2: Environment variables
from dotenv import load_dotenv
load_dotenv()
api_key = os.getenv("OPENAI_API_KEY")
```

---

### Step 5: Never Log Secrets
**❌ BAD:**
```javascript
console.log('API Key:', process.env.OPENAI_API_KEY);
console.log('Full env:', process.env);
```

**✅ GOOD:**
```javascript
console.log('API Key loaded:', !!process.env.OPENAI_API_KEY);
console.log('Key prefix:', process.env.OPENAI_API_KEY?.substring(0, 7));
```

---

## 🔍 CODE AUDIT (Before Every Commit)

### Step 6: Search for Hardcoded Secrets
**Run these searches:**
```bash
# Look for common secret patterns
grep -r "sk-" . --exclude-dir=node_modules --exclude-dir=.git
grep -r "API_KEY.*=" . --exclude-dir=node_modules --exclude-dir=.git
grep -r "Bearer " . --exclude-dir=node_modules --exclude-dir=.git
grep -r "password.*=" . --exclude-dir=node_modules --exclude-dir=.git

# Check for exact string matches
grep -r "sk-proj-" .
grep -r "postgresql://" .
```

**What you're looking for:**
- API keys starting with `sk-` (OpenAI)
- Database URLs starting with `postgresql://`, `mysql://`
- Bearer tokens
- Hardcoded passwords
- JWT secrets

**If you find any: REMOVE IMMEDIATELY before committing**

---

## 🚀 DEPLOYMENT

### Step 7: Set Production Secrets

**Vercel:**
1. Project Settings → Environment Variables
2. Add each secret:
   - Name: `OPENAI_API_KEY`
   - Value: `sk-proj-...`
   - Environment: Production (and Preview if needed)
3. Redeploy after adding secrets

**Streamlit Cloud:**
1. App dashboard → ⚙️ Settings → Secrets
2. Add in TOML format:
```toml
OPENAI_API_KEY = "sk-proj-..."
DATABASE_URL = "postgresql://..."
```
3. Save (app auto-redeploys)

**Replit:**
1. Click lock icon (🔒) in sidebar
2. Add secrets:
   - `OPENAI_API_KEY` = `sk-proj-...`
3. Access in code via `os.getenv()`

---

### Step 8: Verify Production Secrets
**Test checklist:**
- [ ] App deploys without errors
- [ ] Features requiring secrets work correctly
- [ ] No "API key missing" errors in logs
- [ ] Secrets not visible in browser console
- [ ] Secrets not visible in network tab requests

---

## 🆘 EMERGENCY: IF YOU COMMITTED SECRETS

### Immediate Actions (Do This NOW)

**Step 1: ROTATE THE SECRET (Most Important)**
1. Go to the service (OpenAI, Supabase, etc.)
2. Generate a NEW key
3. Delete/revoke the OLD key immediately
4. Update your .env.local with new key
5. Update production secrets with new key

**The exposed key is now useless. Do this BEFORE cleaning Git history.**

**Step 2: Remove from Git History**
```bash
# Option A: BFG Repo-Cleaner (recommended)
# Download from: https://rephrase.github.io/bfg-repo-cleaner/
java -jar bfg.jar --delete-files .env.local
git reflog expire --expire=now --all
git gc --prune=now --aggressive

# Option B: git filter-branch
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch .env.local" \
  --prune-empty --tag-name-filter cat -- --all
```

**Step 3: Force Push**
```bash
git push origin --force --all
git push origin --force --tags
```

**Step 4: Notify Collaborators**
- Tell everyone to re-clone the repository
- Don't just pull (old history still exists locally)

**Step 5: Monitor for Abuse**
- Check API usage dashboards
- Look for unexpected charges
- Review access logs

---

## 📚 BEST PRACTICES

### Use Different Secrets for Each Environment
```bash
# Development
OPENAI_API_KEY=sk-proj-dev-key-here

# Staging
OPENAI_API_KEY=sk-proj-staging-key-here

# Production
OPENAI_API_KEY=sk-proj-prod-key-here
```

**Why:** If dev key leaks, production is still safe.

---

### Rotate Secrets Regularly
**Schedule:**
- Every 90 days (minimum)
- Immediately after team member leaves
- Immediately if you suspect compromise
- After any security incident

---

### Use Principle of Least Privilege
**Only grant the permissions you need:**
- Read-only keys when possible
- Scope API keys to specific resources
- Use service accounts with limited permissions

---

### Document Required Secrets
**Create .env.example:**
```bash
# .env.example (commit this to Git)
OPENAI_API_KEY=your_openai_key_here
DATABASE_URL=your_database_url_here
SUPABASE_KEY=your_supabase_key_here

# DO NOT put real values here!
# This file shows which secrets are needed
# Developers copy this to .env.local and add real values
```

---

## ✅ FINAL CHECKLIST

Before considering secrets management "done":

- [ ] All secrets in .env files (never in code)
- [ ] .env files in .gitignore
- [ ] Tested that secrets load correctly
- [ ] No secrets visible in `git status`
- [ ] Code audit passes (no hardcoded secrets found)
- [ ] Production secrets configured in platform
- [ ] Production app works with production secrets
- [ ] Secrets not visible in browser (console or network tab)
- [ ] .env.example file created (with placeholder values)
- [ ] Team knows where/how to add secrets

---

## 🎯 THE CARDINAL RULES

1. **Secrets NEVER touch source code files**
2. **.env files NEVER touch Git**
3. **Different secrets for dev/staging/prod**
4. **Rotate secrets regularly**
5. **If leaked, rotate IMMEDIATELY**

**Remember: It takes 5 minutes to do this right. It takes 5 hours to fix it after you get it wrong.**
