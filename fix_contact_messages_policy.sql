-- ==========================================
-- FIX CONTACT MESSAGES RLS POLICIES
-- ==========================================
-- Run this if you get 401 error when submitting contact form

-- Disable RLS temporarily
ALTER TABLE contact_messages DISABLE ROW LEVEL SECURITY;

-- Drop all existing policies
DROP POLICY IF EXISTS "Allow public insert" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin select" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin update" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin delete" ON contact_messages;
DROP POLICY IF EXISTS "Enable insert for anon users" ON contact_messages;
DROP POLICY IF EXISTS "Enable read access for admins" ON contact_messages;
DROP POLICY IF EXISTS "Enable update for admins" ON contact_messages;
DROP POLICY IF EXISTS "Enable delete for admins" ON contact_messages;

-- Re-enable RLS
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Policy 1: Allow ANYONE (including anon) to INSERT
CREATE POLICY "Enable insert for anon users" ON contact_messages
  FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);

-- Policy 2: Allow authenticated admins to SELECT
CREATE POLICY "Enable read access for admins" ON contact_messages
  FOR SELECT
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

-- Policy 3: Allow authenticated admins to UPDATE
CREATE POLICY "Enable update for admins" ON contact_messages
  FOR UPDATE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

-- Policy 4: Allow authenticated admins to DELETE
CREATE POLICY "Enable delete for admins" ON contact_messages
  FOR DELETE
  TO authenticated
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

-- ==========================================
-- VERIFY POLICIES
-- ==========================================
-- Check if policies are created correctly
SELECT schemaname, tablename, policyname, roles, cmd 
FROM pg_policies 
WHERE tablename = 'contact_messages';
