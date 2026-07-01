-- ==========================================
-- FIX CONTACT FORM ERROR 401 - JALANKAN INI SEKARANG!
-- ==========================================

-- Step 1: Check current policies
SELECT policyname, cmd, roles FROM pg_policies WHERE tablename = 'contact_messages';

-- Step 2: Drop ALL existing policies
DROP POLICY IF EXISTS "Allow public insert" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin select" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin update" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin delete" ON contact_messages;
DROP POLICY IF EXISTS "Enable insert for anon users" ON contact_messages;
DROP POLICY IF EXISTS "Enable read access for admins" ON contact_messages;
DROP POLICY IF EXISTS "Enable update for admins" ON contact_messages;
DROP POLICY IF EXISTS "Enable delete for admins" ON contact_messages;
DROP POLICY IF EXISTS "public_insert" ON contact_messages;
DROP POLICY IF EXISTS "admin_select" ON contact_messages;
DROP POLICY IF EXISTS "admin_update" ON contact_messages;
DROP POLICY IF EXISTS "admin_delete" ON contact_messages;
DROP POLICY IF EXISTS "authenticated_insert" ON contact_messages;
DROP POLICY IF EXISTS "public_insert_rate_limited" ON contact_messages;

-- Step 3: Enable RLS
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Step 4: Create SIMPLE policies that WORK

-- Policy 1: Allow ANYONE to INSERT (including anon)
CREATE POLICY "public_can_insert" 
ON contact_messages 
FOR INSERT 
TO anon, authenticated
WITH CHECK (true);

-- Policy 2: Admins can SELECT
CREATE POLICY "admins_can_select" 
ON contact_messages 
FOR SELECT 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.email = (auth.jwt() ->> 'email')
  )
);

-- Policy 3: Admins can UPDATE
CREATE POLICY "admins_can_update" 
ON contact_messages 
FOR UPDATE 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.email = (auth.jwt() ->> 'email')
  )
);

-- Policy 4: Admins can DELETE
CREATE POLICY "admins_can_delete" 
ON contact_messages 
FOR DELETE 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.email = (auth.jwt() ->> 'email')
  )
);

-- Step 5: Verify policies are created
SELECT 
  policyname,
  cmd,
  roles,
  permissive
FROM pg_policies 
WHERE tablename = 'contact_messages'
ORDER BY policyname;

-- Expected result: 4 policies
-- 1. admins_can_delete
-- 2. admins_can_select
-- 3. admins_can_update
-- 4. public_can_insert
