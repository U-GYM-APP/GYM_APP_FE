class ApiConfig {
  static const bool useProduction = true; // 🔁 change to false for localhost

  static const String _localBaseUrl = "http://127.0.0.1:8000/api";
  static const String _productionBaseUrl = "https://gym-app-be.onrender.com/api";

  static String get baseUrl => useProduction ? _productionBaseUrl : _localBaseUrl;
}
