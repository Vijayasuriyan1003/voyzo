import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class AuthApi {
  // -----Login APi -----
  Future<Map<String, dynamic>?> login({
    required String email,
    required String password,
  }) async {
    try {
      final loginResponse = await DioClient.dio.post(
        '/api/method/login',
        data: {'usr': email.trim(), 'pwd': password.trim()},
      );

      if (loginResponse.statusCode != 200) return null;

      final userResponse = await DioClient.dio.get(
        '/api/resource/User/${email.trim()}',
      );

      final user = userResponse.data['data'];
      final customerResponse = await DioClient.dio.get(
        '/api/resource/Customer',
        queryParameters: {
          'filters': '[["custom_user","=","${email.trim()}"]]',
          'fields': '["name","customer_name"]',
        },
      );

      final customers = customerResponse.data['data'] as List;

      final customer = customers.isNotEmpty ? customers.first : null;

      return {
        'email': email.trim(),
        'full_name': user['full_name'] ?? '',
        'mobile_no': user['mobile_no'] ?? '',
        'customer_id': customer?['name'] ?? '',
        'customer_name': customer?['customer_name'] ?? '',
      };
    } catch (e) {
      print('LOGIN USER FETCH ERROR: $e');
      return null;
    }
  }

  //  ----- Register API -----
  Future<bool> registerCustomer({
    required String full_name,
    required String email,
    required String mobileno,
    required String password,
  }) async {
    try {
      final response = await DioClient.dio.post(
        '/api/method/frappe.core.doctype.user.user.sign_up',
        data: {
          'email': email.trim(),
          'full_name': full_name.trim(),
          'mobile_no': mobileno.trim(),
          'password': password.trim(),
          'redirect_to': '/app',
        },
      );

      print('REGISTER RESPONSE: ${response.data}');
      final message = response.data['message'];

      if (message is List && message[0] == 0) {
        throw Exception(message[1]);
      }

      return true;
    } on DioException catch (e) {
      print('REGISTER STATUS: ${e.response?.statusCode}');
      print('REGISTER DATA: ${e.response?.data}');
      return false;
    }
  }

  // ----- forget password API ------
  Future<bool> forgotPassword(String input) async {
    try {
      final isEmail = RegExp(
        r'^[\w\-.]+@([\w-]+\.)+[\w-]{2,4}$',
      ).hasMatch(input.trim());

      if (isEmail) {
        final response = await DioClient.dio.post(
          '/api/method/frappe.core.doctype.user.user.reset_password',
          data: {'user': input.trim()},
        );

        print('RESET RESPONSE: ${response.data}');
        return true;
      } else {
        // Mobile OTP API
        // Replace with your OTP API later
        print('Send OTP to: $input');

        return true;
      }
    } on DioException catch (e) {
      print('FORGOT PASSWORD ERROR: ${e.response?.data}');
      return false;
    }
  }

  // to create booking

  Future<bool> createBookingRequest({
    required String customerId,
    required String guestName,
    required String guestPhoneNumber,
    required bool isLocal,
    required String subTripType,
    required String fromDateTime,
    required String toDateTime,
    required String vehicleType,
    required String pickupLocation,
    required String dropOffLocation,
    required String passengers,
  }) async {
    try {
      final response = await DioClient.dio.post(
        '/api/resource/Booking%20Request',
        data: {
          'customer': customerId,
          'guest_name': guestName,
          'guest_phone_number': guestPhoneNumber,
          'trip_type': isLocal ? 'Local' : 'Outstation',
          'sub_trip_type': subTripType,
          'from_date_time': fromDateTime,
          'to_date_time': toDateTime,
          'vehicle_type': vehicleType,
          'pick_up_location': pickupLocation,
          'drop_off_location': dropOffLocation,
          'passengers': passengers,
        },
      );

      return response.statusCode == 200;
    } on DioException catch (e) {
      print('CREATE BOOKING ERROR STATUS: ${e.response?.statusCode}');
      print('CREATE BOOKING ERROR DATA: ${e.response?.data}');
      return false;
    } catch (e) {
      print('CREATE BOOKING ERROR: $e');
      return false;
    }
  }

  // to get detail from booking request and booking

  Future<List<Map<String, dynamic>>> getBookingHistory({
    required String customerId,
  }) async {
    try {
      final bookingRequestRes = await DioClient.dio.get(
        '/api/resource/Booking Request',
        queryParameters: {
          'filters': '[["customer","=","$customerId"]]',
          'fields': '["*"]',
          'limit_page_length': 100,
          'order_by': 'creation desc',
        },
      );

      final bookingRes = await DioClient.dio.get(
        '/api/resource/Booking',
        queryParameters: {
          'filters': '[["customer","=","$customerId"]]',
          'fields': '["*"]',
          'limit_page_length': 100,
          'order_by': 'creation desc',
        },
      );

      final List<Map<String, dynamic>> allBookings = [];

      for (final item in bookingRequestRes.data['data']) {
        final status = item['status']?.toString() ?? '';

        if (status == 'Open') {
          allBookings.add({
            ...item,
            'doctype': 'Booking Request',
            'ui_status': 'pending',
          });
        }
      }

      for (final item in bookingRes.data['data']) {
        final tripstatus = item['trip_status']?.toString() ?? '';

        String uiStatus;

        if (tripstatus == 'Open') {
          uiStatus = 'upcoming';
        } else if (tripstatus == 'Cancelled') {
          uiStatus = 'cancelled';
        } else if (tripstatus == 'Completed') {
          uiStatus = 'completed';
        } else {
          uiStatus = tripstatus.toLowerCase();
        }

        allBookings.add({...item, 'doctype': 'Booking', 'ui_status': uiStatus});
      }

      allBookings.sort((a, b) {
        return (b['creation'] ?? '').compareTo(a['creation'] ?? '');
      });

      return allBookings;
    } on DioException catch (e) {
      print('GET BOOKING HISTORY STATUS: ${e.response?.statusCode}');
      print('GET BOOKING HISTORY DATA: ${e.response?.data}');
      return [];
    } catch (e) {
      print('GET BOOKING HISTORY ERROR: $e');
      return [];
    }
  }

  // To get driver details

  Future<Map<String, dynamic>?> getDriverProfile({
    required String driverId,
  }) async {
    try {
      final response = await DioClient.dio.get(
        '/api/resource/Driver/$driverId',
      );

      return response.data['data'];
    } catch (e) {
      print('GET DRIVER PROFILE ERROR: $e');
      return null;
    }
  }

  // ---------DRIVER SIDE API---------

  static Future<Map<String, dynamic>?> driverLogin({
    required String email,
    required String password,
  }) async {
    try {
      // Login
      await DioClient.dio.post(
        '/api/method/login',
        data: {'usr': email, 'pwd': password},
      );

      // Fetch Driver Details using email
      final response = await DioClient.dio.get(
        '/api/resource/Driver',
        queryParameters: {
          'filters': '[["custom_user","=","$email"]]',
          'fields': '["*"]',
        },
      );

      final data = response.data['data'];

      if (data == null || data.isEmpty) {
        return null;
      }

      final driver = data.first;

      return {
        'email': email,
        'driver_id': driver['name'] ?? '',
        'full_name': driver['full_name'] ?? '',
        'mobile_no': driver['cell_number'] ?? '',
      };
    } on DioException catch (e) {
      print('STATUS: ${e.response?.statusCode}');
      print('DATA: ${e.response?.data}');
      print('URL: ${e.requestOptions.uri}');
      return null;
    }
  }

  // --- to get driver bookings
  static Future<List<Map<String, dynamic>>> getDriverBookings({
    required String driverEmail,
  }) async {
    try {
      final bookingRes = await DioClient.dio.get(
        '/api/resource/Booking',
        queryParameters: {
          'filters': '[["driver_user_id","=","$driverEmail"]]',
          'fields':
              '["name","from_date_time","to_date_time","guest_name","pick_up_location","drop_off_location","duty_type","trip_type","sub_trip_type", "trip_status"]',
          'limit_page_length': 100,
          'order_by': 'creation desc',
        },
      );

      final data = bookingRes.data['data'] as List;

      return data.map((e) => Map<String, dynamic>.from(e)).toList();
    } catch (e) {
      print('Get Driver Bookings Error: $e');
      return [];
    }
  }

  static Future<bool> addExpense({
    required String bookingId,
    required String expenseType,
    required double price,
  }) async {
    try {
      final response = await DioClient.dio.put(
        '/api/resource/Booking/$bookingId',
        data: {
          "extra_charges_details": [
            {"extra_charges_type": expenseType, "price": price},
          ],
        },
      );

      print('Add Expense Success: ${response.data}');
      return true;
    } on DioException catch (e) {
      print('ADD EXPENSE STATUS: ${e.response?.statusCode}');
      print('ADD EXPENSE DATA: ${e.response?.data}');
      print('ADD EXPENSE URL: ${e.requestOptions.uri}');
      return false;
    } catch (e) {
      print('Add Expense Error: $e');
      return false;
    }
  }
}
