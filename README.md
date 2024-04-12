# WatchTV iOS Application
<img src="https://img.shields.io/badge/status-Active-green" height="20"> <img src="https://img.shields.io/github/issues/adumrewal/tmdb-ios-app" height="20"> <img src="https://img.shields.io/github/stars/adumrewal/tmdb-ios-app" height="20"> <img src="https://img.shields.io/github/license/adumrewal/tmdb-ios-app" height="20"> <img src="https://img.shields.io/badge/architecture-MVVM-yellow" height="20"> <img src="https://img.shields.io/badge/language-Swift-yellow" height="20"> 

# WatchTV iOS App in Swift using [The Movie Database TMDB](https://developers.themoviedb.org/3/getting-started/introduction)

## Technical specs
- Language: Swift
- Networking: URLSession
- CoreData for cache mechanism
- Architecture: MVVM
  
<img src="/Screenshots/MVVM_Folder_Structure.png" width="250"/>
*Folder structure for MVVM*

- Pagination
- ViewModels and ViewData for storing UI state
- Protocols
- Swift standard coding/decoding for custom objects

## Tools & SDK:
- Xcode 15.3 & macOS 14.4.1
- Simulator: iPhone 15 iOS 17.4

## Features
- Today Trending Movies view
- Allow search movies with search bar in Today Trending Screen
- Movie Detail view
- App works offline: Save latest movie list on Today Trending, save movie details have fetched, save list movies by search keywords using Core Data
- [Nuke](https://cocoapods.org/pods/Nuke) for image fetching and caching
- Show toast for every error messages on offline/online/failed API calls

## Checklist Specifications

- [x] Use [Trending Movies API](https://developer.themoviedb.org/reference/trending-movies) to get the trending movies for today and create an infinite list (query the next page as it scrolls)
- [x] This should work offline after first use by caching the results, the  cache should persist between application sessions and device reboots results
- [x] The movie list item should include an image, movie title, year and vote average
- [x] Add a search field and allow searching movies using [Search Movie API](https://developer.themoviedb.org/reference/search-movie), when the search field is empty go back to showing the trending movies (search doesn’t need to work offline)
- [x] Present a detail view when a movie is tapped. Get info for the view using [Movie Details API](https://developer.themoviedb.org/reference/movie-details).  Also cache this detail info to make it work off-line for any items that were previously queried and viewed.

### Extra points:

- [x] Create Unit Tests.
- [x] Create a simple UI Test.
- [x] Make search work offline by searching cached results.
- [x] Error message handling (offline/online/failed API calls).

<img src="/Screenshots/OfflineMode.png" width="250"/>
*Offline Mode*

## Screenshots
|Today Trending|Search Movies|Movie Detail|
|:-:|:-:|:-:|
|<img src="/Screenshots/TodayTrending.png" width="250"/>|<img src="/Screenshots/SearchMovies.png" width="250"/>|<img src="/Screenshots/MovieDetail.png" width="250"/>|

## Steps to build and run
- Clone repo (pod files are included)
- Move to project directory, install pods `pod install`
- Open `WatchTV.xcworkspace` in XCode
  - Select `WatchTV` (pre-selected)
  - Choose Simulator/Devices
- Click on Run

## Future work
- Add full Unit Tests
- Add more UITests on another screens
- Add CI/CD
