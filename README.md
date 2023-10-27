# What3wordsTest

Demonstration of the trending movie app using Clean Architecture, MVVM, and Reactive Programming

<img width="845" alt="image" src="https://github.com/trqhien/What3wordsTest/assets/19741536/b9a2c839-2712-45e2-9e4b-9673479b4037">


### Required:

- [x] Use https://developer.themoviedb.org/reference/trending-movies to get the trending movies for today and create an infinite list (query the next page as it scrolls)
- [x] This should work offline after first use by caching the results, the results cache should persist between application sessions and device reboots.
- [x] The movie list item should include an image, movie title, year and vote average
- [x] Add a search field and allow searching movies using https://developer.themoviedb.org/reference/search-movie, when the search field is empty go back to showing the trending movies (search doesn’t need to work offline)
- [x] Present a detail view when a movie is tapped. Get info for the view using https://developer.themoviedb.org/reference/movie-details.  Also cache this detail info to make it work off-line for any items that were previously queried and viewed.

### Extra points:

- [x] Create Unit Tests -> I didn't have enough time to create an entire test suite, so I just demonstrated a few tests and how to inject test objects and mock their behaviors.
- [ ] Create a simple UI Test.
- [x] Make search work offline by searching cached results
- [x] Error message handling (offline/online/failed API calls) -> I didn't go too deep into each error type, just some common ones. However, I have created an error handling mechanism that allows me to scale up my custom error handler with ease. Check out [NetworkError](What3WordsTest/Core/Networking/NetworkError.swift) 



