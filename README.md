# 🚩 iOS Challenge: World Flags Explorer

### Technical Challenge Overview
Stop building generic tutorials. It’s time for a real-world engineering task. This project is designed to test your ability to handle local data, dynamic asset scanning, and custom interactive UI components using **UIKit**.

This repository serves as a **Reference Solution** for the challenge described below.

---

## 🎯 The Challenge: Requirements

### 1. Data Management & Parsing
* **Dynamic Asset Discovery:** Do not hardcode image names. Use `FileManager` to programmatically scan the app bundle for all flag assets.
* **JSON Integration:** Parse a local `Countries.json` file to map ISO country codes (e.g., "US") to their full names (e.g., "United States").

### 2. Navigation & UI Layout
* **Architecture:** Use the **MVC** (Model-View-Controller) pattern.
* **Flow:** Implement a `UINavigationController` stack.
* **List View:** Create a main screen using `UITableViewController` with dynamic cell loading.
* **Visual Consistency:** All flags in the list must be normalized to a consistent size (e.g., 40x30 points) with rounded corners and a subtle border, regardless of the source image proportions.

### 3. Detail View & Interaction
* **Immersive View:** Create a detail screen that hides the navigation bar on tap to focus on the flag.
* **Pinch-to-Zoom:** Implement a `UIScrollView` that allows users to zoom in and out of the flag image.
* **System Sharing:** Add a native "Share" feature using `UIActivityViewController` to export the flag image and country name.

### 4. Game Module (Quiz)
* **Logic:** Build a "Guess the Flag" game where the user is given a country name and must choose from three random flags.
* **State Management:** Implement score tracking and a "Game Over" flow.
* **Tactile Feedback:** Add a custom "Bounce" animation using `CGAffineTransform` when a user taps a flag.

---

## 🛠 Tech Stack & Tools
* **Language:** Swift 5.0+
* **Framework:** UIKit (Storyboard + Programmatic Styling)
* **Key Classes:** `JSONDecoder`, `FileManager`, `UIGraphicsImageRenderer`, `CGAffineTransform`, `UIActivityViewController`.

---

## 💡 Reference Solution Features
In this implementation, I have prioritized:
* **Memory Management:** Efficient cell reuse and the use of `[weak self]` to prevent retain cycles.
* **Adaptive UI:** Support for Large Titles and standard navigation transitions.
* **Clean Code:** Separation of styling logic into a dedicated `Style` utility.

---

## 🚀 How to Run
1. Clone the repository.
2. Open `Challenge.xcodeproj`.
3. Ensure that the flag images and `Countries.json` are included in the **Target Membership**.
4. Run on a simulator (iPhone 13 or newer recommended).

---

**Think you can improve the architecture?** I’m looking for feedback! How would you handle the image rendering context differently? Let’s discuss!

