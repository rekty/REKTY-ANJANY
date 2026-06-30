# Setup Guide - Rekty Anjany Portfolio

Complete setup guide for developers who want to clone and run this project.

## 📋 Prerequisites Checklist

- [ ] Flutter SDK installed (3.0+)
- [ ] Dart SDK installed (3.0+)
- [ ] Git installed
- [ ] Code editor (VS Code recommended)
- [ ] Supabase account created
- [ ] Firebase account (optional, for deployment)

## 🚀 Step-by-Step Setup

### Step 1: Clone & Install

```bash
# Clone repository
git clone https://github.com/YOUR_USERNAME/rekty_anjany.git
cd rekty_anjany

# Install dependencies
flutter pub get

# Verify Flutter setup
flutter doctor
```

### Step 2: Supabase Setup

#### 2.1 Create Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Click "New Project"
3. Fill in project details
4. Wait for database to initialize (~2 minutes)

#### 2.2 Get Credentials

1. Go to Project Settings → API
2. Copy:
   - Project URL (e.g., `https://xxxxx.supabase.co`)
   - `anon` / `public` key

#### 2.3 Configure App

```bash
# Copy example config
cp lib/core/config/supabase_config.dart.example lib/core/config/supabase_config.dart
```

Edit `lib/core/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://YOUR_PROJECT_ID.supabase.co';
  static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
}
```

### Step 3: Database Schema

#### 3.1 Run SQL Schema

1. Open Supabase Dashboard → SQL Editor
2. Copy content from `supabase_schema.sql`
3. Click "Run" to execute

This will create:
- 10 tables
- RLS policies
- Indexes
- Functions

#### 3.2 Verify Tables

Go to Table Editor and verify these tables exist:
- `admin_users`
- `apps`
- `downloads`
- `products`
- `gallery_items`
- `blog_posts`
- `about_me`
- `contact_info`
- `contact_messages`
- `analytics`

### Step 4: Authentication Setup

#### 4.1 Configure OAuth Providers

**Google OAuth:**
1. Supabase Dashboard → Authentication → Providers
2. Enable Google
3. Add OAuth credentials from Google Cloud Console
4. Add redirect URL: `https://YOUR_PROJECT_ID.supabase.co/auth/v1/callback`

**GitHub OAuth:**
1. GitHub → Settings → Developer settings → OAuth Apps
2. Create new OAuth App
3. Copy Client ID and Secret to Supabase
4. Add callback URL: `https://YOUR_PROJECT_ID.supabase.co/auth/v1/callback`

**Facebook OAuth:**
1. Facebook Developers → Create App
2. Configure Facebook Login product
3. Add credentials to Supabase
4. Add OAuth redirect URI

#### 4.2 Add Your Admin Email

Supabase → Table Editor → `admin_users` → Insert row:

```sql
INSERT INTO admin_users (email, role)
VALUES ('your.email@gmail.com', 'super_admin');
```

**Important:** Use the email associated with your OAuth provider!

### Step 5: Storage Setup (Optional)

If you want to upload images:

1. Supabase → Storage → Create bucket: `apps`
2. Set bucket to **public**
3. Create more buckets as needed:
   - `downloads`
   - `gallery`
   - `blog`
   - `products`

### Step 6: Run Development Server

```bash
flutter run -d chrome
```

Or for Windows Edge:
```bash
flutter run -d edge
```

Access at: `http://localhost:PORT`

### Step 7: Test Admin Access

1. Go to `http://localhost:PORT/#/login`
2. Click "Login with Google" (or GitHub/Facebook)
3. Sign in with your admin email
4. You should be redirected to admin dashboard

If you see "Access Denied":
- Verify email in `admin_users` table matches exactly
- Check RLS policies are enabled
- Check browser console for errors

## 🔧 Troubleshooting

### Issue: "Access Denied" in Admin Panel

