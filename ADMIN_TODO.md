# 📋 Admin Panel - Implementation Checklist

## ✅ Completed

- [x] Database schema (`supabase_schema.sql`)
- [x] Admin service with CRUD methods (`admin_service.dart`)
- [x] Admin guard middleware (`admin_guard.dart`)
- [x] Admin layout with sidebar (`admin_layout.dart`)
- [x] Dashboard page with statistics (`admin_dashboard_page.dart`)
- [x] Apps management page (`admin_apps_page.dart`)
- [x] Downloads management page (`admin_downloads_page.dart`)
- [x] Router configuration with protected routes
- [x] Setup documentation (`ADMIN_SETUP.md`)

---

## 🚧 To Be Implemented

### 1. Store Management (`/admin/store`)
**File:** `lib/features/admin/store/admin_store_page.dart`

Features needed:
- List all products with price, badge, rating
- Create product form (name, description, price, original_price, badge, icon)
- Edit product
- Delete product
- Toggle active status
- Sales statistics

**Copy pattern from:** `admin_apps_page.dart`

---

### 2. Gallery Management (`/admin/gallery`)
**File:** `lib/features/admin/gallery/admin_gallery_page.dart`

Features needed:
- Grid view of gallery items
- Upload single/multiple images
- Edit title, category, tags
- Delete images
- Category filter
- Drag & drop reorder

**New features:**
- Image uploader widget
- Grid layout instead of list
- Category dropdown

---

### 3. Blog Management (`/admin/blog`)
**File:** `lib/features/admin/blog/admin_blog_page.dart`

Features needed:
- List all blog posts with excerpt
- Create blog post form
- Rich text editor for content
- Edit post (title, slug, excerpt, content, tag, icon)
- Delete post
- Toggle publish status
- Set publish date
- View count display

**New features:**
- Rich text editor (consider using `flutter_quill` package)
- Slug generator from title
- Publish date picker

---

### 4. About Page Management (`/admin/about`)
**File:** `lib/features/admin/about/admin_about_page.dart`

Features needed:
- Edit about me text (title, subtitle, description)
- Upload profile image
- Edit social media links (JSON object)
- Edit skills list (JSON array)
- Upload/link CV/Resume

**New features:**
- JSON editor for social links and skills
- Profile image uploader
- File picker for CV

---

### 5. Contact Info Management (`/admin/contact`)
**File:** `lib/features/admin/contact/admin_contact_page.dart`

Features needed:
- Edit email address
- Edit phone number
- Edit physical address
- Edit social media links (JSON)
- Preview contact page

**Simple form** - just text fields for contact info

---

### 6. Messages Inbox (`/admin/messages`)
**File:** `lib/features/admin/messages/admin_messages_page.dart`

Features needed:
- List all contact messages (newest first)
- Mark as read/unread
- Delete messages
- Filter by read status
- Search messages
- Badge count for unread messages

**New features:**
- Message card with sender info
- Read/unread toggle
- Search bar
- Filter dropdown

---

## 🎨 Additional Components Needed

### File Upload Widget
**File:** `lib/shared/widgets/admin/file_uploader.dart`

Features:
- Drag & drop area
- File picker button
- Image preview
- Upload progress
- Multiple file support
- File type validation
- Size limit (50MB)

**Package:** Use `file_picker` package

---

### Rich Text Editor
**File:** `lib/shared/widgets/admin/rich_text_editor.dart`

Features:
- Bold, italic, underline
- Headings (H1, H2, H3)
- Lists (ordered, unordered)
- Links
- Code blocks
- Images

**Package:** Use `flutter_quill` or `html_editor_enhanced`

---

### Form Components
**File:** `lib/shared/widgets/admin/form_components.dart`

Components needed:
- Text field with label
- Textarea with label
- Number input
- Dropdown select
- Color picker
- Date picker
- Icon picker
- Tag input (chips)

---

### Image Uploader
**File:** `lib/shared/widgets/admin/image_uploader.dart`

Features:
- Click to upload
- Drag & drop
- Image preview
- Crop functionality (optional)
- Compress before upload
- Upload to Supabase Storage

**Package:** Use `image_picker` (web) and `http` for upload

---

