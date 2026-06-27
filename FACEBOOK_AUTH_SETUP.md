# 📘 Facebook OAuth Setup - Detail Guide

## 🎯 Setup Facebook Login untuk Website

### Step 1: Create Facebook App (5 menit)

1. **Buka Facebook Developers**
   - Go to: https://developers.facebook.com
   - Click **My Apps** di top right
   - Click **Create App**

2. **Select Use Case**
   - Pilih: **Authenticate and request data from users with Facebook Login**
   - Click **Next**

3. **Select App Type**
   - Pilih: **Consumer**
   - Click **Next**

4. **Add App Details**
   - **App name**: `Rekty Anjany`
   - **App contact email**: `rekty.anjany@gmail.com`
   - Click **Create app**
   - Complete security check jika diminta

---

### Step 2: Add Facebook Login Product (2 menit)

1. **Di App Dashboard**
   - Scroll ke section **Add products to your app**
   - Cari **Facebook Login**
   - Click **Set up**

2. **Choose Platform**
   - Pilih **Web**
   - **Site URL**: `https://rektyanjany.com` (atau domain kamu)
   - Click **Save**
   - Click **Continue**

3. **Skip Next Steps**
   - Bisa skip steps berikutnya (SDK installation dll)
   - Kita akan configure manual

---

### Step 3: Get App Credentials (1 menit)

1. **Go to Settings → Basic**
   - Di sidebar kiri, click **Settings**
   - Click **Basic**

2. **Copy Credentials**
   - **App ID**: Copy ini (contoh: `123456789012345`)
   - **App Secret**: Click **Show** button
     - Masukkan password Facebook kamu
     - Copy App Secret (contoh: `abc123def456...`)

3. **App Domains** (opsional)
   - Add domain: `rektyanjany.com`

---

### Step 4: Configure Facebook Login Settings (3 menit)

1. **Go to Facebook Login Settings**
   - Di sidebar: **Products** → **Facebook Login** → **Settings**

2. **Client OAuth Settings**
   - **Client OAuth Login**: ON ✅
   - **Web OAuth Login**: ON ✅
   - **Force Web OAuth Reauthentication**: OFF
   - **Use Strict Mode for Redirect URIs**: ON ✅ (recommended)

3. **Valid OAuth Redirect URIs** (PENTING!)
   Add URL ini:
   ```
   https://tdztcovdwewfsenzrtnq.supabase.co/auth/v1/callback
   ```
   
   Untuk testing lokal, tambahkan juga (opsional):
   ```
   http://localhost:5000/
   http://localhost:3000/
   ```

4. **Click Save Changes**

---

### Step 5: Make App Live (CRITICAL!) ⚠️

**PENTING**: Facebook app default dalam mode **Development**. Hanya kamu (developer) yang bisa login. Untuk production, HARUS switch ke **Live**!

1. **Switch to Live Mode**
   - Di top bar, lihat toggle **In development**
   - Click toggle tersebut
   - Atau: Di sidebar, click **App Mode**
   - Switch dari **Development** ke **Live**

2. **App Review** (mungkin perlu)
   - Jika diminta app review untuk permissions:
     - `email` - biasanya auto-approved
     - `public_profile` - biasanya auto-approved
   - Untuk permissions lain, submit untuk review

3. **Verify Live Status**
   - Top bar harus menunjukkan **Live** (hijau)
   - Bukan **In development** (orange)

---

### Step 6: Configure di Supabase (2 menit)

1. **Open Supabase Dashboard**
   - Go to: https://supabase.com/dashboard
   - Select your project: `rekty-anjany`

2. **Enable Facebook Provider**
   - Click **Authentication** di sidebar
   - Click **Providers**
   - Scroll ke **Facebook**
   - Toggle **Enable Sign in with Facebook** → ON

3. **Enter Credentials**
   - **Facebook client ID**: Paste App ID dari Facebook
   - **Facebook secret**: Paste App Secret dari Facebook
   - Click **Save**

4. **Copy Callback URL**
   - Di Supabase, ada **Callback URL (for OAuth)**
   - Pastikan ini sama dengan yang kamu paste di Facebook:
   ```
   https://tdztcovdwewfsenzrtnq.supabase.co/auth/v1/callback
   ```

---

## 🧪 Testing Facebook Login

### Test Flow

1. **Run App**
   ```bash
   flutter run -d chrome
   ```

2. **Go to Login Page**
   - Navigate to `/login`

3. **Click Facebook Button**
   - Click **"Continue with Facebook"**
   - Browser akan redirect ke Facebook

4. **Facebook Authorization**
   - Jika belum login Facebook: Login dulu
   - Jika sudah login: Click **"Continue as [Your Name]"**
   - Review permissions: email, public_profile
   - Click **"Continue"**

5. **Redirect Back**
   - Facebook akan redirect kembali ke website kamu
   - User sekarang logged in!

---

## 🔍 Verify Login Success

### Check di Browser Console (F12)

```javascript
// Setelah login, check localStorage
localStorage.getItem('supabase.auth.token')
```

