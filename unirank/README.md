# UniRank 🎓

**UniRank** is a modern, Flutter-based social networking and ranking platform designed specifically for students. It connects students across colleges, gamifies academic and extracurricular engagement, and fosters a vibrant community through real-time interaction.

![Flutter](https://img.shields.io/badge/Flutter-%2302569B.svg?style=for-the-badge&logo=Flutter&logoColor=white)
![Dart](https://img.shields.io/badge/dart-%230175C2.svg?style=for-the-badge&logo=dart&logoColor=white)
![Supabase](https://img.shields.io/badge/Supabase-3ECF8E?style=for-the-badge&logo=supabase&logoColor=white)

## 🚀 Features

### 🌟 Core Experience
*   **Swipe Feed Discovery**: A Tinder-style card stack to discover and connect with other students based on their profiles, skills, and interests.
*   **Real-time Chat**: Instant messaging system with real-time updates, typing indicators, and a modern UI.
*   **Leaderboard & Ranking**: Gamified ranking system tracking student attendance, contributions, and engagement.

### 👤 User Profile
*   **Comprehensive Profiles**: Showcase academic details, skills, bio, and social links (GitHub, LeetCode, CodeForces).
*   **Activity Heatmap**: Visual representation of student contributions and activity over time.
*   **Edit & Customize**: Easy-to-use profile editing with avatar uploads.

### 🔔 Engagement
*   **Notifications**: Real-time alerts for new messages, matches, and interactions.
*   **Community Feed**: (Planned) A space for posts, updates, and college news.

## 🛠️ Tech Stack

*   **Frontend**: [Flutter](https://flutter.dev/) (Dart)
*   **Backend**: [Supabase](https://supabase.com/)
    *   **Authentication**: Secure email/password login and signup.
    *   **Database**: PostgreSQL with Row Level Security (RLS).
    *   **Realtime**: WebSocket subscriptions for chat and notifications.
    *   **Storage**: Media storage for profile pictures and posts.
*   **Key Packages**:
    *   `supabase_flutter`: Backend integration.
    *   `appinio_swiper`: Swipe card functionality.
    *   `image_picker`: Media selection.
    *   `google_fonts`: Typography.
    *   `flutter_svg`: Vector assets.

## 📂 Project Structure

```
lib/
├── main.dart             # Application entry point
├── theme.dart            # App-wide theme and color palette
├── env.dart              # Environment variables (Supabase keys)
├── models/               # Data models (Profile, Message, Notification, etc.)
├── services/             # Business logic and API calls (Auth, Chat, Swipe, etc.)
├── screens/              # UI Screens
│   ├── auth/             # Login & Signup screens
│   ├── profile/          # Profile & Edit Profile screens
│   ├── chat_list_screen.dart
│   ├── chat_room_screen.dart
│   ├── swipe_feed_screen.dart
│   ├── notification_screen.dart
│   └── ...
└── widgets/              # Reusable UI components
    ├── neon_navbar.dart  # Custom bottom navigation
    ├── swipe_card.dart   # Card widget for feed
    ├── empty_chat_view.dart
    └── ...
```

## ⚡ Getting Started

### Prerequisites
*   [Flutter SDK](https://docs.flutter.dev/get-started/install) installed.
*   A [Supabase](https://supabase.com/) project set up.

### Installation

1.  **Clone the repository**:
    ```bash
    git clone https://github.com/yourusername/unirank.git
    cd unirank
    ```

2.  **Install dependencies**:
    ```bash
    flutter pub get
    ```

3.  **Configure Environment**:
    *   Create a `lib/env.dart` file (if not present) or update existing keys.
    *   Add your Supabase URL and Anon Key:
        ```dart
        class Env {
          static const String supabaseUrl = 'YOUR_SUPABASE_URL';
          static const String supabaseAnonKey = 'YOUR_SUPABASE_ANON_KEY';
        }
        ```

4.  **Run the App**:
    ```bash
    flutter run
    ```

## 🗄️ Database Setup (Supabase)

This project uses Supabase for its backend. Ensure you have the following tables created:
*   `profiles`: Stores user data.
*   `conversations`: Manages chat threads.
*   `messages`: Stores individual chat messages.
*   `notifications`: User notifications.
*   `swipes`: Tracks user swipes and matches.
*   `posts`: User posts (for the feed).

*(Refer to the `sql/` directory or project documentation for schema definitions and RLS policies.)*

## 🤝 Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

1.  Fork the project
2.  Create your feature branch (`git checkout -b feature/AmazingFeature`)
3.  Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4.  Push to the branch (`git push origin feature/AmazingFeature`)
5.  Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
