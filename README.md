# 🎬 TeldaMovieApp

A clean, modular iOS movie app built using UIKit + MVVM + Coordinator architecture — as part of Telda's iOS engineering challenge.

---

## 🛠️ Features

- 🔍 Search for movies (using The Movie DB API)
- 📆 Group movies by release year
- 📑 Movie details with overview, tagline, status, and revenue
- 🎭 Show similar movies, top actors, and top directors
- 📌 Watchlist management via `UserDefaults`
- 💡 Clean architecture: MVVM + Coordinators

---

## 📸 Screenshots

| Movie List | Detail View | Similar + Top Cast |
|------------|-------------|--------------------|


---

## 🧠 Architecture

- **UIKit** for all screens
- **SwiftUI** used inside UIKit with `UIHostingController` for custom cast tiles
- **MVVM** pattern for business logic and view separation
- **Coordinator** pattern for clean navigation

---

## 🧪 Tech Stack

- Swift 5
- UIKit + SwiftUI
- Combine (for SwiftUI image loader)
- TMDB API v3 (via API Key)
- `URLSession` for network requests

---

## ⚙️ Requirements

- iOS 14.0+
- Xcode 15+

---


📂 TeldaMovieApp
├── AppDelegate.swift
├── SceneDelegate.swift
├── Coordinators/
├── Models/
├── Network/
├── ViewModels/
├── Views/
│   ├── MovieList/
│   ├── MovieDetail/
├── Utils/
├── Resources/


✍️ Author
    •    Kareem El-Fadaly
    •    LinkedIn (https://www.linkedin.com/in/kareem-elfadaly)


📄 License
This project is provided as-is for technical assessment only.
