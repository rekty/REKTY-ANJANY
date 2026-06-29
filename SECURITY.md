# 🔒 Security Guide

## 🛡️ Credentials Management

### What's Safe to Commit
✅ **Supabase Anon Key** - Designed for client-side use
✅ **Supabase URL** - Public project URL
✅ **Firebase Config** - Client configuration
✅ **Public API endpoints** - Read-only APIs

### What's NEVER Safe to Commit
⛔ **Service Role Key** - Full database access
⛔ **Database Password** - Direct database access
⛔ **Private API Keys** - Paid services keys
⛔ **OAuth Client Secrets** - OAuth provider secrets
⛔ **Encryption Keys** - Data encryption keys

---

## 🔐 Environment Variables

### Local Development

1. **Copy template:**
```bash
cp .env.example .env
```

2. **Fill in your credentials in `.env`:**
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=eyJ...your-actual-key
```

3. **Never commit `.env` file!** (already in `.gitignore`)

### Production (Firebase Hosting)

For Flutter Web deployed to Firebase, credentials are compiled into the JS bundle. This is acceptable because:

1. **Anon Key is Public** - Designed for client-side use
2. **Row Level Security (RLS)** - Protects database at Supabase level
3. **OAuth Security** - Users authenticate via OAuth providers
4. **No Service Role Key** - Never expose admin credentials

---

## 🔒 Supabase Security

### Row Level Security (RLS)

Enable RLS on all tables in Supabase:

```sql
-- Enable RLS on apps table
ALTER TABLE apps ENABLE ROW LEVEL SECURITY;

-- Policy: Anyone can read
CREATE POLICY "Enable read access for all users"
ON apps FOR SELECT
USING (true);

-- Policy: Only authenticated users can insert
CREATE POLICY "Enable insert for authenticated users only"
ON apps FOR INSERT
WITH CHECK (auth.role() = 'authenticated');

-- Policy: Only owners can update
CREATE POLICY "Enable update for owners only"
ON apps FOR UPDATE
USING (auth.uid() = user_id);
```

Apply similar policies to:
- `blog_posts`
- `products`
- `gallery_items`
- `downloads`
- `about_me`

### OAuth Configuration

**Redirect URLs (whitelist only these):**
- Production: `https://rekty-anjany-5a2eb.web.app/auth/callback`
- Localhost: `http://localhost:8080/auth/callback`

**Never expose:**
- OAuth Client Secrets
- OAuth Refresh Tokens (server-side only)

---

## 🚨 What to Do if Credentials Leaked

### 1. Rotate Supabase Keys Immediately
- Go to Supabase Dashboard → Settings → API
- Click "Reset" on Anon Key
- Update `.env` file with new key
- Redeploy application

### 2. Check GitHub History
```bash
# Remove sensitive file from Git history
git filter-branch --force --index-filter \
  "git rm --cached --ignore-unmatch lib/core/config/supabase_config.dart" \
  --prune-empty --tag-name-filter cat -- --all

# Force push (WARNING: rewrites history)
git push origin --force --all
```

### 3. Revoke OAuth Apps
- Go to each OAuth provider (Google, GitHub, Facebook)
- Revoke or regenerate client secrets
- Update Supabase Auth settings

### 4. Monitor Access Logs
- Check Supabase Dashboard → Logs
- Look for suspicious access patterns
- Enable alerts for unusual activity

---

## ✅ Security Checklist Before Push

- [ ] No `.env` file in commit
- [ ] No hardcoded passwords in code
- [ ] `.gitignore` includes `.env`
- [ ] Service Role Key not in code
- [ ] Database password not exposed
- [ ] OAuth secrets not committed
- [ ] RLS enabled on all tables
- [ ] Redirect URLs whitelisted
- [ ] HTTPS enforced (Firebase does this)

---

## 📚 Additional Resources

- [Supabase Security Best Practices](https://supabase.com/docs/guides/auth/row-level-security)
- [OWASP Top 10](https://owasp.org/www-project-top-ten/)
- [Firebase Security Rules](https://firebase.google.com/docs/rules)
- [GitHub Security](https://docs.github.com/en/code-security)

---

## 📞 Report Security Issue

If you find a security vulnerability, please:
1. **DO NOT** open a public issue
2. Email directly: security@rektyanjany.com
3. Include detailed description and steps to reproduce

---

**Last Updated:** June 29, 2026  
**Maintained by:** Rekty Anjany
