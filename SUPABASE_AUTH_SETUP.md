# 🔐 Supabase Authentication Setup Guide

## Login dengan Email, Google, GitHub & Facebook

Website kamu sekarang mendukung 4 metode login:
- ✅ **Email/Password** - Login tradisional
- ✅ **Google OAuth** - Login dengan akun Google
- ✅ **GitHub OAuth** - Login dengan akun GitHub
- ✅ **Facebook OAuth** - Login dengan akun Facebook

---

## 📋 Yang Sudah Dikerjakan

### 1. ✅ Login Page Updated
**File**: `lib/features/login/login_page.dart`

Fitur:
- Email/password login form
- Tombol "Sign in with Google"
- Tombol "Sign in with GitHub"
- Tombol "Continue with Facebook"
- Error handling dengan pesan bahasa Indonesia
- Loading states
- Success notifications

### 2. ✅ SupabaseService Ready
**File**: `lib/core/services/supabase_service.dart`

Methods tersedia:
- `signInWithEmail()` - Login dengan email
- `signUpWithEmail()` - Register dengan email
- `signOut()` - Logout
- OAuth dengan `client.auth.signInWithOAuth()`

---

## 🚀 Setup OAuth di Supabase Dashboard

### Step 1: Enable Google OAuth

1. **Buka Supabase Dashboard**
   - Go to: https://supabase.com/dashboard
   - Pilih project kamu

2. **Buka Authentication Settings**
   - Klik **Authentication** di sidebar
   - Klik **Providers**

3. **Enable Google Provider**
   - Cari **Google** di list providers
   - Toggle **Enable Sign in with Google** → ON

4. **Dapatkan Google Client Credentials**
   
   a. **Buka Google Cloud Console**:
      - Go to: https://console.cloud.google.com
      - Create project baru atau pilih project yang ada
   
   b. **Enable Google+ API**:
      - Go to **APIs & Services** → **Library**
      - Search "Google+ API"
      - Click **Enable**
   
   c. **Create OAuth Credentials**:
      - Go to **APIs & Services** → **Credentials**
      - Click **Create Credentials** → **OAuth client ID**
      - Application type: **Web application**
      - Name: `Rekty Anjany Website`
      
   d. **Add Authorized redirect URIs**:
      - Copy **Callback URL** dari Supabase (format: `https://[PROJECT-REF].supabase.co/auth/v1/callback`)
      - Paste ke **Authorized redirect URIs**
      - Click **Create**
   
   e. **Copy Credentials**:
      - Copy **Client ID**
      - Copy **Client Secret**

5. **Paste ke Supabase**
   - Kembali ke Supabase Dashboard → Authentication → Providers → Google
   - Paste **Client ID** ke field "Client ID"
   - Paste **Client Secret** ke field "Client Secret"
   - Click **Save**

---

### Step 2: Enable GitHub OAuth

1. **Buka GitHub Settings**
   - Go to: https://github.com/settings/developers
   - Click **OAuth Apps**
   - Click **New OAuth App**

2. **Register Application**
   - **Application name**: `Rekty Anjany Website`
   - **Homepage URL**: `https://your-website.com` (atau URL website kamu)
   - **Authorization callback URL**: Copy dari Supabase (format: `https://[PROJECT-REF].supabase.co/auth/v1/callback`)
   - Click **Register application**

3. **Get Credentials**
   - Copy **Client ID**
   - Click **Generate a new client secret**
   - Copy **Client Secret** (simpan, tidak bisa dilihat lagi!)

4. **Paste ke Supabase**
   - Kembali ke Supabase Dashboard → Authentication → Providers → GitHub
   - Toggle **Enable Sign in with GitHub** → ON
   - Paste **Client ID**
   - Paste **Client Secret**
   - Click **Save**

---

### Step 3: Enable Facebook OAuth

1. **Buka Facebook Developers**
   - Go to: https://developers.facebook.com
   - Login dengan akun Facebook kamu

2. **Create App**
   - Click **My Apps** → **Create App**
   - Use case: **Authenticate and request data from users with Facebook Login**
   - App type: **Consumer**
   - Click **Next**

3. **App Details**
   - **App Name**: `Rekty Anjany`
   - **App Contact Email**: `rekty.anjany@gmail.com`
   - Click **Create App**

