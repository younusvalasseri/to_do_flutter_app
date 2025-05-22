# 📝 To-Do Flutter App

A modern and efficient task management application built with Flutter, leveraging Riverpod for state management and Firebase Firestore for data persistence. This app enables users to create, edit, and organize tasks with subtasks, assign responsibilities, set due dates, and prioritize important tasks.

## 🚀 Features

* **Task Management**: Create, edit, and delete tasks with ease.
* **Subtasks**: Break down tasks into manageable subtasks.
* **Assignment**: Assign tasks to individuals or team members.
* **Due Dates**: Set and modify due dates for tasks.
* **Priority Marking**: Highlight important tasks for quick reference.
* **Search Functionality**: Quickly find tasks using the search bar.
* **Filtering**: Filter tasks based on status—All, Completed, Pending, or Important.
* **Responsive UI**: Clean and intuitive user interface adaptable to various screen sizes.

## 📸 Screenshots

*Include relevant screenshots here to showcase the app's interface and features.*

## 🛠️ Getting Started

Follow these instructions to set up and run the project locally.

### Prerequisites

* [Flutter SDK](https://flutter.dev/docs/get-started/install)
* [Firebase Account](https://firebase.google.com/)
* A device or emulator to run the application

### Installation

1. **Clone the repository:**

   ```bash
   git clone https://github.com/younusvalasseri/to_do_flutter_app.git
   cd to_do_flutter_app
   ```

2. **Install dependencies:**

   ```bash
   flutter pub get
   ```

3. **Set up Firebase:**

   * Create a new project in the [Firebase Console](https://console.firebase.google.com/).
   * Add an Android/iOS app to your Firebase project.
   * Download the `google-services.json` (for Android) or `GoogleService-Info.plist` (for iOS) and place it in the respective directory:

     * Android: `android/app/`
     * iOS: `ios/Runner/`
   * Enable Firestore in the Firebase Console.

4. **Run the application:**

   ```bash
   flutter run
   ```

## 📂 Project Structure

```
lib/
├── core/
│   └── utils/
│       └── validators.dart
├── data/
│   ├── models/
│   │   ├── subtask_model.dart
│   │   └── task_model.dart
│   └── services/
│       └── firestore_service.dart
├── presentation/
│   ├── screens/
│   │   ├── add_edit_task_screen.dart
│   │   └── task_list_screen.dart
│   └── widgets/
│       ├── search_bar.dart
│       └── stats_section.dart
└── main.dart
```

## 📦 Dependencies

* [cloud\_firestore](https://pub.dev/packages/cloud_firestore)
* [flutter\_riverpod](https://pub.dev/packages/flutter_riverpod)
* [intl](https://pub.dev/packages/intl)
* [flutter](https://flutter.dev/)

*Ensure all dependencies are listed in your `pubspec.yaml` file.*

## 📈 Roadmap

* [ ] Implement user authentication
* [ ] Add notification reminders for tasks
* [ ] Integrate calendar view for tasks
* [ ] Enable task sharing with collaborators
* [ ] Develop a web version of the application

## 🤝 Contributing

Contributions are welcome! Please follow these steps:

1. **Fork the repository**

2. **Create a new branch:**

   ```bash
   git checkout -b feature/YourFeatureName
   ```

3. **Commit your changes:**

   ```bash
   git commit -m 'Add some feature'
   ```

4. **Push to the branch:**

   ```bash
   git push origin feature/YourFeatureName
   ```

5. **Open a pull request**

Please ensure your code adheres to the existing style guidelines and passes all tests.


## 📬 Contact

For any inquiries or feedback, please contact [younusvalasseri](mailto:younusv@gmail.com).
