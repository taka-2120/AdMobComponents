//
//  AdMobComponentsSampleApp.swift
//  AdMobComponentsSample
//
//  Created by Yu Takahashi on 2/23/25.
//

import AdMobComponents
import SwiftUI

@main
struct AdMobComponentsSampleApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .bannerAd(isPresented: true, adUnitID: "ca-app-pub-3940256099942544/2435281174")
                .configureAdMob(
                    nativeAdCount: 3,
                    nativeAdUnitID: "ca-app-pub-3940256099942544/3986624511",
                    canLoadNativeAds: true,
                    nativeAdRefreshInterval: 10
                )
        }
    }
}