### Check di Supabase Dashboard

1. Go to **Authentication** → **Users**
2. Lihat user baru dengan provider: `facebook`
3. Check user metadata:
   - Name
   - Email
   - Avatar URL
   - Facebook ID

---

## 🚨 Common Issues & Solutions

### Issue 1: "App Not Setup: This app is still in development mode"

**Cause**: App masih dalam Development mode

**Fix**:
1. Go to Facebook App Dashboard
2. Top bar: Switch dari **Development** → **Live**
3. Atau: Sidebar → **App Mode** → Switch to Live

---

### Issue 2: "redirect_uri_mismatch" atau "Can't Load URL"

**Cause**: Redirect URI di Facebook tidak match dengan Supabase

**Fix**:
1. Check **Valid OAuth Redirect URIs** di Facebook Login Settings
2. Must be EXACT: `https://tdztcovdwewfsenzrtnq.supabase.co/auth/v1/callback`
3. No trailing slash!
4. Save changes di Facebook
5. Wait 1-2 minutes untuk propagate

---

### Issue 3: "Invalid OAuth access token"

**Cause**: App Secret salah atau expired

**Fix**:
1. Facebook App → Settings → Basic
2. Reset App Secret:
   - Click **Reset** next to App Secret
   - Copy new secret
3. Update di Supabase dengan App Secret yang baru

---

### Issue 4: "The parameter app_id is required"

**Cause**: App ID tidak ter-configure dengan benar

**Fix**:
1. Check App ID di Supabase
2. Pastikan tidak ada spaces atau typo
3. Re-copy dari Facebook Settings → Basic

---

### Issue 5: Facebook popup blocked

**Cause**: Browser block popups

**Fix**:
1. Allow popups untuk localhost atau domain kamu
2. Chrome: Click icon di address bar → Always allow popups
3. Atau setting browser: Allow popups for this site

---

### Issue 6: Stuck di Facebook login page

**Cause**: Multiple issues possible

**Fix**:
1. Clear browser cookies untuk facebook.com
2. Check Valid OAuth Redirect URIs
3. Try different browser
4. Check if app is in Live mode

---

## 🎨 Customize Facebook Login

### Request Additional Permissions

Jika perlu data lebih dari user:

1. **Di kode** (opsional parameter):
```dart
await _supabase.client.auth.signInWithOAuth(
  OAuthProvider.facebook,
  redirectTo: 'https://your-website.com/',
  scopes: 'email,public_profile,user_birthday', // tambah scopes
);
```

2. **Di Facebook App**:
   - App Review → Permissions and Features
   - Request permission: `user_birthday`, `user_friends`, dll
   - Submit for review

### Common Scopes

- `email` - Email address ✅ (default)
- `public_profile` - Name, picture ✅ (default)
- `user_birthday` - Birthday (needs review)
- `user_friends` - Friends list (needs review)
- `user_photos` - Photos (needs review)

---

## 🔒 Security Best Practices

### 1. Keep App Secret Safe

- ❌ JANGAN commit App Secret ke Git
- ❌ JANGAN share di public
- ✅ Simpan di environment variables
- ✅ Rotate secret jika leaked

### 2. Use HTTPS

- ✅ Production harus HTTPS
- ✅ Redirect URI harus HTTPS
- ❌ HTTP hanya untuk localhost testing

### 3. Validate Redirect URIs

- ✅ Use Strict Mode
- ✅ Whitelist exact URLs
- ❌ Jangan gunakan wildcards

---

## 📊 Monitor Login Activity

### Facebook Analytics

1. Go to Facebook App Dashboard
2. **Analytics** → **App Events**
3. Monitor:
   - Login success/failure rates
   - Active users
   - Demographics

### Supabase Analytics

1. Supabase Dashboard → **Authentication** → **Users**
2. Filter by provider: `facebook`
3. Check:
   - Total Facebook users
   - Last sign in
   - Registration trends

---

## 🎯 Production Checklist

Before going live:

- [ ] App is in **Live** mode (not Development)
- [ ] Valid OAuth Redirect URIs configured
- [ ] App ID and Secret pasted in Supabase
- [ ] Privacy Policy URL added (Facebook requirement)
- [ ] Terms of Service URL added (Facebook requirement)
- [ ] App icon uploaded (recommended)
- [ ] Tested login flow end-to-end
- [ ] Verified user data appears in Supabase

---

## 📚 Additional Resources

- [Facebook Login Documentation](https://developers.facebook.com/docs/facebook-login)
- [Facebook App Review](https://developers.facebook.com/docs/app-review)
- [Supabase Facebook Auth](https://supabase.com/docs/guides/auth/social-login/auth-facebook)

---

## 🎊 Summary

**Setup Time**: ~15 minutes
**Difficulty**: Easy-Medium
**Requirements**:
- Facebook account
- Supabase project
- Website domain (or localhost for testing)

**Status**: ✅ Ready for Production

Once Facebook app is **Live** and configured, users dapat login dengan Facebook account mereka! 🚀

---

Made with ❤️ by Kiro for Rekty Anjany
