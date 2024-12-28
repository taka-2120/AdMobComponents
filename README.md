# AdMobComponents

## Description

This package contains useful Banner and Native Ads components for Google AdMob.

## Requirements

- Swift 6.0 or later
- macOS 14, iOS 17, tvOS 17, watchOS 10, macCatalyst 17 or later

## Installation

### via SPM (Swift Package Manager)

- **Using GUI**

  Type the URL bellow to add this package to your project.

  ```shell
  https://github.com/taka-2120/AdMobComponents.git
  ```

- **Add to `Package.swift` manually**

  1. Add this package to the dependencies.

      ```swift
        dependencies: [
            .package(
                url: "https://github.com/taka-2120/AdMobComponents.git",
                .upToNextMajor(from: "1.0.0")
            ),
        ],
      ```

  2. Add this package product to your target.

      ```swift
      targets: [
          .target(
              name: "YourTarget",
              dependencies: [
                  .product(name: "AdMobComponents", package: "AdMobComponents"),
              ]
          ),
      ]
      ```

### Usage

- Add `configureAdMob`modifier to configure Native Ads and start network observer in your `App` struct.

  \* Note: Network observer is required to display ad placeholder when the network is not available.

    ```swift
    import AdMobComponents

    @main
    struct YourApp: App {
        var body: some Scene {
            WindowGroup {
                ContentView()
                    .configureAdMob(
                        nativeAdCount: 5,
                        nativeAdUnitID: "ca-app-pub-....",
                        canLoadNativeAds: !isPurchased, // This variable is just an example. You can use your own variable.
                        nativeAdRefreshInterval: 30
                    )
            }
        }
    }
    ```

- Add `bannerAd` modifier to your `View`.

    ```swift
    import AdMobComponents

    ...

    @State private var isBannerAdPresented = false

    ...

    yourView
        .bannerAd(isPresented: $isBannerAdPresented, adUnitID: "ca-app-pub-....")
    ```

- Add `NativeAdView` component into your `View`.

    ```swift
    import AdMobComponents

    ...

    NativeAdView(showsAt: 0)
    ```
