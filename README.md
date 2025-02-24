# iOS Take Home Test

![Static Badge](https://img.shields.io/badge/coverage-97%2C8%25-mint) 
![Static Badge](https://img.shields.io/badge/Deployment_Target-iOS%2015%2B-green)
![Static Badge](https://img.shields.io/badge/Swift-6.0-indigo)

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
- **UIKit** (for `UIViewController`, `UITableView`, etc.)
- **SwiftUI** (for detailed views and charts)
- **async-await** for networking
- **MVVM + Coordinators** for clean architecture
- **URLSession** for API communication
- **Unit Tests** and **UI Tests** with `XCTest`

## Instructions for Building and Running the Application

### Prerequisites
- **Xcode 16**
- **iOS 15+** Deployment Target
- **Swift 6**

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
   
3. Export the API key:
    If you don’t already have a `~/.zshrc` file, you can create it by running the following command:
    ```sh
    touch ~/.zshrc
    ```
    
    Then, add your API key to the `~/.zshrc` file:
    ```sh
    echo 'export API_KEY=your_api_key_here' >> ~/.zshrc
    ```
    
    Afterward, run the following to reload the environment variables:
    ```sh
    source ~/.zshrc
    ```
    
4. Run the application on the iOS Simulator or a physical device.

## Assumptions & Decisions
- **Pagination**: Implemented client-side pagination to optimize API requests and improve performance.
- **Networking**: Used async/await for clearer and more concise networking code.
- **Charts**: Leveraged `SwiftUI Charts` for data visualization.
- **Securing API Key**: The API key is securely stored in the system's environment variables, retrieved from `Info.plist` at runtime to avoid hardcoding sensitive information in the codebase.

## Challenges & Solutions
- **Efficient Pagination**: Used `UITableViewDiffableDataSource` to manage smooth updates.
- **Mixing UIKit & SwiftUI**: Embedded SwiftUI views inside `UIHostingController` for seamless integration.
- **Error Handling**: Improved error messaging with OSLog to guide users in case of API failures.
- **API Key Security**: Ensured that the API key is not exposed in source control or hardcoded in the application, utilizing environment variables and `Info.plist` for runtime retrieval.

## Testing
- **Unit Tests**: Coverage includes `FavoritesManager`, `NetworkService`, and `ViewModels`. 
  - All services and managers are thoroughly tested to ensure correct functionality.
  - View models are tested to validate proper binding and state management.
- **Mocks**: 
  - `MockNetworkError`: Used to simulate network errors during tests, ensuring proper error handling.
  - `MockFavoritesManager`: Provides a mock implementation of the favorites manager to test the app's ability to handle and store favorites without needing real data.
  - `MockCoinRankingAPI`: A mock API implementation to simulate real API calls and test how the app interacts with network data without making live requests.
  - `MockURLProtocol` to simulate API responses for testing the networking layer without making real requests.
  
## Screenshots
| ![Simulator Screenshot - iPhone 16 - 2025-02-20 at 22 20 13](https://github.com/user-attachments/assets/1605f467-ac6a-499e-a5b3-53a7f65d15f2) | ![Simulator Screenshot - iPhone 16 - 2025-02-20 at 22 20 37](https://github.com/user-attachments/assets/1cf5d393-eae1-4694-a128-68e72af8bd19) | ![Simulator Screenshot - iPhone 16 - 2025-02-20 at 22 20 33](https://github.com/user-attachments/assets/fa46be1e-7bca-486f-8166-b58b5cbc8949) |
| --- | --- | --- |
| ![Simulator Screenshot - iPhone 16 - 2025-02-20 at 22 20 18](https://github.com/user-attachments/assets/a5f1b171-c487-4394-a5f6-98541af58057) | ![Simulator Screenshot - iPhone 16 - 2025-02-20 at 22 21 55](https://github.com/user-attachments/assets/5f14fb9c-4722-4ec3-8122-4fe45f8d8d4e) | ![Simulator Screenshot - iPhone 16 - 2025-02-20 at 22 20 41](https://github.com/user-attachments/assets/a4ff4d88-7379-4a29-877a-087f008bc81b) |

## UI test recording

https://github.com/user-attachments/assets/83c23842-8be1-43f6-80d0-0f862b6af3e5

## TODO:
- Move metrics values to Constants for consistency and reduce hardcoding.
- Break large views into reusable components for modularity.
- Improve API handling and implement caching for performance.
- Store favorites persistently (e.g., `CoreData` or `UserDefaults`).
- Add smooth animations and accessibility support.
- Refine naming across the codebase for clarity and consistency.
- Enhance UI testing capabilities to encompass a comprehensive range of edge scenarios. 
- Implement caching to reduce repeated API calls.
  
## Issues

### API Rate Limit Exceeded  
If you encounter the following error while fetching chart data:  
```
    Error fetching chart data: Rate limit exceeded - Please try again later
```
This means the API has reached its request limit. To resolve this:  
- Wait for some time and try again later.  
- Ensure you're not making excessive requests within a short period.  
- If possible, use API keys with higher rate limits. 
[Documentation](https://developers.coinranking.com/api/documentation/rate-limit)

---
