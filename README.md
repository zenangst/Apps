# Apps

## Description

Apps is a small framework for indexing installed applications into a collection of structs

## Usage

```swift
/// Synchronous loading of applications
let applications = ApplicationController.loadApplications()

/// Asynchronous loading of applications
ApplicationController.asyncLoadApplications()
  .sink { applications in
    // Code goes here.
  }
  .store(in: &subscriptions)
}
```

## Author

Christoffer Winterkvist, christoffer@winterkvist.com

## License

**Apps** is available under the MIT license. See the [LICENSE](https://github.com/zenangst/LaunchArguments/blob/master/LICENSE.md) file for more info.

