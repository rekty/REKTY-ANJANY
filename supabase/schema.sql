-- ============================================
-- REKTY ANJANY DATABASE SCHEMA
-- Supabase PostgreSQL Schema
-- ============================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ============================================
-- BLOG POSTS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS blog_posts (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  excerpt TEXT NOT NULL,
  content TEXT NOT NULL,
  author TEXT NOT NULL DEFAULT 'Rekty Anjany',
  tag TEXT NOT NULL,
  tag_color TEXT NOT NULL,
  icon TEXT NOT NULL,
  read_time TEXT NOT NULL,
  published_at TIMESTAMPTZ DEFAULT NOW(),
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Blog posts index
CREATE INDEX idx_blog_posts_slug ON blog_posts(slug);
CREATE INDEX idx_blog_posts_tag ON blog_posts(tag);
CREATE INDEX idx_blog_posts_published ON blog_posts(published_at DESC);

-- ============================================
-- PRODUCTS / STORE TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  original_price DECIMAL(10, 2),
  badge TEXT, -- 'New', 'Sale', 'Hot', 'Featured'
  rating DECIMAL(2, 1) DEFAULT 5.0,
  sales_count INTEGER DEFAULT 0,
  category TEXT NOT NULL,
  icon TEXT NOT NULL,
  image_url TEXT,
  download_url TEXT,
  is_featured BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Products index
CREATE INDEX idx_products_slug ON products(slug);
CREATE INDEX idx_products_category ON products(category);
CREATE INDEX idx_products_featured ON products(is_featured);

-- ============================================
-- GALLERY ITEMS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS gallery_items (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  title TEXT NOT NULL,
  category TEXT NOT NULL, -- 'all', 'ui', 'mobile', 'web', 'design'
  image_url TEXT NOT NULL,
  description TEXT,
  tags TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Gallery index
CREATE INDEX idx_gallery_category ON gallery_items(category);
CREATE INDEX idx_gallery_created ON gallery_items(created_at DESC);

-- ============================================
-- APPS / DOWNLOADS TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS apps (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  slug TEXT UNIQUE NOT NULL,
  description TEXT NOT NULL,
  icon TEXT NOT NULL,
  status TEXT NOT NULL, -- 'Live', 'Beta', 'Coming Soon'
  status_color TEXT NOT NULL,
  version TEXT NOT NULL,
  size TEXT NOT NULL,
  platform TEXT NOT NULL, -- 'Android', 'iOS', 'Web', 'Desktop'
  features TEXT[],
  download_count INTEGER DEFAULT 0,
  rating DECIMAL(2, 1) DEFAULT 5.0,
  download_url TEXT,
  changelog TEXT,
  screenshots TEXT[],
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Apps index
CREATE INDEX idx_apps_slug ON apps(slug);
CREATE INDEX idx_apps_platform ON apps(platform);
CREATE INDEX idx_apps_status ON apps(status);

-- ============================================
-- CONTACT MESSAGES TABLE
-- ============================================
CREATE TABLE IF NOT EXISTS contact_messages (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Contact messages index
CREATE INDEX idx_contact_read ON contact_messages(is_read);
CREATE INDEX idx_contact_created ON contact_messages(created_at DESC);

-- ============================================
-- AI CHAT HISTORY TABLE (Optional)
-- ============================================
CREATE TABLE IF NOT EXISTS ai_chat_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID NOT NULL,
  user_message TEXT NOT NULL,
  ai_response TEXT NOT NULL,
  model_used TEXT DEFAULT 'openai',
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Chat history index
CREATE INDEX idx_chat_session ON ai_chat_history(session_id);
CREATE INDEX idx_chat_created ON ai_chat_history(created_at DESC);

-- ============================================
-- IMAGE GENERATION HISTORY TABLE (Optional)
-- ============================================
CREATE TABLE IF NOT EXISTS ai_image_history (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  session_id UUID NOT NULL,
  prompt TEXT NOT NULL,
  model_used TEXT NOT NULL,
  aspect_ratio TEXT NOT NULL,
  image_url TEXT NOT NULL,
  seed INTEGER,
  enhance BOOLEAN DEFAULT FALSE,
  no_logo BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Image history index
CREATE INDEX idx_image_session ON ai_image_history(session_id);
CREATE INDEX idx_image_created ON ai_image_history(created_at DESC);

-- ============================================
-- ROW LEVEL SECURITY (RLS) POLICIES
-- ============================================

-- Blog posts - Public read
ALTER TABLE blog_posts ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Blog posts are viewable by everyone" ON blog_posts
  FOR SELECT USING (true);

-- Products - Public read
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Products are viewable by everyone" ON products
  FOR SELECT USING (true);

-- Gallery - Public read
ALTER TABLE gallery_items ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Gallery items are viewable by everyone" ON gallery_items
  FOR SELECT USING (true);

-- Apps - Public read
ALTER TABLE apps ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Apps are viewable by everyone" ON apps
  FOR SELECT USING (true);

-- Contact messages - Anyone can insert
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can submit contact messages" ON contact_messages
  FOR INSERT WITH CHECK (true);

-- AI Chat - Public read/write (or you can restrict this)
ALTER TABLE ai_chat_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view and create chat history" ON ai_chat_history
  FOR ALL USING (true);

-- AI Image - Public read/write
ALTER TABLE ai_image_history ENABLE ROW LEVEL SECURITY;
CREATE POLICY "Anyone can view and create image history" ON ai_image_history
  FOR ALL USING (true);

-- ============================================
-- SAMPLE DATA
-- ============================================

-- Sample Blog Posts
INSERT INTO blog_posts (title, slug, excerpt, content, tag, tag_color, icon, read_time) VALUES
('Building Scalable React Applications', 'building-scalable-react-applications', 'Best practices for structuring React apps with TypeScript, state management patterns, and performance optimization techniques.', 'Full article content here...', 'React', '#54C5F8', 'web_rounded', '5 min read'),
('Building RESTful APIs with Node.js', 'building-restful-apis-nodejs', 'A comprehensive guide to creating robust REST APIs using Node.js and Express.', 'Full article content here...', 'Backend', '#34D399', 'dns_rounded', '7 min read'),
('PostgreSQL Performance Tuning', 'postgresql-performance-tuning', 'Master database optimization with indexing strategies and query analysis.', 'Full article content here...', 'Database', '#A78BFA', 'storage_rounded', '6 min read');

-- Sample Products
INSERT INTO products (name, slug, description, price, original_price, badge, rating, sales_count, category, icon) VALUES
('Rekty AI Pro', 'rekty-ai-pro', 'Advanced AI assistant with unlimited generations', 29.99, 49.99, 'Sale', 4.8, 128, 'AI Tools', 'auto_awesome_rounded'),
('POS System License', 'pos-system-license', 'Complete point of sale solution for your business', 99.99, 149.99, 'Hot', 4.9, 89, 'Business', 'point_of_sale_rounded'),
('Premium UI Kit', 'premium-ui-kit', '200+ modern UI components for Flutter', 19.99, NULL, 'New', 5.0, 234, 'Design', 'palette_rounded');

-- Sample Apps
INSERT INTO apps (name, slug, description, icon, status, status_color, version, size, platform, features, download_count, rating) VALUES
('Rekty AI', 'rekty-ai', 'AI-powered assistant for text and image generation', 'auto_awesome_rounded', 'Live', '#34D399', '2.1.0', '45 MB', 'Android', ARRAY['AI Chat', 'Image Generation', 'Offline Mode'], 5420, 4.8),
('Rekty POS', 'rekty-pos', 'Modern point of sale system', 'point_of_sale_rounded', 'Beta', '#FFA000', '1.5.0', '38 MB', 'Web', ARRAY['Sales Tracking', 'Inventory', 'Reports'], 1230, 4.6);

-- Sample Gallery Items
INSERT INTO gallery_items (title, category, image_url, description, tags) VALUES
('Modern Dashboard UI', 'ui', 'https://picsum.photos/400/300?random=1', 'Clean and modern dashboard design', ARRAY['UI', 'Dashboard', 'Dark Mode']),
('Mobile App Mockup', 'mobile', 'https://picsum.photos/400/300?random=2', 'Beautiful mobile app interface', ARRAY['Mobile', 'iOS', 'Android']),
('Website Landing Page', 'web', 'https://picsum.photos/400/300?random=3', 'Responsive landing page design', ARRAY['Web', 'Landing', 'Responsive']);
