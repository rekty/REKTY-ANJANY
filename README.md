# Rekty Anjany Portfolio

A modern, full-stack portfolio website built with Flutter and Supabase, featuring a complete admin panel for content management.

## 🌐 Live Demo

**Website:** https://rekty-anjany-5a2eb.web.app

## 🔗 Repository

**GitHub:** https://github.com/rekty/REKTY-ANJANY

---

# 📸 Screenshots

### 🏠 Home

<p align="center">
  <img src="assets/screenshots/home.png" alt="Home" width="100%">
</p>

---

### 🔐 Login

<p align="center">
  <img src="assets/screenshots/login.png" alt="Login" width="100%">
</p>

---

### 📱 Applications

<p align="center">
  <img src="assets/screenshots/apps.png" alt="Applications" width="100%">
</p>

---

### 📥 Downloads

<p align="center">
  <img src="assets/screenshots/downloads.png" alt="Downloads" width="100%">
</p>

---

### 🛒 Store

<p align="center">
  <img src="assets/screenshots/store.png" alt="Store" width="100%">
</p>

---

### 🖼️ Gallery

<p align="center">
  <img src="assets/screenshots/gallery.png" alt="Gallery" width="100%">
</p>

---

### 📝 Blog

<p align="center">
  <img src="assets/screenshots/blog.png" alt="Blog" width="100%">
</p>

---

### ⚙️ Admin Dashboard

<p align="center">
  <img src="assets/screenshots/admin-dashboard.png" alt="Admin Dashboard" width="100%">
</p>

---

### 📊 Admin Management

<p align="center">
  <img src="assets/screenshots/admin-management.png" alt="Admin Management" width="100%">
</p>

---

## ✨ Features

### Public Features

- 🏠 **Home** - Landing page with hero section
- 🤖 **AI Integration** - AI-powered features showcase
- 📱 **Apps** - Showcase of mobile/web applications
- 📥 **Downloads** - APK and resource downloads
- 🛒 **Store** - Digital products and tools
- 🖼️ **Gallery** - Project screenshots and designs
- 📝 **Blog** - Articles and tutorials
- 👤 **About** - Personal profile and skills
- 📧 **Contact** - Contact form and information

### Admin Panel Features

- 🔐 **Secure Authentication** - OAuth login (Google, GitHub, Facebook)
- 🛡️ **Role-Based Access Control** - Email-based admin verification
- 📊 **Dashboard** - Statistics and analytics
- ✏️ **Content Management** - Full CRUD for all content types
- 🖼️ **Image Upload** - Supabase Storage integration
- 📱 **Responsive Design** - Works on all devices

## 🛠️ Tech Stack
## 🛠️ Tech Stack

### Frontend

- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **go_router** - Declarative routing
- **http** - API communication

### Backend

- **Supabase** - Backend-as-a-Service
  - PostgreSQL Database
  - Row Level Security (RLS)
  - Authentication (OAuth)
  - Storage (File uploads)
  - RESTful API

### Hosting

- **Firebase Hosting** - Production deployment
- **GitHub** - Version control

---

# 🚀 Getting Started

## Prerequisites

- Flutter SDK (3.0 or higher)
- Dart SDK (3.0 or higher)
- Firebase CLI (optional)
- A Supabase account
- VS Code / Android Studio

---

## Installation

### 1. Clone Repository

```bash
git clone https://github.com/rekty/REKTY-ANJANY.git
cd REKTY-ANJANY
```

---

### 2. Install Dependencies

```bash
flutter pub get
```

---

### 3. Configure Supabase

Copy the example configuration file.

```bash
cp lib/core/config/supabase_config.dart.example lib/core/config/supabase_config.dart
```

Get your credentials from your Supabase Dashboard.

Update:

```dart
class SupabaseConfig {
  static const String supabaseUrl = "YOUR_SUPABASE_URL";
  static const String supabaseAnonKey = "YOUR_ANON_KEY";
}
```

---

### 4. Setup Database

Run your SQL schema inside Supabase SQL Editor.

```bash
# Run supabase_schema.sql
```

---

### 5. Configure OAuth (Optional)

Enable:

- Google
- GitHub
- Facebook

Redirect URL

Development

```
http://localhost:PORT/auth/callback
```

Production

```
https://YOUR_DOMAIN/auth/callback
```

---

### 6. Add Admin User

Insert administrator into

```
admin_users
```

Example

```sql
INSERT INTO admin_users (email, role)
VALUES ('your.email@example.com','super_admin');
```

---

# 💻 Development

Run development server

```bash
flutter run -d chrome
```

or

```bash
flutter run -d edge
```

---

# 📦 Build

### Flutter Web

```bash
flutter build web --release
```

### Android APK

```bash
flutter build apk --release
```

### Android App Bundle

```bash
flutter build appbundle --release
```

---

# 🚀 Deployment

### Firebase Hosting

```bash
firebase login

firebase init hosting

firebase deploy --only hosting
```

