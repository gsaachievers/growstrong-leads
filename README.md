# GrowStrong Achievers — Lead Capture Portal

Static GitHub Pages website + Supabase database. Public form at `index.html`; password-protected staff dashboard at `leads.html`. No backend server required.

## 1. Supabase setup
1. Open your Supabase project > **SQL Editor** > New query. Paste and run `schema.sql`.
2. Open **Project Settings > API** (or **Connect** in newer UI). Copy **Project URL** and **publishable key** (or legacy `anon` key). **Never use `service_role` or secret keys in browser files.**
3. Copy `config.example.js` to `config.js`, replace placeholders, and commit `config.js` to GitHub. Publishable/anon keys are safe in public clients *only with RLS configured*.
4. Under **Authentication > Users**, invite or create a staff user with email and password. **Do not enable unrestricted self-sign-up** if only staff should see all leads. If using invitations, set Auth URL configuration Site URL / Redirect URLs to your deployed GitHub Pages site as appropriate.

## 2. GitHub Pages
1. Create a repository, upload all files including `config.js`.
2. GitHub > repo > **Settings > Pages** > **Deploy from branch** > main / root > Save.
3. Wait for your URL (e.g. `https://username.github.io/repository/`). The public form is `.../index.html`, staff view is `.../leads.html`.
4. Open public form and submit a test lead; check **Supabase > Table Editor > gsa_leads**. Then log into dashboard, update a status and export CSV (opens in Excel).
5. Print the QR displayed on the public form **after publishing**. Before publishing, it points to your local URL and will not work for customers.

## Important security / operational notes
- Public visitors can **insert** leads but cannot read them. Authenticated users can view/update all leads. Only provision trusted staff accounts; for role-based per-center access, add a separate staff roles table and tighter RLS before rollout.
- The public form allows anonymous submissions and may receive spam. Consider CAPTCHA + server-side verification / rate limiting for production. Supabase API request quotas apply.
- QR image uses `api.qrserver.com` to encode the public form URL. No lead details are sent to that service.
- CSV export includes only currently filtered and loaded leads, up to latest 5,000. CSV is Excel-compatible; not a native `.xlsx`. Leads are stored in Supabase, **not automatically appended to a shared Excel workbook**.
- Ensure you have a privacy notice and appropriate consent for collecting parent/child details. Avoid sensitive child health information in Notes.
