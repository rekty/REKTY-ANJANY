-- ==========================================
-- ADMIN PANEL DATABASE SCHEMA
-- Run this in Supabase SQL Editor
-- ==========================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ==========================================
-- 1. ADMIN USERS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS admin_users (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT UNIQUE NOT NULL,
  role TEXT DEFAULT 'admin',
  created_at TIMESTAMP DEFAULT NOW(),
  last_login TIMESTAMP
);

-- Insert your admin email (CHANGE THIS!)
INSERT INTO admin_users (email, role) 
VALUES ('zikri.auliaibrahim@gmail.com', 'super_admin')
ON CONFLICT (email) DO NOTHING;

-- ==========================================
-- 2. APPS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS apps (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  tagline TEXT,
  description TEXT,
  version TEXT,
  platform TEXT,
  icon TEXT,
  color TEXT,
  download_url TEXT,
  features JSONB,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES admin_users(id)
);

-- ==========================================
-- 3. DOWNLOADS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS downloads (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  version TEXT,
  platform TEXT,
  file_size TEXT,
  file_url TEXT,
  download_url TEXT,
  source_url TEXT,
  icon TEXT,
  color TEXT,
  features JSONB,
  download_count INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES admin_users(id)
);

-- ==========================================
-- 4. PRODUCTS (STORE) TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10,2),
  original_price DECIMAL(10,2),
  icon TEXT,
  badge TEXT,
  rating DECIMAL(3,2) DEFAULT 5.0,
  sales_count INTEGER DEFAULT 0,
  is_active BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES admin_users(id)
);

-- ==========================================
-- 5. GALLERY TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS gallery_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  description TEXT,
  image_url TEXT,
  category TEXT,
  tags TEXT[],
  display_order INTEGER DEFAULT 0,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES admin_users(id)
);

-- ==========================================
-- 6. BLOG POSTS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS blog_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  slug TEXT UNIQUE,
  excerpt TEXT,
  content TEXT,
  tag TEXT,
  tag_color TEXT,
  icon TEXT,
  read_time TEXT,
  view_count INTEGER DEFAULT 0,
  published_at TIMESTAMP DEFAULT NOW(),
  is_published BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW(),
  created_by UUID REFERENCES admin_users(id)
);

