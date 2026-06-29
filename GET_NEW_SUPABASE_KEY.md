# 🔑 Get New Supabase Publishable Key

## 📖 Context: Supabase API Keys Update

Supabase has 2 types of keys:

### 1. Legacy Keys (Old - Still Works)
- **Format**: JWT (long string starting with `eyJ...`)
- **anon public**: `eyJhbGciOi...` (safe for browser)
- **service_role**: `eyJhbGciOi...` (secret - server only)
- **Status**: Works but will be deprecated in late 2026

### 2. New Keys (Recommended)
- **Format**: `sb_publishable_...` and `sb_secret_...`
- **Benefits**: Better security, zero-downtime rotation, instant revocation
- **Status**: Available now, recommended for new projects

---

## 🎯 Which Key to Use?

### For Flutter Web App (Your Case):

**Option A: Use New Publishable Key** ✅ Recommended
```dart
static const String supabaseAnonKey = 'sb_publishable_xxxxx';
```

**Option B: Use Legacy anon Key** ✅ Also works (what you have now)
```dart
static const String supabaseAnonKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

Both will work! Legacy key works until late 2026.

---

## 📋 Get New Publishable Key

### Step 1: Go to Supabase Dashboard
```
https://supabase.com/dashboard/project/tdztcovdwewfsenzrtnq/settings/api
```

### Step 2: Click Correct Tab
Look for **2 tabs** at top:
1. **"Publishable and secret API keys"** 👈 Click this tab!
2. "Legacy anon, service_role API keys"

### Step 3: Copy Key
Under "Publishable and secret API keys" tab:
- Find: **Publishable key**
- Format: `sb_publishable_...`
- Click copy icon

### Step 4: Update Code
Edit: `lib/core/config/supabase_config.dart`

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://tdztcovdwewfsenzrtnq.supabase.co';
  
  // New publishable key (recommended)
  static const String supabaseAnonKey = 'sb_publishable_xxxxx';
  
  // OR use legacy anon key (still works)
  // static const String supabaseAnonKey = 'eyJhbGciOi...';
}
```

---

## 🤔 Current Situation

**Your current key**:
```
eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InRkenRjb3Zkd2V3ZnNlbnpydG5xIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODI1NTk5MjksImV4cCI6MjA5ODEzNTkyOX0.8sxWy-VUpq137xDvBewBnIX0rBllFP44oq84PhBWB6w
```

**Status**: ✅ **VALID Legacy anon key**
- This SHOULD work!
- Valid format
- Correct length
- Role: anon ✅

---

## 🔧 Why Website Still Loading Loop?

If key is valid but still loading loop, possible issues:

### 1. **Supabase Not Initialized Before App Renders**
Fixed in latest code with try-catch

### 2. **CORS Issue**
Check browser console for CORS errors

### 3. **Supabase Package Version Issue**
Check `pubspec.yaml`:
```yaml
supabase_flutter: ^2.15.0  # Should be compatible
```

### 4. **Flutter Web Limitation**
Some Supabase features don't work in web by default

---

## 🚀 Quick Test: Try New Publishable Key

### Get New Key:
1. Dashboard → API Settings
2. Tab: "Publishable and secret API keys"
3. Copy: `sb_publishable_...`

### Update Code:
```dart
static const String supabaseAnonKey = 'sb_publishable_xxxxx';
```

### Rebuild:
```bash
flutter clean
flutter build web --release --tree-shake-icons
firebase deploy --only hosting
```

### Test:
Open: https://rekty-anjany-5a2eb.web.app

---

## 💡 Alternative: Disable Supabase Temporarily

If you want to test if Supabase is causing the issue:

### Comment Out Supabase Init:
```dart
// main.dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  ImageCacheManager.instance.initialize();
  
  // COMMENTED OUT FOR TESTING
  // await SupabaseService.initialize(...);
  
  runApp(const RektyAnjanyApp());
}
```

### Rebuild & Deploy
```bash
flutter build web --release --tree-shake-icons
firebase deploy --only hosting
```

### Result:
- ✅ If website loads: Issue is Supabase initialization
- ❌ If still loading: Issue is something else

---

## 🎯 Recommendation

### Option 1: Try New Publishable Key (5 min)
1. Get `sb_publishable_...` from dashboard
2. Update code
3. Rebuild & deploy
4. Test

### Option 2: Debug Current Setup (10 min)
1. Check browser console for exact error
2. Share error screenshot
3. I can help fix specific issue

### Option 3: Disable Supabase Temporarily (5 min)
1. Comment out Supabase init
2. Rebuild & deploy
3. Website will load without database features
4. Fix Supabase issue later

---

## 📸 Where to Find New Publishable Key

**Screenshot guide**:

```
Supabase Dashboard
└── Settings
    └── API
        ├── Tab 1: "Publishable and secret API keys" 👈 CLICK HERE
        │   ├── Publishable key: sb_publishable_xxxxx 👈 COPY THIS
        │   └── Secret key: sb_secret_xxxxx (don't use this)
        │
        └── Tab 2: "Legacy anon, service_role API keys"
            ├── anon public: eyJhbGciOi... 👈 OR USE THIS (current)
            └── service_role: eyJhbGciOi... (secret)
```

---

Made with ❤️ by Kiro
