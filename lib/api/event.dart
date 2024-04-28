import 'package:dio/dio.dart';
import 'package:discounttour/model/event_model.dart';

import '../core/interceptors/auth-interceptor.dart';
import 'api.dart';

class EventService {
  Future<Map<String, dynamic>> fetchEvents(pageNumber) async {
    var dio = Dio();
    var fullUrl = '${Api.resourceUrl()}/api/events?page=$pageNumber&size=10';

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      Response response = await dio.get(fullUrl);

      if (response.statusCode == 200) {
        List<dynamic> responseData =
            response.data; // Assuming response.data is a List<dynamic>
        List<EventModel> events =
            responseData.map((data) => EventModel.fromJson(data)).toList();
        String totalCount = response.headers.value('x-total-count');

        return {'events': events, 'totalCount': totalCount};
      }
    } catch (error) {
      print('eeerrrr' + error);
    }
  }

  Future<Map<String, dynamic>> fetchEventsByCategory(pageNumber, category) async {
    var dio = Dio();
    var fullUrl = '${Api.resourceUrl()}/api/events?type.equals=$category&page=$pageNumber&size=10';

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      Response response = await dio.get(fullUrl);

      if (response.statusCode == 200) {
        List<dynamic> responseData =
            response.data; // Assuming response.data is a List<dynamic>
        List<EventModel> events =
        responseData.map((data) => EventModel.fromJson(data)).toList();
        String totalCount = response.headers.value('x-total-count');

        return {'events': events, 'totalCount': totalCount};
      }
    } catch (error) {
      print('eeerrrr' + error);
    }
  }

  Future<Map<String, dynamic>> fetchFavoritesEvents(pageNumber, category) async {
    var dio = Dio();
    var fullUrl = '${Api.resourceUrl()}/api/events/favorites/$category?page=$pageNumber&size=10';

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      Response response = await dio.get(fullUrl);

      if (response.statusCode == 200) {
        List<dynamic> responseData =
            response.data; // Assuming response.data is a List<dynamic>
        List<EventModel> events =
        responseData.map((data) => EventModel.fromJson(data)).toList();
        String totalCount = response.headers.value('x-total-count');

        return {'events': events, 'totalCount': totalCount};
      }
    } catch (error) {
      print('eeerrrr' + error);
    }
  }

  Future<Map<String, dynamic>> fetchRecommendedEvents() async {
    var dio = Dio();
    var fullUrl = '${Api.resourceUrl()}/api/events/suggested';

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      Response response = await dio.get(fullUrl);

      if (response.statusCode == 200) {
        List<dynamic> responseData =
            response.data; // Assuming response.data is a List<dynamic>
        List<EventModel> events =
            responseData.map((data) => EventModel.fromJson(data)).toList();

        return {'events': events};
      }
    } catch (error) {
      print('eeerrrr' + error);
    }
  }

  Future<Map<String, dynamic>> fetchActivitiesEvents(pageNumber) async {
    var dio = Dio();
    var fullUrl = '${Api.resourceUrl()}/api/events/activities?page=$pageNumber&size=10';

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      Response response = await dio.get(fullUrl);

      if (response.statusCode == 200) {
        print("respoonse 20000");
        List<dynamic> responseData =
            response.data; // Assuming response.data is a List<dynamic>
        List<EventModel> events =
        responseData.map((data) => EventModel.fromJson(data)).toList();
        String totalCount = response.headers.value('x-total-count');

        return {'events': events, 'totalCount': totalCount};
      }
    } catch (error) {
      print('eeerrrr' + error);
    }
  }

  Future<bool> addToFavorite(id) async {
    var dio = Dio();
    var fullUrl = '${Api.resourceUrl()}/api/events/favorites/$id';

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      Response response = await dio.post(fullUrl);

      if (response.statusCode == 204) {
        return true;
      }
    } catch (error) {
      print('eeerrrr' + error);
    }
  }

  Future<bool> deleteFromFavorite(id) async {
    var dio = Dio();
    var fullUrl = '${Api.resourceUrl()}/api/events/favorites/$id';

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      Response response = await dio.delete(fullUrl);

      if (response.statusCode == 204) {
        return true;
      }
    } catch (error) {
      print('eeerrrr' + error);
    }
  }

  createEvent(data) async {
    var dio = Dio();
    var fullUrl = '${Api.resourceUrl()}/api/events';

    dio.interceptors
      ..add(LogInterceptor())
      ..add(AuthInterceptor());

    try {
      Response response = await dio.post(fullUrl, data: data);
      return response;
    } catch (error) {
      print('eeerrrr' + error);
    }
  }
}
