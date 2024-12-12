# Book Discovery App


The **Book Discovery App** is a Flutter-based mobile application designed to allow users to discover and search through a collection of books. The app fetches data from the [Gutendex API](https://gutendex.com/), a free API that provides access to thousands of books in the public domain. Users can explore books, search for specific titles or authors, and view detailed information about each book. The app also supports pagination to load more books as users scroll down.

## Features

- **Book Discovery**: Browse a vast collection of public domain books.
- **Search Functionality**: Search books by title, author, or other keywords. The search results are dynamically fetched as the user types or submits a query.
- **Pagination**: The app supports infinite scrolling by fetching more books as the user reaches the end of the current list.
- **Detailed View**: Tap on a book to view detailed information about it, including its title, author, and a preview image of the book cover.

## Technologies Used

- **Flutter**: Framework used for building the mobile app.
- **HTTP**: Used for making network requests to fetch book data from the Gutendex API.
- **JSON**: Data from the API is parsed using JSON.


## Getting Started

This project is a starting point for a Flutter application.

To run the app locally, follow the steps below:
1. Install Flutter on your system.
2. Clone this repository:
   ```bash
   git clone https://github.com/Chaitanya1104/Book-Discovery-App.git
   cd Book-Discovery-App
3. Install dependencies by clicking pub get in the pubsec.yaml.
4. Run the app by clicking main.dart file.

## Snapshots

Below are some screenshots of the app:

<div style="display: flex; justify-content: space-around; gap: 20px;">

  <div style="text-align: center;">
    <img src="assets/screenshots/home_screen.png" alt="Home Screen" width="250"/>
    <p>Home Screen</p>
  </div>

  <div style="text-align: center;">
    <img src="assets/screenshots/search_screen.png" alt="Search Screen" width="250"/>
    <p>Searching</p>
  </div>

  <div style="text-align: center;">
    <img src="assets/screenshots/book_detail_screen.png" alt="Book Detail Screen" width="250"/>
    <p>Book Detail Screen</p>
  </div>

</div>
