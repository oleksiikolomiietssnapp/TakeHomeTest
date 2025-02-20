# iOS Take Home Test

## Objective
The purpose of this project is to demonstrate the ability to develop an iOS application that interacts with a public API, efficiently handles paginated data, and presents it in a user-friendly way.

## Project Overview
The app fetches cryptocurrency data from the CoinRanking API and presents it in a paginated list. Users can sort, favorite, and view details of each coin.

## Features
- **Top 100 Coins**: Displays a paginated list of the top 100 coins, showing relevant details such as name, price, and 24-hour performance. Users can sort by highest price and best performance.
- **Coin Details**: Provides an in-depth view of a selected coin, including a performance chart with filtering options and additional statistics.
- **Favorites Management**: Allows users to favorite coins for quick access. The favorites list is dynamically updated and supports swipe gestures for easy management.

## Tech Stack
- **Swift**
- **UIKit** (for TableView/CollectionView)
- **SwiftUI** (for detailed views and charts)
- **async-await** for networking
- **MVVM + Coordinators** for clean architecture
- **URLSession** for API communication
- **Unit Tests** with XCTest

## Instructions for Building and Running the Application
### Prerequisites
- Xcode 16+
- iOS 17+ Deployment Target

### Steps
1. Clone the repository:
   ```sh
   git clone https://github.com/oleksiikolomiietssnapp/ios-take-home-test.git
   cd ios-take-home-test
   ```
2. Open the project in Xcode:
   ```sh
   open TakeHomeTest.xcodeproj
   ```
3. Run the application on the iOS Simulator or a physical device.

## Assumptions & Decisions
- **Pagination**: Implemented client-side pagination to optimize API requests and improve performance.
- **Networking**: Used async/await for clearer and more concise networking code.
- **Charts**: Leveraged `SwiftUI Charts` for data visualization.

## Challenges & Solutions
- **Efficient Pagination**: Used `UITableViewDiffableDataSource` to manage smooth updates.
- **Mixing UIKit & SwiftUI**: Embedded SwiftUI views inside `UIHostingController` for seamless integration.
- **Error Handling**: Improved error messaging with OSLog to guide users in case of API failures.

## Testing
- **Unit Tests**: Coverage for `FavoritesManager` and `NetworkService`.
- **Mock Networking**: Utilized `URLProtocol` to simulate API responses.