**Solution:**
1. Verify admin email in database:
   ```sql
   SELECT * FROM admin_users WHERE email = 'your.email@gmail.com';
   ```
2. Check RLS policy:
   ```sql
   SELECT * FROM admin_users WHERE email = auth.jwt()->>'email';
   ```

### Issue: OAuth Redirect Error

**Solution:**
1. Check redirect URLs in Supabase Dashboard
2. Make sure URL includes `/auth/callback`
3. For local dev: `http://localhost:PORT/auth/callback`
4. For production: `https://your-domain.com/auth/callback`

### Issue: Supabase Connection Error

**Solution:**
1. Verify Project URL is correct
2. Verify Anon Key is correct
3. Check Supabase project is not paused
4. Test connection in browser: `https://YOUR_PROJECT.supabase.co/rest/v1/`

### Issue: CORS Error

**Solution:**
Supabase automatically handles CORS. If you see CORS errors:
1. Clear browser cache
2. Rebuild Flutter app: `flutter clean && flutter pub get`
3. Check Supabase project is active

### Issue: Build Errors

**Solution:**
```bash
flutter clean
flutter pub get
flutter pub upgrade
flutter doctor
flutter build web
```

## 📦 Production Deployment

### Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize (first time only)
firebase init hosting

# Build and deploy
flutter build web --release
firebase deploy --only hosting
```

### Update Redirect URLs

After deployment, update OAuth redirect URLs:
- Supabase → Auth → URL Configuration
- Add production URL: `https://your-domain.web.app/auth/callback`

## 🔐 Security Checklist

Before pushing to GitHub:

- [ ] `supabase_config.dart` is in `.gitignore`
- [ ] `.env` files are in `.gitignore`
- [ ] No hardcoded passwords or secrets
- [ ] Firebase config is public (safe)
- [ ] Supabase anon key is public (safe)
- [ ] Admin emails are not in code
- [ ] RLS policies are enabled on all tables

## 📝 Next Steps

After setup:

1. **Customize Theme:**
   - Edit `lib/core/constants/app_colors.dart`
   - Modify `lib/core/constants/app_radius.dart`

2. **Add Content:**
   - Login to admin panel
   - Create apps, downloads, blog posts, etc.

3. **Customize Pages:**
   - Edit about page content
   - Update contact information
   - Add your portfolio items

4. **Deploy:**
   - Build for production
   - Deploy to Firebase Hosting
   - Test all features

## 🎯 Common Tasks

### Adding a New Admin

```sql
INSERT INTO admin_users (email, role)
VALUES ('new.admin@example.com', 'admin');
```

Roles:
- `super_admin` - Full access
- `admin` - Standard admin access
- `editor` - Content editing only

### Resetting Database

```sql
-- Drop all tables
DROP TABLE IF EXISTS analytics CASCADE;
DROP TABLE IF EXISTS contact_messages CASCADE;
DROP TABLE IF EXISTS contact_info CASCADE;
DROP TABLE IF EXISTS about_me CASCADE;
DROP TABLE IF EXISTS blog_posts CASCADE;
DROP TABLE IF EXISTS gallery_items CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS downloads CASCADE;
DROP TABLE IF EXISTS apps CASCADE;
DROP TABLE IF EXISTS admin_users CASCADE;

-- Re-run supabase_schema.sql
```

### Updating Supabase Schema

1. Make changes in Supabase SQL Editor
2. Export schema: Dashboard → Database → SQL Editor → Save to file
3. Update `supabase_schema.sql` in repo
4. Document changes in commit message

## 📞 Need Help?

- 📧 Email: rekty.anjany@gmail.com
- 🐛 Issues: [GitHub Issues](https://github.com/YOUR_USERNAME/rekty_anjany/issues)
- 📖 Docs: [Flutter Docs](https://flutter.dev/docs)
- 📖 Supabase: [Supabase Docs](https://supabase.com/docs)

---

Good luck! 🚀