## 📁 Project Structure

## 📁 Project Structure

```text
lib/
├── app/
│   └── router.dart
├── core/
│   ├── config/
│   ├── constants/
│   ├── middleware/
│   └── services/
├── features/
│   ├── home/
│   ├── apps/
│   ├── downloads/
│   ├── store/
│   ├── gallery/
│   ├── blog/
│   ├── about/
│   ├── contact/
│   ├── auth/
│   ├── login/
│   └── admin/
└── shared/
    └── layout/
```

---

# 🗄️ Database Schema

The project uses the following tables in Supabase.

- `admin_users`
- `apps`
- `downloads`
- `products`
- `gallery_items`
- `blog_posts`
- `about_me`
- `contact_info`
- `contact_messages`
- `analytics`

See `supabase_schema.sql` for the complete database schema.

---

# 🔒 Security

## Protected Files

- ✅ Supabase credentials
- ✅ Environment variables (.env)
- ✅ Firebase configuration
- ✅ Admin email addresses
- ✅ OAuth client secrets

---

## Public Files

- ✅ Supabase Anon Key
- ✅ Firebase public configuration
- ✅ Database schema
- ✅ Flutter source code

---

## Row Level Security (RLS)

Every database table uses Row Level Security.

Permission overview

- Public Read Access
- Admin Write Access
- JWT Authentication
- Secure API Access

---

# 🎨 Customization

## Theme

Edit

```text
lib/core/constants/app_colors.dart
```

Example

```dart
class AppColors {
  static const primary = Color(0xFF54C5F8);
  static const background = Color(0xFF0B0E13);
}
```

---

## Content Management

All website content can be managed directly from the Admin Panel.

```
/admin
```

No manual source code editing is required after deployment.

---

# 📝 Environment Variables

Create a `.env` file (already ignored by Git).

```env
SUPABASE_URL=your_supabase_url

SUPABASE_ANON_KEY=your_anon_key
```

> **Note**
>
> This project currently uses
> `supabase_config.dart`
> instead of `.env` for easier Flutter integration.

---

# 📈 Features Overview

### Public Website

- Home
- Apps
- Downloads
- Store
- Gallery
- Blog
- About
- Contact
- AI Integration

### Admin Panel

- Dashboard
- Manage Apps
- Manage Downloads
- Manage Products
- Manage Gallery
- Manage Blog
- Manage About
- Manage Contact
- Manage Messages
- Authentication
- Image Upload
- Statistics

---

# ⚡ Performance

- Flutter Web
- Responsive Layout
- Firebase Hosting
- Supabase Backend
- Modern UI
- Clean Architecture
- Optimized Routing

---

## 🤝 Contributing
## 🤝 Contributing

Contributions are welcome!

If you'd like to contribute to this project:

1. Fork this repository.
2. Create a new feature branch.

```bash
git checkout -b feature/amazing-feature
```

3. Commit your changes.

```bash
git commit -m "Add amazing feature"
```

4. Push your branch.

```bash
git push origin feature/amazing-feature
```

5. Open a Pull Request.

---

# 📄 License

This project is licensed under the **MIT License**.

See the **LICENSE** file for more information.

---

# 👤 Author

## Rekty Anjany

Modern Flutter Developer

### 🌐 Website

https://rekty-anjany-5a2eb.web.app

### 💻 GitHub

https://github.com/rekty

### 📂 Repository

https://github.com/rekty/REKTY-ANJANY

### 📧 Email

rekty.anjany@gmail.com

---

# 🙏 Acknowledgments

Special thanks to

- Flutter Team
- Supabase Team
- Firebase Team
- Open Source Community

for providing amazing tools and services that make this project possible.

---

# 📞 Support

If you find a bug or have any suggestions, feel free to:

- Open an Issue
- Submit a Pull Request
- Contact via Email

Email

rekty.anjany@gmail.com

GitHub Issues

https://github.com/rekty/REKTY-ANJANY/issues

---

# 🔒 Security Notes

Before deploying to production:

- Never commit `supabase_config.dart`
- Never expose Service Role Keys
- Enable Row Level Security (RLS)
- Always use HTTPS
- Keep dependencies updated
- Store secrets securely
- Regularly back up your database

---

# ⭐ Support This Project

If you like this project, please consider giving it a ⭐ on GitHub.

It helps the project grow and motivates future development.

---

# 🚀 Roadmap

Future planned features:

- 🤖 AI Assistant
- 🌙 Dark / Light Theme
- 📱 Progressive Web App (PWA)
- 🔔 Push Notifications
- 🌍 Multi-language Support
- 📊 Advanced Analytics
- 📈 SEO Optimization
- ⚡ Performance Improvements

---

# ❤️ Made With

Flutter ❤️ Supabase ❤️ Firebase Hosting

---

<p align="center">

Developed with ❤️ by <b>Rekty Anjany</b>

© 2026 Rekty Anjany

</p>