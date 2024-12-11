import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DetailPage extends StatefulWidget {
  final String id; // Book ID
  DetailPage({required this.id});

  @override
  _DetailPageState createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  bool _loading = true;
  Map<String, dynamic>? bookDetails;

  @override
  void initState() {
    super.initState();
    fetchBookDetails();
  }

  fetchBookDetails() async {
    String detailUrl = "https://gutendex.com/books/${widget.id}/";
    try {
      var response = await http.get(Uri.parse(detailUrl));
      if (response.statusCode == 200) {
        setState(() {
          bookDetails = jsonDecode(response.body);
          _loading = false;
        });
      } else {
        print("Failed to fetch book details");
        setState(() {
          _loading = false;
        });
      }
    } catch (e) {
      print("Error fetching book details: $e");
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            color: const Color(0xff050709), // Background color
          ),
          Positioned(
            top: 50,
            left: 20,
            child: IconButton(
              icon: const Icon(Icons.arrow_back, size: 30,color: Colors.white),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const <Widget>[
                    Text(
                      "Book Details",
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.w500,
                        color: Color(0xffffffff), // White text
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40), // Space below the title
                Expanded(
                  child: _loading
                      ? const Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                    ),
                  )
                      : bookDetails != null
                      ? Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Image.network(
                          bookDetails?['formats']['image/jpeg'] ??
                              "https://via.placeholder.com/150",
                          height: 300,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 30),
                      Text(
                        "Title: ${bookDetails?['title'] ?? 'No Title'}",
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Author: ${bookDetails?['authors'] != null && bookDetails!['authors'].isNotEmpty ? bookDetails!['authors'][0]['name'] : 'Unknown'}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Birth Year: ${bookDetails?['authors'] != null && bookDetails!['authors'].isNotEmpty && bookDetails!['authors'][0]['birth_year'] != null ? bookDetails!['authors'][0]['birth_year'].toString() : 'N/A'}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Death Year: ${bookDetails?['authors'] != null && bookDetails!['authors'].isNotEmpty && bookDetails!['authors'][0]['death_year'] != null ? bookDetails!['authors'][0]['death_year'].toString() : 'N/A'}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        "Language: ${bookDetails?['languages'] != null && bookDetails!['languages'].isNotEmpty ? bookDetails!['languages'][0].toUpperCase() : 'Unknown'}",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  )
                      : const Center(
                    child: Text(
                      "Failed to load book details.",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
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