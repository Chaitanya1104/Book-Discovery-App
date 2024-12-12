import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'detailpage.dart';

class BookScreen extends StatefulWidget {
  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  List<dynamic> books = [];
  String? nextPageUrl = "https://gutendex.com/books/";
  bool _isFetchingMore = false;
  bool _loading = false;
  late ScrollController _scrollController;
  TextEditingController textEditingController = TextEditingController();
  String? currentQuery;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController()..addListener(_loadMoreBooks);
    fetchBooks();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    textEditingController.dispose();
    super.dispose();
  }

  Future<void> fetchBooks({bool isPagination = false, String? query}) async {
    // Handle URL based on query or pagination
    String url;
    if (query != null && query.isNotEmpty) {
      url = "https://gutendex.com/books/?search=$query";
      currentQuery = query;
    } else {
      url = nextPageUrl ?? "";
    }

    if (url.isEmpty || (isPagination && nextPageUrl == null)) return;

    setState(() {
      if (isPagination) {
        _isFetchingMore = true;
      } else {
        _loading = true;
        if (query != null) books.clear(); // Clear books only on a new query
      }
    });

    try {
      var response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        Map<String, dynamic> jsonData = jsonDecode(response.body);

        setState(() {
          books.addAll(jsonData["results"]);
          nextPageUrl = jsonData["next"];
        });
      } else {
        print("Failed to fetch books: ${response.statusCode}");
      }
    } catch (e) {
      print("Error fetching books: $e");
    } finally {
      setState(() {
        _loading = false;
        _isFetchingMore = false;
      });
    }
  }

  void _loadMoreBooks() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent &&
        !_isFetchingMore) {
      fetchBooks(isPagination: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          RefreshIndicator(
            onRefresh: () async {
              textEditingController.clear();
              currentQuery = null;
              nextPageUrl = "https://gutendex.com/books/"; // Reset to initial URL
              setState(() {
                books.clear();
              });
              await fetchBooks();
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    color: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const SizedBox(height: 50),
                        const Center(
                          child: Text(
                            "Book Discovery",
                            style: TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                            ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          "Explore through our list of books and uncover your next great read.",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: textEditingController,
                                decoration: const InputDecoration(
                                  hintText: "Search for books...",
                                  hintStyle: TextStyle(fontSize: 16, color: Colors.white54),
                                  filled: true,
                                  fillColor: Color(0xff1b1b1b),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.all(
                                      Radius.circular(8),
                                    ),
                                  ),
                                ),
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () {
                                if (textEditingController.text.isNotEmpty) {
                                  fetchBooks(query: textEditingController.text);
                                }
                              },
                              child: const Text("Search"),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  ),
                  _loading && books.isEmpty
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                      : books.isEmpty
                      ? const Center(
                    child: Text(
                      "No books found!",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                      : Container(
                    color: Colors.black,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 200,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => DetailPage(
                                    id: books[index]['id'].toString(),
                                  ),
                                ),
                              );
                            },
                            child: BookTile(
                              title: books[index]['title'] ?? "No Title",
                              imgUrl: books[index]['formats']?['image/jpeg'] ??
                                  "https://via.placeholder.com/150",
                              author: books[index]['authors'] != null &&
                                  books[index]['authors'].isNotEmpty
                                  ? books[index]['authors'][0]['name']
                                  : "Unknown Author",
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                  if (_isFetchingMore)
                    const Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CircularProgressIndicator(
                        color: Colors.white,
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}


class BookTile extends StatelessWidget {
  final String title, imgUrl, author;

  BookTile({
    required this.title,
    required this.imgUrl,
    required this.author,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Image.network(
              imgUrl,
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  "By $author",
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
