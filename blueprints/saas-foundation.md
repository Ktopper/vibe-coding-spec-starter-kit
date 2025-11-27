# APP: Focus Recipes Cloud (SaaS Edition)

## 1. App Identity

### Core Concept
The multiplayer version of Focus Recipes. Users can save custom recipes, track completion history, and share recipes via public links.

Vibe: Professional calm with social elements. Notion meets Headspace.

### Target User
Power users who want to:
- Save custom recipes permanently
- Track productivity patterns over time
- Share proven recipes with teammates

### Value Proposition
Unlike the client-only version, this adds persistence, collaboration, and insights without sacrificing the calm UX.

---

## 2. Data Models

### Profiles (extends auth.users)
```sql
create table profiles (
  id uuid references auth.users primary key,
  display_name text not null,
  avatar_url text,
  subscription_tier text check (subscription_tier in ('free', 'pro')) default 'free',
  created_at timestamptz default now()
);

-- RLS Policies
alter table profiles enable row level security;

create policy "Users can view their own profile"
  on profiles for select
  using (auth.uid() = id);

create policy "Users can update their own profile"
  on profiles for update
  using (auth.uid() = id);
```

### Recipes
```sql
create table recipes (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete cascade not null,
  name text not null,
  description text,
  phases jsonb not null,  -- Array of {name, duration_seconds, theme_color, animation_type}
  is_public boolean default false,
  times_completed int default 0,
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

-- RLS Policies
alter table recipes enable row level security;

create policy "Users can view own recipes and public recipes"
  on recipes for select
  using (auth.uid() = user_id OR is_public = true);

create policy "Users can create their own recipes"
  on recipes for insert
  with check (auth.uid() = user_id);

create policy "Users can update their own recipes"
  on recipes for update
  using (auth.uid() = user_id);

create policy "Users can delete their own recipes"
  on recipes for delete
  using (auth.uid() = user_id);
```

### Sessions (completion tracking)
```sql
create table sessions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete cascade not null,
  recipe_id uuid references recipes(id) on delete set null,
  recipe_name text not null,  -- Denormalized for deleted recipes
  completed_at timestamptz not null,
  duration_seconds int not null,
  phases_completed int not null
);

-- RLS Policies
alter table sessions enable row level security;

create policy "Users can view their own sessions"
  on sessions for select
  using (auth.uid() = user_id);

create policy "Users can create their own sessions"
  on sessions for insert
  with check (auth.uid() = user_id);
```

### Example Seed Data
```sql
-- Sample public recipes (run after user signup)
insert into recipes (user_id, name, description, phases, is_public) values
(
  (select id from profiles where display_name = 'System'),
  'Classic Pomodoro',
  'The standard 25-5-5-5 cycle',
  '[
    {"name": "Focus", "duration_seconds": 1500, "theme_color": "#EF4444", "animation_type": "breathing"},
    {"name": "Break", "duration_seconds": 300, "theme_color": "#10B981", "animation_type": "pulse"},
    {"name": "Focus", "duration_seconds": 1500, "theme_color": "#EF4444", "animation_type": "breathing"},
    {"name": "Long Break", "duration_seconds": 900, "theme_color": "#3B82F6", "animation_type": "static"}
  ]'::jsonb,
  true
);
```

---

## 3. User Stories (What Happens, Not How)

### Feature 1: The Invisible Wall (RLS in Action)
**User Action:** User A tries to view User B's private recipes by manipulating the API.

**System Response:**
- Database-level RLS blocks the query
- Supabase returns empty array `[]`
- No application-level check needed

**Success Criteria:**
- RLS policy explicitly checks: `auth.uid() = user_id OR is_public = true`
- No server-side filtering required
- Works even if client-side code is compromised

### Feature 2: Public/Private Toggle
**User Action:** User creates a recipe and toggles "Make Public."

**System Response:**
- Recipe appears in public feed
- Anyone can view recipe (even unauthenticated users)
- URL becomes shareable: `/recipes/[id]`

**Success Criteria:**
- Public recipes accessible without login
- Private recipes return 404 for non-owners
- Toggle updates `is_public` column via Server Action

### Feature 3: Session Tracking
**User Action:** User completes a recipe.

**System Response:**
- Create session record with completion details
- Increment `times_completed` on recipe
- Show completion toast with streak info

**Success Criteria:**
- Session saved immediately after completion
- Recipe counter updated atomically
- User can view history in dashboard

### Feature 4: Recipe Sharing
**User Action:** User clicks "Share" on public recipe.

**System Response:**
- Copy link to clipboard: `app.com/recipes/abc123`
- Anyone with link can view recipe
- Viewer can clone recipe to their account

**Success Criteria:**
- Public recipes work without authentication
- Clone operation creates new recipe owned by viewer
- Original recipe not editable by viewers

---

## 4. Technical Stack & Constraints

