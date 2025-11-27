# Pre-Launch Security Checklist
## The 15-Point Verification Before Going Live

This checklist represents the minimum security practices every app must pass before deployment. If you can't check every box, you're not ready to ship.

---

## ✅ SECRETS MANAGEMENT (Critical)

### Check 1: The Secrets Hunt
**Task:** Find and eliminate all hardcoded secrets

**How to verify:**
```bash
# Search your entire codebase for common secret patterns
grep -r "API_KEY" .
grep -r "SECRET" .
grep -r "PASSWORD" .
grep -r "sk-" .  # OpenAI keys start with sk-
grep -r "Bearer" .
```

**What to fix:**
- [ ] NO API keys in source code files
- [ ] NO database URLs in source code
- [ ] NO passwords or tokens in source code
- [ ] All secrets loaded from environment variables (`process.env.X` or `os.getenv('X')`)

**Where secrets belong:**
- Development: `.env.local` (in `.gitignore`)
- Production: Platform secrets panel (Vercel, Streamlit Cloud, etc.)

**Consequences of failure:** Bot scrapers find your keys within hours, drain your API credits, result in hundreds/thousands in unexpected bills

---

### Check 2: Git Protection
**Task:** Ensure secrets can't be committed to version control

**How to verify:**
```bash
# Check your .gitignore
cat .gitignore | grep -E "\.env|secrets|\.local"

# Verify files aren't tracked
git status

# Check if secrets ever existed in history
git log --all --full-history --source --name-only -- **/.env*
```

**What to include in .gitignore:**
```
.env
.env.local
.env*.local
.streamlit/secrets.toml
*.key
*.pem
secrets/
```

**If you already committed secrets:**
1. **ROTATE IMMEDIATELY** (invalidate old key, generate new one)
2. Remove from git history (use `git filter-branch` or BFG Repo-Cleaner)
3. Force push to remote
4. Audit who had repository access
5. Monitor for unauthorized usage

**Consequences of failure:** Secrets remain in Git history forever, even if "deleted" later. Anyone with past access can extract them.

---

## 🔒 DATABASE SECURITY (Multi-User Apps Only)

### Check 3: Row Level Security Enabled
**Task:** Verify RLS is enabled on ALL user-data tables

**How to verify (Supabase/Postgres):**
```sql
-- Check which tables have RLS enabled
SELECT tablename, rowsecurity 
FROM pg_tables 
WHERE schemaname = 'public';

-- Should return rowsecurity = true for all user-owned tables
```

**What to check:**
- [ ] RLS enabled on every table containing user data
- [ ] NO tables with `rowsecurity = false` unless explicitly public

**How to fix:**
```sql
ALTER TABLE your_table_name ENABLE ROW LEVEL SECURITY;
```

**Consequences of failure:** Complete data exposure. All users can see all other users' data. This is a CRITICAL security vulnerability.

---

### Check 4: RLS Policies Exist
**Task:** Verify policies for SELECT, INSERT, UPDATE, DELETE

**How to verify:**
```sql
-- Check existing policies
SELECT schemaname, tablename, policyname, cmd
FROM pg_policies
WHERE schemaname = 'public';
```

**What to check:**
- [ ] SELECT policy (who can read)
- [ ] INSERT policy (who can create)
- [ ] UPDATE policy (who can modify)
- [ ] DELETE policy (who can remove)

**Common policy template:**
```sql
-- User can only access their own data
CREATE POLICY "Users can view own data"
  ON table_name FOR SELECT
  USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own data"
  ON table_name FOR INSERT
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own data"
  ON table_name FOR UPDATE
  USING (auth.uid() = user_id)
  WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete own data"
  ON table_name FOR DELETE
  USING (auth.uid() = user_id);
```

**Consequences of failure:** RLS enabled but no policies = nobody can access data (breaks app). Missing policies = unauthorized access holes.

---

### Check 5: The Two-Browser Test
**Task:** Verify data isolation between users

**How to test:**
1. Open Chrome (regular window)
2. Open Chrome (incognito window)
3. Sign in as User A in regular window
4. Sign in as User B in incognito window
5. User A creates data
6. Verify User B CANNOT see User A's data
7. User B creates data
8. Verify User A CANNOT see User B's data

**What to check:**
- [ ] Users can only see their own private data
- [ ] Users cannot modify other users' data
- [ ] Public data (if any) is visible to all as intended
- [ ] Deleted users' data is handled correctly (cascade or nullify)

**Consequences of failure:** Privacy violation, data leaks, potential legal liability

---

## 🛡️ INPUT VALIDATION (Always Required)

### Check 6: Server-Side Validation
**Task:** Validate ALL user inputs on the server

**What to check:**
- [ ] Type validation (is it the expected data type?)
- [ ] Length validation (within acceptable bounds?)
- [ ] Format validation (email, URL, phone match expected pattern?)
- [ ] Range validation (numbers within min/max?)
- [ ] Sanitization (dangerous characters removed/escaped?)

**Example (TypeScript + Zod):**
```typescript
import { z } from 'zod';

const schema = z.object({
  name: z.string().min(3).max(50),
  email: z.string().email(),
  age: z.number().min(0).max(120)
});

// Validate before using
const result = schema.safeParse(userInput);
if (!result.success) {
  return { error: 'Invalid input' };
}
```

**Remember:** Client-side validation is UX. Server-side validation is security.

**Consequences of failure:** SQL injection, XSS attacks, data corruption, app crashes

---

### Check 7: File Upload Security (If Applicable)
**Task:** Validate uploaded files

