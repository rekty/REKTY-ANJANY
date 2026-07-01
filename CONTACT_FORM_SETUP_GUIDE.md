# Contact Form Setup Guide

## ✅ Implementation Complete

The contact form is now fully functional with real Supabase integration!

## 🎯 Quick Setup Steps

### Step 1: Create Database Table
1. Open Supabase Dashboard: https://app.supabase.com/project/tdztcovdwewfsenzrtnq
2. Go to **SQL Editor** (left sidebar)
3. Click **New Query**
4. Copy and paste the contents of `supabase_contact_messages_table.sql`
5. Click **Run** or press `Ctrl+Enter`
6. Verify table created: Go to **Table Editor** → You should see `contact_messages` table

### Step 2: Verify RLS Policies
1. In Supabase Dashboard, go to **Authentication** → **Policies**
2. Select `contact_messages` table
3. Verify 4 policies exist:
   - ✅ "Allow public insert" (INSERT with no auth)
   - ✅ "Allow admin select" (SELECT for admins only)
   - ✅ "Allow admin update" (UPDATE for admins only)
   - ✅ "Allow admin delete" (DELETE for admins only)

### Step 3: Test the Implementation
1. **Build the app:**
   ```bash
   flutter build web --release
   ```

2. **Deploy to Firebase:**
   ```bash
   firebase deploy --only hosting
   ```

3. **Test public submission:**
   - Visit: https://rekty-anjany-5a2eb.web.app/contact
   - Fill in the contact form
   - Click "Send Message"
   - You should see success message ✅

4. **Test admin view:**
   - Login to admin: https://rekty-anjany-5a2eb.web.app/login
   - Email: `zikri.auliaibrahim@gmail.com`
   - Go to **Messages** page
   - You should see the submitted message
   - Test mark as read/unread
   - Test delete

## 📊 Database Schema

```sql
Table: contact_messages
├── id (UUID, Primary Key)
├── name (TEXT, NOT NULL)
├── email (TEXT, NOT NULL)
├── subject (TEXT, NOT NULL)
├── message (TEXT, NOT NULL)
├── is_read (BOOLEAN, default: false)
└── created_at (TIMESTAMP, default: NOW())

Indexes:
├── idx_contact_messages_created_at (created_at DESC)
├── idx_contact_messages_is_read (is_read)
└── idx_contact_messages_email (email)
```

## 🔒 Security

### Row Level Security (RLS)
- ✅ **Public can INSERT** - Anyone can submit contact form
- ✅ **Admins can SELECT** - Only admins can view messages
- ✅ **Admins can UPDATE** - Only admins can mark as read
- ✅ **Admins can DELETE** - Only admins can delete messages

### Authentication
- ✅ Public form uses anon key (safe for public use)
- ✅ Admin operations use authenticated user token
- ✅ Admin verification via `admin_users` table

## 📝 Features

### Public Contact Form (`/contact`)
- ✅ Name field (required)
- ✅ Email field (required, validated)
- ✅ Subject field (required)
- ✅ Message field (required, multiline)
- ✅ Client-side validation
- ✅ Loading state during submission
- ✅ Success screen with checkmark
- ✅ Error handling with SnackBar
- ✅ Auto-clear form after success

### Admin Messages Page (`/admin/messages`)
- ✅ View all messages
- ✅ Unread counter badge
- ✅ Visual distinction (unread = bold + blue border)
- ✅ Click to view full message details
- ✅ Mark as read/unread
- ✅ Delete with confirmation
- ✅ Refresh button
- ✅ Empty state when no messages
- ✅ Responsive design

## 🧪 Testing Checklist

### Frontend Testing
- [ ] Form validation works (try submitting empty fields)
- [ ] Email validation works (try invalid email)
- [ ] Success screen appears after submission
- [ ] Form clears after successful submission
- [ ] Error handling works (test with invalid data)
- [ ] Loading state displays during submission

### Backend Testing
- [ ] Message appears in Supabase table
- [ ] `is_read` defaults to `false`
- [ ] `created_at` timestamp is correct
- [ ] All fields saved correctly

### Admin Testing
- [ ] Login to admin panel works
- [ ] Messages page accessible
- [ ] Unread counter shows correct number
- [ ] Can view message details
- [ ] Mark as read/unread works
- [ ] Delete with confirmation works
- [ ] Refresh button works

### Security Testing
- [ ] Public users can submit without login
- [ ] Public users CANNOT view messages list
- [ ] Public users CANNOT access admin panel
- [ ] Only verified admins can view/manage messages
- [ ] RLS policies enforced correctly

## 🚀 Deployment

```bash
# Build Flutter app
flutter build web --release

# Deploy to Firebase
firebase deploy --only hosting

# Visit the live site
https://rekty-anjany-5a2eb.web.app
```

## 📖 Documentation

- **Full Implementation Guide:** `CONTACT_FORM_IMPLEMENTATION.md`
- **SQL Schema:** `supabase_contact_messages_table.sql`
- **This Setup Guide:** `CONTACT_FORM_SETUP_GUIDE.md`

## 🐛 Troubleshooting

### Issue: Form submission fails
**Error:** `401 Unauthorized`
**Solution:** 
1. Check RLS policies in Supabase
2. Ensure "Allow public insert" policy exists
3. Verify table name is correct: `contact_messages`

### Issue: Admin can't view messages
**Error:** Empty message list or 403 error
**Solution:**
1. Verify admin user exists in `admin_users` table
2. Check admin email matches exactly
3. Verify "Allow admin select" RLS policy exists
4. Make sure admin is logged in

### Issue: Delete not working
**Error:** Permission denied
**Solution:**
1. Check "Allow admin delete" RLS policy
2. Verify admin authentication token is valid
3. Check console for errors

### Issue: Messages not appearing in real-time
**Note:** This is expected behavior
**Solution:** Click the refresh button to reload messages

## 💡 Optional Enhancements

### Email Notifications
Add email notification when new message received:
1. Use Supabase Edge Functions
2. Integrate SendGrid or Resend
3. Create email template
4. Trigger on INSERT to `contact_messages`

### Spam Prevention
Add rate limiting and captcha:
1. Implement honeypot field
2. Add reCAPTCHA v3
3. Rate limit by IP address
4. Add cooldown period between submissions

### Reply Functionality
Allow admins to reply to messages:
1. Add reply form in message details modal
2. Store replies in separate table
3. Send email with reply
4. Track conversation history

## 📞 Support

### Contact Developer
- **Name:** Rekty
- **Email:** rekty.anjany@gmail.com
- **GitHub:** https://github.com/rekty
- **Website:** https://rekty-anjany-5a2eb.web.app

### Need Help?
Submit a message via the contact form! 😊

---

**Last Updated:** July 1, 2026
**Version:** 1.0.0
**Status:** ✅ Production Ready
