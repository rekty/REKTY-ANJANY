# Contact Form Implementation

## Overview
Real contact form integration with Supabase database. Messages are stored in `contact_messages` table and can be managed from admin panel.

## ✅ Implementation Status
- [x] Contact form submission to Supabase
- [x] Admin messages page (view/manage messages)
- [x] Mark as read/unread functionality
- [x] Delete messages functionality
- [x] Real-time message counter in admin sidebar
- [x] Form validation
- [x] Success/error feedback
- [x] Public submission (no authentication required)

## Database Schema

### Table: `contact_messages`
```sql
CREATE TABLE contact_messages (
  id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
  name TEXT NOT NULL,
  email TEXT NOT NULL,
  subject TEXT NOT NULL,
  message TEXT NOT NULL,
  is_read BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Add RLS (Row Level Security) policies
ALTER TABLE contact_messages ENABLE ROW LEVEL SECURITY;

-- Allow public INSERT (anyone can submit contact form)
CREATE POLICY "Allow public insert" ON contact_messages
  FOR INSERT
  WITH CHECK (true);

-- Allow admin SELECT, UPDATE, DELETE (only admins can read/manage)
CREATE POLICY "Allow admin select" ON contact_messages
  FOR SELECT
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

CREATE POLICY "Allow admin update" ON contact_messages
  FOR UPDATE
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );

CREATE POLICY "Allow admin delete" ON contact_messages
  FOR DELETE
  USING (
    EXISTS (
      SELECT 1 FROM admin_users
      WHERE email = auth.jwt() ->> 'email'
    )
  );
```

## Files Modified

### 1. Contact Form Page
**File:** `lib/features/contact/contact_page.dart`
- ✅ Removed mock implementation
- ✅ Added real Supabase integration
- ✅ Added AdminService import
- ✅ Implemented `submitContactMessage()` method call
- ✅ Added success/error feedback with SnackBar
- ✅ Form validation working
- ✅ Auto-clear form after successful submission

### 2. Admin Service
**File:** `lib/core/services/admin_service.dart`
- ✅ Added `submitContactMessage()` method for public submissions
- ✅ Uses public headers (no auth) for form submission
- ✅ Existing methods for admin management:
  - `getContactMessages()` - Fetch all messages (admin only)
  - `updateContactMessage()` - Update message fields
  - `markMessageAsRead()` - Mark as read
  - `deleteContactMessage()` - Delete message
  - `deleteMessage()` - Alternative delete method

### 3. Admin Messages Page
**File:** `lib/features/admin/messages/admin_messages_page.dart`
- ✅ Already implemented and working
- ✅ Shows all contact form submissions
- ✅ Mark as read/unread functionality
- ✅ Delete functionality
- ✅ Message details modal
- ✅ Unread counter badge
- ✅ Refresh button

## User Flow

### Public User (Contact Form)
1. Visit `/contact` page
2. Fill in form fields:
   - Name (required)
   - Email (required, validated)
   - Subject (required)
   - Message (required, multiline)
3. Click "Send Message" button
4. See loading state while submitting
5. On success:
   - See success screen with checkmark icon
   - Message saved to database
   - Form cleared
   - SnackBar confirmation
6. On error:
   - See error SnackBar with details
   - Form data preserved

### Admin User (Message Management)
1. Login to admin panel
2. Navigate to "Messages" page from sidebar
3. View all messages with:
   - Visual distinction (unread = blue border + bold)
   - Unread counter badge in header
   - Name, email, subject, message preview
4. Click message to view full details
5. Actions available:
   - Mark as read/unread
   - Delete message
   - Refresh list
6. Confirmation dialog for deletions

## API Endpoints Used

### Public Endpoint (No Auth)
```
POST /rest/v1/contact_messages
Body: {
  "name": "string",
  "email": "string", 
  "subject": "string",
  "message": "string",
  "is_read": false
}
```

### Admin Endpoints (Auth Required)
```
GET /rest/v1/contact_messages?select=*&order=created_at.desc
PATCH /rest/v1/contact_messages?id=eq.{id}
DELETE /rest/v1/contact_messages?id=eq.{id}
```

## Security

### Row Level Security (RLS)
- ✅ **Public INSERT**: Anyone can submit contact form (no auth)
- ✅ **Admin only SELECT/UPDATE/DELETE**: Only verified admin users can read/manage messages
- ✅ Form submission uses public anon key (safe)
- ✅ Admin operations use authenticated user token
- ✅ Admin validation via `admin_users` table

### Data Validation
- ✅ Client-side validation (Flutter form validators)
- ✅ Email format validation
- ✅ Required field validation
- ✅ Trim whitespace from inputs
- ✅ Server-side validation via Supabase schema constraints

## Testing

### Test Contact Form Submission
1. Visit: https://rekty-anjany-5a2eb.web.app/contact
2. Fill in all fields
3. Submit form
4. Verify success message appears
5. Check admin panel for new message

### Test Admin Management
1. Login to admin panel: https://rekty-anjany-5a2eb.web.app/login
2. Navigate to Messages page
3. Verify new message appears as unread
4. Click message to view details
5. Test mark as read/unread
6. Test delete functionality

## Next Steps (Optional Enhancements)

### Email Notifications
- [ ] Send email to admin when new message received
- [ ] Use Supabase Edge Functions or external service
- [ ] Email template with message details

### Message Status Management
- [ ] Add status field (new/read/replied/archived)
- [ ] Filter messages by status
- [ ] Bulk actions (mark multiple as read, delete multiple)

### Reply Functionality
- [ ] Add reply form in admin panel
- [ ] Send reply email to user
- [ ] Track reply history

### Spam Prevention
- [ ] Add rate limiting (prevent spam submissions)
- [ ] Add simple captcha or honeypot field
- [ ] Block suspicious IP addresses

### Analytics
- [ ] Track response time metrics
- [ ] Most common subjects/topics
- [ ] Message volume over time

## Support

### Troubleshooting

**Problem:** Form submission fails with 401 error
**Solution:** Check RLS policies - ensure public INSERT is enabled

**Problem:** Admin can't view messages
**Solution:** Verify admin user exists in `admin_users` table with correct email

**Problem:** Messages not appearing in admin panel
**Solution:** Check Supabase RLS policies for SELECT permission

**Problem:** Delete not working
**Solution:** Verify admin has DELETE permission in RLS policies

### Contact Developer
- **Name:** Rekty
- **GitHub:** https://github.com/rekty
- **Website:** https://rekty-anjany-5a2eb.web.app

## Changelog

### Version 1.0.0 (July 1, 2026)
- ✅ Initial implementation
- ✅ Real Supabase integration
- ✅ Public form submission
- ✅ Admin message management
- ✅ Mark as read/unread
- ✅ Delete functionality
- ✅ Form validation
- ✅ Success/error feedback
