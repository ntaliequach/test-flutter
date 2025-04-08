# 🍵 Matcha-Go

Matcha-Go is a Flutter app that helps users find nearby matcha cafes, explore online matcha brands, and save favorites — all powered by Google APIs and Firebase.

---

## 🎥 Demo

[![Watch the Demo](https://img.shields.io/badge/Watch%20Demo-Click%20Here-green?style=for-the-badge)](https://github.com/user-attachments/assets/0fe340d1-e292-49bc-addd-213dc2974894)

---

## 💡 What I Learned

- Used **pub.dev** to explore and integrate useful Flutter packages
- Displayed real-time location and map markers using **Google Maps**
- Saved user favorites locally with **shared_preferences**
- Built and deployed real APIs with **Firebase Cloud Functions (Python)**
- Scraped and served matcha brand search results with a custom **Flask API**
- Managed secure keys with **dotenv** and **Google Secret Manager**
- Handled async UI loading with **FutureBuilder** and stateful widgets
- Practiced end-to-end integration of frontend + backend using REST

---

## 🧰 Tech Stack

- **Flutter (Dart)** – frontend mobile app
- **Python + Flask** – custom backend
- **Firebase Cloud Functions** – real-time API for cafes
- **Google Maps & Custom Search APIs** – external data
- **Shared Preferences** – favorites storage
- **Google Secret Manager** – API key security

---

## 📁 Project Structure

```
/lib
  ├── matcha_shops.dart             # Nearby cafes, map view, favorites
  ├── matcha_brands.dart            # Search UI for online brands
  ├── services/
      ├── googleplaces.dart         # Cafe data via Google Maps API
      ├── matcha_brand_service.dart # Talks to Flask API

/functions
  ├── main.py                       # Firebase Function (real-time cafe data)
  ├── matcha_search_api.py         # Flask API for Google brand search
```

---

## 🚀 Future Ideas

- Deploy Flask to Cloud Run for public access
- Show Google Shopping star ratings (if API allows)
- Add user login to sync data across devices
- Polish UI and add motion transitions

---

## 👩‍💻 Built by Natalie
