import 'package:get/get.dart';

import '../helper/db_helper.dart';
import '../helper/qoute_helper.dart';
import '../modal/db_modal.dart';

class DataController extends GetxController {
  var quotes = <Quote>[].obs;
  var isLoading = false.obs;
  var backgroundImage = 'assets/img/back.jpg'.obs;
  var likedQuotes = <Quote>[].obs;
  var allQuotes = <Quote>[].obs; // To store all fetched quotes

  final DatabaseHelper _databaseHelper = DatabaseHelper();

  @override
  void onInit() {
    super.onInit();
    fetchData();
    loadLikedQuotes();
  }

  void fetchData() async {
    isLoading(true);
    try {
      List<Quote>? result = await ApiServices.apiServices.fetchData();
      if (result != null) {
        result.shuffle();
        allQuotes(result); // Store all fetched quotes
        quotes(result); // Initially display all quotes
      } else {
        print('Here is a problem');
      }
    } finally {
      isLoading(false);
    }
  }

  void fetchDataByCategory(String category) {
    isLoading(true);
    try {
      List<Quote> filteredQuotes =
          allQuotes.where((quote) => quote.category == category).toList();
      quotes(filteredQuotes);
    } catch (e) {
      print('Error filtering data by category: $e');
    } finally {
      isLoading(false);
    }
  }

  void setBackgroundImage(String imagePath) {
    backgroundImage.value = imagePath;
  }

  void toggleLike(Quote quote, int index) async {
    if (likedQuotes.any((liked) => liked.quote == quote.quote)) {
      likedQuotes.removeWhere((liked) => liked.quote == quote.quote);
      await _databaseHelper.deleteLikedQuote(quote.quote);
    } else {
      likedQuotes.add(quote);
      await _databaseHelper.insertData(
          quote.author, quote.quote, quote.category, index);
    }

    if (quotes[index].isLiked == "1") {
      quotes[index].isLiked = "0";
    } else {
      quotes[index].isLiked = "1";
    }
    update();
    quotes.refresh();
    print(quotes[index].isLiked);
  }

  Future<RxList> showCategoryData(String category) async {
    likedQuotes.value = await _databaseHelper.showCategoryWiseData(category);
    return likedQuotes;
  }

  void loadLikedQuotes() async {
    List<Quote> likedQuotesFromDb = await _databaseHelper.getLikedQuotes();
    likedQuotes.value = likedQuotesFromDb;
  }

  // void getLikeData(String category)
  // {
  //   _databaseHelper.InsertData(category);
  // }

  // Group liked quotes by category
  Map<String, List<Quote>> get likedQuotesByCategory {
    var groupedQuotes = <String, List<Quote>>{};
    for (var quote in likedQuotes) {
      if (groupedQuotes.containsKey(quote.category)) {
        groupedQuotes[quote.category]!.add(quote);
      } else {
        groupedQuotes[quote.category] = [quote];
      }
    }
    return groupedQuotes;
  }

  void updateBackgroundImage(String newImage) {
    backgroundImage.value = newImage;
  }
}
// }
