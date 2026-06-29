# ✅ Correct Build Commands

## 🚨 Update: Flutter 3.22+ tidak support `--web-renderer`

### ❌ Old Command (Tidak Work)
```bash
flutter build web --release --web-renderer canvaskit
```

### ✅ New Command (Use This!)
```bash
flutter build web --release
```

Flutter sekarang **automatically** pilih renderer terbaik!

---

## 🚀 Rebuild & Redeploy - Correct Commands

### Step 1: Clean (Optional tapi recommended)
```bash
flutter clean
```

### Step 2: Get Dependencies
```bash
flutter pub get
```

### Step 3: Build for Production
```bash
flutter build web --release
```

**Optional optimizations**:
```bash
flutter build web --release --tree-shake-icons
```

---

## 📦 What This Does

**`--release`**: Production mode
- Minified code
- Optimized performance
- Small bundle size

**`--tree-shake-icons`**: Remove unused icons
- Reduces icon font size by 98%+
- Only includes icons you use

**No `--web-renderer` needed**: 
- Flutter auto-selects best renderer
- Uses CanvasKit by default for best performance

---

## 🔥 Full Rebuild & Redeploy Script

Copy paste ini:

```bash
flutter clean
flutter pub get
flutter build web --release --tree-shake-icons
firebase deploy --only hosting
```

Atau satu baris:

```bash
flutter clean && flutter pub get && flutter build web --release --tree-shake-icons && firebase deploy --only hosting
```

---

## ⏱️ Expected Build Time

- Clean: 5 seconds
- Pub get: 10 seconds
- Build: 3-5 minutes
- Deploy: 30 seconds

**Total**: ~6 minutes

---

## ✅ After Build

Check output:
```
√ Built build\web
```

Then deploy:
```bash
firebase deploy --only hosting
```

---

Made with ❤️ by Kiro
