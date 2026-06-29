# 🌐 Rekty Anjany - Personal Portfolio Website

Modern, professional portfolio website built with Flutter Web featuring dark theme design, OAuth authentication, and dynamic content management.

**Live Website:** [https://rekty-anjany-5a2eb.web.app](https://rekty-anjany-5a2eb.web.app)

---

## ✨ Features

### 🎨 Design & UI
- **Modern Dark Theme** - Apple-inspired dark design with mesh gradient backgrounds
- **Glassmorphism Effects** - Subtle glass-like UI elements with backdrop blur
- **Responsive Layout** - Optimized for desktop, tablet, and mobile devices
- **Smooth Animations** - Hover effects, transitions, and micro-interactions
- **Accessibility** - WCAG compliant with semantic HTML and ARIA labels

### 🔐 Authentication
- **OAuth Login** - Google, GitHub, and Facebook authentication
- **Session Management** - Persistent login state using localStorage
- **Supabase Integration** - Secure authentication via Supabase Auth REST API
- **Protected Routes** - Login/Logout state management with dynamic navbar

### 📱 Pages & Content

1. **Home** - Hero section with featured apps, downloads, store, gallery, and blog previews
2. **Apps** - Showcase of 4 applications with detailed descriptions and features
3. **Downloads** - APK and resource downloads with version info and file sizes
4. **Store** - Digital products marketplace with pricing and badges
5. **Gallery** - Portfolio showcase with category filtering
6. **Blog** - Technical articles with reading time and tags
7. **About** - Personal information and background
8. **Contact** - Contact form and social media links

### 🛠️ Technical Stack
- **Framework:** Flutter 3.32.8 (Web)
- **State Management:** Built-in StatefulWidget
- **Authentication:** Supabase Auth REST API
- **Routing:** go_router with named routes
- **HTTP Client:** http package
- **Deployment:** Firebase Hosting
- **Storage:** Browser localStorage for session persistence

---

## 🚀 Getting Started

### Prerequisites
- Flutter SDK 3.32.8 or higher
- Node.js (for Firebase CLI)
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/yourusername/rekty_anjany.git
cd rekty_anjany
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Configure Supabase**

Create or update `lib/core/config/supabase_config.dart`:
```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://tdztcovdwewfsenzrtnq.supabase.co';
  static const String supabaseAnonKey = 'your-anon-key-here';
}
```

Get your keys from [Supabase Dashboard](https://supabase.com/dashboard) → Project Settings → API

4. **Configure OAuth Redirect URLs**

In Supabase Dashboard → Authentication → URL Configuration:
- Add redirect URL: `https://rekty-anjany-5a2eb.web.app/auth/callback`
- For local testing: `http://localhost:8080/auth/callback`

5. **Run development server**
```bash
flutter run -d chrome
```

---

## 🏗️ Build & Deploy

### Build for Production
```bash
# Clean previous build
flutter clean

# Build optimized web app
flutter build web --release
```

### Deploy to Firebase Hosting
```bash
# Install Firebase CLI (if not installed)
npm install -g firebase-tools

# Login to Firebase
firebase login

# Deploy
firebase deploy --only hosting
```

### One-Line Build & Deploy
```cmd
cd c:\Users\Administrator\Documents\project_flutter\rekty_anjany & flutter clean & flutter build web --release & firebase deploy --only hosting
```

---

## 📁 Project Structure

```
lib/
├── app/
│   └── router.dart                 # Route configuration with go_router
├── core/
│   ├── config/
│   │   └── supabase_config.dart   # Supabase credentials
│   ├── constants/
│   │   ├── app_colors.dart        # Color palette
│   │   ├── app_spacing.dart       # Spacing constants
│   │   ├── app_radius.dart        # Border radius values
│   │   └── app_shadow.dart        # Shadow styles
│   └── services/
│       └── supabase_auth_service.dart  # Authentication service
├── features/
│   ├── home/                      # Home page with sections
│   ├── apps/                      # Apps showcase page
│   ├── downloads/                 # Downloads page
│   ├── store/                     # Store/marketplace page
│   ├── gallery/                   # Gallery/portfolio page
│   ├── blog/                      # Blog articles page
│   ├── about/                     # About page
│   ├── contact/                   # Contact page
│   ├── login/                     # Login page with OAuth
│   └── auth/                      # Auth callback handler
├── shared/
│   ├── layout/
│   │   ├── app_scaffold.dart      # Common page layout
│   │   ├── navbar.dart            # Navigation bar
│   │   └── responsive_container.dart
│   └── widgets/
│       ├── background/
│       │   ├── mesh_gradient_background.dart
│       │   └── glow_background.dart
│       └── navigation/
│           └── login_button.dart   # Dynamic login/logout button
└── main.dart                      # App entry point

web/
├── index.html                     # HTML entry with service worker config
├── manifest.json                  # PWA manifest
└── icons/                         # App icons

firebase.json                      # Firebase hosting configuration
.firebaserc                        # Firebase project configuration
```

---

## 🔑 Environment Configuration

### Supabase Setup

1. **Create Supabase Project** at [supabase.com](https://supabase.com)

2. **Enable OAuth Providers:**
   - Go to Authentication → Providers
   - Enable Google, GitHub, Facebook
   - Configure OAuth apps for each provider
   - Add redirect URL: `https://rekty-anjany-5a2eb.web.app/auth/callback`

3. **Get Credentials:**
   - Project URL: `https://tdztcovdwewfsenzrtnq.supabase.co`
   - Anon Key: Found in Settings → API (starts with `eyJ...`, ~250 characters)

### Firebase Setup

1. **Initialize Firebase**
```bash
firebase init hosting
```

2. **Configure `firebase.json`:**
```json
{
  "hosting": {
    "public": "build/web",
    "ignore": ["firebase.json", "**/.*", "**/node_modules/**"],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ]
  }
}
```

---

## 🎨 Customization

### Colors
Edit `lib/core/constants/app_colors.dart`:
```dart
class AppColors {
  static const primary = Color(0xFF54C5F8);      // Cyan
  static const background = Color(0xFF0a0e27);   // Dark blue-black
  static const card = Color(0xFF1a1f3a);         // Card background
  // ... more colors
}
```

### Content Management

**Option 1: Edit Directly in Code**
- Apps: `lib/features/apps/apps_page_supabase.dart`
- Downloads: `lib/features/downloads/downloads_page_supabase.dart`
- Store: `lib/features/store/store_page_supabase.dart`
- Gallery: `lib/features/gallery/gallery_page_supabase.dart`
- Blog: `lib/features/blog/blog_page_supabase.dart`

**Option 2: Use Supabase Database** (Recommended for dynamic content)
- Create tables in Supabase Dashboard
- Update services to fetch from database
- Manage content via Supabase Table Editor

---

## 🐛 Common Issues & Solutions

### Service Worker Errors
**Problem:** `flutter_bootstrap.js` errors or caching issues

**Solution:**
```javascript
// In web/index.html, service worker is disabled
window.flutterConfiguration = {
  serviceWorkerSettings: {
    serviceWorkerVersion: null,
  },
};
```

### OAuth Redirect Not Working
**Problem:** After login, page doesn't redirect

**Solution:**
1. Check redirect URL in Supabase matches exactly
2. Verify `auth_callback_page.dart` parses `access_token` correctly
3. Clear browser localStorage and try again

### White Screen on Pages
**Problem:** Apps/Store/Gallery pages show blank content

**Solution:**
- Ensure dummy data includes all required fields (`name`, `description`, `version`, `icon`, `color`, etc.)
- Check browser console for errors
- Verify no null values in data

### Build Errors
**Problem:** Compilation fails

**Solution:**
```bash
flutter clean
flutter pub get
flutter build web --release
```

---

## 📊 Performance Optimization

- **Code Splitting:** Lazy loading for route-based components
- **Image Optimization:** Use WebP format and lazy loading
- **Caching:** Disabled service worker to prevent stale content
- **Bundle Size:** Tree-shaking enabled, MaterialIcons optimized
- **Loading States:** Skeleton screens and loading indicators

See `PERFORMANCE_OPTIMIZATION.md` for detailed guide.

---

## 🔒 Security

### Safe to Expose (Client-Side)
✅ **Supabase Anon Key** - Designed for public client use  
✅ **Supabase URL** - Public project endpoint  
✅ **Firebase Config** - Client-side configuration  

### NEVER Expose
⛔ **Service Role Key** - Full admin access  
⛔ **Database Password** - Direct DB access  
⛔ **OAuth Client Secrets** - Provider secrets  

### Security Measures
- **OAuth Security:** Tokens stored in localStorage with expiration
- **Row Level Security (RLS):** Enabled on all Supabase tables
- **Environment Variables:** Credentials in `.env` (not committed)
- **CORS:** Configured in Supabase for allowed domains
- **XSS Prevention:** Flutter's built-in sanitization
- **HTTPS Only:** Firebase Hosting enforces HTTPS

### Before Pushing to GitHub
```bash
# Check for exposed secrets
git diff

# Verify .env is not staged
git status

# Ensure .gitignore includes .env
cat .gitignore | grep .env
```

**Read full security guide:** See `SECURITY.md`

---

## 📝 License

This project is for personal portfolio use. Feel free to fork and customize for your own portfolio.

---

## 👤 Author

**Rekty Anjany**
- Website: [https://rekty-anjany-5a2eb.web.app](https://rekty-anjany-5a2eb.web.app)
- GitHub: [@rektyanjany](https://github.com/rektyanjany)

---

## 🙏 Acknowledgments

- [Flutter](https://flutter.dev) - UI Framework
- [Supabase](https://supabase.com) - Backend & Authentication
- [Firebase](https://firebase.google.com) - Hosting
- [Unsplash](https://unsplash.com) - Gallery placeholder images

---

## 📞 Support

For issues, questions, or suggestions:
1. Check existing [Issues](https://github.com/yourusername/rekty_anjany/issues)
2. Create a new issue with detailed description
3. Contact via website contact form

---

**Last Updated:** June 29, 2026  
**Version:** 1.0.0  
**Flutter Version:** 3.32.8  
**Status:** ✅ Production Ready
