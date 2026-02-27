#!/usr/bin/env bash
# ════════════════════════════════════════════════════════
#  Autodesk Mail AI — One-Click Deploy Script
#  Usage: bash deploy.sh
# ════════════════════════════════════════════════════════

set -e

GREEN='\033[0;32m'
ORANGE='\033[0;33m'
RED='\033[0;31m'
NC='\033[0m'

echo ""
echo -e "${ORANGE}▶ Autodesk Mail AI — Deployment${NC}"
echo "────────────────────────────────"

# ── Check Node / Vercel ──
if ! command -v node &> /dev/null; then
  echo -e "${RED}✗ Node.js not found. Install from https://nodejs.org${NC}"
  exit 1
fi

if ! command -v vercel &> /dev/null; then
  echo -e "${ORANGE}Installing Vercel CLI…${NC}"
  npm install -g vercel
fi

# ── Deploy to Vercel ──
echo ""
echo -e "${GREEN}▶ Deploying to Vercel…${NC}"
DEPLOY_OUTPUT=$(vercel --prod --yes 2>&1)
DEPLOY_URL=$(echo "$DEPLOY_OUTPUT" | grep -Eo 'https://[a-zA-Z0-9._-]+\.vercel\.app' | tail -1)

if [ -z "$DEPLOY_URL" ]; then
  echo -e "${RED}✗ Could not detect deployment URL. Check Vercel output above.${NC}"
  echo "$DEPLOY_OUTPUT"
  exit 1
fi

echo -e "${GREEN}✓ Deployed to: ${DEPLOY_URL}${NC}"

# ── Patch manifest.xml ──
echo ""
echo -e "${GREEN}▶ Patching manifest.xml with live URL…${NC}"
sed -i.bak "s|DEPLOY_URL|${DEPLOY_URL}|g" manifest.xml
echo -e "${GREEN}✓ manifest.xml updated${NC}"

# ── Re-deploy with patched manifest ──
echo ""
echo -e "${GREEN}▶ Re-deploying with patched manifest…${NC}"
vercel --prod --yes > /dev/null 2>&1
echo -e "${GREEN}✓ Final deployment complete${NC}"

# ── Done ──
echo ""
echo "════════════════════════════════════════"
echo -e "${GREEN}✅ DEPLOYMENT COMPLETE${NC}"
echo "════════════════════════════════════════"
echo ""
echo "  Live URL:  ${DEPLOY_URL}"
echo "  Taskpane:  ${DEPLOY_URL}/taskpane.html"
echo "  Manifest:  ${DEPLOY_URL}/manifest.xml"
echo ""
echo -e "${ORANGE}NEXT STEPS — Sideload the Add-in:${NC}"
echo ""
echo "  1. Go to: https://outlook.office.com"
echo "  2. Click gear icon → View all Outlook settings"
echo "  3. Mail → Customize actions → Manage add-ins"
echo "  4. My add-ins → Add a custom add-in → Add from file"
echo "  5. Upload: manifest.xml  (from this folder)"
echo ""
echo "  Then open any email → click 'AI Assistant' in the ribbon"
echo "  Enter your Anthropic API key (sk-ant-...) on first launch"
echo ""
