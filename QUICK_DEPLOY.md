# 🚀 Quick Deploy Guide - 30 Menit!

## ✅ Website Sudah 95% Jadi!

Tinggal 3 langkah untuk deploy:

---

## Step 1: Update Redirect URLs (2 menit)

Edit: `lib/features/login/login_page.dart`

**Cari** (ada 3 tempat):
```dart
redirectTo: 'https://your-website.com/',
```

**Ganti** jadi:
```dart
redirectTo: 'http://localhost:5000/', // Untuk testing
```

Atau langsung production URL:
```dart
redirectTo: 'https://rektyanjany.com/', // Ganti dengan domain kamu
```

---

## Step 2: Build Production (3 menit)

```bash
flutter build web --release --web-renderer canvaskit --tree-shake-icons
```

Output: `build/web/`

Test locally (optional):
```bash
cd build/web
python -m http.server 8000
```
Open: http://localhost:8000

---

## Step 3: Deploy (5 menit)

### Option A: Firebase Hosting (Recommended)

```bash
# Install Firebase CLI (first time only)
npm install -g firebase-tools

# Login
firebase login

# Init (first time only)
firebase init hosting
# Pilih: build/web
# Single-page app: Yes
# Automatic builds: No

# Deploy
firebase deploy --only hosting
```

URL: `https://your-project.web.app`

---

### Option B: Netlify (Easiest)

**Via Website** (Drag & Drop):
1. Go to: https://app.netlify.com
2. Drag folder `build/web` ke Netlify
3. Done! URL: `https://random-name.netlify.app`

**Via CLI**:
```bash
npm install -g netlify-cli
netlify deploy --dir=build/web --prod
```

---

### Option C: Vercel

```bash
npm install -g vercel
cd build/web
vercel --prod
```

URL: `https://your-project.vercel.app`

---

## 🎉 Done!

Website kamu sekarang LIVE! 🚀

---

## 🔧 Optional: Setup OAuth (15 menit)

Untuk enable Google, GitHub, Facebook login:

Follow: `AUTH_QUICK_SETUP.md`

Quick steps:
1. Google Cloud Console → OAuth credentials (5 min)
2. GitHub Settings → OAuth App (5 min)
3. Facebook Developers → Create App (5 min)
4. Paste credentials ke Supabase Dashboard

---

## 🧪 Test Checklist

After deploy:

- [ ] Open production URL
- [ ] Test all pages (Home, About, Blog, Store, Gallery, Apps, Downloads, Contact, AI, Login)
- [ ] Test contact form (should save to Supabase)
- [ ] Test responsive (mobile view)
- [ ] Check loading speed (< 3 seconds)
- [ ] Test on Chrome, Firefox, Safari

---

## 📊 Performance Check

Run Lighthouse audit:
1. Open website
2. Press F12
3. Lighthouse tab
4. Generate report

Target: 90+ score

---

## 🎯 After Deploy

### Update OAuth Redirect URLs

Jika sudah setup OAuth:

1. **Google Cloud Console**
   - Update Authorized redirect URIs
   - Add: `https://your-domain.com/`

2. **GitHub OAuth App**
   - Update Authorization callback URL
   - Add: `https://your-domain.com/`

3. **Facebook App**
   - Update Valid OAuth Redirect URIs
   - Add: `https://your-domain.com/`

4. **Supabase**
   - Update `redirectTo` di kode:
     ```dart
     redirectTo: 'https://your-domain.com/',
     ```
   - Rebuild & redeploy

---

## 🔥 Custom Domain (Optional)

### Firebase Hosting
```bash
firebase hosting:channel:deploy production
```
Go to: Firebase Console → Hosting → Add custom domain

### Netlify
Go to: Site settings → Domain management → Add custom domain

### Vercel
Go to: Project settings → Domains → Add

---

## ✅ Website is LIVE!

**Total Time**: ~10-30 minutes (tergantung hosting)

**Status**: 🟢 **PRODUCTION READY**

Selamat! Website kamu sudah online! 🎉🚀

---

Made with ❤️ by Kiro
