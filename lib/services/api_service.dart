import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import 'package:strybuc/config.dart';

class ApiService {
  final String grantApiUrl = AppConfig.grantApiUrl;
  final String authApiUrl =  AppConfig.authApiUrl;
  final String customerApiUrl =  AppConfig.customerApiUrl;
  final int tokenExpirationDuration = 3600 * 1000; // 1 hour in milliseconds

  // Fetch access token from the grant API and store it in SharedPreferences
  Future<String?> getAccessToken() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? savedToken = prefs.getString('access_token'); // Retrieve saved token
      int? savedTokenTimestamp = prefs.getInt('access_token_timestamp'); // Retrieve saved timestamp

      // Check if a valid access token is already saved and not expired
      if (savedToken != null && savedTokenTimestamp != null) {
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        if (currentTime - savedTokenTimestamp < tokenExpirationDuration) {
         // print("Token found in SharedPreferences and is valid.");
          return savedToken; // Return the saved token if it hasn't expired
        } else {
          print("Token expired, fetching a new one.");
        }
      }

      // If no valid token, proceed to fetch a new one from the grant API
      final Map<String, String> queryParams = {
        'client': 'postmantest',
        'company': 'st',
        'username': 'api',
        'password': 'cRlUOK1H', // Replace with your real password
      };

      final Uri uri = Uri.parse(grantApiUrl).replace(queryParameters: queryParams);
      final response = await http.post(uri, headers: {'Content-Type': 'application/x-www-form-urlencoded'}).timeout(
        const Duration(seconds: 120), // Set timeout duration for network request
        onTimeout: () {
          throw Exception("Request timed out while fetching access token");
        },
      );
      print('API Response: ${response.body}'); // Debugging
      if (response.body.isEmpty) {
        throw Exception('Empty response received from API.');
      }

      // Handle the response from the grant API
      if (response.body.isNotEmpty) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String accessToken = responseBody['access_token'];
        // Store the token and the current timestamp in SharedPreferences
        final currentTime = DateTime.now().millisecondsSinceEpoch;
        prefs.setString('access_token', accessToken);
        prefs.setInt('access_token_timestamp', currentTime);
        return accessToken;
      } else {
        throw Exception('Failed to retrieve access token: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while fetching access token: ${e.toString()}');
    }
  }

  // Authenticate user with login and password using the stored access token
  Future<Map<String, dynamic>> login(String login, String password) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      // Ensure you have the access token available
      final String? accessToken = await getAccessToken();

      // If no token is available, throw an error
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      // Prepare the login request parameters
      final Map<String, String> queryParams = {
        'login': login,
        'password': password,
      };

      // Build the URI for the authentication API call
      final Uri uri = Uri.parse(authApiUrl).replace(queryParameters: queryParams);

      // Send the POST request to the authenticate API
      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'authorization': accessToken,  // Use the stored access token for authorization
          'cache-control': 'no-cache',
        },
      ).timeout(
        const Duration(seconds: 120),  // Timeout for this request as well
        onTimeout: () {
          throw Exception("Request timed out during logins");
        },
      );
      
      // Handle the response from the login API
      if (response.body.isNotEmpty) {
        prefs.setString('login', login);

        // Save customer record on login
        final customerData = await customer(login);
        if (customerData.isNotEmpty) {
          final customer = customerData.first;

          prefs.setString('customer_name', customer['customer_name'] ?? '');
          prefs.setString('customer_email_address', customer['customer_email_address'] ?? '');
          prefs.setString('customer_phone', customer['customer_phone'] ?? '');
          prefs.setString('customer_company_cu', customer['customer_company_cu'] ?? '');
        }

        // Save customer record on login
        final salesCustomerData = await salesCustomer();
        if (salesCustomerData.isNotEmpty) {
          final salesCustomer = salesCustomerData.first;
          prefs.setString('salesman_email_address', salesCustomer['salesman_email_address'] ?? '');
        }  

      // Retrieve and print the saved email
      final salesmanEmailAddress = prefs.getString('salesman_email_address');
      print('Retrieved salesman_email_address: $salesmanEmailAddress');
        // Assuming the API returns a JSON response
        return json.decode(response.body);
      } else {
        throw Exception('Failed to login: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred during login: $e');
    }
  }

  // Authenticate user with login and password using the stored access token
  Future<List<Map<String, dynamic>>> customer(String login) async {
    try {
      final String? accessToken = await getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      final Map<String, String> queryParams = {
        'query': 'FOR EACH customer NO-LOCK WHERE customer.company_cu  = "ST" AND customer.is_deleted = no AND customer = "$login"',
        'columns': 'customer.name,customer.email_address,customer.phone,customer.company_cu',
      };

      final Uri uri = Uri.parse(customerApiUrl).replace(queryParameters: queryParams);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'authorization': accessToken,
          'cache-control': 'no-cache',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception("Request timed out during customer data");
        },
      );

      if (response.body.isNotEmpty) {
        // Here you can safely decode the response as a List<Map<String, dynamic>>
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch customer data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred during customer data fetch: $e');
    }
  }

  Future<List<Map<String, dynamic>>> salesCustomer() async {
    try {
      final String? accessToken = await getAccessToken();
      if (accessToken == null) {
        throw Exception('No access token available');
      }

      final Map<String, String> queryParams = {
        'query': 'FOR EACH salesman NO-LOCK WHERE salesman = "145"',
        'columns': 'salesman.email_address',
      };

      final Uri uri = Uri.parse(customerApiUrl).replace(queryParameters: queryParams);

      final response = await http.post(
        uri,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded; charset=UTF-8',
          'authorization': accessToken,
          'cache-control': 'no-cache',
        },
      ).timeout(
        const Duration(seconds: 60),
        onTimeout: () {
          throw Exception("Request timed out during sales customer data");
        },
      );

      if (response.body.isNotEmpty) {
        return List<Map<String, dynamic>>.from(json.decode(response.body));
      } else {
        throw Exception('Failed to fetch sales customer data: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred during sales customer data fetch: $e');
    }
  }




}
