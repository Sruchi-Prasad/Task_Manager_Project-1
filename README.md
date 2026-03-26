# Flutter Task Management App (Track B)

A premium, mobile-first task management application built with a focus on UI/UX excellence and robust state management. 

## 📦 Features Overview
- **Complete CRUD Support**: Create, Read, Update, and Delete tasks.
- **Local Persistence**: Powered by Hive for instant access across sessions.
- **Search with Debounce**: High-performance search with text highlighting.
- **Status Filtering**: Rapid organization by To-Do, In Progress, and Done.
- **Dependency Logic**: Visual blocking for unready tasks.
- **Draft Auto-Save**: Persistent form drafts to prevent data loss.
- **Premium Async UX**: 2s simulated loading states with interactive protection.

## 🧠 Architecture
The app follows a clean **separation of concerns** by leveraging the **Provider** pattern for state management. This ensures a highly scalable and maintainable codebase where business logic is decoupled from the UI layer.

## 📋 Task Model
Each task in the system is structured with the following exact specifications:
- **Title**: Descriptive name of the task.
- **Description**: Detailed context or sub-tasks.
- **Due Date**: Datepicker-integrated deadline.
- **Status**: Categorized as `To-Do`, `In Progress`, or `Done`.
- **Blocked By**: Optional dependency on another task (Logic: Task B remains disabled if Task A is not `Done`).

## ✨ UI/UX Highlights (Track B Focus)
Designed for a premium user experience with:
- **Responsive Layout**: Adapts seamlessly to different screen sizes.
- **Premium Typography**: Uses 'Roboto' for a clean, professional aesthetic.
- **Interactive Feedback**: 
  - **Greyed-out Blocked Tasks**: Visual lock icon and reduced opacity for blocked dependencies.
  - **Dynamic Highlighting**: Search results are highlighted in real-time within titles.
- **Loading UX**: 
  - **Asynchronous Handling**: Demonstrates professional loading states during 2s simulated delays.
  - **State Injection**: Save buttons are disabled during loading to prevent duplicate requests (no double-tap bugs).
  - **Material 3 Spinner**: High-quality loading indicators for immediate feedback.

## 💾 Technical Persistence
- **Hive Database**: Uses a lightweight NoSQL database for ultra-fast local storage.
- **Draft Persistence**: Task forms use **local state caching**. If a user starts typing and the app minimizes or closes, the draft is saved to Hive and automatically restored on the next open.
- **Adapter Registration**: Custom Hive TypeAdapters for the `Task` and `TaskStatus` models ensure type safety.

## 🛠️ Tech Stack
- **Flutter**: Framework.
- **Provider**: State Management.
- **Hive**: Local Persistence.
- **Uuid**: Unique IDs.
- **Intl**: Formatting.

## 🚀 Setup Instructions
1.  Ensure **Flutter** is installed.
2.  Clone this repository.
3.  Run `flutter pub get`.
4.  Run `flutter run` (or `flutter run -d edge` for web).

## 🤖 AI Usage & Challenges
This project was built with the assistance of **Antigravity** (Google DeepMind).
- **Initial Prompts**: used to generate the skeleton for Provider-based state management and Hive initialization.
- **The Challenge**: Initially, the AI suggested an incorrect Hive adapter setup which caused runtime errors when deserializing enum values.
- **The Fix**: Manually debugged the `TypeAdapter` logic and ensured all adapters were correctly registered in `main.dart` and `HiveService` before app launch.
- **Optimization**: Refined the high-frequency search debounce logic beyond the AI's initial basic timer suggestion to ensure memory safety.
