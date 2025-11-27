# APP: The Resume Roaster

## 1. App Identity

### Core Concept
Users submit resume text. AI judges it like a ruthless Silicon Valley recruiter.

Returns: score (0-100), savage roast (280 chars max), 3 red flags, 3 fixes.

Vibe: Scorched Earth. Dark mode, neon red accents, brutal honesty.

### Target User
Job seekers tired of generic "polite" feedback who want the hard truth about why they aren't getting hired.

### Value Proposition
Unlike friends who sugarcoat or expensive resume services that take days, this gives honest, specific feedback in 30 seconds.

---

## 2. Data Models

### RoastResult (JSON Output from OpenAI)
```python
{
  "score": int,  # 0-100, integer only
  "roast": str,  # max 280 characters, savage tone
  "redFlags": List[str],  # exactly 3 items
  "fixes": List[str]  # exactly 3 actionable items
}
```

### System Prompt for OpenAI
```
You are a ruthless Silicon Valley recruiter who has seen 10,000 resumes.
You judge resumes harshly but fairly.

Analyze the resume and return ONLY valid JSON matching this schema:
{
  "score": number (0-100 integer),
  "roast": string (max 280 chars, be savage but constructive),
  "redFlags": array of exactly 3 strings (what's wrong),
  "fixes": array of exactly 3 strings (how to improve)
}

Rules:
- Score 0-30: Unqualified, needs complete rewrite
- Score 31-60: Has potential but major issues
- Score 61-85: Competitive with improvements
- Score 86-100: Elite, minimal changes needed

Red flags should be specific: "No metrics in accomplishments" not "Bad format"
Fixes should be actionable: "Add numbers to each bullet point" not "Make it better"
```

---

## 3. User Stories (What Happens, Not How)

### Feature 1: The Roast (Core Flow)
**User Action:** User pastes resume text and clicks "🔥 Roast Me"

**System Response:**
1. Show skeleton loader with status messages:
   - "Analyzing format..." (0-2s)
   - "Checking for buzzwords..." (2-4s)  
   - "Preparing roast..." (4-5s)
2. Call OpenAI API with JSON mode
3. Render results:
   - Score animates up from 0 to actual score
   - If score < 50, shake the screen slightly
   - Roast displays in large text (red background)
   - Red flags as red pills
   - Fixes as green checkboxes

**Success Criteria:**
- Output is always valid JSON (use `response_format={"type": "json_object"}`)
- Total time < 10 seconds
- No conversational fluff from AI
- Score animation feels satisfying

### Feature 2: PDF Upload (Optional Enhancement)
**User Action:** User uploads resume.pdf

**System Response:**
- Extract text using PyPDF2
- Pass extracted text to roasting engine
- Handle common PDF issues (scanned images, multi-column layouts)

**Success Criteria:**
- Handles standard PDF layouts without crashing
- Falls back to text input if PDF extraction fails
- Shows error: "PDF couldn't be read. Try copy-pasting text instead."

### Feature 3: Rate Limiting (Cost Protection)
**User Action:** User clicks "Roast Me" 5 times in 60 seconds

**System Response:**
- Track roast count in session_state
- After 5 roasts: Show message "Slow down! Max 5 roasts per session."
- Reset counter when user refreshes page

**Success Criteria:**
- Prevents runaway API costs
- Clear user communication
- No error, just friendly limit

---

## 4. Technical Stack & Constraints

### Stack
- **Context File:** `.cursorrules-python`
- **Framework:** Python 3.11+ with Streamlit 1.x
- **AI:** OpenAI API (gpt-4o-mini recommended for cost)
- **PDF Parsing:** PyPDF2 (optional)
- **Deployment:** Streamlit Cloud

### Technical Constraints (What We MUST Do)
- ✅ MUST use `st.secrets` for API key (never hardcode)
- ✅ MUST use `response_format={"type": "json_object"}` for OpenAI calls
- ✅ MUST implement rate limiting (max 5 per session)
- ✅ MUST show loading states (skeleton loader with messages)
- ✅ MUST initialize all session_state variables at top of app.py

### Anti-Patterns (What We NEVER Do)
- ❌ NEVER hardcode API keys. Use `st.secrets["OPENAI_API_KEY"]`.
- ❌ NEVER trust AI to return JSON without forcing it (`response_format`)
- ❌ NEVER process unbounded input (set max text length: 10,000 chars)
- ❌ NEVER skip error handling (API can fail, handle gracefully)
- ❌ NEVER use deprecated `st.cache` (use `@st.cache_data`)

---

## 5. Non-Goals (What This App Is NOT)

### Explicitly Out of Scope
- [ ] Resume templates or formatting tools
- [ ] Cover letter analysis
- [ ] Job board integration
- [ ] Resume storage or history
- [ ] User accounts

### Why These Are Out:
This is a **single-purpose tool**. It does one thing (roast resumes) extremely well. Adding features would:
- Dilute the core value proposition
- Require database and auth (complexity)
- Slow down time-to-value (currently 30 seconds)

---

## 6. Edge Cases & Guardrails

### What Happens When...
- **API key is missing?** → Show friendly error: "API key not configured. Add OPENAI_API_KEY to Streamlit secrets."
- **OpenAI API is down?** → Catch exception, show: "AI is temporarily unavailable. Try again in a minute."
- **User pastes 50,000 characters?** → Truncate to 10,000, show warning
- **AI returns invalid JSON?** → Catch parsing error, show: "Unexpected response. Try again."
- **User spams submit button?** → Rate limit kicks in after 5 roasts

### Error States
- **Empty input**: Disable button until text is entered
- **API timeout**: Show error after 15 seconds
- **JSON parsing failure**: Log error, show generic message to user

