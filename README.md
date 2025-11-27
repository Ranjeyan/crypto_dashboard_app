# 📊 Crypto Price Dashboard

A professional Flutter application that displays real-time cryptocurrency prices with interactive TradingView charts, built using GetX for state management, dependency injection, and routing.

![Flutter](https://img.shields.io/badge/Flutter-3.0+-02569B?style=flat&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=flat&logo=dart)
![GetX](https://img.shields.io/badge/GetX-4.6.6-8B5CF6?style=flat)

## 📱 Demo


 

https://github.com/user-attachments/assets/36a1a6f2-2164-41ee-8695-5e87421327f8



### Dashboard Screen
- Displays top 20 cryptocurrencies by market cap
- Real-time price updates
- 24h price change indicators
- Pull-to-refresh functionality

### Detail Screen
- Cryptocurrency details with current price
- Interactive TradingView chart
- 24h High/Low statistics
- Market cap information

## ✨ Features

### Core Features
- ✅ **Real-time Cryptocurrency Data** - Fetches live data from CoinGecko API
- ✅ AI-Powered Chatbot - Gemini AI integration for crypto insights and queries
- ✅ **Interactive TradingView Charts** - Professional trading charts with technical analysis tools
- ✅ **Multi-Screen Navigation** - Smooth routing between dashboard and detail screens
- ✅ **Price Tracking** - Monitor 24h price changes and percentage movements
- ✅ **Pull-to-Refresh** - Update data with a simple swipe gesture
- ✅ **Dark Theme UI** - Modern, eye-friendly design

### Technical Features
- ✅ **GetX State Management** - Reactive state management with minimal boilerplate
- ✅ **GetX Dependency Injection** - Clean architecture with proper DI
- ✅ **GetX Routing** - Named route navigation
- ✅ **Clean Architecture** - Organized folder structure
- ✅ **API Integration** - RESTful API calls to CoinGecko
- ✅ **Error Handling** - Graceful error management and user feedback
- ✅ **Responsive Design** - Adapts to different screen sizes
- ✅ Lottie Animations - Smooth and engaging UI animations

## 🏗️ Architecture

This project follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── main.dart                          # Application entry point
├── core/
│   ├── constants/
│   │   └── api_constants.dart         # API endpoints and URLs
│   ├── themes/
│   │   └── app_theme.dart             # Application theming
│   └── utils/
│       └── responsive.dart            # Responsive layout utilities
├── data/
│   ├── models/
│   │   ├── crypto_data.dart           # Cryptocurrency data model
│   │   ├── chart_data.dart            # Chart data model
│   │   └── chat_message.dart          # Chat message model
│   └── providers/
│       └── crypto_api_provider.dart   # API service layer
├── services/
│   └── gemini_services.dart           # Gemini AI service
├── controllers/
│   ├── crypto_controller.dart         # GetX controller (Business logic)
│   └── chatbot_controller.dart        # Chatbot controller
├── views/
│   ├── dashboard/
│   │   ├── dashboard_screen.dart      # Main dashboard UI
│   │   └── widgets/
│   │       └── crypto_card.dart       # Cryptocurrency card widget
│   ├── detail/
│   │   ├── crypto_detail_screen.dart  # Detail screen UI
│   │   └── widgets/
│   │       ├── price_chart.dart       # TradingView chart widget
│   │       └── stat_row.dart          # Statistics row widget
│   └── chatbot/
│       └── chatbot_screen.dart        # Chatbot screen UI
└── routes/
    └── app_routes.dart                # Route definitions
```

### Architecture Layers

1. **Presentation Layer** (`views/`)
   - UI components and screens
   - Widgets for reusable UI elements

2. **Business Logic Layer** (`controllers/`)
   - GetX controllers managing state
   - Business logic and data manipulation

3. **Data Layer** (`data/`)
   - Models for data structures
   - API providers for network calls

4. **Core Layer** (`core/`)
   - Constants and configurations
   - Themes and styling
   - Utility functions

 5. **Service Layer** (`services/`)
   - Constants and configurations
   - Themes and styling
 

## 🚀 Getting Started


### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/yourusername/crypto_dashboard.git
   cd crypto_dashboard
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the app**
   ```bash
   flutter run
   ```

### Platform-Specific Setup

#### Android
Add internet permission in `android/app/src/main/AndroidManifest.xml`:
```xml
<manifest xmlns:android="http://schemas.android.com/apk/res/android">
    <uses-permission android:name="android.permission.INTERNET"/>
    <!-- Rest of your manifest -->
</manifest>
```

#### iOS
No additional setup required. Internet permissions are enabled by default.

## 📦 Dependencies

| Package | Version | Purpose |
|---------|---------|---------|
| `get` | ^4.7.3 | State management, DI, and routing |
| `http` | ^1.6.0 | HTTP requests to CoinGecko API |
| `webview_flutter` | ^4.13.0 | Embedding TradingView charts |
| `intl` | ^0.20.2 | Number and currency formatting |
| `lottie` | ^3.3.2 | Embedding Animations |

## 🔧 Configuration

### API Configuration

The app uses **CoinGecko's free public API** (no API key required):

- **Base URL**: `https://api.coingecko.com/api/v3`
- **Endpoints Used**:
  - `/coins/markets` - Fetch cryptocurrency list
  - `/coins/{id}/market_chart` - Fetch price history

All API configurations are centralized in `lib/core/constants/api_constants.dart`.

### TradingView Configuration

The TradingView widget is configured in `lib/views/detail/widgets/price_chart.dart`:
- Theme: Dark mode
- Interval: Daily (D)
- Style: Candlestick charts
- Timezone: UTC

## 🎯 Key Implementation Details

### 1. GetX State Management

```dart
// Reactive variables
var cryptoList = <CryptoData>[].obs;
var isLoading = false.obs;

// Observing changes in UI
Obx(() => cryptoList.isEmpty 
    ? CircularProgressIndicator() 
    : ListView.builder(...)
)
```

### 2. GetX Dependency Injection

```dart
// Registration (main.dart)
initialBinding: BindingsBuilder(() {
  Get.put(CryptoController());
}),

// Usage (any screen/widget)
final CryptoController controller = Get.find();
```

### 3. GetX Routing

```dart
// Route definition
GetPage(name: '/', page: () => DashboardScreen()),
GetPage(name: '/details', page: () => CryptoDetailScreen()),

// Navigation
Get.toNamed('/details');
```

### 4. API Integration

```dart
Future<List<CryptoData>> fetchCryptoList() async {
  final response = await http.get(Uri.parse(ApiConstants.getMarketsUrl()));
  if (response.statusCode == 200) {
    final List<dynamic> data = json.decode(response.body);
    return data.map((json) => CryptoData.fromJson(json)).toList();
  }
  throw Exception('Failed to load crypto data');
}
```

## 📱 Features Walkthrough

### Dashboard Screen
1. **Crypto List Display**
   - Shows top 20 cryptocurrencies
   - Displays icon, name, symbol, current price
   - Color-coded 24h price changes (green/red)

2. **Interactive Cards**
   - Tap any card to view detailed information
   - Smooth navigation to detail screen

3. **Refresh Mechanism**
   - Pull-down to refresh data
   - Refresh button in app bar
   - Automatic data loading on app start

### Detail Screen
1. **Price Information**
   - Large display of current price
   - 24h price change with amount and percentage
   - Cryptocurrency icon and name

2. **TradingView Chart**
   - Full-featured trading chart
   - Zoom, pan, and analyze
   - Multiple timeframe options
   - Technical indicators available

3. **Statistics**
   - 24h High price
   - 24h Low price
   - Market capitalization

