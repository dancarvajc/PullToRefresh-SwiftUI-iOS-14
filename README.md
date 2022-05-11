# PullToRefresh for iOS 14+ - SwiftUI


An example of pull to refresh funcionality on SwiftUI for iOS 14+. **100% SwiftUI**. No UIKit usage. 

<p align="center">
    <img alt="RefreshableScrollView" src="README.assets/pull.gif" />
</p>

This modifier mimics the [refreshable modifier](https://developer.apple.com/documentation/swiftui/label/refreshable(action:)) functionality. It can take async tasks and shows a progressView when calling the task.

| <img src="README.assets/image-20220511031830250.png" alt="image-20220511031830250" style="zoom: 25%;" /> | <img src="README.assets/image-20220511032116861.png" alt="image-20220511032116861" style="zoom:25%;" /> | <img src="README.assets/image-20220511032139075.png" alt="image-20220511032139075" style="zoom:25%;" /> |
| ------------------------------------------------------------ | ------------------------------------------------------------ | ------------------------------------------------------------ |

## Usage

Just copy the `PullToRefreshModifier.swift` file in your project and use the modifier like this:

```swift
        NavigationView {
            ScrollView {
		   ...
                }
                .pullToRefresh {
                    await asyncTask()
                }
        }
```

You have to apply the pullToRefresh modifier to ScrollView or any view inside of it.

*Work is in progress to support iOS 13.*

