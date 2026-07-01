-- ==========================================
-- CONTACT MESSAGES TABLE
-- ==========================================
-- This table stores messages submitted from the contact form
-- Public users can INSERT, only admins can SELECT/UPDATE/DELETE

-- Create table
CREATE TABLE IF NOT EXISTS contact_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add indexes for better performance
CREATE INDEX IF NOT EXISTS idx_contact_messages_created_at ON contact_messages(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_contact_messages_is_read ON contact_messages(is_read);
CREATE INDEX IF NOT EXISTS idx_contact_messages_email ON contact_messages(email);

-- Enable Row Level Security
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Drop existing policies if they exist
DROP POLICY IF EXISTS "Allow public insert" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin select" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin update" ON contact_messages;
DROP POLICY IF EXISTS "Allow admin delete" ON contact_messages;

-- Policy 1: Allow anyone to INSERT (submit contact form)
-- This allows public users to submit contact form without authentication
CREATE POLICY "Allow public insert" ON contact_messages
  FOR INSERT
  WITH CHECK (true);

-- Policy 2: Allow only admins to SELECT (read messages)
-- Admins are verified via admin_users table
CREATE POLICY "Allow admin select" ON contact_messages
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

-- Policy 3: Allow only admins to UPDATE (mark as read, etc.)
CREATE POLICY "Allow admin update" ON contact_messages
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

-- Policy 4: Allow only admins to DELETE
CREATE POLICY "Allow admin delete" ON contact_messages
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

-- ==========================================
-- TESTING QUERIES
-- ==========================================

-- 1. Test public insert (this should work without authentication)
-- INSERT INTO contact_messages (name, email, subject, message)
-- VALUES ('Test User', 'test@example.com', 'Test Subject', 'Test message content');

-- 2. View all messages (requires admin authentication)
-- SELECT * FROM contact_messages ORDER BY created_at DESC;

-- 3. Count unread messages
-- SELECT COUNT(*) as unread_count FROM contact_messages WHERE is_read = false;

-- 4. Mark message as read
-- UPDATE contact_messages SET is_read = true WHERE id = 'your-message-id';

-- 5. Delete message
-- DELETE FROM contact_messages WHERE id = 'your-message-id';

-- ==========================================
-- SAMPLE DATA (for testing only)
-- ==========================================

-- Uncomment to insert sample data for testing
-- INSERT INTO contact_messages (name, email, subject, message, is_read) VALUES
-- ('John Doe', 'john@example.com', 'Question about your services', 'Hi, I would like to know more about your services. Can you provide more details?', false),
-- ('Jane Smith', 'jane@example.com', 'Collaboration opportunity', 'I have an exciting project and would love to collaborate with you.', false),
-- ('Bob Johnson', 'bob@example.com', 'Feedback on your portfolio', 'Your portfolio looks amazing! Great work on the design.', true),
-- ('Alice Brown', 'alice@example.com', 'Technical question', 'I noticed you use Flutter for web development. What are your thoughts on it?', true);

-- ==========================================
-- CLEANUP (if needed)
-- ==========================================

-- Drop table completely (WARNING: This deletes all data)
-- DROP TABLE IF EXISTS contact_messages CASCADE;