4. **Add Facebook Login Product**
   - Di dashboard app, scroll ke **Add Products**
   - Cari **Facebook Login**
   - Click **Set Up**

5. **Configure OAuth Settings**
   - Pilih platform: **Web**
   - Site URL: `https://your-website.com` (atau URL website kamu)
   - Click **Save**
   - Click **Settings** → **Basic** di sidebar

6. **Get App Credentials**
   - Copy **App ID**
   - Click **Show** pada **App Secret** → Copy

7. **Add Valid OAuth Redirect URIs**
   - Di sidebar: **Facebook Login** → **Settings**
   - **Valid OAuth Redirect URIs**: Tambahkan URL ini:
     ```
     https://tdztcovdwewfsenzrtnq.supabase.co/auth/v1/callback
     ```
   - Click **Save Changes**

8. **Make App Live** (PENTING!)
   - Di top bar, toggle dari **In development** ke **Live**
   - Atau go to **App Mode** di sidebar dan switch to Live

9. **Paste ke Supabase**
   - Kembali ke Supabase Dashboard → Authentication → Providers → Facebook
   - Toggle **Enable Sign in with Facebook** → ON
   - Paste **Facebook client ID** (App ID)
   - Paste **Facebook secret** (App Secret)
   - Click **Save**

---

### Step 4: Update Redirect URL di Kode

Edit file: `lib/features/login/login_page.dart`

Cari 3 baris ini:
```dart
redirectTo: 'https://your-website.com/', // Ganti dengan URL website kamu
```

Ganti dengan:
```dart
redirectTo: 'https://rektyanjany.com/', // Atau URL production kamu
```

**Untuk testing lokal**, gunakan:
```dart
redirectTo: 'http://localhost:5000/', // Untuk flutter run di chrome
```

---

## 🧪 Testing Authentication

### 1. Test Email/Password Login

**Pertama, buat user test di Supabase:**

```sql
-- Jalankan di Supabase SQL Editor
-- Ini akan create user test dengan email verified

-- ATAU bisa manual lewat dashboard:
-- Authentication → Users → Add User
```

**Atau gunakan register (jika sudah buat halaman register)**

Kemudian test login:
1. Run app: `flutter run -d chrome`
2. Go to `/login`
3. Masukkan email & password
4. Click "Sign In"
5. ✅ Harus berhasil login dan redirect ke home

---

### 2. Test Google Login

1. Run app: `flutter run -d chrome`
2. Go to `/login`
3. Click **"Sign in with Google"**
4. Popup Google akan muncul
5. Pilih akun Google kamu
6. ✅ Harus redirect ke website setelah berhasil

**Troubleshooting**:
- Jika popup blocked: Allow popups di browser
- Jika error "redirect_uri_mismatch": Cek redirect URI di Google Console
- Jika error "unauthorized_client": Tunggu 5 menit, Google perlu propagate settings

---

### 3. Test GitHub Login

1. Run app: `flutter run -d chrome`
2. Go to `/login`
3. Click **"Sign in with GitHub"**
4. Redirect ke GitHub authorization page
5. Click **"Authorize"**
6. ✅ Harus redirect ke website setelah berhasil

**Troubleshooting**:
- Jika error "redirect_uri_mismatch": Cek callback URL di GitHub OAuth App settings
- Jika error "bad_verification_code": Client secret salah, cek lagi di GitHub

---

---

## 🔒 Security Settings di Supabase

### Enable Email Confirmations (Opsional)

Jika ingin user harus konfirmasi email dulu:

1. Supabase Dashboard → Authentication → Settings
2. **Enable email confirmations** → ON
3. User akan dapat email konfirmasi setelah register
4. Mereka harus click link di email sebelum bisa login

### Disable Email Confirmations (Untuk Testing)

Jika ingin langsung bisa login tanpa konfirmasi:

1. Supabase Dashboard → Authentication → Settings
2. **Enable email confirmations** → OFF
3. User bisa langsung login setelah register

---

## 🎨 Customize Email Templates

Untuk custom email yang dikirim Supabase:

1. Supabase Dashboard → Authentication → Email Templates
2. Edit templates:
   - **Confirm signup** - Email konfirmasi register
   - **Magic Link** - Magic link login
   - **Change Email Address** - Konfirmasi ganti email
   - **Reset Password** - Reset password

