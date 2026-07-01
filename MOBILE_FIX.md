# Mobile Responsive Issues - Troubleshooting Guide

## 🔍 Cara Test Mobile View

### Option 1: Browser DevTools (Recommended)
1. Buka website di Chrome/Edge
2. Tekan `F12` atau `Ctrl+Shift+I`
3. Klik icon device toolbar (atau `Ctrl+Shift+M`)
4. Pilih device: iPhone, Samsung Galaxy, atau Responsive
5. Test semua halaman

### Option 2: Test di HP Langsung
1. Buka website di HP: `https://rekty-anjany-5a2eb.web.app`
2. Screenshot bagian yang bermasalah
3. Share ke developer untuk fix

## 🐛 Masalah Umum & Solusi

### Issue 1: Horizontal Scroll Muncul

**Penyebab:**
- Ada element dengan width lebih besar dari screen
- Fixed width yang tidak responsive
- Padding/margin terlalu besar

**Cara Cek:**
```dart
// Check di Chrome DevTools Console
document.body.scrollWidth  // Harus sama dengan screen width
document.body.offsetWidth
```

**Solusi:**
- Pakai `MediaQuery` untuk responsive width
- Ganti fixed width dengan `double.infinity` atau percentage
- Kurangi padding di mobile

### Issue 2: Text Terlalu Kecil/Besar

**Penyebab:**
- Font size fixed untuk semua device
- Tidak ada scale factor

**Solusi:**
```dart
// Bad
Text('Hello', style: TextStyle(fontSize: 32))

// Good - Responsive font
Text('Hello', style: TextStyle(
  fontSize: AppBreakpoints.isMobile(context) ? 24 : 32
))
```

### Issue 3: Content Terpotong

**Penyebab:**
- Container dengan fixed height
- Overflow hidden
- Tidak pakai `SingleChildScrollView`

**Solusi:**
```dart
// Wrap dengan SingleChildScrollView
SingleChildScrollView(
  child: Column(
    children: [...],
  ),
)
```

### Issue 4: Navbar Tidak Muat

**Penyebab:**
- Terlalu banyak menu item
- Text terlalu panjang
- Tidak ada hamburger menu

**Solusi:**
- Pakai hamburger menu di mobile
- Hide beberapa menu
- Shrink logo/text

### Issue 5: Cards/Images Overflow

**Penyebab:**
- Fixed width cards
- Images tidak responsive

**Solusi:**
```dart
// Bad
Container(width: 400, child: ...)

// Good
Container(
  width: AppBreakpoints.isMobile(context) ? double.infinity : 400,
  child: ...
)

// Images
Image.network(
  url,
  width: double.infinity,
  fit: BoxFit.cover,
)
```

## 🔧 Quick Fixes

### Fix 1: Add Viewport Meta (Already Done ✅)

File: `web/index.html`
```html
<meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=5.0">
```

### Fix 2: Make Navbar Responsive

Create mobile drawer for navigation.

### Fix 3: Responsive Typography

```dart
// Create responsive text helper
double getResponsiveFontSize(BuildContext context, {
  required double mobile,
  required double tablet,
  required double desktop,
}) {
  if (AppBreakpoints.isMobile(context)) return mobile;
  if (AppBreakpoints.isTablet(context)) return tablet;
  return desktop;
}

// Usage
Text(
  'Hello',
  style: TextStyle(
    fontSize: getResponsiveFontSize(
      context,
      mobile: 20,
      tablet: 24,
      desktop: 32,
    ),
  ),
)
```

### Fix 4: Responsive Layouts

```dart
// Desktop: Row, Mobile: Column
LayoutBuilder(
  builder: (context, constraints) {
    if (constraints.maxWidth < 600) {
      return Column(children: [...]);
    }
    return Row(children: [...]);
  },
)

// Or use helper
AppBreakpoints.isMobile(context)
  ? Column(children: [...])
  : Row(children: [...])
```

### Fix 5: Test All Breakpoints

Test pada width:
- 375px (iPhone SE)
- 390px (iPhone 12/13/14)
- 428px (iPhone Pro Max)
- 360px (Android Small)
- 768px (iPad)
- 1024px (iPad Landscape)

## 📱 Specific Page Issues

### Home Page - Hero Section

**Potential Issues:**
- Title text terlalu besar
- Subtitle overflow
- Button tidak center

**Check File:** `lib/features/home/sections/hero_section.dart`

### Apps/Downloads/Store Pages

**Potential Issues:**
- Card width fixed
- Grid columns tidak responsive
- Images tidak scale

**Check Files:**
- `lib/features/apps/apps_page_supabase.dart`
- `lib/features/downloads/downloads_page_supabase.dart`
- `lib/features/store/store_page_supabase.dart`

### Admin Panel

**Potential Issues:**
- Sidebar tidak collapse di mobile
- Table overflow
- Form width fixed

**Solutions:**
- Hide sidebar, show drawer
- Make table scrollable
- Use `SingleChildScrollView` horizontal

## 🛠️ Development Tools

### Flutter Inspector

```bash
# Run in debug mode
flutter run -d chrome

# Open DevTools
flutter run -d chrome --web-browser-flag="--disable-web-security"
```

### Check Overflow

```dart
// Add to MaterialApp
MaterialApp(
  debugShowCheckedModeBanner: false,
  builder: (context, child) {
    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
      child: child!,
    );
  },
)
```

## 📋 Testing Checklist

Test pada setiap halaman:

- [ ] No horizontal scroll
- [ ] All text visible
- [ ] Buttons clickable
- [ ] Images load properly
- [ ] Forms usable
- [ ] Navigation works
- [ ] No overflow errors

## 🔄 How to Fix

1. **Identify problematic page**
   - Screenshot dari HP
   - Note which section bermasalah

2. **Open file in editor**
   - Cari widget yang overflow
   - Check fixed width/height

3. **Make responsive**
   - Add MediaQuery checks
   - Use LayoutBuilder
   - Test di DevTools

4. **Build & Deploy**
   ```bash
   flutter build web --release
   firebase deploy --only hosting
   ```

5. **Test di HP lagi**
   - Clear cache
   - Reload page
   - Verify fix

## 📞 Need Specific Fix?

Kalau ada halaman spesifik yang bermasalah:

1. Screenshot halaman tersebut di HP
2. Sebutkan device (iPhone/Android, ukuran layar)
3. Jelaskan masalahnya (scroll horizontal, text terpotong, dll)
4. Developer akan fix file yang spesifik

## 🎯 Priority Fixes

**High Priority:**
1. ✅ Navbar mobile menu
2. ✅ Hero section text size
3. ✅ Cards responsive width
4. ✅ Images responsive

**Medium Priority:**
1. Form layouts
2. Table horizontal scroll
3. Admin panel mobile view

**Low Priority:**
1. Font size tweaks
2. Spacing adjustments
3. Animation performance

---

**Note:** Semua responsive config sudah ada (breakpoints, spacing, viewport meta). Kemungkinan issue ada di widget individual yang pakai fixed width/height.
