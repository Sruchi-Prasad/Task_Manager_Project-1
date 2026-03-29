# 📱 Flutter Task Management App (Flodo Assignment)

A premium, mobile-first task management application built using Flutter, with a strong focus on clean UI/UX, robust state management, and seamless local data persistence.

---

## 📦 Features Overview

* ✅ **Complete CRUD Support**: Create, Read, Update, and Delete tasks.
* 💾 **Local Persistence**: Powered by Hive for fast and reliable storage across sessions.
* 🔍 **Debounced Search with Highlighting** *(Stretch Goal)*: Real-time search with highlighted matching text.
* 🎯 **Status Filtering**: Filter tasks by To-Do, In Progress, and Done.
* 🔗 **Task Dependency Logic**: Blocked tasks remain disabled until the parent task is completed.
* 📝 **Draft Auto-Save**: Prevents data loss by restoring unsaved input.
* ⏳ **Premium Async UX**: Simulated 2-second delay with loading indicator and disabled actions.

---

## 🧠 Track Chosen

**Track B – Mobile Specialist**
(Flutter + Local Database using Hive)

---

## 🚀 Stretch Goal Implemented

* **Debounced Autocomplete Search with Real-Time Highlighting**

---

## 📋 Task Model

Each task includes the following fields:

* **Title**: Task name
* **Description**: Detailed information
* **Due Date**: Selected via date picker
* **Status**: `To-Do`, `In Progress`, or `Done`
* **Blocked By**: Optional dependency on another task
  👉 *A task remains disabled until the parent task is marked as Done*

---

## ✨ UI/UX Highlights

Designed with a premium and intuitive user experience:

* 📱 **Responsive Layout**: Works smoothly across devices
* 🔤 **Typography**: Clean and modern design using Roboto
* 🎨 **Visual Feedback**:

  * Blocked tasks are greyed out with reduced opacity
  * Active tasks are clearly distinguishable
* 🔍 **Search Highlighting**: Matching text dynamically highlighted
* ⏳ **Loading Experience**:

  * 2-second simulated delay
  * Loading indicator shown
  * Save button disabled to prevent duplicate actions

---

## 💾 Data Persistence

* **Hive Database**: Lightweight and fast NoSQL database
* **Type Safety**: Custom TypeAdapters for `Task` and `TaskStatus`
* **Draft Persistence**: Automatically saves in-progress task input and restores it on reopen

---

## 🛠️ Tech Stack

* Flutter
* Dart
* Provider (State Management)
* Hive (Local Database)
* Uuid (Unique IDs)
* Intl (Date Formatting)

---

## 🎥 Demo Video

👉 https://1drv.ms/v/c/F0EC80AB8EC79BC7/IQAGFHatWye9RqZcBA8VfHZUAXDjy-BCdN_YzW_M4gkDSOI?e=ANgKqJ

---

## ⚙️ Setup Instructions

1. Ensure Flutter is installed
2. Clone this repository
3. Run:

   ```
   flutter pub get
   flutter run
   ```

---

## 🤖 AI Usage & Challenges

This project was built with the assistance of AI tools.

* **Usage**: Used for initial structure, UI suggestions, and debugging guidance
* **Challenge Faced**: Incorrect Hive adapter implementation caused runtime errors during enum deserialization
* **Solution**: Manually debugged and fixed TypeAdapter registration in `main.dart` and `HiveService`
* **Optimization**: Improved debounce logic for better performance and memory safety

---

## 💡 Key Highlights

* Clean and scalable architecture using Provider
* Strong focus on UI/UX for better user experience
* Real-world problem solving (dependency logic, async handling)
