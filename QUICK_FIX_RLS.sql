-- ==========================================
-- QUICK FIX: DISABLE RLS (UNTUK TESTING)
-- ==========================================
-- Cara tercepat: Matikan RLS sementara untuk testing
-- PERINGATAN: Ini membuat table accessible untuk semua orang
-- Untuk production, sebaiknya pakai RLS yang proper

-- Option 1: DISABLE RLS (SIMPLE, TESTING ONLY)
ALTER TABLE contact_messages DISABLE ROW LEVEL SECURITY;

-- ==========================================
-- ATAU
-- ==========================================

-- Option 2: ENABLE RLS WITH PROPER POLICIES (RECOMMENDED)
-- Uncomment section ini jika mau pakai RLS yang proper

/*
-- Enable RLS
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Drop all existing policies
DROP POLICY IF EXISTS "Allow public insert" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin select" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin update" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin delete" ON contact_messages;
DROP POLICY IF EXISTS "Enable insert for anon users" ON contact_messages;
DROP POLICY IF EXISTS "Enable read access for admins" ON contact_messages;
DROP POLICY IF EXISTS "Enable update for admins" ON contact_messages;
DROP POLICY IF EXISTS "Enable delete for admins" ON contact_messages;

-- Create new policies
CREATE POLICY "public_insert" ON contact_messages
  FOR INSERT
  WITH CHECK (true);

CREATE POLICY "admin_select" ON contact_messages
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

CREATE POLICY "admin_update" ON contact_messages
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

CREATE POLICY "admin_delete" ON contact_messages
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );
*/
