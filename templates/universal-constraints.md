# Universal Security Constraints
## Stack-Agnostic Rules That Apply to Every Project

These constraints are **non-negotiable** regardless of your tech stack, framework, or deployment target. They represent fundamental security and development hygiene that every project must follow.

---

## 1. SECRETS MANAGEMENT (CRITICAL)

### The Golden Rules

**NEVER:**
- ❌ Hardcode API keys, database URLs, or credentials in source code
- ❌ Commit .env, .env.local, .env.production, or secrets.toml to git
- ❌ Log secrets to console (even in development)
- ❌ Store secrets in localStorage or sessionStorage
- ❌ Share secrets via unsecured channels (Slack, email)
- ❌ Use production secrets in development
- ❌ Reuse secrets across projects

**ALWAYS:**
- ✅ Use environment variables for ALL secrets
- ✅ Add secret files to .gitignore BEFORE first commit
- ✅ Use different secrets for dev/staging/production
- ✅ Rotate secrets regularly (every 90 days minimum)
- ✅ Use secret management services (Vercel env, GitHub secrets, etc.)
- ✅ Audit git history if you accidentally commit secrets (rotate immediately)

### Language-Specific Patterns

**JavaScript/TypeScript (Node.js, Next.js, etc.):**
```javascript
// Access secrets via process.env
const apiKey = process.env.OPENAI_API_KEY;

// .gitignore MUST include:
.env
.env.local
.env*.local
.vercel
```

**Python (Django, Flask, Streamlit, etc.):**
```python
import os
api_key = os.getenv('OPENAI_API_KEY')

# .gitignore MUST include:
.env
.env.local
.streamlit/secrets.toml
*.pyc
__pycache__/
```

**If You Committed Secrets by Mistake:**
1. Rotate the secret IMMEDIATELY (invalidate the old one)
2. Remove from git history: `git filter-branch` or BFG Repo-Cleaner
3. Force push to remote
4. Audit who had access to the repository
5. Monitor for unauthorized usage

---

## 2. INPUT VALIDATION (ALWAYS)

### The Reality
**User input is hostile until proven otherwise.**

Every input field, URL parameter, file upload, and API request is a potential attack vector.

### Validation Checklist

Before processing ANY user input:
- [ ] **Type validation:** Is it the expected data type?
- [ ] **Length validation:** Is it within acceptable bounds?
- [ ] **Format validation:** Does it match the expected pattern (email, URL, etc.)?
- [ ] **Range validation:** Is the number within min/max bounds?
- [ ] **Allowlist validation:** Is the value from an allowed set? (safer than blocklist)
- [ ] **Sanitization:** Remove or escape dangerous characters

### Common Vulnerabilities

**SQL Injection:**
```javascript
// ❌ NEVER do this (vulnerable)
const query = `SELECT * FROM users WHERE email = '${userInput}'`;

// ✅ ALWAYS use parameterized queries
const query = 'SELECT * FROM users WHERE email = ?';
db.query(query, [userInput]);
```

**Cross-Site Scripting (XSS):**
```javascript
// ❌ NEVER render user input directly as HTML
innerHTML = userInput;

// ✅ ALWAYS sanitize or use frameworks that auto-escape
textContent = userInput; // Safe in vanilla JS
// OR use React/Vue (they escape by default)
```

**Path Traversal:**
```javascript
// ❌ NEVER trust file paths from users
fs.readFile(`./uploads/${userFilename}`); // Can access ../../../etc/passwd

// ✅ ALWAYS validate and sanitize paths
const safePath = path.basename(userFilename); // Removes directory traversal
```

### Server-Side Validation is Mandatory
Client-side validation is UX. Server-side validation is security.

**NEVER trust client-side validation alone.** Always validate on the server.

---

## 3. AUTHENTICATION & AUTHORIZATION

### Authentication (Who are you?)
**NEVER:**
- ❌ Roll your own auth (password hashing, session management, etc.)
- ❌ Store passwords in plain text
- ❌ Use MD5 or SHA1 for password hashing
- ❌ Store sessions in localStorage (use httpOnly cookies)

