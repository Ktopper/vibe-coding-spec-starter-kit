#!/bin/bash

# ====================================================================
# Multi-IDE Rules Deployment Script
# ====================================================================
# Deploys Vibe Coding starter kit rules to multiple AI IDE formats
# 
# Usage: ./setup-ide-rules.sh [stack] [--all-ides] [--cursor-only]
#
# Stacks: nextjs, python, utility, saas
# Options:
#   --all-ides     Deploy to all IDE formats (default)
#   --cursor-only  Deploy only to Cursor
#   --windsurf     Deploy only to Windsurf
#   --cline        Deploy only to Cline  
#   --copilot      Deploy only to GitHub Copilot
#   --continue     Deploy only to Continue
# ====================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Default values
STACK=""
DEPLOY_CURSOR=true
DEPLOY_WINDSURF=false
DEPLOY_CLINE=false
DEPLOY_COPILOT=false
DEPLOY_CONTINUE=false
ALL_IDES=false

# ====================================================================
# Helper Functions
# ====================================================================

print_header() {
    echo -e "${BLUE}"
    echo "╔══════════════════════════════════════════════════════════╗"
    echo "║   Vibe Coding Starter Kit - Multi-IDE Deployment        ║"
    echo "╚══════════════════════════════════════════════════════════╝"
    echo -e "${NC}"
}

print_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

print_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

show_usage() {
    echo "Usage: $0 [stack] [options]"
    echo ""
    echo "Stacks:"
    echo "  nextjs    - Next.js 15 + TypeScript + Supabase"
    echo "  python    - Python + Streamlit + OpenAI"
    echo "  utility   - React + Vite (client-side only)"
    echo "  saas      - Next.js + Supabase + RLS + Auth"
    echo ""
    echo "Options:"
    echo "  --all-ides      Deploy to all IDE formats (default)"
    echo "  --cursor-only   Deploy only to Cursor"
    echo "  --windsurf      Deploy only to Windsurf"
    echo "  --cline         Deploy only to Cline"
    echo "  --copilot       Deploy only to GitHub Copilot"
    echo "  --continue      Deploy only to Continue"
    echo ""
    echo "Examples:"
    echo "  $0 nextjs                    # Deploy Next.js rules to Cursor"
    echo "  $0 saas --all-ides           # Deploy SaaS rules to all IDEs"
    echo "  $0 python --windsurf         # Deploy Python rules to Windsurf only"
}

# ====================================================================
# Parse Arguments
# ====================================================================

if [ $# -eq 0 ]; then
    print_error "No stack specified."
    echo ""
    show_usage
    exit 1
fi

STACK=$1
shift

# Parse options
while [ $# -gt 0 ]; do
    case "$1" in
        --all-ides)
            ALL_IDES=true
            DEPLOY_CURSOR=true
            DEPLOY_WINDSURF=true
            DEPLOY_CLINE=true
            DEPLOY_COPILOT=true
            DEPLOY_CONTINUE=true
            ;;
        --cursor-only)
            DEPLOY_CURSOR=true
            DEPLOY_WINDSURF=false
            DEPLOY_CLINE=false
            DEPLOY_COPILOT=false
            DEPLOY_CONTINUE=false
            ;;
        --windsurf)
            DEPLOY_CURSOR=false
            DEPLOY_WINDSURF=true
            ;;
        --cline)
            DEPLOY_CURSOR=false
            DEPLOY_CLINE=true
            ;;
        --copilot)
            DEPLOY_CURSOR=false
            DEPLOY_COPILOT=true
            ;;
        --continue)
            DEPLOY_CURSOR=false
            DEPLOY_CONTINUE=true
            ;;
        -h|--help)
            show_usage
            exit 0
            ;;
        *)
            print_error "Unknown option: $1"
            echo ""
            show_usage
            exit 1
            ;;
    esac
    shift
done

# ====================================================================
# Validate Stack
# ====================================================================

SOURCE="templates/.cursorrules-${STACK}"

if [ ! -f "$SOURCE" ]; then
    print_error "Stack '$STACK' not found."
    echo ""
    echo "Available stacks:"
    echo "  - nextjs"
    echo "  - python"
    echo "  - utility"
    echo "  - saas"
    exit 1
