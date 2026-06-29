# Rekty Anjany - Personal Portfolio & Admin Panel

A modern, responsive personal portfolio website built with Flutter Web, featuring a powerful admin panel for content management.

![Flutter](https://img.shields.io/badge/Flutter-3.32.8-blue)
![Dart](https://img.shields.io/badge/Dart-3.8.1-blue)
![Firebase](https://img.shields.io/badge/Firebase-Hosting-orange)
![Supabase](https://img.shields.io/badge/Supabase-Auth%20%26%20Database-green)

## ✨ Features

### 🌐 Public Website
- **Modern UI/UX** - Glassmorphism design with mesh gradient backgrounds
- **Responsive Design** - Works seamlessly on desktop, tablet, and mobile
- **Multiple Sections**:
  - Home - Hero section with profile card
  - Apps - Showcase of applications
  - Downloads - File downloads with version tracking
  - Store - Digital products marketplace
  - Gallery - Image portfolio
  - Blog - Articles and posts
  - About - Personal information
  - Contact - Contact form and information
- **AI Chat** - Integrated AI assistant powered by Cloudflare Workers
- **Authentication** - OAuth login (Google, GitHub, Facebook) via Supabase

### 🔐 Admin Panel
- **Secure Authentication** - OAuth-based admin access
- **Role-based Access Control** - Super admin and admin roles
- **Dashboard** - Statistics and quick actions
- **Content Management**:
  - ✅ Apps management (planned)
  - ✅ Downloads management (planned)
  - ✅ Products management (planned)
  - ✅ Gallery management (planned)
  - ✅ Blog posts management (planned)
  - ✅ About page editor (planned)
  - ✅ Contact messages viewer (planned)
  - ✅ Contact info editor (planned)

## 🚀 Tech Stack

- **Frontend**: Flutter Web
- **Backend**: Supabase (PostgreSQL database + Auth)
- **Hosting**: Firebase Hosting
- **AI**: Cloudflare Workers AI
- **State Management**: StatefulWidgets
- **Routing**: go_router
- **HTTP Client**: http package

## 📋 Prerequisites

- Flutter SDK 3.32.8 or higher
- Dart SDK 3.8.1 or higher
- Firebase CLI
- Supabase account
- Git

## 🛠️ Installation

### 1. Clone the repository

```bash
git clone https://github.com/your-username/rekty_anjany.git
cd rekty_anjany
```

### 2. Install dependencies

```bash
flutter pub get
```

### 3. Configure environment variables

Copy `.env.example` to `.env` and fill in your credentials:

```bash
cp .env.example .env
```

Edit `.env`:
```env
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your-supabase-anon-key
CLOUDFLARE_WORKERS_URL=https://your-worker.workers.dev/
```

### 4. Update Supabase Config

Edit `lib/core/config/supabase_config.dart` with your Supabase credentials.

### 5. Setup Supabase Database

Run the SQL scripts in `supabase_schema.sql` in your Supabase SQL Editor:

1. Create tables
2. Enable RLS (Row Level Security)
3. Create policies
4. Insert your admin email

### 6. Configure Firebase

- Install Firebase CLI: `npm install -g firebase-tools`
- Login: `firebase login`
- Initialize: `firebase init hosting`

### 7. Run development server

```bash
flutter run -d chrome
```

## 📦 Build & Deploy

### Build for production

```bash
flutter build web --release
```

### Deploy to Firebase

```bash
firebase deploy --only hosting
```

### Combined command

```bash
flutter build web --release && firebase deploy --only hosting
```

## 🗂️ Project Structure

```
lib/
├── app/                    # App configuration
│   ├── app.dart           # Main app widget
│   ├── router.dart        # Route configuration
│   └── theme.dart         # Theme configuration
├── core/                   # Core utilities
│   ├── config/            # Configuration files
│   ├── constants/         # Constants (colors, spacing, etc.)
│   ├── middleware/        # Middleware (auth guards)
│   ├── services/          # Services (auth, admin, etc.)
│   └── utils/             # Utility functions
├── features/              # Feature modules
│   ├── admin/            # Admin panel
│   ├── about/            # About page
│   ├── ai/               # AI chat
│   ├── apps/             # Apps showcase
│   ├── auth/             # Authentication
│   ├── blog/             # Blog
│   ├── contact/          # Contact
│   ├── downloads/        # Downloads
│   ├── gallery/          # Gallery
│   ├── home/             # Home page
│   ├── login/            # Login page
│   └── store/            # Store
├── shared/                # Shared widgets
│   └── widgets/          # Reusable widgets
└── main.dart              # Entry point
```

## 🔒 Security

- **Environment Variables**: Sensitive data stored in `.env` (not committed to Git)
- **Row Level Security**: Supabase RLS policies protect database
- **OAuth Authentication**: Secure login via trusted providers
- **Admin Access Control**: Role-based permissions
- **HTTPS Only**: All traffic encrypted

## 📝 Database Schema

The application uses Supabase PostgreSQL with the following tables:

- `admin_users` - Admin user accounts
- `apps` - Application showcase items
- `downloads` - Downloadable files
- `products` - Store products
- `gallery_items` - Gallery images
- `blog_posts` - Blog articles
- `about_me` - About page content
- `contact_info` - Contact information
- `contact_messages` - Contact form submissions

See `supabase_schema.sql` for complete schema.

## 🎨 Customization

### Colors

Edit `lib/core/constants/app_colors.dart` to customize the color scheme.

### Spacing

Edit `lib/core/constants/app_spacing.dart` to adjust spacing values.

### Fonts

The app uses system fonts by default. To add custom fonts, edit `pubspec.yaml`.

## 🐛 Known Issues

- Font warning for Noto fonts (cosmetic, doesn't affect functionality)
- Admin panel content management forms are in development

## 🚧 Roadmap

- [ ] Complete admin panel CRUD forms
- [ ] File upload functionality
- [ ] Rich text editor for blog
- [ ] Email notifications for contact form
- [ ] Analytics dashboard
- [ ] Multi-language support
- [ ] Dark/Light theme toggle

## 📄 License

This project is private and not licensed for public use.

## 👤 Author

**Rekty Anjany**
- Website: [rekty-anjany-5a2eb.web.app](https://rekty-anjany-5a2eb.web.app)
- Developer & Creator

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for backend infrastructure
- Firebase for hosting
- Cloudflare for AI capabilities

---

**Note**: This is a personal portfolio project. Please do not use without permission.
