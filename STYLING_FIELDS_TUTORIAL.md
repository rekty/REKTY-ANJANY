# Tutorial: Tambah Styling Fields ke Admin Forms

Tutorial step-by-step untuk menambahkan color picker dan font weight selector ke admin forms.

## 📋 Yang Sudah Disiapkan:

✅ **SQL Migration** - `supabase_migration_styling.sql` (SUDAH DIJALANKAN)
✅ **Helper Widgets** - Color picker & Font weight selector
✅ **Database columns** - Siap dipakai

---

## 🎯 Steps untuk Update Setiap Form

### Step 1: Import Helper Widgets

Tambahkan di bagian atas file form:

```dart
import '../../../shared/widgets/form/color_picker_field.dart';
import '../../../shared/widgets/form/font_weight_field.dart';
```

### Step 2: Tambah Controllers

Di dalam `State` class, tambah controllers baru:

```dart
// Styling controllers
final _titleColorController = TextEditingController();
final _taglineColorController = TextEditingController(); // Optional, untuk apps/downloads
final _descriptionColorController = TextEditingController();
final _fontWeightController = TextEditingController();
```

### Step 3: Set Default Values di initState

```dart
@override
void initState() {
  super.initState();
  // Set defaults
  _titleColorController.text = '#FFFFFF';
  _taglineColorController.text = '#54C5F8';
  _descriptionColorController.text = '#94A3B8';
  _fontWeightController.text = 'bold';
  
  _checkAdminAccess();
}
```

### Step 4: Load Values di `_loadApp()` / `_loadItem()`

Tambahkan setelah load data existing:

```dart
// Load styling fields
_titleColorController.text = app['title_color'] ?? '#FFFFFF';
_taglineColorController.text = app['tagline_color'] ?? '#54C5F8'; // Jika ada
_descriptionColorController.text = app['description_color'] ?? '#94A3B8';
_fontWeightController.text = app['font_weight'] ?? 'bold';
```

### Step 5: Tambahkan Fields di Form Build

Setelah field-field existing (version, platform, dll), tambahkan section styling:

```dart
const SizedBox(height: AppSpacing.xxxl),

// Styling Section Header
const Text(
  '🎨 Styling',
  style: TextStyle(
    color: AppColors.textPrimary,
    fontSize: 18,
    fontWeight: FontWeight.bold,
  ),
),
const SizedBox(height: 4),
const Text(
  'Customize colors and font style',
  style: TextStyle(
    color: AppColors.textSecondary,
    fontSize: 13,
  ),
),

const SizedBox(height: AppSpacing.xl),

// Title Color
ColorPickerField(
  label: 'Title Color',
  value: _titleColorController.text,
  onChanged: (color) {
    setState(() {
      _titleColorController.text = color;
    });
  },
),

const SizedBox(height: AppSpacing.xl),

// Tagline Color (Optional - hanya untuk Apps/Downloads)
ColorPickerField(
  label: 'Tagline Color',
  value: _taglineColorController.text,
  onChanged: (color) {
    setState(() {
      _taglineColorController.text = color;
    });
  },
),

const SizedBox(height: AppSpacing.xl),

// Description Color
ColorPickerField(
  label: 'Description Color',
  value: _descriptionColorController.text,
  onChanged: (color) {
    setState(() {
      _descriptionColorController.text = color;
    });
  },
),

const SizedBox(height: AppSpacing.xl),

// Font Weight
FontWeightField(
  label: 'Font Weight',
  value: _fontWeightController.text,
  onChanged: (value) {
    setState(() {
      _fontWeightController.text = value ?? 'bold';
    });
  },
),
```

### Step 6: Save Data di `_saveApp()` / `_saveItem()`

Tambahkan styling fields ke data object:

```dart
final data = {
  'name': _nameController.text.trim(),
  // ... existing fields ...
  
  // Styling fields (NEW)
  'title_color': _titleColorController.text.trim(),
  'tagline_color': _taglineColorController.text.trim(), // Jika ada
  'description_color': _descriptionColorController.text.trim(),
  'font_weight': _fontWeightController.text.trim(),
  
  'updated_at': DateTime.now().toIso8601String(),
};
```

### Step 7: Dispose Controllers

Tambahkan di `dispose()`:

```dart
@override
void dispose() {
  // ... existing controllers ...
  
  // Styling controllers
  _titleColorController.dispose();
  _taglineColorController.dispose(); // Jika ada
  _descriptionColorController.dispose();
  _fontWeightController.dispose();
  
  super.dispose();
}
```

---

## 📝 Summary per Module

### Apps Form (`admin_app_form_page.dart`)
Fields to add:
- `title_color`
- `tagline_color`
- `description_color`
- `font_weight`

### Downloads Form (`admin_download_form_page.dart`)
Fields to add:
- `title_color`
- `tagline_color`
- `description_color`
- `font_weight`

### Products Form (`admin_product_form_page.dart`)
Fields to add:
- `title_color`
- `description_color`
- `font_weight`

### Blog Form (`admin_blog_form_page.dart`)
Fields to add:
- `title_color`
- `excerpt_color`
- `tag_color`
- `font_weight`

### Gallery Form (`admin_gallery_form_page.dart`)
Fields to add:
- `title_color`
- `description_color`
- `font_weight`

---

## 🎨 Update Public Pages

After forms are updated, update public pages to use the colors:

### Example (Apps Page):

```dart
// Replace static styles with dynamic ones
Text(
  name,
  style: TextStyle(
    color: _parseColor(app['title_color'] ?? '#FFFFFF'),
    fontSize: 26,
    fontWeight: _parseFontWeight(app['font_weight'] ?? 'bold'),
  ),
),

// Helper methods
Color _parseColor(String hexColor) {
  try {
    return Color(int.parse(hexColor.replaceFirst('#', '0xFF')));
  } catch (e) {
    return AppColors.textPrimary;
  }
}

FontWeight _parseFontWeight(String weight) {
  switch (weight) {
    case 'light': return FontWeight.w300;
    case 'normal': return FontWeight.w400;
    case 'semibold': return FontWeight.w600;
    case 'bold': return FontWeight.w700;
    default: return FontWeight.bold;
  }
}
```

---

## ✅ Checklist

**Admin Forms:**
- [ ] Apps Form
- [ ] Downloads Form
- [ ] Products Form
- [ ] Blog Form
- [ ] Gallery Form

**Public Pages:**
- [ ] Apps Page
- [ ] Downloads Page
- [ ] Store Page
- [ ] Blog Page
- [ ] Gallery Page

**Testing:**
- [ ] Create new item with custom colors
- [ ] Edit existing item
- [ ] View on public page with custom colors
- [ ] Test on mobile
- [ ] Test color combinations

---

## 🚀 Quick Start

1. Start with **Apps Form** (copy from this tutorial)
2. Test create & edit
3. Update **Apps Public Page** to display colors
4. Repeat for other modules

---

**Good luck! Kalau ada yang stuck, tanya aja!** 😊
