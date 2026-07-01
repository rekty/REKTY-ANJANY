# 🔒 Security Policy

## Overview

This project implements multiple layers of security to protect sensitive data and admin access.

---

## 🛡️ Security Measures

### 1. Credentials Protection

**✅ What is PROTECTED (Never in Git):**
- Supabase credentials (`supabase_config.dart`)
- Admin emails and passwords (database only)
- Environment variables (`.env`)
- Firebase admin SDK keys
- Private keys and certificates
- OAuth client secrets (Supabase only)

**✅ What is SAFE to commit:**
- Example configuration files (`*.example.dart`, `.env.example`)
- Database schema without data (`*.sql`)
- Public documentation
- Source code (no hardcoded credentials)

### 2. Row Level Security (RLS)

All Supabase tables are protected with RLS policies:

| Table | Public Access | Admin Access |
|-------|---------------|--------------|
| `apps` | ✅ Read | ✅ Full CRUD |
| `downloads` | ✅ Read | ✅ Full CRUD |
| `products` | ✅ Read | ✅ Full CRUD |
| `gallery_items` | ✅ Read | ✅ Full CRUD |
| `blog_posts` | ✅ Read | ✅ Full CRUD |
| `about_me` | ✅ Read | ✅ Full CRUD |
| `contact_info` | ✅ Read | ✅ Full CRUD |
| `contact_messages` | ✅ Insert only | ✅ Full CRUD |
| `admin_users` | ❌ None | ✅ Read only |

**Note:** `contact_messages` has RLS disabled to allow public form submission. Admin access is protected at application level.

### 3. Admin Access Control

**Database-Level:**
- Admin users stored in `admin_users` table
- Only whitelisted emails can access admin panel
- Email verification on every admin request
- JWT token validation via Supabase Auth

**Application-Level:**
- Route guards (`/admin/*` routes protected)
- Middleware checks authentication before rendering
- `isAdmin()` check against `admin_users` table
- Redirect to `/login` if unauthorized

**Authentication Methods:**
- ✅ Google OAuth
- ✅ GitHub OAuth
- ✅ Facebook OAuth
- ✅ Email/Password (Supabase Auth)

### 4. API Security

**Supabase REST API:**
- All requests require `apikey` header (anon key)
- Authenticated requests require `Authorization: Bearer <JWT>` header
- JWT tokens validated by Supabase
- Rate limiting enforced by Supabase (default limits)

**Admin Endpoints:**
```dart
// Admin requests automatically include JWT token
final response = await http.get(
  Uri.parse('$baseUrl/admin_users?email=eq.$email'),
  headers: {
    'apikey': SupabaseConfig.supabaseAnonKey,
    'Authorization': 'Bearer $accessToken', // Required for admin
  },
);
```

### 5. OAuth Configuration

**Redirect URLs:**
- ✅ Supabase callback: `https://YOUR_PROJECT.supabase.co/auth/v1/callback`
- ❌ Website URL (NOT added to OAuth providers)

**OAuth Providers:**
- Configured in Supabase Dashboard only
- Client secrets stored in Supabase (not in code)
- Tokens managed by Supabase Auth
- Automatic JWT refresh

---

## 🚨 Reporting Security Issues

If you discover a security vulnerability, please:

1. **DO NOT** open a public issue
2. **DO NOT** disclose publicly until fixed
3. Email the maintainer directly: rekty.anjany@gmail.com
4. Include:
   - Description of the vulnerability
   - Steps to reproduce
   - Potential impact
   - Suggested fix (if any)

**Response Time:** Within 48 hours for critical issues

---

## ✅ Security Checklist for Deployment

Before deploying to production:

### Configuration
- [ ] `.gitignore` includes all sensitive files
- [ ] `supabase_config.dart` is in `.gitignore`
- [ ] No hardcoded credentials in source code
- [ ] Environment variables properly configured
- [ ] OAuth redirect URLs correctly set

### Database
- [ ] RLS enabled on all tables (except contact_messages)
- [ ] RLS policies tested and working
- [ ] Admin users properly configured in `admin_users` table
- [ ] Database backups configured
- [ ] SSL/TLS enabled (Supabase default)

### Authentication
- [ ] OAuth providers configured in Supabase only
- [ ] Strong password policy enabled
- [ ] Email verification enabled (optional)
- [ ] 2FA recommended for admin accounts
- [ ] Session timeout configured

### Application
- [ ] Admin routes protected with middleware
- [ ] `isAdmin()` validation working
- [ ] JWT tokens validated on all admin requests
- [ ] Error messages don't leak sensitive info
- [ ] HTTPS enforced in production

### Monitoring
- [ ] Supabase logs monitored regularly
- [ ] Suspicious activity alerts configured
- [ ] Failed login attempts tracked
- [ ] API rate limits appropriate
- [ ] Database size monitored

---

## 🔐 Best Practices

### For Developers

**DO:**
- ✅ Use example files (`*.example.dart`, `.env.example`)
- ✅ Keep dependencies updated
- ✅ Use strong, unique passwords
- ✅ Enable 2FA on GitHub and OAuth accounts
- ✅ Review Supabase logs regularly
- ✅ Rotate OAuth secrets periodically
- ✅ Test RLS policies before deployment

**DON'T:**
- ❌ Commit `supabase_config.dart` or `.env` files
- ❌ Share admin credentials publicly
- ❌ Use service_role key in client apps
- ❌ Disable RLS without good reason
- ❌ Hardcode any credentials in source code
- ❌ Push to public repo without security review

### For Admin Users

**DO:**
- ✅ Use strong, unique passwords
- ✅ Enable 2FA on OAuth accounts (Google/GitHub/Facebook)
- ✅ Logout after admin session
- ✅ Use HTTPS only
- ✅ Review contact messages for spam
- ✅ Keep browser and OS updated

**DON'T:**
- ❌ Share admin credentials
- ❌ Use public computers for admin access
- ❌ Leave admin session open unattended
- ❌ Click suspicious links in contact messages
- ❌ Disable browser security features

---

## 📚 Security Resources

### Documentation
- [Supabase Security](https://supabase.com/docs/guides/auth)
- [Supabase RLS](https://supabase.com/docs/guides/auth/row-level-security)
- [OAuth 2.0 Best Practices](https://datatracker.ietf.org/doc/html/draft-ietf-oauth-security-topics)
- [Flutter Security](https://docs.flutter.dev/security)

### Tools
- [Supabase Dashboard](https://app.supabase.com) - Monitor logs & policies
- [GitHub Security Alerts](https://github.com/security) - Dependency vulnerabilities
- [Firebase Security Rules](https://firebase.google.com/docs/rules) - Hosting protection

---

## 🔄 Security Update Log

### Version 1.0.0 (July 2026)
- ✅ Initial security implementation
- ✅ RLS policies configured
- ✅ Admin authentication implemented
- ✅ OAuth integration (Google, GitHub, Facebook)
- ✅ `.gitignore` configured
- ✅ Example files created
- ✅ Documentation completed

---

## 📞 Contact

**Security Issues:** rekty.anjany@gmail.com

**General Support:** https://github.com/rekty/REKTY-ANJANY/issues

---

<p align="center">
  <b>Security is everyone's responsibility.</b><br>
  Report issues responsibly. Keep credentials secure.
</p>

---

**Last Updated:** July 1, 2026  
**Maintained By:** Rekty Anjany
