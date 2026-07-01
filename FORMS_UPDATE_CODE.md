# Quick Copy-Paste Code for Remaining Forms

## ✅ Apps Form - COMPLETED

## Downloads Form

### 1. Add to imports (top of file):
```dart
import '../../../shared/widgets/form/color_picker_field.dart';
import '../../../shared/widgets/form/font_weight_field.dart';
```

### 2. Add controllers after existing controllers:
```dart
// Styling controllers  
final _titleColorController = TextEditingController();
final _taglineColorController = TextEditingController();
final _descriptionColorController = TextEditingController();
final _fontWeightController = TextEditingController();
```

### 3. Set defaults in initState (after existing code):
```dart
_titleColorController.text = '#FFFFFF';
_taglineColorController.text = '#54C5F8';
_descriptionColorController.text = '#94A3B8';
_fontWeightController.text = 'bold';
```

### 4. Load values in _loadDownload() (after existing load code):
```dart
_titleColorController.text = download['title_color'] ?? '#FFFFFF';
_taglineColorController.text = download['tagline_color'] ?? '#54C5F8';
_descriptionColorController.text = download['description_color'] ?? '#94A3B8';
_fontWeightController.text = download['font_weight'] ?? 'bold';
```

### 5. Add to data object in _saveDownload():
```dart
'title_color': _titleColorController.text.trim(),
'tagline_color': _taglineColorController.text.trim(),
'description_color': _descriptionColorController.text.trim(),
'font_weight': _fontWeightController.text.trim(),
```

### 6. Dispose in dispose():
```dart
_titleColorController.dispose();
_taglineColorController.dispose();
_descriptionColorController.dispose();
_fontWeightController.dispose();
```

### 7. Add UI (after features field, before action buttons):
Same as Apps form styling section (copy from apps form lines after "💡 Tip" until action buttons)

---

## Products Form

Same as Downloads but **NO tagline_color** (products don't have tagline)

### Controllers:
```dart
final _titleColorController = TextEditingController();
final _descriptionColorController = TextEditingController();
final _fontWeightController = TextEditingController();
```

### Defaults:
```dart
_titleColorController.text = '#FFFFFF';
_descriptionColorController.text = '#94A3B8';
_fontWeightController.text = 'bold';
```

### UI Fields (only 3 fields, skip tagline):
```dart
ColorPickerField(
  label: 'Title Color',
  value: _titleColorController.text,
  onChanged: (color) {
    setState(() => _titleColorController.text = color);
  },
),

const SizedBox(height: AppSpacing.xl),

ColorPickerField(
  label: 'Description Color',
  value: _descriptionColorController.text,
  onChanged: (color) {
    setState(() => _descriptionColorController.text = color);
  },
),

const SizedBox(height: AppSpacing.xl),

FontWeightField(
  label: 'Font Weight',
  value: _fontWeightController.text,
  onChanged: (value) {
    setState(() => _fontWeightController.text = value ?? 'bold');
  },
),
```

---

## Blog Form

### Controllers:
```dart
final _titleColorController = TextEditingController();
final _excerptColorController = TextEditingController();
final _tagColorController = TextEditingController();
final _fontWeightController = TextEditingController();
```

### Defaults:
```dart
_titleColorController.text = '#FFFFFF';
_excerptColorController.text = '#94A3B8';
_tagColorController.text = '#54C5F8';
_fontWeightController.text = 'bold';
```

### Load:
```dart
_titleColorController.text = post['title_color'] ?? '#FFFFFF';
_excerptColorController.text = post['excerpt_color'] ?? '#94A3B8';
_tagColorController.text = post['tag_color'] ?? '#54C5F8';
_fontWeightController.text = post['font_weight'] ?? 'bold';
```

### Save:
```dart
'title_color': _titleColorController.text.trim(),
'excerpt_color': _excerptColorController.text.trim(),
'tag_color': _tagColorController.text.trim(),
'font_weight': _fontWeightController.text.trim(),
```

### UI:
```dart
ColorPickerField(
  label: 'Title Color',
  value: _titleColorController.text,
  onChanged: (color) => setState(() => _titleColorController.text = color),
),

const SizedBox(height: AppSpacing.xl),

ColorPickerField(
  label: 'Excerpt Color',
  value: _excerptColorController.text,
  onChanged: (color) => setState(() => _excerptColorController.text = color),
),

const SizedBox(height: AppSpacing.xl),

ColorPickerField(
  label: 'Tag Color',
  value: _tagColorController.text,
  onChanged: (color) => setState(() => _tagColorController.text = color),
),

const SizedBox(height: AppSpacing.xl),

FontWeightField(
  label: 'Font Weight',
  value: _fontWeightController.text,
  onChanged: (value) => setState(() => _fontWeightController.text = value ?? 'bold'),
),
```

---

## Gallery Form

Same as Products (no tagline)

### Controllers:
```dart
final _titleColorController = TextEditingController();
final _descriptionColorController = TextEditingController();
final _fontWeightController = TextEditingController();
```

### Everything else same pattern as Products

---

## Summary Table

| Form | title_color | tagline_color | description_color | excerpt_color | tag_color | font_weight |
|------|-------------|---------------|-------------------|---------------|-----------|-------------|
| Apps | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ |
| Downloads | ✅ | ✅ | ✅ | ❌ | ❌ | ✅ |
| Products | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |
| Blog | ✅ | ❌ | ❌ | ✅ | ✅ | ✅ |
| Gallery | ✅ | ❌ | ✅ | ❌ | ❌ | ✅ |

---

**Implementation Order:**
1. ✅ Apps - DONE
2. Downloads - Copy pattern from Apps
3. Products - Remove tagline field
4. Blog - Use excerpt & tag instead
5. Gallery - Same as Products

Good luck! 🚀