fi

# ====================================================================
# Main Deployment
# ====================================================================

print_header

echo "Stack: ${YELLOW}${STACK}${NC}"
echo "Source: ${SOURCE}"
echo ""

# Count deployments
DEPLOY_COUNT=0
if [ "$DEPLOY_CURSOR" = true ]; then ((DEPLOY_COUNT++)); fi
if [ "$DEPLOY_WINDSURF" = true ]; then ((DEPLOY_COUNT++)); fi
if [ "$DEPLOY_CLINE" = true ]; then ((DEPLOY_COUNT++)); fi
if [ "$DEPLOY_COPILOT" = true ]; then ((DEPLOY_COUNT++)); fi
if [ "$DEPLOY_CONTINUE" = true ]; then ((DEPLOY_COUNT++)); fi

if [ $DEPLOY_COUNT -eq 0 ]; then
    print_error "No IDEs selected for deployment."
    exit 1
fi

echo "Deploying to ${DEPLOY_COUNT} IDE format(s)..."
echo ""

# ====================================================================
# Deploy to Cursor
# ====================================================================

if [ "$DEPLOY_CURSOR" = true ]; then
    cp "$SOURCE" .cursorrules
    print_success "Cursor: .cursorrules"
fi

# ====================================================================
# Deploy to Windsurf
# ====================================================================

if [ "$DEPLOY_WINDSURF" = true ]; then
    # Legacy format
    cp "$SOURCE" .windsurfrules
    
    # Modern format
    mkdir -p .windsurf/rules
    cp "$SOURCE" .windsurf/rules/rules.md
    
    print_success "Windsurf: .windsurfrules + .windsurf/rules/rules.md"
fi

# ====================================================================
# Deploy to Cline
# ====================================================================

if [ "$DEPLOY_CLINE" = true ]; then
    mkdir -p .clinerules/rules
    cp "$SOURCE" .clinerules/rules/main.md
    
    # Optional: Also copy universal constraints as separate file
    if [ -f "templates/universal-constraints.md" ]; then
        cp "templates/universal-constraints.md" .clinerules/rules/security.md
        print_success "Cline: .clinerules/rules/main.md + security.md"
    else
        print_success "Cline: .clinerules/rules/main.md"
    fi
fi

# ====================================================================
# Deploy to GitHub Copilot
# ====================================================================

if [ "$DEPLOY_COPILOT" = true ]; then
    mkdir -p .github
    cp "$SOURCE" .github/copilot-instructions.md
    print_success "GitHub Copilot: .github/copilot-instructions.md"
fi

# ====================================================================
# Deploy to Continue
# ====================================================================

if [ "$DEPLOY_CONTINUE" = true ]; then
    cp "$SOURCE" .continuerules
    print_success "Continue: .continuerules"
fi

# ====================================================================
# Summary
# ====================================================================

echo ""
echo -e "${GREEN}╔══════════════════════════════════════════════════════════╗${NC}"
echo -e "${GREEN}║                   Deployment Complete!                   ║${NC}"
echo -e "${GREEN}╚══════════════════════════════════════════════════════════╝${NC}"
echo ""

print_info "Your ${STACK} rules are now deployed to ${DEPLOY_COUNT} IDE format(s)."

if [ "$DEPLOY_CURSOR" = true ] || [ "$DEPLOY_WINDSURF" = true ] || [ "$DEPLOY_CLINE" = true ]; then
    echo ""
    print_warning "Restart your IDE to load the new rules."
fi

echo ""
print_info "Next steps:"
echo "  1. Open your AI IDE"
echo "  2. Test with: 'What stack am I using?'"
echo "  3. Verify AI references your rules"
echo ""

# ====================================================================
# Create .gitignore Entry (Optional)
# ====================================================================

if [ ! -f .gitignore ]; then
    print_info "Creating .gitignore..."
    cat > .gitignore << 'EOF'
# AI IDE Rules (generated)
.cursorrules
.windsurfrules
.windsurf/
.clinerules/
.continuerules
.github/copilot-instructions.md
EOF
    print_success ".gitignore created"
    echo ""
    print_warning "Add templates/ to your repo, not the generated rule files."
fi

exit 0
