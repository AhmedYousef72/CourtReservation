# SportReserve 🏀⚽🎾

A comprehensive Flutter application for booking and managing sports courts and facilities. Users can browse available courts, make reservations, and manage their bookings with an intuitive and modern interface.

## 📱 Features

### ✅ Completed Features
- **Authentication System**
  - User login and registration
  - Firebase Authentication integration
  - Secure user session management

- **Court Management**
  - Browse available sports courts
  - View detailed court information (pricing, amenities, ratings)
  - Filter courts by sport type and availability
  - Real-time data from Firebase Firestore

- **User Interface**
  - Modern, responsive design
  - Dark/Light theme support
  - Intuitive navigation with bottom tab bar
  - Custom widgets and components

- **Court Booking System**
  - View court details and pricing
  - Check availability
  - User-friendly booking interface

- **Profile Management**
  - User profile screen
  - Account information management

### 🚧 In Development
- Reservation confirmation and management
- Payment integration
- Push notifications
- Advanced filtering and search

## 🏗️ Architecture

The app follows **Clean Architecture** principles with **BLoC** state management:

```
lib/
├── core/                          # Core utilities and shared components
│   ├── helpers/                   # Helper functions (responsive design)
│   ├── theme/                     # App themes and styling
│   └── widgets/                   # Reusable UI components
├── data/                          # Data layer
│   ├── datasources/              # Remote data sources
│   │   ├── firebase/             # Firebase-specific implementations
│   │   ├── auth_remote_datasource.dart
│   │   └── court_remote_datasource.dart
│   ├── models/                   # Data models
│   │   ├── court.dart            # Court model
│   │   ├── user.dart             # User model
│   │   └── reservation_model.dart # Reservation model
│   └── repositories/             # Repository implementations
├── logic/                        # Business logic (BLoC)
│   ├── authentication/           # Auth state management
│   ├── court/                    # Court-related logic
│   ├── navigation/               # Navigation state
│   ├── profile/                  # Profile management
│   └── reservation/              # Booking logic
└── presentation/                 # UI layer
    ├── screens/                  # App screens
    │   ├── auth/                 # Login & signup screens
    │   ├── booking_detail/       # Booking details
    │   ├── courts/               # Court listing
    │   ├── home/                 # Home screen with navigation
    │   ├── item_detail/          # Court detail screen
    │   ├── onboarding/           # App introduction
    │   ├── profile/              # User profile
    │   ├── reservation/          # Reservation management
    │   └── splash/               # Splash screen
    └── widgets/                  # Screen-specific widgets
```

## 🛠️ Tech Stack

- **Framework**: Flutter 3.x
- **Language**: Dart
- **State Management**: BLoC (flutter_bloc)
- **Backend**: Firebase
  - Firebase Authentication
  - Cloud Firestore (Database)
- **UI**: Material Design with custom theming
- **Architecture**: Clean Architecture + BLoC Pattern

## 🔧 Dependencies

### Main Dependencies
```yaml
dependencies:
  flutter:
    sdk: flutter
  flutter_bloc: ^8.1.3           # State management
  firebase_core: ^2.24.2         # Firebase core
  firebase_auth: ^4.15.3         # Authentication
  cloud_firestore: ^4.13.6       # Database
  equatable: ^2.0.5              # Value equality
```

### Dev Dependencies
```yaml
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

## 🚀 Getting Started

### Prerequisites
- Flutter SDK (3.0 or higher)
- Dart SDK
- Firebase CLI
- Android Studio / VS Code
- Git

### Installation

1. **Clone the repository**
```bash
git clone https://github.com/ahmedyousef/sportreserve.git
cd sportreserve
```

2. **Install dependencies**
```bash
flutter pub get
```

3. **Firebase Setup**
   - Create a new Firebase project at [Firebase Console](https://console.firebase.google.com)
   - Enable Authentication and Firestore Database
   - Download configuration files:
     - `google-services.json` for Android → `android/app/`
     - `GoogleService-Info.plist` for iOS → `ios/Runner/`
   - Generate `firebase_options.dart`:
   ```bash
   flutterfire configure
   ```

4. **Configure Firestore Security Rules**
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    match /{document=**} {
      allow read, write: if request.auth != null; // Authenticated users only
    }
  }
}
```

5. **Run the app**
```bash
flutter run
```

## 🎯 App Screens

### Authentication Flow
- **Splash Screen**: App loading and initialization
- **Onboarding**: Feature introduction for new users
- **Login/Signup**: User authentication

### Main App Flow
- **Home Screen**: Central hub with navigation tabs
  - Catalog: Browse available courts
  - Favorites: Saved courts
  - Reserves: User's bookings
  - Profile: Account management
- **Court Detail**: Detailed information about specific courts
- **Booking**: Court reservation interface
- **Profile**: User account management

## 📊 Sample Data

The app initializes with sample court data including:
- **Court Juan**: Multi-sport facility ($5.00/hour)
- **P. Carolina**: Free public park courts
- **Court Zzz**: Professional tennis courts ($8.00/hour)
- **Elite Sports Center**: Premium indoor facility ($12.00/hour)
- And 6 more diverse court options

Each court includes:
- Name and location
- Pricing information
- Amenities (parking, lighting, facilities)
- Sport types supported
- Availability status

## 🎨 UI/UX Features

- **Responsive Design**: Adapts to different screen sizes
- **Modern Interface**: Clean, intuitive Material Design
- **Theme Support**: Light and dark mode compatibility
- **Custom Components**: Reusable UI elements
- **Smooth Navigation**: Bottom tab navigation with state management

## 🔒 Security

- Firebase Authentication for secure user management
- Firestore security rules to protect user data
- Sensitive configuration files excluded from version control
- Input validation and error handling

## 🚀 Future Enhancements

- [ ] Real-time booking notifications
- [ ] Payment gateway integration
- [ ] Court owner dashboard
- [ ] Advanced search and filters
- [ ] Social features (reviews, sharing)
- [ ] Calendar integration
- [ ] Map view for court locations
- [ ] Offline support

## 🤝 Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 👥 Team

- **Ahmed Yousef** - Lead Developer & Full-Stack Flutter Developer


**SportReserve** - Making sports facility booking simple and accessible for everyone! 🏆