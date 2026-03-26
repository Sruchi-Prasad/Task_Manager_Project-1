# Flutter Task Management App (Track B)

A premium, localized task management application built as part of the Mobile Specialist track.

## Features

- **Task Management**: Full CRUD operations for tasks (Create, Read, Update, Delete).
- **Local Persistence**: Powered by **Hive** for fast, local storage that persists after app restarts.
- **State Management**: Implemented using **Provider** for clean architecture and reactive UI.
- **Advanced Filtering**: Filter tasks by status (To-Do, In Progress, Done).
- **Search with Debounce**: High-performance search with a 300ms debounce and dynamic text highlighting.
- **Blocked Task Logic**: Tasks can be "blocked" by other unfinished tasks. Blocked tasks are visually greyed out and interaction is disabled until the dependency is marked as "Done".
- **Draft Persistence**: Task creation forms persist data locally while typing, ensuring no work is lost if the screen is closed accidentally.
- **Simulated Network Delay**: Artificially simulated 2-second delay during save operations with a premium loading spinner to demonstrate UX handling of asynchronous tasks.

## Tech Stack

- **Flutter**: UI Framework.
- **Provider**: State Management.
- **Hive**: Local NoSQL Database.
- **Uuid**: Unique identifier generation.
- **Intl**: Date formatting.

## Setup Instructions

1.  Ensure Flutter is installed on your machine.
2.  Clone this repository or copy the files.
3.  Run `flutter pub get` to install dependencies.
4.  Run `flutter run` to start the application.

## Stretch Goal
- **Debounced Search + Highlight Text**: Implemented a timer-based debounce for search queries and a custom `RichText` widget to highlight matching terms within task titles.

## AI Usage
- Built with the assistance of **Antigravity** (Google DeepMind).
