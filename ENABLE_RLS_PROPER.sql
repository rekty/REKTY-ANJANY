-- ==========================================
-- ENABLE RLS WITH PROPER POLICIES
-- ==========================================
-- This will secure your contact_messages table properly
-- Public can INSERT only, Admins can SELECT/UPDATE/DELETE

-- Step 1: Enable RLS
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Step 2: Drop all existing policies (clean slate)
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

-- Step 3: Create simple and working policies

-- Policy 1: Allow INSERT for everyone (public contact form)
-- This is what makes the contact form work for public users
CREATE POLICY "public_insert" 
ON contact_messages 
FOR INSERT 
WITH CHECK (true);

-- Policy 2: Allow SELECT for authenticated admins only
-- This protects message viewing to admins only
CREATE POLICY "admin_select" 
ON contact_messages 
FOR SELECT 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.email = auth.jwt() ->> 'email'
  )
);

-- Policy 3: Allow UPDATE for authenticated admins only
-- This allows admins to mark messages as read
CREATE POLICY "admin_update" 
ON contact_messages 
FOR UPDATE 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.email = auth.jwt() ->> 'email'
  )
);

-- Policy 4: Allow DELETE for authenticated admins only
-- This allows admins to delete spam messages
CREATE POLICY "admin_delete" 
ON contact_messages 
FOR DELETE 
TO authenticated
USING (
  EXISTS (
    SELECT 1 FROM admin_users
    WHERE admin_users.email = auth.jwt() ->> 'email'
  )
);

-- ==========================================
-- VERIFY POLICIES ARE CREATED
-- ==========================================
SELECT 
  schemaname,
  tablename, 
  policyname, 
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE tablename = 'contact_messages'
ORDER BY policyname;

-- Expected result: 4 policies
-- 1. admin_delete
-- 2. admin_select  
-- 3. admin_update
-- 4. public_insert
