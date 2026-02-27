# Autodesk Mail AI — Outlook Add-in

An AI-powered email assistant built for Autodesk professionals, deeply knowledgeable about AEC, MFG, and Utility verticals.

---

## Features

| Feature | Description |
|---|---|
| **Smart Reply** | Generate context-aware replies with tone control (Professional, Concise, Consultative, Friendly) |
| **Grammar Engine** | Fix, rewrite, shorten, formalize, or simplify any email text |
| **Compose** | Draft full emails from a prompt, with vertical-specific templates |
| **Email Insights** | Analyze sentiment, intent, urgency, opportunities, and risks |
| **Autodesk Knowledge** | Pre-tuned on AEC, MFG, and Utility workflows, products, and buyer personas |

---

## File Structure

```
outlook-addin/
├── manifest.xml       ← Outlook add-in manifest (register this with Microsoft)
├── taskpane.html      ← Full task pane UI + AI logic (single-file app)
├── commands.html      ← Required stub for ribbon commands
└── README.md          ← This file
```

---

## Setup & Deployment

### Step 1 — Get an Anthropic API Key

1. Go to https://console.anthropic.com
2. Create an account and generate an API key (`sk-ant-...`)
3. Keep it handy — you'll enter it in the add-in on first use

### Step 2 — Host the Files

The add-in files must be served over **HTTPS**. Options:

#### Option A: Vercel (Recommended — Free & Easy)
```bash
npm install -g vercel
cd outlook-addin
vercel --prod
```
Vercel will give you a URL like `https://your-app.vercel.app`. 

#### Option B: Azure Static Web Apps (Microsoft-native)
```bash
az staticwebapp create --name autodesk-mail-ai --resource-group myRG
```

#### Option C: Any HTTPS host
Upload `taskpane.html`, `commands.html` to any web host with SSL.

### Step 3 — Update manifest.xml

Replace every `https://your-domain.com` in `manifest.xml` with your actual hosted URL.

```xml
<!-- Example -->
<SourceLocation DefaultValue="https://your-app.vercel.app/taskpane.html"/>
```

### Step 4 — Sideload into Outlook

#### Outlook on the Web (OWA)
1. Open Outlook Web (outlook.office.com)
2. Click the gear icon → **View all Outlook settings**
3. Go to **Mail → Customize actions → Manage add-ins**
4. Click **My add-ins → Add a custom add-in → Add from file**
5. Upload your `manifest.xml`

#### Outlook Desktop (Windows)
1. Open Outlook
2. Go to **File → Options → Customize Ribbon**
3. Or: **Home tab → Get Add-ins → My add-ins → Custom add-ins → Add from File**
4. Upload `manifest.xml`

#### Enterprise Deployment (Microsoft 365 Admin)
1. Go to https://admin.microsoft.com
2. **Settings → Integrated apps → Upload custom app**
3. Upload `manifest.xml` — it deploys to all org users

### Step 5 — Enter Your API Key

1. Open any email in Outlook
2. Click the **AI Assistant** button in the ribbon
3. Enter your Anthropic API key in the field at the top
4. Click **Save** — it's stored locally in the browser

---

## Usage Guide

### Reply Tab
1. Open an email
2. Select a **tone** (Professional / Concise / Consultative / Friendly)
3. Click a **Quick Action** (Acknowledge, Need More Info, Schedule Meeting, etc.)
4. Review the generated reply
5. Click **Insert →** to place it directly in your reply compose window
6. Use **Custom Prompt** for freeform instructions

### Grammar Tab
1. Paste or type any text
2. Click an action: Fix Grammar, Rewrite Clearly, Shorten, Make Formal, Make Technical, Simplify
3. Review the before/after comparison
4. **Copy** to clipboard or **Apply to Compose** tab

### Compose Tab
1. Select your **Vertical** (AEC / MFG / Utility / General)
2. Use a **Template** shortcut or type your own description
3. Click **Generate Email**
4. Click **Insert →** to place in your compose window

### Insights Tab
- **Sentiment**: Is this customer happy, frustrated, or neutral?
- **Intent**: What are they actually asking for?
- **Identify Vertical**: Which Autodesk business unit should own this?
- **Urgency Level**: How fast do you need to respond?
- **Opportunities**: What can you upsell or cross-sell?
- **Risks & Flags**: Any churn signals or competitive threats?

---

## Autodesk Knowledge Coverage

### AEC
- Revit, Civil 3D, AutoCAD, Navisworks, InfraWorks
- Autodesk Construction Cloud (ACC), BIM 360, Forma, Tandem
- BIM workflows, CDE, ISO 19650, clash detection, 4D/5D scheduling

### MFG
- Fusion 360, Inventor, AutoCAD Mechanical, Vault
- PDM/PLM, CAD-to-CAM, simulation, generative design, ERP integration

### Utility
- AutoCAD Map 3D, Civil 3D, InfraWorks
- GIS integration, asset lifecycle management, digital twin, regulatory compliance

---

## Customization

### Add Your Own Knowledge
Edit the `AUTODESK_SYSTEM` constant in `taskpane.html` to add:
- Your specific sales territory or named accounts
- Custom product bundles or pricing context
- Regional compliance requirements
- Company-specific email signature templates

### Change the AI Model
In `taskpane.html`, find:
```javascript
model: 'claude-opus-4-6',
```
Options:
- `claude-opus-4-6` — Most capable (recommended)
- `claude-sonnet-4-6` — Faster, cheaper
- `claude-haiku-4-5-20251001` — Fastest, for quick grammar fixes

---

## Security Notes

- Your API key is stored in `localStorage` (browser-local, never transmitted elsewhere)
- Email body content is sent to Anthropic's API for processing — review your org's data policy
- For enterprise use, consider building a thin backend proxy so the API key never leaves your servers

---

## Troubleshooting

| Issue | Fix |
|---|---|
| Add-in doesn't appear | Check manifest.xml URLs are HTTPS and reachable |
| API key error | Verify key starts with `sk-ant-` and has credits |
| "Insert" doesn't work | Add-in needs `ReadWriteMailbox` permission in manifest |
| CORS errors | Anthropic API supports direct browser access with the `anthropic-dangerous-direct-browser-access` header |

---

## License

MIT — Free to use and modify for internal Autodesk team use.