-- ==========================================
-- 7. ABOUT ME TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS about_me (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT,
  subtitle TEXT,
  description TEXT,
  profile_image_url TEXT,
  cv_url TEXT,
  skills JSONB,
  social_links JSONB,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Insert default about me
INSERT INTO about_me (title, subtitle, description) 
VALUES (
  'Rekty Anjany',
  'Developer, Creator, Innovator',
  'Passionate developer creating modern web and mobile applications.'
)
ON CONFLICT DO NOTHING;

-- ==========================================
-- 8. CONTACT INFO TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS contact_info (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  email TEXT,
  phone TEXT,
  address TEXT,
  social_media JSONB,
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Insert default contact info
INSERT INTO contact_info (email, phone) 
VALUES ('contact@rektyanjany.com', '+62 xxx xxxx xxxx')
ON CONFLICT DO NOTHING;

-- ==========================================
-- 9. CONTACT MESSAGES TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS contact_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  subject TEXT,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT false,
  replied BOOLEAN DEFAULT false,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ==========================================
-- 10. ANALYTICS TABLE
-- ==========================================
CREATE TABLE IF NOT EXISTS analytics (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  page_path TEXT,
  visitor_id TEXT,
  user_agent TEXT,
  referrer TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ==========================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ==========================================

-- Enable RLS on all tables
ALTER TABLE apps ENABLE ROW LEVEL SECURITY;
ALTER TABLE downloads ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE gallery_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
ALTER TABLE about_me ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_info ENABLE ROW LEVEL SECURITY;
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Public READ access for all content tables
CREATE POLICY "Public read access" ON apps FOR SELECT USING (true);
CREATE POLICY "Public read access" ON downloads FOR SELECT USING (true);
CREATE POLICY "Public read access" ON products FOR SELECT USING (true);
CREATE POLICY "Public read access" ON gallery_items FOR SELECT USING (true);
CREATE POLICY "Public read access" ON blog_posts FOR SELECT USING (is_published = true);
CREATE POLICY "Public read access" ON about_me FOR SELECT USING (true);
CREATE POLICY "Public read access" ON contact_info FOR SELECT USING (true);

-- Admin FULL access (INSERT, UPDATE, DELETE)
CREATE POLICY "Admin full access" ON apps 
  FOR ALL USING (
    auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

CREATE POLICY "Admin full access" ON downloads 
  FOR ALL USING (
    auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

CREATE POLICY "Admin full access" ON products 
  FOR ALL USING (
    auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

CREATE POLICY "Admin full access" ON gallery_items 
  FOR ALL USING (
    auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

CREATE POLICY "Admin full access" ON blog_posts 
  FOR ALL USING (
    auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

CREATE POLICY "Admin full access" ON about_me 
  FOR ALL USING (
    auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

CREATE POLICY "Admin full access" ON contact_info 
  FOR ALL USING (
    auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

CREATE POLICY "Admin read messages" ON contact_messages 
  FOR ALL USING (
    auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

-- Public can INSERT contact messages
CREATE POLICY "Public can send messages" ON contact_messages 
  FOR INSERT WITH CHECK (true);

-- ==========================================
-- STORAGE BUCKETS
-- ==========================================

-- Create storage buckets for file uploads
INSERT INTO storage.buckets (id, name, public) 
VALUES 
  ('apps', 'apps', true),
  ('downloads', 'downloads', true),
  ('products', 'products', true),
  ('gallery', 'gallery', true),
  ('blog', 'blog', true),
  ('profile', 'profile', true)
ON CONFLICT DO NOTHING;

-- Storage policies (public read, admin write)
CREATE POLICY "Public read access" ON storage.objects 
  FOR SELECT USING (bucket_id IN ('apps', 'downloads', 'products', 'gallery', 'blog', 'profile'));

CREATE POLICY "Admin upload access" ON storage.objects 
  FOR INSERT WITH CHECK (
    bucket_id IN ('apps', 'downloads', 'products', 'gallery', 'blog', 'profile') 
    AND auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

CREATE POLICY "Admin update access" ON storage.objects 
  FOR UPDATE USING (
    bucket_id IN ('apps', 'downloads', 'products', 'gallery', 'blog', 'profile') 
    AND auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

CREATE POLICY "Admin delete access" ON storage.objects 
  FOR DELETE USING (
    bucket_id IN ('apps', 'downloads', 'products', 'gallery', 'blog', 'profile') 
    AND auth.jwt() ->> 'email' IN (SELECT email FROM admin_users)
  );

-- ==========================================
-- FUNCTIONS & TRIGGERS
-- ==========================================

-- Function to update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
   NEW.updated_at = NOW();
   RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Triggers for updated_at
CREATE TRIGGER update_apps_updated_at BEFORE UPDATE ON apps 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_downloads_updated_at BEFORE UPDATE ON downloads 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at BEFORE UPDATE ON products 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_gallery_updated_at BEFORE UPDATE ON gallery_items 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_blog_updated_at BEFORE UPDATE ON blog_posts 
  FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ==========================================
-- INDEXES FOR PERFORMANCE
-- ==========================================

CREATE INDEX IF NOT EXISTS idx_apps_created_at ON apps(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_downloads_created_at ON downloads(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_products_created_at ON products(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_gallery_created_at ON gallery_items(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_blog_published_at ON blog_posts(published_at DESC);
CREATE INDEX IF NOT EXISTS idx_blog_slug ON blog_posts(slug);
CREATE INDEX IF NOT EXISTS idx_messages_created_at ON contact_messages(created_at DESC);

-- ==========================================
-- DONE! Schema Created Successfully
-- ==========================================
