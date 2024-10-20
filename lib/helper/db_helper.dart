import 'dart:convert';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;

import '../modal/db_modal.dart';

class ApiServices {
  static final ApiServices apiServices = ApiServices._singleton();
  ApiServices._singleton();

  Future<List<Quote>?> fetchData({String? category}) async {
    String apiData = "https://sheetdb.io/api/v1/ijalfqzzvwh0c";
    Uri uri = Uri.parse(apiData);
    Response response = await http.get(uri);

    if (response.statusCode == 200) {
      print('API called successfully');
      List<dynamic> jsonData = json.decode(response.body);
      List<Quote> quotes =
          jsonData.map((json) => Quote.fromJson(json)).toList();

      if (category != null) {
        quotes = quotes.where((quote) => quote.category == category).toList();
      }

      return quotes;
    }
    return null;
  }
}
