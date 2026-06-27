# ⚡ Quick Auth Setup - 8 Menit!

## 🎯 Setup Google OAuth (2 menit)

### 1. Google Cloud Console
1. Go: https://console.cloud.google.com
2. Create project → Name: `Rekty Anjany`
3. APIs & Services → Library → Enable "Google+ API"
4. Credentials → Create OAuth client ID → Web application
5. Authorized redirect URIs → Add: `https://tdztcovdwewfsenzrtnq.supabase.co/auth/v1/callback`
6. Copy **Client ID** dan **Client Secret**

### 2. Supabase Dashboard
1. Go: https://supabase.com/dashboard
2. Authentication → Providers → Google
3. Enable → ON
4. Paste Client ID & Client Secret
5. Save

---

## 🎯 Setup GitHub OAuth (2 menit)

### 1. GitHub Settings
1. Go: https://github.com/settings/developers
2. OAuth Apps → New OAuth App
3. Application name: `Rekty Anjany`
4. Homepage URL: `https://rektyanjany.com`
5. Callback URL: `https://tdztcovdwewfsenzrtnq.supabase.co/auth/v1/callback`
6. Register → Copy **Client ID**
7. Generate new client secret → Copy **Client Secret**

### 2. Supabase Dashboard
1. Authentication → Providers → GitHub
2. Enable → ON
3. Paste Client ID & Client Secret
4. Save

---

## 🎯 Setup Facebook OAuth (3 menit)

### 1. Facebook Developers
1. Go: https://developers.facebook.com
2. My Apps → Create App
3. Use case: **Authenticate with Facebook Login**
4. App type: **Consumer**
5. App name: `Rekty Anjany`
6. Contact email: `rekty.anjany@gmail.com`

### 2. Add Facebook Login
1. Add Products → Facebook Login → Set Up
2. Platform: **Web**
3. Site URL: `https://rektyanjany.com`
4. Settings → Basic → Copy **App ID** dan **App Secret**

### 3. Configure OAuth
1. Facebook Login → Settings
2. Valid OAuth Redirect URIs: `https://tdztcovdwewfsenzrtnq.supabase.co/auth/v1/callback`
3. Save Changes
4. **PENTING**: Toggle app **Development** → **Live** mode!

### 4. Supabase Dashboard
1. Authentication → Providers → Facebook
2. Enable → ON
3. Paste App ID & App Secret
4. Save

---

## 🎯 Update Kode (1 menit)

Edit: `lib/features/login/login_page.dart`

Cari baris ini (ada 3x):
```dart
redirectTo: 'https://your-website.com/',
```

Ganti jadi:
```dart
redirectTo: 'http://localhost:5000/', // Untuk testing lokal
// redirectTo: 'https://rektyanjany.com/', // Untuk production
```

---

## ✅ Test Login

```bash
flutter run -d chrome
```

1. Buka `/login`
2. Test 4 metode:
   - ✅ Email/Password
   - ✅ Google button
   - ✅ GitHub button
   - ✅ Facebook button

---

## 🔥 Callback URL Kamu

Copy paste ini ke Google, GitHub & Facebook:

```
https://tdztcovdwewfsenzrtnq.supabase.co/auth/v1/callback
```

**PENTING**: Harus **EXACT** sama dengan ini!

---

## 📞 Troubleshooting

**Error "redirect_uri_mismatch"**
→ Cek callback URL, harus exact sama

**Popup blocked**
→ Allow popups di browser

**"Invalid credentials"**
→ User belum exist, buat dulu di Supabase

**Facebook "App Not Setup"**
→ Switch Facebook app dari Development ke Live mode

**Facebook stuck di login**
→ Check Valid OAuth Redirect URIs di Facebook settings

---

Selesai! 🎉
