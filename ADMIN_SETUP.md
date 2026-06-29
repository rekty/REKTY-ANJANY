# 🔐 Admin Panel Setup Guide

Complete guide to setting up and using the admin panel for Rekty Anjany portfolio website.

---

## 📋 Prerequisites

1. **Supabase Account** - Sign up at [supabase.com](https://supabase.com)
2. **Admin Email** - Your email address that will have admin access
3. **OAuth Setup** - Google/GitHub/Facebook OAuth already configured

---

## 🚀 Step 1: Run Database Setup

### 1.1 Open Supabase SQL Editor

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Select your project
3. Click **SQL Editor** in the left sidebar
4. Click **New query**

### 1.2 Execute Schema Script

1. Open `supabase_schema.sql` in this project
2. **IMPORTANT:** Find this line and change to YOUR email:
   ```sql
   INSERT INTO admin_users (email, role) 
   VALUES ('your-email@gmail.com', 'super_admin')
   ```
   Change `'your-email@gmail.com'` to your actual email (same as OAuth login)

3. Copy the **entire** SQL script
4. Paste into Supabase SQL Editor
5. Click **Run** (or press F5)
6. Wait for "Success. No rows returned" message

### 1.3 Verify Tables Created

In Supabase Dashboard → **Table Editor**, you should see:
- ✅ `admin_users`
- ✅ `apps`
- ✅ `downloads`
- ✅ `products`
- ✅ `gallery_items`
- ✅ `blog_posts`
- ✅ `about_me`
- ✅ `contact_info`
- ✅ `contact_messages`
- ✅ `analytics`

### 1.4 Verify Storage Buckets

In Supabase Dashboard → **Storage**, you should see:
- ✅ `apps`
- ✅ `downloads`
- ✅ `products`
- ✅ `gallery`
- ✅ `blog`
- ✅ `profile`

---

## 🔑 Step 2: Configure Admin Access

### 2.1 Verify Admin User

1. Go to Supabase → **Table Editor** → `admin_users`
2. You should see your email with role `super_admin`
3. If not, insert manually:
   ```sql
   INSERT INTO admin_users (email, role)
   VALUES ('your-email@gmail.com', 'super_admin');
   ```

### 2.2 Test Admin Check

Open browser console and test:
```javascript
// This will be automatic in the app
localStorage.getItem('supabase_access_token')
```

---

## 🎨 Step 3: Access Admin Panel

### 3.1 Login with OAuth

1. Go to your website: `https://rekty-anjany-5a2eb.web.app`
2. Click **Login** button
3. Login with Google/GitHub/Facebook (use your admin email)
4. After login, you'll be redirected to home page

### 3.2 Access Admin Panel

- Navigate to: `https://rekty-anjany-5a2eb.web.app/admin`
- Or add `/admin` to your local URL: `http://localhost:8080/admin`

### 3.3 What You Should See

- **Sidebar** with menu: Dashboard, Apps, Downloads, Store, Gallery, Blog, About, Messages, Contact Info
- **Dashboard** with statistics cards
- **Quick Actions** buttons

---

## 📱 Admin Panel Features

### Dashboard (`/admin`)
- View total counts: Apps, Downloads, Products, Gallery, Blog, Messages
- Quick action buttons
- Statistics overview

### Apps Management (`/admin/apps`)
- **List** all apps
- **Create** new app
- **Edit** existing app (name, description, version, platform, features)
- **Delete** app
- Upload app icon

### Downloads Management (`/admin/downloads`)
- **List** all downloads
- **Upload** APK/files
- **Edit** download info (version, file size, description)
- **Delete** downloads
- Track download counts

### Store Management (`/admin/store`)
- **List** all products
- **Create** new product
- **Edit** product (price, description, badge)
- **Delete** product
- Upload product images

### Gallery Management (`/admin/gallery`)
- **Upload** images (single or multiple)
- **Edit** title & category
- **Delete** images
- Manage categories
- Drag & drop reordering

### Blog Management (`/admin/blog`)
- **Create** new article with rich text editor
- **Edit** existing posts
- **Delete** posts
- Set publish date
- Manage tags & categories
- View statistics (views, reads)

### About Page (`/admin/about`)
- Edit about me text
- Upload profile photo
- Edit social media links
- Edit skills & expertise
- Update CV/Resume link

### Messages Inbox (`/admin/messages`)
- View all contact form submissions
- Mark as read/unread
- Reply to messages
- Delete messages
- Filter by status

### Contact Info (`/admin/contact`)
- Edit email address
- Edit phone number
- Edit physical address
- Manage social media links
- Update contact form settings

---

## 🔒 Security Features

### Row Level Security (RLS)

All tables have RLS enabled with these policies:

**Public Access:**
- ✅ Read all published content (apps, downloads, store, gallery, blog)
- ✅ Send contact messages

**Admin Only:**
- ✅ Create, Update, Delete all content
- ✅ View unpublished content
- ✅ Access analytics
- ✅ Read contact messages

### Admin Validation

The system checks:
1. User is logged in (OAuth token exists)
2. User email matches an entry in `admin_users` table
3. If not admin, redirect to `/unauthorized`

### Storage Security

- Public can **read** all uploaded files
- Only admins can **upload, update, delete** files
- File uploads are organized by bucket (apps, gallery, etc.)

---

## 🐛 Troubleshooting

### Can't Access Admin Panel

**Problem:** Redirected to login or "Unauthorized"

**Solutions:**
1. Make sure you're logged in with OAuth
2. Check your email is in `admin_users` table:
   ```sql
   SELECT * FROM admin_users WHERE email = 'your-email@gmail.com';
   ```
3. Verify OAuth token is saved in localStorage:
   - Open browser DevTools → Application → Local Storage
   - Look for `supabase_access_token`
4. Try logout and login again

### RLS Errors

**Problem:** "permission denied for table" errors

**Solution:**
1. Verify RLS policies are created:
   ```sql
   SELECT * FROM pg_policies WHERE tablename = 'apps';
   ```
2. Re-run the schema script
3. Check Supabase logs for detailed errors

### File Upload Fails

**Problem:** Can't upload images or files

**Solution:**
1. Check storage buckets exist in Supabase → Storage
2. Verify bucket policies allow admin uploads
3. Check file size limits (default 50MB)
4. Verify correct MIME types

### Token Expired

**Problem:** "JWT expired" or "Invalid token"

**Solution:**
1. Logout from website
2. Clear localStorage
3. Login again with OAuth
4. Token will auto-refresh

---

## 📊 Database Schema Reference

### `admin_users`
```sql
id          UUID PRIMARY KEY
email       TEXT UNIQUE
role        TEXT (admin, super_admin)
created_at  TIMESTAMP
last_login  TIMESTAMP
```

### `apps`
```sql
id           UUID PRIMARY KEY
name         TEXT
tagline      TEXT
description  TEXT
version      TEXT
platform     TEXT
icon         TEXT (storage path)
color        TEXT (hex)
download_url TEXT
features     JSONB (array of strings)
created_at   TIMESTAMP
updated_at   TIMESTAMP
created_by   UUID (admin user)
```

### `downloads`
```sql
id            UUID PRIMARY KEY
name          TEXT
description   TEXT
version       TEXT
platform      TEXT
file_size     TEXT
file_url      TEXT (storage path)
download_url  TEXT
source_url    TEXT
icon          TEXT
color         TEXT
features      JSONB
download_count INTEGER
created_at    TIMESTAMP
updated_at    TIMESTAMP
created_by    UUID
```

### `products`
```sql
id             UUID PRIMARY KEY
name           TEXT
description    TEXT
price          DECIMAL(10,2)
original_price DECIMAL(10,2)
icon           TEXT
badge          TEXT (NEW, SALE, HOT, FEATURED)
rating         DECIMAL(3,2)
sales_count    INTEGER
is_active      BOOLEAN
created_at     TIMESTAMP
updated_at     TIMESTAMP
created_by     UUID
```

### `gallery_items`
```sql
id            UUID PRIMARY KEY
title         TEXT
description   TEXT
image_url     TEXT (storage path)
category      TEXT
tags          TEXT[]
display_order INTEGER
created_at    TIMESTAMP
updated_at    TIMESTAMP
created_by    UUID
```

### `blog_posts`
```sql
id           UUID PRIMARY KEY
title        TEXT
slug         TEXT UNIQUE
excerpt      TEXT
content      TEXT (markdown/html)
tag          TEXT
tag_color    TEXT
icon         TEXT
read_time    TEXT
view_count   INTEGER
published_at TIMESTAMP
is_published BOOLEAN
created_at   TIMESTAMP
updated_at   TIMESTAMP
created_by   UUID
```

### `contact_messages`
```sql
id         UUID PRIMARY KEY
name       TEXT
email      TEXT
subject    TEXT
message    TEXT
is_read    BOOLEAN
replied    BOOLEAN
created_at TIMESTAMP
```

---

## 🔄 Next Steps

### Coming Features

- [ ] Rich text editor for blog posts
- [ ] Drag & drop file upload
- [ ] Image cropper & optimizer
- [ ] Bulk operations (delete multiple items)
- [ ] Export data (CSV, JSON)
- [ ] Activity logs
- [ ] Email notifications for new messages
- [ ] SEO settings (meta tags, sitemap)
- [ ] Analytics integration (Google Analytics)
- [ ] Multi-language support

### Extending Admin Panel

To add a new admin page:

1. Create page in `lib/features/admin/[feature]/`
2. Add route in `lib/app/router.dart`
3. Add menu item in `lib/features/admin/admin_layout.dart`
4. Create CRUD methods in `lib/core/services/admin_service.dart`

---

## 📞 Support

If you encounter issues:
1. Check browser console for errors
2. Check Supabase logs (Dashboard → Logs)
3. Verify RLS policies are correct
4. Test API calls in Supabase API docs

---

**Setup Version:** 1.0.0  
**Last Updated:** June 29, 2026  
**Maintained by:** Rekty Anjany
