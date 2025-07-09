# Daily Goals App

A beautiful iOS app for tracking daily goals and achievements with Firebase authentication and real-time synchronization.

## Features

### 🔐 Authentication
- **Email/Password Login**: Secure authentication using Firebase Auth
- **User Registration**: Easy sign-up process with email validation
- **Error Handling**: Clear error messages for wrong passwords, unregistered emails, etc.
- **Session Management**: Automatic login state persistence

### 🎯 Goal Management
- **Add Goals**: Create new daily goals with a simple interface
- **Toggle Completion**: Check off completed goals with smooth animations
- **Delete Goals**: Swipe to delete unwanted goals
- **Real-time Sync**: Goals sync across devices using Firebase Firestore
- **Visual Feedback**: Beautiful UI with completion states and animations

### 📱 User Experience
- **Modern UI**: Clean, intuitive interface with iOS design guidelines
- **Loading States**: Smooth loading indicators during operations
- **Empty States**: Helpful messages when no goals exist
- **Responsive Design**: Works on all iPhone sizes

### 🔔 Daily Notifications
- **Daily Reminder**: Notification at 23:59 every day for goal review
- **Progress Summary**: Daily wrap-up with completion statistics
- **Background Processing**: Automatic daily summary generation

## Technical Stack

- **Frontend**: SwiftUI
- **Backend**: Firebase
- **Authentication**: Firebase Auth
- **Database**: Firestore
- **Notifications**: UserNotifications framework
- **Background Tasks**: BackgroundTasks framework

## Setup Instructions

1. **Firebase Setup**:
   - Create a Firebase project
   - Enable Authentication (Email/Password)
   - Enable Firestore Database
   - Download `GoogleService-Info.plist` and add to project

2. **iOS Configuration**:
   - Add background modes capability for background tasks
   - Request notification permissions
   - Configure background task identifier in Info.plist

3. **Build & Run**:
   - Open `Daily.xcodeproj` in Xcode
   - Select your target device
   - Build and run the app

## App Structure

```
Daily/
├── Authentication/
│   ├── LoginView.swift          # Login interface
│   ├── SignUpView.swift         # Registration interface
│   └── AuthService.swift        # Authentication logic
├── Goals/
│   ├── GoalListView.swift       # Main goals interface
│   ├── GoalRow.swift           # Individual goal display
│   ├── Goal.swift              # Goal data model
│   └── GoalsService.swift      # Goals business logic
├── Notifications/
│   ├── DailyReviewWorker.swift # Daily summary generation
│   └── AppDelegate.swift       # App lifecycle & notifications
└── App/
    └── DailyApp.swift          # Main app entry point
```

## Key Features Implementation

### Authentication Flow
- App starts with login screen if user not authenticated
- Sign up button navigates to registration
- Proper error handling for all auth scenarios
- Automatic navigation to goals screen after successful login

### Goal Management
- Real-time Firestore listener for goal updates
- Add goals with validation
- Toggle completion with visual feedback
- Swipe-to-delete functionality
- Daily goal organization by date

### Daily Notifications
- Scheduled daily reminder at 23:59
- Background task for summary generation
- Progress statistics in notifications
- Automatic rescheduling of background tasks

## Future Enhancements

- [ ] Goal categories/tags
- [ ] Goal streaks and statistics
- [ ] Social sharing of achievements
- [ ] Goal templates
- [ ] Offline support
- [ ] Dark mode support
- [ ] Widget support

## Requirements

- iOS 15.0+
- Xcode 13.0+
- Swift 5.5+
- Firebase account

## License

This project is for educational purposes. 