### Stack
- **Context File:** `.cursorrules-saas`
- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript 5.x
- **Database:** Supabase (Postgres + RLS)
- **Auth:** Supabase Auth (SSR with @supabase/ssr)
- **Styling:** Tailwind CSS 4.0
- **Icons:** Lucide React
- **Deployment:** Vercel

### Technical Constraints (What We MUST Do)
- ✅ MUST enable RLS on all tables immediately after creation
- ✅ MUST use `@supabase/ssr` for auth (not deprecated auth-helpers)
- ✅ MUST validate all Server Actions with Zod
- ✅ MUST use Server Actions for mutations (no client-side INSERT/UPDATE/DELETE)
- ✅ MUST handle auth state in middleware for protected routes

### Anti-Patterns (What We NEVER Do)
- ❌ NEVER use `supabase-js` client directly for sensitive operations
- ❌ NEVER create tables without RLS policies
- ❌ NEVER trust client-side validation alone
- ❌ NEVER expose service_role key to client
- ❌ NEVER use `auth.uid()` in application code (RLS does this)

---

## 5. Non-Goals (What This App Is NOT)

### Explicitly Out of Scope
- [ ] Team workspaces (multi-tenant)
- [ ] Real-time collaboration
- [ ] Mobile push notifications
- [ ] Advanced analytics dashboard
- [ ] Social features (likes, comments)
- [ ] Stripe integration (monetization)

### Why These Are Out:
This SaaS version demonstrates core multiplayer patterns. Adding these features would:
- Require significant complexity (multi-tenancy is hard)
- Increase infrastructure costs (real-time, push)
- Distract from core value (persistence + sharing)

**Note:** These can be added later as paid features.

---

## 6. Edge Cases & Guardrails

### What Happens When...
- **User deletes recipe that others have cloned?** → Clones remain (independent copies)
- **User has 100+ recipes?** → Paginate results (limit 20 per page)
- **User tries to make 1000 recipes?** → Free tier limit: 10 recipes (upgrade to Pro for unlimited)
- **User's session is interrupted mid-recipe?** → Resume from localStorage, save session on completion only
- **Public recipe has offensive content?** → Add `reported` flag, manual review queue (out of scope for MVP)

### Error States
- **RLS blocks operation**: Return clear message "You don't have permission to do that"
- **Supabase is down**: Show offline banner, queue operations in localStorage
- **Invalid session token**: Redirect to login with return URL
- **Concurrent updates**: Use optimistic UI, handle conflicts with "Refresh to see latest"

---

## 7. Design Philosophy

### Visual Aesthetic
**Polished Productized:** Clean, professional, trustworthy. 

**Inspiration:** Linear (speed), Notion (data tables), Headspace (calm)

### Interaction Patterns
- **Optimistic UI**: Updates appear instant, rollback on error
- **Progressive disclosure**: Advanced features behind "..." menu
- **Keyboard shortcuts**: `/` to search, `n` for new recipe, `esc` to close modals
- **Empty states**: Helpful onboarding for new users

### Performance Targets
- Time to Interactive: < 3 seconds
- Server Action response: < 200ms
- Lighthouse score: > 90 (all categories)
- Core Web Vitals: Pass all metrics

---

## 8. Success Metrics (How We Know It Works)

### Technical Success
- [ ] All tables have RLS policies enabled
- [ ] No SQL injection vulnerabilities (use parameterized queries)
- [ ] Auth state persists across page reloads
- [ ] Server Actions validate input with Zod
- [ ] Public recipes accessible without login

### User Success
- [ ] User can sign up and create first recipe in < 2 minutes
- [ ] User can toggle recipe public/private without confusion
- [ ] User can share recipe link that works for others
- [ ] User can view completion history
- [ ] User understands free vs pro limits

---

## 9. Implementation Notes

### Auth Pattern (Critical - Using @supabase/ssr)
```typescript
// app/lib/supabase/server.ts
import { createServerClient } from '@supabase/ssr';
import { cookies } from 'next/headers';

export async function createClient() {
  const cookieStore = cookies();
  
  return createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return cookieStore.get(name)?.value;
        },
      },
    }
  );
}
```

