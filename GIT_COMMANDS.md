# Git Commands - Quick Reference

Panduan lengkap untuk commit dan push ke GitHub.

## ⚠️ SEBELUM COMMIT - CHECKLIST KEAMANAN

**WAJIB CEK DULU!**

- [ ] File `lib/core/config/supabase_config.dart` **TIDAK** di-commit
- [ ] File `.env` **TIDAK** di-commit
- [ ] File `.firebase/` **TIDAK** di-commit
- [ ] Tidak ada password/secret di code
- [ ] Tidak ada admin email hardcoded

### Cara Cek File yang Akan Di-commit

```bash
# Lihat status
git status

# Lihat file yang berubah
git diff

# Pastikan supabase_config.dart TIDAK muncul!
```

## 🚀 First Time Setup

### 1. Inisialisasi Git (jika belum)

```bash
cd c:\Users\Administrator\Documents\project_flutter\rekty_anjany

# Init git (jika belum)
git init

# Add remote
git remote add origin https://github.com/YOUR_USERNAME/rekty_anjany.git

# Verify
git remote -v
```

### 2. Configure Git (jika belum)

```bash
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

### 3. Verify .gitignore Working

```bash
# Test if file is ignored
git check-ignore lib/core/config/supabase_config.dart

# Should return: lib/core/config/supabase_config.dart
# If not, file will be committed! DON'T COMMIT!
```

## 📤 Push ke GitHub - Step by Step

### Step 1: Stage Files

```bash
# Add all files (kecuali yang di .gitignore)
git add .

# Atau add selective
git add README.md
git add lib/
git add pubspec.yaml
```

### Step 2: Check What Will Be Committed

```bash
# Lihat file yang akan di-commit
git status

# ⚠️ PASTIKAN TIDAK ADA:
# - lib/core/config/supabase_config.dart
# - .env
# - .firebase/
```

### Step 3: Commit

```bash
# Commit dengan message yang jelas
git commit -m "feat: initial commit with admin panel"

# Atau commit yang lebih detail
git commit -m "feat: add complete admin panel

- Supabase integration
- OAuth authentication
- CRUD operations
- Image upload support
- Responsive design
"
```

### Step 4: Push to GitHub

```bash
# First push (if new repo)
git push -u origin main

# Or if branch is master
git push -u origin master

# Subsequent pushes
git push
```

## 🔄 Update Repository

### Pull Latest Changes

```bash
# Pull from main branch
git pull origin main

# Or with rebase
git pull --rebase origin main
```

### Create New Branch

```bash
# Create and switch to new branch
git checkout -b feature/new-feature

# Push branch to GitHub
git push -u origin feature/new-feature
```

### Merge Branch

```bash
# Switch to main
git checkout main

# Merge feature branch
git merge feature/new-feature

# Push
git push
```

## 🔧 Common Tasks

### Remove File from Git (but keep locally)

```bash
# If you accidentally committed supabase_config.dart
git rm --cached lib/core/config/supabase_config.dart
git commit -m "chore: remove credentials from repo"
git push
```

### Undo Last Commit (not pushed yet)

```bash
# Keep changes
git reset --soft HEAD~1

# Discard changes
git reset --hard HEAD~1
```

### View Commit History

```bash
# Simple view
git log --oneline

# Detailed view
git log

# With graph
git log --graph --oneline --all
```

### Check Remote URL

```bash
git remote -v
```

### Change Remote URL

```bash
git remote set-url origin https://github.com/NEW_USERNAME/rekty_anjany.git
```

## 🚨 Emergency: Accidentally Committed Secrets

If you committed `supabase_config.dart` or secrets:

### Method 1: Remove from Last Commit

```bash
# Remove file
git rm --cached lib/core/config/supabase_config.dart

# Amend commit
git commit --amend -m "feat: initial commit (removed secrets)"

# Force push (⚠️ only if you haven't shared the commit)
git push --force
```

### Method 2: Create New Commit

```bash
# Remove file
git rm --cached lib/core/config/supabase_config.dart

# Commit removal
git commit -m "chore: remove credentials from repo"

# Push
git push
```

### Method 3: Rotate Credentials

If secrets already pushed:

1. **IMMEDIATELY** rotate your credentials in Supabase:
   - Go to Supabase Dashboard → Settings → API
   - Generate new keys
   - Update local `supabase_config.dart`
   
2. Remove from repo:
   ```bash
   git rm --cached lib/core/config/supabase_config.dart
   git commit -m "chore: remove old credentials"
   git push
   ```

3. Update RLS policies if needed

## 📋 Complete Push Workflow

```bash
# 1. Check status
git status

# 2. Pull latest (if working with team)
git pull

# 3. Add files
git add .

# 4. VERIFY no secrets included
git status

# 5. Commit
git commit -m "feat: add new feature"

# 6. Push
git push

# 7. Verify on GitHub
# Open: https://github.com/YOUR_USERNAME/rekty_anjany
```

## 🏷️ Creating Releases

```bash
# Tag current commit
git tag -a v1.0.0 -m "Release version 1.0.0"

# Push tag
git push origin v1.0.0

# Or push all tags
git push --tags
```

## 🔍 Useful Git Commands

```bash
# Show changes
git diff

# Show changes for specific file
git diff lib/features/admin/dashboard/admin_dashboard_page.dart

# Show staged changes
git diff --staged

# Discard changes to file
git checkout -- filename

# Discard all changes
git checkout .

# Stash changes
git stash

# Apply stashed changes
git stash pop

# List stashes
git stash list
```

## 📊 GitHub Repository Setup

### After First Push

1. Go to: `https://github.com/YOUR_USERNAME/rekty_anjany`
2. Add description
3. Add topics: `flutter`, `dart`, `supabase`, `admin-panel`, `portfolio`
4. Enable Issues
5. Enable Discussions
6. Add README preview
7. Star your own repo! ⭐

### Repository Settings

**Settings → General:**
- ✅ Issues enabled
- ✅ Discussions enabled
- ❌ Wiki disabled (using markdown files)

**Settings → Security:**
- ✅ Dependabot alerts enabled
- ✅ Secret scanning enabled

## ⚡ Quick Commands

```bash
# Status
git status

# Add all
git add .

# Commit
git commit -m "your message"

# Push
git push

# Pull
git pull

# One-liner: add, commit, push
git add . && git commit -m "update" && git push
```

## 📞 Help

If stuck:

```bash
# Help for command
git help commit
git help push

# Or
git commit --help
```

---

**Remember:** Always check `git status` before committing! 🔍
