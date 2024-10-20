import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/db_controller.dart';
import '../modal/db_modal.dart';

class FolderPage extends StatelessWidget {
  const FolderPage({super.key});

  @override
  Widget build(BuildContext context) {
    // QuoteController controller = Get.put(QuoteController());
    final DataController dataController = Get.put(DataController());
    return Center(
      child: Scaffold(
        body: Obx(
          () {
            if (dataController.likedQuotes.isNotEmpty) {
              var quotesByCategory = dataController.likedQuotesByCategory;
              return ListView.builder(
                itemCount: quotesByCategory.keys.length,
                itemBuilder: (context, index) {
                  var category = quotesByCategory.keys.elementAt(index);
                  var quotes = quotesByCategory[category]!;
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 8.0, horizontal: 16.0),
                    child: Card(
                      elevation: 4, // Add shadow here
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ListTile(
                        title: Text(category),
                        trailing: InkWell(
                          onTap: () {
                            // dataController.getLikeData(category);
                            Get.to(QuotesDetailScreen(
                              category: category,
                              quotes: quotes,
                            ));
                          },
                          child: Icon(Icons.arrow_forward_ios),
                        ),
                      ),
                    ),
                  );
                },
              );
            } else {
              return Center(
                child: Text(
                  'No liked quotes',
                  style: TextStyle(fontSize: 18, color: Colors.grey),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

String Family = 'friendship';

class QuotesDetailScreen extends StatelessWidget {
  final String category;
  final List<Quote> quotes;

  const QuotesDetailScreen(
      {super.key, required this.category, required this.quotes});

  @override
  Widget build(BuildContext context) {
    final DataController dataController = Get.find<DataController>();
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/img/2.jpeg',
              fit: BoxFit.cover,
            ),
          ),
          // Content
          Positioned.fill(
            child: Column(
              children: [
                // Top section with title and back icon
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.0, vertical: 40.0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: Icon(Icons.arrow_back, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                      SizedBox(width: 10),
                      Text(
                        category,
                        style: TextStyle(
                          fontSize: 24,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemCount: quotes.length,
                    itemBuilder: (context, index) {
                      var quote = quotes[index];
                      var quoteIndex =
                          dataController.likedQuotes.indexOf(quote);
                      return Card(
                        elevation: 2, // Add shadow here
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        margin: const EdgeInsets.symmetric(
                            vertical: 8.0, horizontal: 16.0),
                        child: ListTile(
                          title: Text(
                            quote.quote,
                            style: TextStyle(fontSize: 16),
                          ),
                          subtitle: Text('- ${quote.author}'),
                          trailing: IconButton(
                            icon: Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              dataController.toggleLike(quote, quoteIndex);
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
