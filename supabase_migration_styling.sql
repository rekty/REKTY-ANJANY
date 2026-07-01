-- ==========================================
-- MIGRATION: Add Styling Fields
-- Phase 1: Basic Color & Font Customization
-- ==========================================
-- Run this in Supabase SQL Editor AFTER creating tables

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
  ADD COLUMN IF NOT EXISTS font_weight TEXT DEFAULT 'normal';

-- ==========================================
-- 5. BLOG TABLE - Add Styling Fields
-- ==========================================
ALTER TABLE blog_posts 
  ADD COLUMN IF NOT EXISTS title_color TEXT DEFAULT '#FFFFFF',
  ADD COLUMN IF NOT EXISTS excerpt_color TEXT DEFAULT '#94A3B8',
  ADD COLUMN IF NOT EXISTS tag_color TEXT DEFAULT '#54C5F8',
  ADD COLUMN IF NOT EXISTS font_weight TEXT DEFAULT 'bold';

-- ==========================================
-- VERIFY MIGRATION
-- ==========================================
-- Check apps table columns
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'apps' 
  AND column_name IN ('title_color', 'tagline_color', 'description_color', 'font_weight');

-- Check downloads table columns
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'downloads' 
  AND column_name IN ('title_color', 'tagline_color', 'description_color', 'font_weight');

-- Check products table columns
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'products' 
  AND column_name IN ('title_color', 'description_color', 'font_weight');

-- Check gallery table columns
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'gallery_items' 
  AND column_name IN ('title_color', 'description_color', 'font_weight');

-- Check blog table columns
SELECT column_name, data_type, column_default 
FROM information_schema.columns 
WHERE table_name = 'blog_posts' 
  AND column_name IN ('title_color', 'excerpt_color', 'tag_color', 'font_weight');

-- ==========================================
-- NOTES
-- ==========================================
-- Default Colors:
-- - title_color: #FFFFFF (White)
-- - tagline_color: #54C5F8 (Cyan)
-- - description_color: #94A3B8 (Gray)
-- - tag_color: #54C5F8 (Cyan)
-- 
-- Font Weights: light, normal, semibold, bold
-- 
-- All existing records will get default values automatically
-- ==========================================