**ALWAYS:**
- ✅ Use established auth libraries (Supabase, Auth0, NextAuth, Passport, etc.)
- ✅ Use bcrypt or Argon2 if you must hash passwords
- ✅ Implement rate limiting on login endpoints
- ✅ Use multi-factor authentication for sensitive operations
- ✅ Enforce strong password requirements

### Authorization (What can you do?)
**The Golden Question:** "Can THIS user access THIS resource?"

**NEVER:**
- ❌ Trust client-side authorization checks
- ❌ Use user-supplied IDs without verification
- ❌ Assume "logged in" means "can access everything"
- ❌ Skip authorization checks because "only admins know the URL"

**ALWAYS:**
- ✅ Verify authorization on EVERY server request
- ✅ Check ownership before mutations (user_id === session.user_id)
- ✅ Use Row Level Security (RLS) for databases
- ✅ Implement principle of least privilege
- ✅ Log authorization failures

**Example Pattern:**
```typescript
// Server Action
export async function deleteRecipe(recipeId: string) {
  // 1. Authenticate
  const session = await getSession();
  if (!session) return { error: 'Unauthorized' };
  
  // 2. Authorize (verify ownership)
  const recipe = await db.recipe.findUnique({ where: { id: recipeId } });
  if (recipe.userId !== session.user.id) {
    return { error: 'Forbidden' };
  }
  
  // 3. Execute
  await db.recipe.delete({ where: { id: recipeId } });
  return { success: true };
}
```

---

## 4. ERROR HANDLING (DEFENSIVE)

### The Balance
Users need to know what went wrong. Attackers shouldn't learn about your system.

**NEVER:**
- ❌ Return raw database errors to users
- ❌ Expose stack traces in production
- ❌ Log sensitive data (passwords, credit cards, API keys)
- ❌ Return different errors for "user not found" vs "wrong password" (timing attacks)

**ALWAYS:**
- ✅ Log full errors server-side for debugging
- ✅ Return generic, user-friendly messages to clients
- ✅ Use error monitoring (Sentry, LogRocket, etc.)
- ✅ Have fallback behavior for failures

**Example:**
```typescript
try {
  await paymentService.charge(amount);
} catch (error) {
  // Log full error server-side
  console.error('Payment failed:', error);
  logger.error('Payment error', { userId, amount, error });
  
  // Return generic message to user
  return { error: 'Payment failed. Please try again or contact support.' };
}
```

---

## 5. DEPENDENCIES (MAINTENANCE)

### Dependency Hygiene

**Regularly:**
- [ ] Update dependencies (monthly minimum)
- [ ] Audit for known vulnerabilities
- [ ] Remove unused dependencies
- [ ] Pin major versions (avoid automatic breaking changes)

**Commands:**
```bash
# JavaScript/Node
npm audit
npm audit fix
npm outdated

# Python
pip-audit
pip list --outdated

# General
dependabot (GitHub)
renovate (automated PRs)
```

**Supply Chain Attacks:**
- Vet packages before adding (check stars, last update, maintainer)
- Use lock files (package-lock.json, Pipfile.lock)
- Consider using private npm registry for critical projects

---

## 6. HTTPS & NETWORK SECURITY

**NEVER:**
- ❌ Deploy without HTTPS in production
- ❌ Make API calls to HTTP endpoints
- ❌ Disable SSL certificate validation
- ❌ Use self-signed certificates in production