---

## 7. Design Philosophy

### Visual Aesthetic
**Scorched Earth Theme:**
- Dark background (#0F172A slate-900)
- Neon red accents (#EF4444)
- White text for readability
- Sharp corners, high contrast
- No gentle language - embrace the roast

**Inspiration:** Terminal UI, HackerNews aesthetic, brutalist design

### Interaction Patterns
- **Immediate feedback**: Button shows loading spinner on click
- **Anticipation building**: Status messages during API call
- **Dramatic reveal**: Score animates up, screen shake on low scores
- **Clear hierarchy**: Score → Roast → Red Flags → Fixes

### Performance Targets
- Time to first interaction: < 3 seconds
- API response: < 10 seconds
- No UI lag during score animation

---

## 8. Success Metrics (How We Know It Works)

### Technical Success
- [ ] App loads without errors
- [ ] API calls return valid JSON 100% of time
- [ ] Rate limiting prevents cost overruns
- [ ] No sensitive data logged (no API keys in logs)
- [ ] Works on mobile (responsive design)

### User Success
- [ ] User can paste resume and get feedback in < 30 seconds
- [ ] User understands what to improve (fixes are actionable)
- [ ] User doesn't feel attacked (savage but constructive)
- [ ] User shares their roast (screenshot-worthy UI)

---

## 9. Implementation Notes

### API Call Pattern (Critical)
```python
import openai
import json
import streamlit as st
from tenacity import retry, stop_after_attempt, wait_exponential

# Initialize session state (AT TOP OF FILE)
if 'roast_count' not in st.session_state:
    st.session_state.roast_count = 0

@retry(stop=stop_after_attempt(3), wait=wait_exponential(min=2, max=10))
def roast_resume(resume_text: str) -> dict:
    """Call OpenAI with JSON mode for structured output."""
    
    client = openai.OpenAI(api_key=st.secrets["OPENAI_API_KEY"])
    
    system_prompt = """You are a ruthless Silicon Valley recruiter.
    
    Return ONLY valid JSON matching this schema:
    {
      "score": number (0-100),
      "roast": string (max 280 chars),
      "redFlags": array of exactly 3 strings,
      "fixes": array of exactly 3 strings
    }"""
    
    response = client.chat.completions.create(
        model="gpt-4o-mini",
        messages=[
            {"role": "system", "content": system_prompt},
            {"role": "user", "content": resume_text}
        ],
        response_format={"type": "json_object"},  # CRITICAL
        max_tokens=1000,
        temperature=0.7
    )
    
    # Parse JSON
    result = json.loads(response.choices[0].message.content)
    
    # Validate structure
    assert "score" in result
    assert "roast" in result
    assert len(result["redFlags"]) == 3
    assert len(result["fixes"]) == 3
    
    return result
```

### Rate Limiting Pattern
```python
# Check limit before API call
if st.session_state.roast_count >= 5:
    st.error("🔥 Slow down! Max 5 roasts per session. Refresh to reset.")
    st.stop()

# Increment after successful roast
st.session_state.roast_count += 1
```

### UI Layout
```python
import streamlit as st

st.set_page_config(page_title="Resume Roaster 🔥", page_icon="🔥", layout="wide")

# Header
st.title("🔥 The Resume Roaster")
st.caption("Get brutally honest feedback from an AI recruiter")

# Input area
resume_text = st.text_area(
    "Paste your resume text",
    height=300,
    max_chars=10000,
    placeholder="Paste your resume here (max 10,000 characters)..."
)

# Roast button
if st.button("🔥 Roast Me", type="primary", use_container_width=True):
    if not resume_text:
        st.error("Paste your resume first!")
        st.stop()
    
    # Show loading with status messages
    with st.spinner("Analyzing format..."):
        time.sleep(1)
    with st.spinner("Checking for buzzwords..."):
        time.sleep(1)
    with st.spinner("Preparing roast..."):
        result = roast_resume(resume_text)
    
    # Display results
    st.markdown(f"### Score: {result['score']}/100")
    st.error(result['roast'])  # Red background
    
    st.markdown("#### 🚩 Red Flags")
    for flag in result['redFlags']:
        st.markdown(f"- {flag}")
    
    st.markdown("#### ✅ How to Fix")
    for fix in result['fixes']:
        st.markdown(f"- {fix}")
```

---

## 10. Prompts for Building

### Initial Build Prompt
```
Read @spec.md for full requirements.
Reference @.cursorrules for code standards.

Build a Streamlit app with:
1. Dark theme (slate-900 background)
2. Large text area for resume input (max 10,000 chars)
3. "🔥 Roast Me" button (primary, full-width)
4. OpenAI integration with JSON mode
5. Rate limiting (max 5 roasts per session)

CRITICAL:
- Initialize session_state at top of file
- Use st.secrets["OPENAI_API_KEY"]
- Use response_format={"type": "json_object"}
- Add retry logic with tenacity

Start with the API integration, test it, then build the UI.
```

### Enhancement Prompt (Optional)
```
Add PDF upload capability:
1. st.file_uploader for PDF files
2. Extract text with PyPDF2
3. Pass extracted text to existing roast function
4. Handle errors gracefully (show fallback message)

Keep text input as primary method. PDF is secondary option.
```

---

## Notes for the AI Builder

**This spec is your constitution. When in doubt, refer back to this document.**

Key priorities:
1. **Security**: Never expose API keys
2. **Cost**: Rate limiting is mandatory
3. **Reliability**: JSON mode prevents parsing failures
4. **UX**: Loading states make wait feel shorter

**The "scorched earth" aesthetic is intentional.** Don't soften it. The brutal honesty is the brand.
