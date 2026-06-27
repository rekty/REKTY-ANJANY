# 🚀 Supabase Setup Guide untuk Rekty Anjany

## Step 1: Create Supabase Project

1. Buka [https://supabase.com](https://supabase.com)
2. Sign in dengan GitHub
3. Click **"New Project"**
4. Isi:
   - Name: `rekty-anjany`
   - Database Password: (simpan ini!)
   - Region: pilih yang terdekat (Singapore/Tokyo)
5. Click **"Create new project"**
6. Tunggu ~2 menit sampai project ready

## Step 2: Get API Credentials

1. Di dashboard Supabase, klik **Settings** (⚙️) di sidebar kiri
2. Klik **API**
3. Copy credentials ini:
   - **Project URL** → `https://xxxxx.supabase.co`
   - **anon public** key → `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...`

## Step 3: Update Flutter App

Buka file `lib/core/config/supabase_config.dart` dan update:

```dart
class SupabaseConfig {
  static const String supabaseUrl = 'https://xxxxx.supabase.co'; // Your Project URL
  static const String supabaseAnonKey = 'eyJhbGci...'; // Your anon key
}
```

## Step 4: Run SQL Schema

1. Di Supabase dashboard, klik **SQL Editor** di sidebar
2. Click **"New query"**
3. Copy SEMUA isi file `supabase/schema.sql`
4. Paste ke editor
5. Click **"Run"** atau tekan `Ctrl + Enter`
6. Tunggu sampai selesai (akan muncul "Success" di bawah)

## Step 5: Verify Tables

1. Klik **Table Editor** di sidebar
2. Kamu harus lihat tables ini:
   - `blog_posts`
   - `products`
   - `gallery_items`
   - `apps`
   - `contact_messages`
   - `ai_chat_history`
   - `ai_image_history`

## Step 6: Test Data

Sample data sudah include di schema.sql, tapi kalau mau tambah manual:

### Add Blog Post
```sql
INSERT INTO blog_posts (title, slug, excerpt, content, tag, tag_color, icon, read_time)
VALUES (
  'Your Blog Title',
  'your-blog-slug',
  'Short excerpt...',
  'Full content here...',
  'Tutorial',
  '#00E5FF',
  'school_rounded',
  '5 min read'
);
```

### Add Product
```sql
INSERT INTO products (name, slug, description, price, category, icon)
VALUES (
  'Product Name',
  'product-slug',
  'Product description...',
  29.99,
  'AI Tools',
  'auto_awesome_rounded'
);
```

## Step 7: Row Level Security (RLS)

RLS sudah di-enable otomatis oleh schema! Tapi kalau mau edit:

1. Klik **Authentication** → **Policies**
2. Pilih table
3. Edit policies sesuai kebutuhan

**Current Policies:**
- Blog, Products, Gallery, Apps → **Public READ** ✅
- Contact Messages → **Anyone can INSERT** ✅
- AI History → **Public READ/WRITE** (optional: bisa di-restrict)

## Step 8: (Optional) Setup Storage for Images

Kalau mau upload images ke Supabase:

1. Klik **Storage** di sidebar
2. Click **"Create a new bucket"**
3. Name: `gallery` atau `products`
4. Public bucket: **YES**
5. Click **Create**

Upload images manual atau via Flutter app!

## Step 9: Test from Flutter

Run app dan coba:
```bash
flutter run -d chrome
```

## 🔍 Common Issues

### Error: "Invalid API Key"
- Double check `supabaseUrl` dan `supabaseAnonKey`
- Pastikan tidak ada space atau typo

### Error: "relation does not exist"
- Pastikan schema.sql sudah di-run
- Check di **Table Editor** apakah tables ada

### Error: "RLS policy violation"
- Check policies di **Authentication** → **Policies**
- Pastikan public read enabled untuk tables yang perlu

## 📚 Next Steps

1. ✅ Setup Supabase project
2. ✅ Run SQL schema
3. ✅ Update config di Flutter
4. 🔄 Test CRUD operations
5. 🎨 Customize data sesuai kebutuhan
6. 🚀 Deploy!

## 🆘 Need Help?

- [Supabase Docs](https://supabase.com/docs)
- [Flutter Supabase Package](https://pub.dev/packages/supabase_flutter)
- [Supabase Discord](https://discord.supabase.com/)
