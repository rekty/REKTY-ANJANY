# 🚀 Build Commands - Quick Reference

## ⚡ Fast Build for Testing

```bash
flutter run -d chrome
```

Hot reload: Press `r`
Hot restart: Press `R`

---

## 🏗️ Production Build (Recommended)

```bash
flutter build web --release --web-renderer canvaskit --tree-shake-icons
```

**Output**: `build/web/`
**Size**: ~2.5 MB (uncompressed), ~700 KB (gzipped)
**Time**: ~1-2 minutes

---

## 🎯 Maximum Optimization Build

```bash
flutter clean && flutter pub get && flutter build web --release --web-renderer canvaskit --tree-shake-icons --split-debug-info=build/debug-info --obfuscate --dart-define=FLUTTER_WEB_USE_SKIA=true
```

**Output**: `build/web/`
**Size**: ~2.3 MB (uncompressed), ~650 KB (gzipped)
**Time**: ~2-3 minutes

Benefits:
- Smallest bundle size
- Code obfuscation (security)
- Remove debug symbols
- Tree-shake unused icons

---

## 📦 Deploy to Hosting

### Option 1: Firebase Hosting

```bash
# Install Firebase CLI
npm install -g firebase-tools

# Login
firebase login

# Initialize
firebase init hosting

# Build
flutter build web --release --web-renderer canvaskit --tree-shake-icons

# Deploy
firebase deploy --only hosting
```

### Option 2: Netlify

```bash
# Build
flutter build web --release --web-renderer canvaskit --tree-shake-icons

# Deploy (drag build/web folder to Netlify)
# Or use Netlify CLI:
npm install -g netlify-cli
netlify deploy --dir=build/web --prod
```

### Option 3: Vercel

```bash
# Build
flutter build web --release --web-renderer canvaskit --tree-shake-icons

# Deploy
npm install -g vercel
vercel --prod
```

### Option 4: GitHub Pages

```bash
# Build
flutter build web --release --web-renderer canvaskit --tree-shake-icons --base-href "/rekty_anjany/"

# Deploy
cd build/web
git init
git add .
git commit -m "Deploy"
git branch -M gh-pages
git remote add origin https://github.com/rekty/rekty_anjany.git
git push -u origin gh-pages --force
```

---

## 🧹 Clean Build (When Issues)

```bash
flutter clean
flutter pub get
flutter build web --release
```

---

## 🧪 Test Production Build Locally

```bash
# Build
flutter build web --release

# Serve locally
cd build/web
python -m http.server 8000

# Or use live-server
npm install -g live-server
live-server build/web
```

Open: http://localhost:8000

---

## 📊 Check Bundle Size

```bash
# After build
cd build/web
ls -lh *.js
```

Expected:
- `main.dart.js`: ~2.5 MB
- `flutter.js`: ~200 KB

---

## ⚠️ Common Issues

### Issue: "flutter_service_worker.js not found"
**Fix**: 
```bash
flutter clean
flutter build web --release
```

### Issue: White screen after deploy
**Fix**: Check console (F12) for errors
```bash
# Rebuild with correct base-href
flutter build web --release --base-href "/"
```

### Issue: Slow loading
**Fix**: Enable GZIP on hosting + use CDN

---

## 🎯 Development vs Production

### Development
```bash
flutter run -d chrome
```
- Fast rebuild
- Hot reload
- Debug mode
- Large bundle (~10MB)

### Production
```bash
flutter build web --release
```
- Optimized
- Minified
- Small bundle (~700KB gzipped)
- No hot reload

---

Made with ❤️ by Kiro
