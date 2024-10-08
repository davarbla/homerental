import 'package:get/get.dart';

class AllProvider extends GetConnect {
  static String urlBase = "https://homerental.fboys.app/";
  static String tokenAPI = 'aG9tZXJlbnRhbDpiMXNtMWxsNGg=';

  Future<Response>? pushResponse(final String path, final String encoded) =>
      post(
        urlBase + path,
        encoded,
        contentType: 'application/json; charset=UTF-8',
        headers: {
          'x-api-key': tokenAPI,
          'Content-type': 'application/json',
        },
      );
}
