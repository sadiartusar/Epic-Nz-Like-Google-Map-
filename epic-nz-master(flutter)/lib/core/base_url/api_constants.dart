class ApiConstants {
  // static const String baseUrl = 'http://142.248.180.28:5000/api/v1/';
  // static const String baseUrl = 'http://127.0.0.1:5000/api/v1/';
  // static const String baseUrl = 'http://192.168.10.31:5000/api/v1/';
  static const String baseUrl = 'https://epic-nz-like-google-map.onrender.com/api/v1/';
  

  static Map<String, String> headers(String? token) {
    return {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
      'ngrok-skip-browser-warning': 'true',
      if (token != null && token.isNotEmpty) ...{
        'Authorization': 'Bearer $token',
        'Cookie': 'accessToken=$token',
      },
    };
  }

  static const String mapboxToken =
      'pk.eyJ1IjoiZXBpY256IiwiYSI6ImNta3V3ZW1lYjAwZHMzZnM4b3dpdnU4Y3MifQ.Ta0mlo_uy59ZbLLbkcQNcQ';

  // static const String socketBaseUrl = "http://142.248.180.28:5000";
  // static const String socketBaseUrl = "http://192.168.10.31:5000";
   static const String socketBaseUrl = "https://epic-nz-like-google-map.onrender.com";
    // static const String socketBaseUrl = "http://10.254.174.63:5000";
}
