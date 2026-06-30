# Rekty Anjany Portfolio

A modern, full-stack portfolio website built with Flutter and Supabase, featuring a complete admin panel for content management.

## 🌐 Live Demo

**Public Website:** [https://rekty-anjany-5a2eb.web.app](https://rekty-anjany-5a2eb.web.app)

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

## 🚀 Getting Started

### Prerequisites

- [Flutter SDK](https://flutter.dev/docs/get-started/install) (3.0 or higher)
- [Dart SDK](https://dart.dev/get-dart) (3.0 or higher)
- [Firebase CLI](https://firebase.google.com/docs/cli) (optional, for deployment)
- A [Supabase](https://supabase.com) account
- A code editor (VS Code, Android Studio, etc.)

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/rekty_anjany.git
   cd rekty_anjany
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Configure Supabase**
   
   a. Copy the example config file:
   ```bash
   cp lib/core/config/supabase_config.dart.example lib/core/config/supabase_config.dart
   ```
   
   b. Get your Supabase credentials from [https://app.supabase.com](https://app.supabase.com):
      - Project URL
      - Anon/Public Key
   
   c. Update `lib/core/config/supabase_config.dart`:
   ```dart
   class SupabaseConfig {
     static const String supabaseUrl = 'YOUR_SUPABASE_URL';
     static const String supabaseAnonKey = 'YOUR_ANON_KEY';
   }
   ```

4. **Set up Supabase Database**
   
   Run the SQL schema in your Supabase SQL Editor:
   ```bash
   # Copy content from supabase_schema.sql and run in Supabase SQL Editor
   ```

5. **Configure OAuth Providers** (Optional)
   
   In Supabase Dashboard → Authentication → Providers:
   - Enable Google, GitHub, Facebook
   - Add redirect URLs:
     - Development: `http://localhost:PORT/auth/callback`
     - Production: `https://YOUR_DOMAIN/auth/callback`

6. **Add Admin Users**
   
   In Supabase → Table Editor → `admin_users`:
   - Insert your email with role `super_admin`
   
   Example:
   ```sql
   INSERT INTO admin_users (email, role)
   VALUES ('your.email@example.com', 'super_admin');
   ```

### Development

Run the app in development mode:

```bash
flutter run -d chrome
# or
flutter run -d edge
```

### Build for Production

**Web:**
```bash
flutter build web --release
```

**Android APK:**
```bash
flutter build apk --release
```

**Android App Bundle:**
```bash
flutter build appbundle --release
```

### Deployment

**Firebase Hosting:**
```bash
firebase login
firebase init hosting
firebase deploy --only hosting
```

## 📁 Project Structure

```
lib/
├── app/                    # App configuration
│   └── router.dart        # Route definitions
├── core/
│   ├── config/            # Configuration files
│   ├── constants/         # App constants
│   ├── middleware/        # Route guards
│   └── services/          # API services
├── features/              # Feature modules
│   ├── home/             # Home page
│   ├── apps/             # Apps showcase
│   ├── downloads/        # Downloads page
│   ├── store/            # Store page
│   ├── gallery/          # Gallery page
│   ├── blog/             # Blog page
│   ├── about/            # About page
│   ├── contact/          # Contact page
│   ├── auth/             # Authentication
│   ├── login/            # Login page
│   └── admin/            # Admin panel
└── shared/               # Shared widgets
    └── layout/           # Layout components
```

## 🗄️ Database Schema

The project uses the following tables in Supabase:

- `admin_users` - Admin user management
- `apps` - Application showcase
- `downloads` - Downloadable resources
- `products` - Store products
- `gallery_items` - Gallery images
- `blog_posts` - Blog articles
- `about_me` - About page content
- `contact_info` - Contact information
- `contact_messages` - Contact form submissions
- `analytics` - Usage analytics

See `supabase_schema.sql` for full schema definition.

## 🔒 Security

### What's Protected

- ✅ Supabase credentials (via `.gitignore`)
- ✅ Environment variables (`.env` files)
- ✅ Firebase config (`.firebase/`)
- ✅ Admin email addresses (not in code)
- ✅ OAuth client secrets (in Supabase dashboard)

### What's Public

- ✅ Supabase Anon Key (safe for client-side)
- ✅ Firebase public config
- ✅ Database schema
- ✅ Frontend code

### Row Level Security (RLS)

All tables have RLS enabled:
- **Public read** access for content
- **Admin write** access (verified via JWT)

## 🎨 Customization

### Theme Colors

Edit `lib/core/constants/app_colors.dart`:
```dart
class AppColors {
  static const primary = Color(0xFF54C5F8);
  static const background = Color(0xFF0B0E13);
  // ... more colors
}
```

### Content

All content can be managed through the admin panel at `/admin`.

## 📝 Environment Variables

Create `.env` file (already in `.gitignore`):

```env
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
```

**Note:** This project uses a Dart config file instead of `.env` for simplicity.

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👤 Author

**Rekty Anjany**

- Website: [https://rekty-anjany-5a2eb.web.app](https://rekty-anjany-5a2eb.web.app)
- Email: rekty.anjany@gmail.com
- GitHub: [@YOUR_GITHUB_USERNAME](https://github.com/YOUR_GITHUB_USERNAME)

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Supabase for the backend infrastructure
- Firebase for hosting services
- All open-source contributors

## 📞 Support

For support, email rekty.anjany@gmail.com or open an issue on GitHub.

---

**⚠️ Important Security Notes:**

1. Never commit `supabase_config.dart` to version control
2. Keep your Supabase Service Role key secret (only use Anon key in client)
3. Configure RLS policies properly before going to production
4. Use HTTPS in production
5. Regularly update dependencies for security patches

---

Made with ❤️ using Flutter & Supabase