## 🔧 Supabase Storage Integration

### Upload File Function
**File:** `lib/core/services/storage_service.dart`

```dart
class StorageService {
  Future<String> uploadFile(
    String bucket,
    String path,
    Uint8List fileBytes,
  ) async {
    // Upload to Supabase Storage
    // Return public URL
  }
  
  Future<void> deleteFile(String bucket, String path) async {
    // Delete from storage
  }
}
```

**Implementation:**
1. Get file bytes from picker
2. Generate unique filename
3. Upload to Supabase Storage bucket
4. Get public URL
5. Save URL to database

---

## 📝 Forms Pattern

### Create/Edit Form Structure

```dart
class AdminCreateAppPage extends StatefulWidget {
  final String? editId; // null = create, not null = edit
  
  @override
  State<AdminCreateAppPage> createState() => _AdminCreateAppPageState();
}

class _AdminCreateAppPageState extends State<AdminCreateAppPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  // ... more controllers
  
  bool _loading = false;
  bool get _isEdit => widget.editId != null;
  
  @override
  void initState() {
    super.initState();
    if (_isEdit) _loadData();
  }
  
  Future<void> _loadData() async {
    // Load existing data for edit
  }
  
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() => _loading = true);
    
    try {
      final data = {
        'name': _nameController.text,
        'description': _descriptionController.text,
        // ... more fields
      };
      
      if (_isEdit) {
        await AdminService.instance.updateApp(widget.editId!, data);
      } else {
        await AdminService.instance.createApp(data);
      }
      
      if (mounted) {
        Navigator.pop(context, true); // Return true = refresh list
      }
    } catch (e) {
      // Show error
    } finally {
      setState(() => _loading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_isEdit ? 'Edit App' : 'Create App'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.all(24),
          children: [
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(labelText: 'Name'),
              validator: (v) => v?.isEmpty ?? true ? 'Required' : null,
            ),
            // ... more fields
            
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _loading ? null : _submit,
              child: Text(_isEdit ? 'Update' : 'Create'),
            ),
          ],
        ),
      ),
    );
  }
}
```

---

## 🚀 Implementation Order (Recommended)

1. **Store Management** - Similar to Apps, good practice
2. **Messages Inbox** - Simple, no forms needed
3. **Contact Info** - Simple form
4. **About Page** - Form + image upload
5. **Gallery** - Image upload + grid view
6. **Blog** - Complex (rich text editor)

---

## 📦 Required Packages

Add to `pubspec.yaml`:

```yaml
dependencies:
  # Existing packages...
  
  # File handling
  file_picker: ^8.0.0+1
  image_picker: ^1.0.7
  
  # Rich text editor (choose one)
  flutter_quill: ^9.3.0
  # OR
  html_editor_enhanced: ^2.5.1
  
  # Image handling
  image: ^4.1.7  # For compression
  
  # Utilities
  intl: ^0.19.0  # Date formatting
  uuid: ^4.3.3   # Generate unique IDs
```

---

## 🎯 Quick Start Next Steps

1. **Run Supabase Schema:**
   - Open `supabase_schema.sql`
   - Change admin email to yours
   - Run in Supabase SQL Editor

2. **Test Admin Access:**
   - Login with OAuth
   - Navigate to `/admin`
   - Should see dashboard

3. **Implement Store Page:**
   - Copy `admin_apps_page.dart`
   - Rename to `admin_store_page.dart`
   - Update for products
   - Add route in router.dart

4. **Continue with other pages following the pattern**

---

## 💡 Tips

- **Reuse patterns:** Apps and Downloads pages show the structure
- **Start simple:** Get CRUD working first, then add features
- **Test with real data:** Create items via Supabase dashboard first
- **Use dummy data:** While building UI
- **Error handling:** Always show user-friendly messages
- **Loading states:** Show spinners during operations

---

## 📞 Need Help?

Refer to:
- `ADMIN_SETUP.md` - Setup guide
- `admin_apps_page.dart` - Full CRUD example
- `admin_service.dart` - API methods
- `supabase_schema.sql` - Database structure

---

**Status:** Foundation Complete ✅  
**Next:** Implement remaining CRUD pages 🚧  
**Version:** 1.0.0
