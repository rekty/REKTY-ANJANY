# 🧪 Quick Test Guide - Supabase Integration

## ⚡ Fast Testing Checklist

### Before Testing
1. ✅ Supabase project created
2. ✅ Database URL: `https://tdztcovdwewfsenzrtnq.supabase.co`
3. ✅ SQL schema executed in Supabase
4. ✅ Anon key configured in `lib/core/config/supabase_config.dart`

---

## 🎯 Test Each Page

### 1. Run the App
```bash
flutter run -d chrome
```

### 2. Test Blog Page
1. Click **"Blog"** in navigation
2. **Expected**: Loading spinner → Blog posts appear
3. **Check**: Posts have title, excerpt, tag, icon
4. **If Error**: Click "Retry" button

### 3. Test Store Page
1. Click **"Store"** in navigation
2. **Expected**: Products load with pricing
3. **Check**: "View All" and "Popular" tabs work
4. **If Error**: Verify `products` table has data

### 4. Test Gallery Page
1. Click **"Gallery"** in navigation
2. **Expected**: Images load in grid
3. **Check**: Category filter works (All, UI Design, Mobile, Web)
4. **Test**: Click different categories

### 5. Test Apps Page
1. Click **"Apps"** in navigation
2. **Expected**: App cards appear with icons
3. **Check**: Version badges, features, platform info
4. **Hover**: Card should glow on hover (desktop)

### 6. Test Downloads Page
1. Click **"Downloads"** in navigation
2. **Expected**: Downloadable apps listed
3. **Check**: Version, file size, platform, what's new
4. **Buttons**: "Download APK" and "Source" visible

### 7. Test Contact Form
1. Click **"Contact"** in navigation
2. Fill form:
   - Name: `Test User`
   - Email: `test@example.com`
   - Subject: `Test Message`
   - Message: `This is a test submission`
3. Click **"Send Message"**
4. **Expected**: Success checkmark appears
5. **Verify**: Check Supabase → `contact_messages` table

---

## 🔍 Verify in Supabase Dashboard

### After Testing Contact Form
1. Go to [Supabase Dashboard](https://supabase.com)
2. Select your project
3. Click **"Table Editor"** in sidebar
4. Click **"contact_messages"** table
5. **Should see**: Your test submission

### Check Other Tables
- **blog_posts** - Should have sample blog posts
- **products** - Should have sample products
- **gallery_items** - Should have gallery images
- **apps** - Should have apps data

---

## ❌ Common Issues & Fixes

### Issue 1: "Failed to load"
**Cause**: Database connection failed

**Fix**:
1. Open `lib/core/config/supabase_config.dart`
2. Verify URL: `https://tdztcovdwewfsenzrtnq.supabase.co`
3. Verify Anon Key is correct
4. Click "Retry" in app

### Issue 2: "No items available"
**Cause**: Tables are empty

**Fix**:
1. Go to Supabase Dashboard → SQL Editor
2. Run `supabase/schema.sql` again (includes sample data)
3. Or manually add data in Table Editor

### Issue 3: Contact form submission fails
**Cause**: RLS policy blocking insert

**Fix**:
1. Go to Supabase → Authentication → Policies
2. Find `contact_messages` table
3. Ensure "Anyone can insert" policy exists

### Issue 4: Images not showing in Gallery
**Cause**: Image URLs are placeholders

**Fix**:
1. Gallery will show placeholder images
2. Update `image_url` in `gallery_items` table with real URLs
3. Or use Supabase Storage for real images

---

## 🎨 Test Checklist

- [ ] Blog page loads posts from database
- [ ] Store page shows products
- [ ] Gallery displays images with filters
- [ ] Apps page lists applications
- [ ] Downloads page shows downloadable items
- [ ] Contact form saves to database
- [ ] Loading states appear while fetching
- [ ] Error states show retry button
- [ ] Empty states display proper messages
- [ ] Hover effects work on desktop
- [ ] Mobile responsive layout works
- [ ] All navigation links work

---

## 🚀 Quick Commands

### Run App
```bash
flutter run -d chrome
```

### Check for Errors
```bash
flutter analyze
```

### Clean Build (if issues)
```bash
flutter clean
flutter pub get
flutter run -d chrome
```

### Hot Reload (while running)
Press `r` in terminal

### Hot Restart (while running)
Press `R` in terminal

---

## 📊 Expected Data

### Blog Posts (4 items)
- Building Scalable React Applications
- Backend Best Practices with Node.js
- Database Design with PostgreSQL
- Modern Web Design Principles

### Products (4 items)
- AI Assistant Pro
- Code Snippet Manager
- UI Component Library
- Design System Kit

### Gallery Items (8 items)
- UI Design samples
- Mobile app screenshots
- Web design examples
- Various categories

### Apps (4 items)
- Rekty AI
- Rekty POS
- Rekty Store
- Rekty Gallery

---

## ✅ Success Indicators

### Page Loaded Successfully
- ✅ No error message
- ✅ Content displayed
- ✅ No infinite loading

### Database Connected
- ✅ Data appears within 2 seconds
- ✅ "Retry" button not needed
- ✅ Contact form submits successfully

### UI Working
- ✅ Cards have proper colors
- ✅ Icons display correctly
- ✅ Hover effects work
- ✅ Responsive on mobile

---

## 🎯 Performance Expectations

- **Blog Page**: < 2s load time
- **Store Page**: < 2s load time
- **Gallery Page**: < 2s load time
- **Apps Page**: < 2s load time
- **Downloads Page**: < 2s load time
- **Contact Submit**: < 1s response time

---

## 🐛 Browser Console (for debugging)

Press **F12** to open developer tools

### Check for errors:
1. Click "Console" tab
2. Look for red error messages
3. Common errors:
   - `Invalid API Key` → Check config
   - `RLS policy violation` → Check policies
   - `relation does not exist` → Run schema.sql

---

## 📞 What to Report if Issues

If something doesn't work, note:
1. Which page had the issue?
2. What was the error message?
3. Did "Retry" work?
4. Any red errors in browser console (F12)?
5. Screenshot of the issue

---

## 🎊 All Tests Passing?

If everything works:
1. 🎉 Supabase integration successful!
2. ✅ All pages load data from database
3. 💾 Contact form saves submissions
4. 🚀 Ready for production data

**Next**: Add your real content to Supabase tables!

---

Made with ❤️ by Kiro