### Server Action with Zod Validation
```typescript
// app/actions/recipes.ts
'use server';

import { z } from 'zod';
import { createClient } from '@/lib/supabase/server';
import { revalidatePath } from 'next/cache';

const createRecipeSchema = z.object({
  name: z.string().min(3, 'Name must be at least 3 characters'),
  description: z.string().optional(),
  phases: z.array(z.object({
    name: z.string(),
    duration_seconds: z.number().positive(),
    theme_color: z.string().regex(/^#[0-9A-F]{6}$/i),
    animation_type: z.enum(['breathing', 'pulse', 'static'])
  })).min(1, 'Recipe must have at least one phase'),
  is_public: z.boolean().default(false)
});

export async function createRecipe(formData: FormData) {
  const supabase = await createClient();
  
  // Check auth
  const { data: { user } } = await supabase.auth.getUser();
  if (!user) {
    return { error: 'You must be logged in to create recipes' };
  }
  
  // Validate input
  const rawData = {
    name: formData.get('name'),
    description: formData.get('description'),
    phases: JSON.parse(formData.get('phases') as string),
    is_public: formData.get('is_public') === 'true'
  };
  
  const result = createRecipeSchema.safeParse(rawData);
  if (!result.success) {
    return { error: result.error.issues[0].message };
  }
  
  // Insert (RLS handles permission check)
  const { data, error } = await supabase
    .from('recipes')
    .insert({
      user_id: user.id,
      ...result.data
    })
    .select()
    .single();
  
  if (error) {
    return { error: error.message };
  }
  
  revalidatePath('/recipes');
  return { data };
}
```

### RLS Policy Patterns
```sql
-- Pattern 1: Own data only
create policy "Users can view their own data"
  on table_name for select
  using (auth.uid() = user_id);

-- Pattern 2: Own data OR public
create policy "Users can view own or public data"
  on table_name for select
  using (auth.uid() = user_id OR is_public = true);

-- Pattern 3: Own data with validation
create policy "Users can insert with constraints"
  on table_name for insert
  with check (
    auth.uid() = user_id 
    AND (subscription_tier = 'pro' OR recipe_count < 10)
  );
```

### Middleware for Auth
```typescript
// middleware.ts
import { createServerClient } from '@supabase/ssr';
import { NextResponse, type NextRequest } from 'next/server';

export async function middleware(request: NextRequest) {
  const response = NextResponse.next();
  
  const supabase = createServerClient(
    process.env.NEXT_PUBLIC_SUPABASE_URL!,
    process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY!,
    {
      cookies: {
        get(name: string) {
          return request.cookies.get(name)?.value;
        },
        set(name: string, value: string, options) {
          response.cookies.set(name, value, options);
        },
        remove(name: string, options) {
          response.cookies.delete(name);
        },
      },
    }
  );
  
  const { data: { user } } = await supabase.auth.getUser();
  
  // Protect /dashboard routes
  if (request.nextUrl.pathname.startsWith('/dashboard') && !user) {
    return NextResponse.redirect(new URL('/login', request.url));
  }
  
  return response;
}

export const config = {
  matcher: ['/dashboard/:path*']
};
```

---

## 10. Prompts for Building

### Database Setup Prompt
```
Set up the Supabase database schema:

1. Create the three tables: profiles, recipes, sessions
2. Enable RLS on all tables immediately
3. Create RLS policies as specified in the spec
4. Add indexes on user_id and created_at columns
5. Set up foreign key constraints with cascade deletes

CRITICAL:
- NEVER create tables without RLS enabled
- Test RLS policies by attempting forbidden operations
- Use `auth.uid()` in policies, not application code
```

### Auth Integration Prompt
```
Implement authentication using @supabase/ssr:

1. Create server-side Supabase client in /lib/supabase/server.ts
2. Set up middleware to protect /dashboard routes
3. Add sign up, login, and logout flows
4. Handle auth callbacks from Supabase
5. Create profile automatically on first sign-up (database trigger)

CRITICAL:
- Use @supabase/ssr, NOT @supabase/auth-helpers-nextjs
- Always check auth.getUser() in Server Actions
- Handle cookie management properly
```

### Server Actions Prompt
```
Create Server Actions for CRUD operations:

1. createRecipe - with Zod validation
2. updateRecipe - with ownership check
3. deleteRecipe - with cascade considerations
4. togglePublic - simple boolean toggle
5. completeSession - atomic counter increment

CRITICAL:
- Validate ALL inputs with Zod
- Check user authentication before operations
- Use revalidatePath after mutations
- Return structured {data, error} objects
```

### UI Components Prompt
```
Build the dashboard UI:

1. RecipeList - grid of recipe cards with edit/delete/share
2. RecipeEditor - form with phase builder (add/remove/reorder)
3. SessionHistory - table with filtering and export
4. PublicRecipeFeed - discover page for public recipes

Follow Tailwind mobile-first approach.
Use optimistic UI for mutations.
Add loading skeletons for async states.
```

---

## Notes for the AI Builder

**This spec is your constitution. When in doubt, refer back to this document.**

Key priorities:
1. **Security**: RLS first, validation second, application logic third
2. **DX**: Server Actions > API routes (simpler, type-safe)
3. **Performance**: Static where possible, dynamic only when needed
4. **UX**: Optimistic UI makes SaaS feel instant

**RLS is your security moat.** Even if application code is compromised, the database protects user data.

**Trust the spec.** Don't add features not listed here. Don't skip anti-patterns. Don't soften constraints.
