import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';

class ApiService {
  final String grantApiUrl = 'http://50.234.128.254:8080/distone/rest/service/authorize/grant';
  final String authApiUrl = 'http://50.234.128.254:8080/distone/rest/service/customer/authenticate';
  final int tokenExpirationDuration = 3600 * 1000; // 1 hour in milliseconds

  // Fetch access token from the grant API and store it in SharedPreferences
  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedToken = prefs.getString('access_token'); // Retrieve saved token
      int? savedTokenTimestamp = prefs.getInt('access_token_timestamp'); // Retrieve saved timestamp

      // Check if a valid access token is already saved and not expired
      /*if (savedToken != null && savedTokenTimestamp != null) {
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        if (currentTime - savedTokenTimestamp < tokenExpirationDuration) {
          // print("Token found in SharedPreferences and is valid.");
          return savedToken; // Return the saved token if it hasn't expired
        } else {
          // print("Token expired, fetching a new one.");
        }
      }*/

      // If no valid token, proceed to fetch a new one from the grant API
      final Map<String, String> queryParams = {
        'client': 'postmantest',
        'company': 'st',
        'username': 'api',
        'password': 'cRlUOK1H', // Replace with your real password
      };

      final Uri uri = Uri.parse(grantApiUrl).replace(queryParameters: queryParams);
      print('checkt $grantApiUrl');
      final response = await http.post(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded'}).timeout(
        const Duration(seconds: 120), // Set timeout duration for network request
        onTimeout: () {
          throw Exception("Request timed out while fetching access token");
        },
      );
      print('API Response: ${response.body}'); // Debugging
      print('api');
      if (response.body.isEmpty) {
        throw Exception('Empty response received from API.');
      }

      print('outside');
      // Handle the response from the grant API
      //if (response.statusCode == 200) {
      print('inside');
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final String accessToken = responseBody['access_token'];

      // Store the token and the current timestamp in SharedPreferences
      final currentTime = DateTime.now().millisecondsSinceEpoch;
     //prefs.setString('access_token', accessToken);
     //prefs.setInt('access_token_timestamp', currentTime);
      //print("Token saved to SharedPreferences: $accessToken");

      return accessToken;
      /*} else {
        throw Exception('Failed to retrieve access token: ${response.statusCode}');
      }*/
    } catch (e) {
      throw Exception('Error occurred while fetching access token: ${e.toString()}');
    }
  }

  // Authenticate user with login and password using the stored access token
  Future<Map<String, dynamic>> login(String login, String password) async {
    try {
      // Ensure you have the access token available
      final String? accessToken = await getAccessToken();

      // If no token is available, throw an error
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      // print("Using access token for login: $accessToken");

      // Prepare the login request parameters
      final Map<String, String> queryParams = {
        'login': login,
        'password': password,
      };

      // Build the URI for the authentication API call
      final Uri uri = Uri.parse(authApiUrl).replace(queryParameters: queryParams);
      print('check access token fetchrr');
      // Send the POST request to the authenticate API
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'authorization': accessToken,  // Use the stored access token for authorization
          'cache-control': 'no-cache',
        },
      ).timeout(
        const Duration(seconds: 20),  // Timeout for this request as well
        onTimeout: () {
          throw Exception("Request timed out during login");
        },
      );
      print('loginres: ${response.body}');
      print('access=: ${accessToken}');

      // Handle the response from the login API
      //if (response.statusCode == 200) {
        // Assuming the API returns a JSON response
        return json.decode(response.body);
     /* } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }*/
    } catch (e) {
      throw Exception('Error occurred during login: $e');
    }
  }
}
