# Contributing Guide

Thank you for considering contributing to Rekty Anjany Portfolio!

## 🤝 How to Contribute

### Reporting Bugs

1. Check if the bug has already been reported in [Issues](https://github.com/YOUR_USERNAME/rekty_anjany/issues)
2. If not, create a new issue with:
   - Clear title
   - Detailed description
   - Steps to reproduce
   - Expected vs actual behavior
   - Screenshots (if applicable)
   - Environment details (OS, Flutter version, browser)

### Suggesting Features

1. Check [Issues](https://github.com/YOUR_USERNAME/rekty_anjany/issues) for similar suggestions
2. Create a new issue with:
   - Clear feature description
   - Use cases
   - Mockups or examples (if applicable)

### Pull Requests

1. Fork the repository
2. Create a feature branch from `main`:
   ```bash
   git checkout -b feature/your-feature-name
   ```

3. Make your changes:
   - Follow the code style
   - Add comments for complex logic
   - Update documentation if needed

4. Test your changes:
   ```bash
   flutter test
   flutter analyze
   flutter build web
   ```

5. Commit with clear messages:
   ```bash
   git commit -m "feat: add new feature"
   git commit -m "fix: resolve bug in admin panel"
   git commit -m "docs: update README"
   ```

6. Push to your fork:
   ```bash
   git push origin feature/your-feature-name
   ```

7. Create Pull Request:
   - Describe what you changed
   - Reference related issues
   - Add screenshots for UI changes

## 📝 Commit Message Convention

Use semantic commit messages:

- `feat:` - New feature
- `fix:` - Bug fix
- `docs:` - Documentation changes
- `style:` - Code style changes (formatting, etc.)
- `refactor:` - Code refactoring
- `perf:` - Performance improvements
- `test:` - Adding or updating tests
- `chore:` - Maintenance tasks

Examples:
```
feat: add image upload to gallery
fix: resolve admin auth loop issue
docs: update setup guide
style: format admin dashboard code
refactor: simplify API service methods
```

## 🎨 Code Style

### Dart/Flutter

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` before committing
- Run `flutter analyze` to check for issues
- Maximum line length: 80 characters (when practical)

### File Naming

- Use snake_case: `admin_dashboard_page.dart`
- Widgets: `widget_name.dart`
- Services: `service_name.dart`
- Models: `model_name.dart`

### Widget Organization

```dart
class MyWidget extends StatelessWidget {
  // 1. Constructor
  const MyWidget({super.key, required this.title});

  // 2. Fields
  final String title;

  // 3. Build method
  @override
  Widget build(BuildContext context) {
    return Container();
  }

  // 4. Private helper methods
  Widget _buildHelper() {
    return Container();
  }
}
```

## 🧪 Testing

Before submitting PR:

```bash
# Run tests
flutter test

# Run analyzer
flutter analyze

# Format code
flutter format lib/

# Build to verify
flutter build web --release
```

## 🔒 Security

- Never commit credentials
- Never commit API keys
- Never commit admin emails
- Always use `.gitignore` for sensitive files
- Check `supabase_config.dart` is not in commits

## 📦 Dependencies

When adding dependencies:

1. Check if really needed
2. Use latest stable version
3. Update `pubspec.yaml`
4. Run `flutter pub get`
5. Document in PR why it's needed

## 🐛 Debugging Tips

### Enable Debug Logs

```dart
// In main.dart
debugPrint('Debug message');
print('Info message');
```

### Check Supabase Logs

Supabase Dashboard → Logs → Query logs

### Check Browser Console

F12 → Console tab → Look for errors

## 📖 Resources

- [Flutter Documentation](https://flutter.dev/docs)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)
- [Supabase Documentation](https://supabase.com/docs)
- [Material Design Guidelines](https://material.io/design)

## ❓ Questions?

- Open a [Discussion](https://github.com/YOUR_USERNAME/rekty_anjany/discussions)
- Email: rekty.anjany@gmail.com

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

---

Thank you for contributing! 🎉
