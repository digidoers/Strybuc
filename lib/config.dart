class AppConfig {
  static const String baseUrl = 'http://50.234.128.254:8080/distone/rest/service';
  static const String grantApiUrl = '$baseUrl/authorize/grant';
  static const String authApiUrl = '$baseUrl/customer/authenticate';
  static const String customerApiUrl = '$baseUrl/data/read';
}