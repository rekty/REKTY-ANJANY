-- ==========================================
-- OPTION 1: RLS WITH RATE LIMITING
-- ==========================================
-- Limit submissions to prevent spam
-- Each user can only submit once per hour

-- Enable RLS
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies
DROP POLICY IF EXISTS "public_insert" ON contact_messages;
DROP POLICY IF EXISTS "admin_select" ON contact_messages;
DROP POLICY IF EXISTS "admin_update" ON contact_messages;
DROP POLICY IF EXISTS "admin_delete" ON contact_messages;

-- Policy 1: Allow INSERT but with rate limit check
-- Users can only insert if they haven't submitted in the last hour
CREATE POLICY "public_insert_rate_limited" 
ON contact_messages 
FOR INSERT 
WITH CHECK (
  -- Allow if no message from this email in last 1 hour
  NOT EXISTS (
    SELECT 1 FROM contact_messages
    WHERE email = contact_messages.email
    AND created_at > NOW() - INTERVAL '1 hour'
  )
);

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