Template menggunakan **HTML** dan **Variables**:
```html
<h2>Welcome to Rekty Anjany!</h2>
<p>Click below to confirm your email:</p>
<a href="{{ .ConfirmationURL }}">Confirm Email</a>
```

---

## 📊 Monitor Users

### Check Logged In Users

1. Supabase Dashboard → Authentication → Users
2. Lihat list semua users
3. Info yang tersedia:
   - Email
   - Provider (email, google, github)
   - Created at
   - Last sign in
   - Confirmed status

### Manual User Management

Dari dashboard kamu bisa:
- ✅ Add user manual
- ❌ Delete user
- 🔒 Disable user
- ✉️ Resend confirmation email

---

## 🚨 Common Issues & Fixes

### Issue 1: "Invalid login credentials"
**Cause**: Email/password salah atau user belum exist

**Fix**:
1. Pastikan user sudah register
2. Check email & password benar
3. Atau buat user test di Supabase dashboard

### Issue 2: "Email not confirmed"
**Cause**: Email confirmation enabled tapi user belum konfirmasi

**Fix**:
1. Check inbox email user
2. Click confirmation link
3. Atau disable email confirmation di settings

### Issue 3: OAuth popup blocked
**Cause**: Browser block popups

**Fix**:
1. Allow popups untuk localhost atau domain kamu
2. Click icon di address bar
3. Click "Always allow popups"

### Issue 4: "redirect_uri_mismatch"
**Cause**: Callback URL tidak match dengan yang di Google/GitHub

**Fix**:
1. Copy exact callback URL dari Supabase
2. Paste ke Google Console / GitHub OAuth App
3. Format: `https://[PROJECT-REF].supabase.co/auth/v1/callback`
4. Tunggu 5 menit untuk Google propagate

### Issue 5: OAuth tidak redirect setelah login
**Cause**: `redirectTo` URL salah atau tidak accessible

**Fix**:
1. Update `redirectTo` di `login_page.dart`
2. Untuk local testing: `http://localhost:5000/`
3. Untuk production: `https://rektyanjany.com/`

---

## 🔐 Get Current User Info

Untuk check user yang sedang login:

```dart
final user = SupabaseService.instance.currentUser;

if (user != null) {
  print('User ID: ${user.id}');
  print('Email: ${user.email}');
  print('Provider: ${user.appMetadata['provider']}');
  print('Name: ${user.userMetadata?['full_name']}');
  print('Avatar: ${user.userMetadata?['avatar_url']}');
}
```

### User Metadata dari OAuth

**Google OAuth** menyediakan:
- `full_name` - Nama lengkap
- `avatar_url` - URL foto profil
- `email` - Email

**GitHub OAuth** menyediakan:
- `user_name` - Username GitHub
- `full_name` - Nama lengkap
- `avatar_url` - URL foto profil
- `email` - Email

---

## 🎯 Next Steps

### 1. ✅ Setup OAuth Providers
- [ ] Enable Google OAuth di Supabase
- [ ] Enable GitHub OAuth di Supabase
- [ ] Enable Facebook OAuth di Supabase
- [ ] Update `redirectTo` URL di kode

### 2. 🎨 Optional Improvements
- [ ] Buat halaman Register
- [ ] Buat halaman Reset Password
- [ ] Buat halaman Profile (edit profile, change password)
- [ ] Add logout button di navbar
- [ ] Protect routes (hanya bisa diakses kalau login)

### 3. 🚀 Test Everything
- [ ] Test email/password login
- [ ] Test Google login
- [ ] Test GitHub login
- [ ] Test Facebook login
- [ ] Test logout
- [ ] Check user data di Supabase dashboard

---

## 📚 Documentation Links

- [Supabase Auth Docs](https://supabase.com/docs/guides/auth)
- [Google OAuth Setup](https://console.cloud.google.com/)
- [GitHub OAuth Setup](https://github.com/settings/developers)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)

---

## 🎊 Summary

**Login Methods**: 4
- ✅ Email/Password
- ✅ Google OAuth
- ✅ GitHub OAuth
- ✅ Facebook OAuth

**Files Updated**: 1
- ✅ `lib/features/login/login_page.dart`

**Status**: 🟡 **NEEDS OAUTH SETUP**

Setelah setup Google, GitHub & Facebook OAuth di Supabase Dashboard, authentication akan ready to use! 🚀

---

Made with ❤️ by Kiro for Rekty Anjany