**What to check:**
- [ ] File size limits enforced (e.g., max 5MB)
- [ ] File type validation server-side (MIME type, not just extension)
- [ ] Malicious file scanning (if possible)
- [ ] Files stored outside web root or in object storage
- [ ] Generated unique filenames (don't trust user-supplied names)

**Consequences of failure:** Malware distribution, server compromise, DoS attacks

---

## 💸 COST CONTROL (AI/API-Powered Apps)

### Check 8: Rate Limiting
**Task:** Prevent abuse of expensive operations

**What to implement:**
- [ ] Login endpoints (prevent brute force)
- [ ] AI API calls (prevent credit drain)
- [ ] File uploads (prevent DoS)
- [ ] Email sending (prevent spam)

**Example (Upstash Ratelimit):**
```typescript
import { Ratelimit } from '@upstash/ratelimit';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '1 m'), // 10 requests per minute
});

const { success } = await ratelimit.limit(userIdentifier);
if (!success) {
  return new Response('Rate limit exceeded', { status: 429 });
}
```

**Consequences of failure:** Runaway costs, drained API credits, unexpected bills

---

### Check 9: API Spending Limits
**Task:** Set hard limits on API spending

**Where to set:**
- OpenAI: Organization settings → Usage limits
- Anthropic: Dashboard → Billing → Set budget
- Other providers: Check their dashboard

**What to set:**
- [ ] Monthly spending cap (e.g., $100/month)
- [ ] Email alerts at 50%, 75%, 90% of limit
- [ ] Automatic shutdown at 100% (if available)

**Consequences of failure:** $1,000+ surprise bills from runaway loops or bot abuse

---

## 🚨 ERROR HANDLING

### Check 10: User-Friendly Errors
**Task:** Never expose system details to users

**What to check:**
- [ ] NO raw database errors shown to users
- [ ] NO stack traces in production
- [ ] NO system file paths visible
- [ ] Generic, helpful messages ("Something went wrong. Please try again.")
- [ ] Specific errors logged server-side for debugging

**Example:**
```typescript
try {
  await dangerousOperation();
} catch (error) {
  // Log full error for debugging
  console.error('Operation failed:', error);
  logger.error('Critical operation', { userId, error });
  
  // Return generic message to user
  return { error: 'Unable to complete request. Please try again or contact support.' };
}
```

**Consequences of failure:** Information leakage helps attackers understand your system

---

## 🌐 NETWORK SECURITY

### Check 11: HTTPS Enabled
**Task:** Ensure encrypted connections in production

**What to check:**
- [ ] HTTPS enforced (not HTTP)
- [ ] Valid SSL certificate
- [ ] HSTS header enabled
- [ ] Secure cookies (Secure and HttpOnly flags)

**Most platforms (Vercel, Netlify, etc.) enable HTTPS by default. Verify it's actually working.**

**Consequences of failure:** Data intercepted in transit, man-in-the-middle attacks

---

### Check 12: CORS Configuration
**Task:** Restrict which domains can access your API

**What to check:**
- [ ] CORS not set to wildcard (`*`) in production
- [ ] Only trusted domains whitelisted
- [ ] Credentials allowed only for specific origins

**Example (Next.js API route):**
```typescript
const allowedOrigins = ['https://yourdomain.com', 'https://www.yourdomain.com'];

if (!allowedOrigins.includes(req.headers.origin)) {
  return new Response('Forbidden', { status: 403 });
}
```

**Consequences of failure:** Unauthorized domains can make requests to your API

---

## 📊 MONITORING & BACKUPS

### Check 13: Error Monitoring Active
**Task:** Know when things break

**What to setup:**
- [ ] Error tracking service (Sentry, LogRocket, etc.)
- [ ] Uptime monitoring (UptimeRobot, Pingdom)
- [ ] Performance monitoring (Vercel Analytics, etc.)
- [ ] Alerts for critical errors

**Consequences of failure:** Users experience bugs but you don't know about them

---

### Check 14: Database Backups Configured
**Task:** Protect against data loss

**What to setup:**
- [ ] Automated daily backups
- [ ] Backup retention policy (e.g., keep 30 days)
- [ ] Test restore process (verify backups actually work)
- [ ] Backups stored separately from primary database

**Most platforms (Supabase, PlanetScale) include automatic backups. Verify they're enabled.**

**Consequences of failure:** Catastrophic data loss with no recovery option

---

## 🎯 FINAL VERIFICATION

### Check 15: Manual Security Audit
**Task:** Walk through the entire app looking for issues

**Test scenarios:**
- [ ] Try to access another user's data (should fail)
- [ ] Try to submit invalid data (should be rejected)
- [ ] Try to exceed rate limits (should be blocked)
- [ ] Try to upload a huge file (should be rejected)
- [ ] Try to XSS yourself (input `<script>alert('xss')</script>` in forms)
- [ ] Check browser console for sensitive data leaks
- [ ] Review network tab for exposed secrets in requests

**This is your last line of defense. Take it seriously.**

---

## 🚀 POST-LAUNCH

After deploying, continue monitoring:
- Daily: Check error dashboards
- Weekly: Review usage patterns, look for abuse
- Monthly: Audit dependencies for vulnerabilities (`npm audit`, `pip-audit`)
- Quarterly: Rotate secrets proactively

---

## REMEMBER

**You're one checklist away from:**
- Peace of mind (knowing your users' data is safe)
- Protecting your wallet (no surprise bills)
- Building trust (users feel secure)
- Sleeping well (no 3am "we've been hacked" calls)

**Or one unchecked box away from:**
- Data breaches (and the legal consequences)
- Drained bank accounts (from API abuse)
- Destroyed reputation (users leave permanently)
- Catastrophic failure (that could have been prevented)

**Choose wisely. Check every box.**