**ALWAYS:**
- ✅ Use HTTPS for all production traffic
- ✅ Set Secure and HttpOnly flags on cookies
- ✅ Implement CORS properly (don't use wildcard `*` in production)
- ✅ Use Content Security Policy (CSP) headers
- ✅ Enable HSTS (HTTP Strict Transport Security)

---

## 7. FILE UPLOADS (HIGH RISK)

**NEVER:**
- ❌ Trust file extensions (they can be spoofed)
- ❌ Execute uploaded files
- ❌ Store uploads in publicly accessible directories
- ❌ Skip file size limits
- ❌ Allow arbitrary file types

**ALWAYS:**
- ✅ Validate file MIME type server-side
- ✅ Scan files for malware (if possible)
- ✅ Enforce file size limits
- ✅ Store files outside web root or use object storage (S3, R2, etc.)
- ✅ Generate unique filenames (don't use user-supplied names)
- ✅ Serve files through CDN or proxy (not directly)

**Example:**
```typescript
const MAX_FILE_SIZE = 5 * 1024 * 1024; // 5MB
const ALLOWED_TYPES = ['image/jpeg', 'image/png', 'application/pdf'];

function validateUpload(file: File) {
  if (file.size > MAX_FILE_SIZE) {
    return { error: 'File too large (max 5MB)' };
  }
  
  if (!ALLOWED_TYPES.includes(file.type)) {
    return { error: 'Invalid file type' };
  }
  
  return { valid: true };
}
```

---

## 8. RATE LIMITING (ABUSE PREVENTION)

**Implement rate limiting on:**
- Login endpoints (prevent brute force)
- API endpoints (prevent abuse)
- File uploads (prevent DoS)
- Email sending (prevent spam)
- Expensive operations (AI API calls, etc.)

**Example (Next.js):**
```typescript
import { Ratelimit } from '@upstash/ratelimit';

const ratelimit = new Ratelimit({
  redis: Redis.fromEnv(),
  limiter: Ratelimit.slidingWindow(10, '1 m'), // 10 requests per minute
});

export async function POST(req: Request) {
  const ip = req.headers.get('x-forwarded-for');
  const { success } = await ratelimit.limit(ip);
  
  if (!success) {
    return new Response('Rate limit exceeded', { status: 429 });
  }
  
  // Process request
}
```

---

## 9. DATABASE SECURITY

**NEVER:**
- ❌ Use default database passwords
- ❌ Expose database ports to public internet
- ❌ Grant overly broad permissions
- ❌ Skip database backups
- ❌ Store sensitive data unencrypted

**ALWAYS:**
- ✅ Use strong, unique database passwords
- ✅ Restrict database access to application servers only
- ✅ Use connection pooling
- ✅ Enable SSL/TLS for database connections
- ✅ Implement Row Level Security (Postgres/Supabase)
- ✅ Regular automated backups with retention policy
- ✅ Encrypt sensitive data at rest

---

## 10. LOGGING & MONITORING

### What to Log
- Authentication events (login, logout, failures)
- Authorization failures
- Errors and exceptions
- Critical state changes
- Performance metrics

### What NOT to Log
- Passwords (NEVER)
- API keys or tokens
- Credit card numbers
- Social security numbers
- Full user records (log IDs only)

### Monitoring Checklist
- [ ] Error tracking (Sentry, Rollbar, etc.)
- [ ] Uptime monitoring (UptimeRobot, Pingdom, etc.)
- [ ] Performance monitoring (Vercel Analytics, New Relic, etc.)
- [ ] Security alerts (failed logins, unusual traffic, etc.)

---

## 11. DEPLOYMENT CHECKLIST

Before deploying to production:
- [ ] All secrets in environment variables (not in code)
- [ ] .gitignore includes all secret files
- [ ] HTTPS enabled
- [ ] Database backups configured
- [ ] Error monitoring active
- [ ] Rate limiting on public endpoints
- [ ] Input validation on all user inputs
- [ ] Dependencies audited and up-to-date
- [ ] CORS configured correctly
- [ ] Content Security Policy headers set
- [ ] Session cookies are Secure and HttpOnly
- [ ] No console.log with sensitive data
- [ ] Test accounts removed

---

## 12. INCIDENT RESPONSE PLAN

If a security breach occurs:
1. **Contain:** Take affected systems offline immediately
2. **Assess:** Determine scope (what data? how many users?)
3. **Notify:** Inform affected users (legal requirement in many jurisdictions)
4. **Rotate:** Change all secrets, passwords, API keys
5. **Patch:** Fix the vulnerability
6. **Review:** Conduct post-mortem to prevent recurrence
7. **Document:** Keep detailed records for legal/compliance

---

## REMEMBER

**Security is not a feature. It's the foundation.**

These constraints are not suggestions. They are the minimum bar for responsible software development.

When in doubt, ask:
- "What's the worst thing that could happen?"
- "How would an attacker exploit this?"
- "What data could be exposed?"

Then build your defenses accordingly.
