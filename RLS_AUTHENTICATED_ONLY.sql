-- ==========================================
-- OPTION 2: ONLY AUTHENTICATED USERS CAN SUBMIT
-- ==========================================
-- Only logged-in users can send messages
-- This prevents spam but requires users to login first

-- Enable RLS
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "public_insert" ON contact_messages;
DROP POLICY IF EXISTS "public_insert_rate_limited" ON contact_messages;
DROP POLICY IF EXISTS "admin_select" ON contact_messages;
DROP POLICY IF EXISTS "admin_update" ON contact_messages;
DROP POLICY IF EXISTS "admin_delete" ON contact_messages;

-- Policy 1: Allow INSERT only for authenticated users
-- Users must login (Google/GitHub/Facebook/Email) before sending message
CREATE POLICY "authenticated_insert" 
ON contact_messages 
FOR INSERT 
TO authenticated
WITH CHECK (true);

-- Policy 2: Allow SELECT for admins
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

-- Policy 3: Allow UPDATE for admins
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

-- Policy 4: Allow DELETE for admins
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

-- Verify policies
SELECT policyname, cmd FROM pg_policies WHERE tablename = 'contact_messages';
