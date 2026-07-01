-- ==========================================
-- MIGRATION: Add Styling Fields - COMPLETE
-- Includes: Apps, Downloads, Products, Gallery, Blog, Contact Info
-- ==========================================
-- Run this in Supabase SQL Editor: https://supabase.com/dashboard/project/YOUR_PROJECT/editor

-- ==========================================
-- 1. APPS TABLE - Add Styling Fields
-- ==========================================
ALTER TABLE apps 
  ADD COLUMN IF NOT EXISTS title_color TEXT DEFAULT '#FFFFFF',
  ADD COLUMN IF NOT EXISTS tagline_color TEXT DEFAULT '#54C5F8',
  ADD COLUMN IF NOT EXISTS description_color TEXT DEFAULT '#94A3B8',
  ADD COLUMN IF NOT EXISTS font_weight TEXT DEFAULT 'bold';

-- ==========================================
-- 2. DOWNLOADS TABLE - Add Styling Fields
-- ==========================================
ALTER TABLE downloads 
  ADD COLUMN IF NOT EXISTS title_color TEXT DEFAULT '#FFFFFF',
  ADD COLUMN IF NOT EXISTS tagline_color TEXT DEFAULT '#54C5F8',
  ADD COLUMN IF NOT EXISTS description_color TEXT DEFAULT '#94A3B8',
  ADD COLUMN IF NOT EXISTS font_weight TEXT DEFAULT 'bold';

-- ==========================================
-- 3. PRODUCTS TABLE - Add Styling Fields
-- ==========================================
ALTER TABLE products 
  ADD COLUMN IF NOT EXISTS title_color TEXT DEFAULT '#FFFFFF',
  ADD COLUMN IF NOT EXISTS description_color TEXT DEFAULT '#94A3B8',
  ADD COLUMN IF NOT EXISTS font_weight TEXT DEFAULT 'bold';

-- ==========================================
-- 4. GALLERY TABLE - Add Styling Fields
-- ==========================================
ALTER TABLE gallery_items 
  ADD COLUMN IF NOT EXISTS title_color TEXT DEFAULT '#FFFFFF',
  ADD COLUMN IF NOT EXISTS description_color TEXT DEFAULT '#94A3B8',
  ADD COLUMN IF NOT EXISTS font_weight TEXT DEFAULT 'bold';

-- ==========================================
-- 5. BLOG TABLE - Add Styling Fields
-- ==========================================
ALTER TABLE blog_posts 
  ADD COLUMN IF NOT EXISTS title_color TEXT DEFAULT '#FFFFFF',
  ADD COLUMN IF NOT EXISTS excerpt_color TEXT DEFAULT '#94A3B8',
  ADD COLUMN IF NOT EXISTS tag_color TEXT DEFAULT '#54C5F8',
  ADD COLUMN IF NOT EXISTS font_weight TEXT DEFAULT 'bold';

-- ==========================================
-- 6. CONTACT INFO TABLE - Add Styling Fields
-- ==========================================
ALTER TABLE contact_info 
  ADD COLUMN IF NOT EXISTS title_color TEXT DEFAULT '#FFFFFF',
  ADD COLUMN IF NOT EXISTS description_color TEXT DEFAULT '#94A3B8',
  ADD COLUMN IF NOT EXISTS font_weight TEXT DEFAULT 'bold';

-- ==========================================
-- VERIFY MIGRATION - Check All Tables
-- ==========================================

-- Check apps table
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'apps' 
  AND column_name IN ('title_color', 'tagline_color', 'description_color', 'font_weight');

-- Check downloads table
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'downloads' 
  AND column_name IN ('title_color', 'tagline_color', 'description_color', 'font_weight');

-- Check products table
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'products' 
  AND column_name IN ('title_color', 'description_color', 'font_weight');

-- Check gallery table
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'gallery_items' 
  AND column_name IN ('title_color', 'description_color', 'font_weight');

-- Check blog table
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'blog_posts' 
  AND column_name IN ('title_color', 'excerpt_color', 'tag_color', 'font_weight');

-- Check contact_info table
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'contact_info' 
  AND column_name IN ('title_color', 'description_color', 'font_weight');

-- ==========================================
-- SUCCESS! All styling columns added
-- ==========================================
-- Next Steps:
-- 1. All existing records now have default styling values
-- 2. You can edit styling from admin panel
-- 3. Changes will reflect immediately on public pages
-- ==========================================
