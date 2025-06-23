# Pokemon TCG iOS Interview Project

A comprehensive iOS interview project built with SwiftUI that tests real-world development skills through bug fixes, feature implementation, and architectural improvements.

## 🎯 Overview

This project simulates a real-world Pokemon card browsing app with intentionally planted bugs and incomplete features. Candidates will demonstrate their iOS development skills by:

- **Debugging** common SwiftUI and iOS issues
- **Implementing** new features and screens
- **Refactoring** code for better architecture
- **Optimizing** performance and user experience

## 🏗️ Architecture

**MVVM Pattern with SwiftUI**
- **Views**: SwiftUI views with proper state management
- **ViewModels**: ObservableObject classes handling business logic
- **Models**: Data structures for Pokemon cards and sets
- **Services**: Network layer with REST API integration
- **Extensions**: Custom color palette and utilities

## 🚀 Features

### Current Implementation
- ✅ Pokemon card browsing with search
- ✅ Detailed card view with stats and attacks
- ✅ Dark theme with custom color palette
- ✅ Network layer with Pokemon TCG API
- ✅ Error handling and loading states
- ✅ Modern SwiftUI architecture

### API Integration
- **Pokemon TCG API**: REST-based API for card data
- **Endpoints**: Cards, sets, search functionality
- **Response Models**: Structured data models
- **Error Handling**: Network error management

## 📱 Setup Instructions

### Prerequisites
- Xcode 15.0+
- iOS 18.4+ deployment target
- Internet connection for API calls

### Getting Started
1. Clone the repository
2. Open `PokemonTCG.xcodeproj` in Xcode
3. Build and run on simulator or device
4. Review `INTERVIEW_TASKS.md` for specific tasks

### Project Structure
```
PokemonTCG/
├── Views/           # SwiftUI views
├── ViewModels/      # Business logic
├── Models/          # Data structures
├── Networking/      # API layer
├── Extensions/      # Utilities
└── Resources/       # Assets, colors
```

### Pokemon TCG API
- [API Documentation](https://pokemontcg.io/)
- [API Examples](https://docs.pokemontcg.io/)

## 📄 License

This project is intended for educational and interview purposes. Pokemon TCG data is provided by the Pokemon TCG API and is subject to their terms of service.

---

**Happy Coding!** 🚀 