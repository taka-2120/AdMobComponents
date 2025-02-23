//
//  View+Configure.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 12/28/24.
//

import SwiftUI

public extension View {
    ///
    /// `configureAdMob` modifier configures mainly Native Ads, also simultaneously sets up `NetworkObserver` to observe network connections for displaying ad placeholders under offline for both of Native and Banner Ads.
    ///
    /// - parameter nativeAdCount: The number of Native Ads will be loaded.
    /// - parameter nativeAdUnitID: The unit ID for Native Ads provided by Google AdMob.
    /// - parameter canLoadNativeAds: The flag determines wether load Native Ads or not.
    /// - parameter nativeAdRefreshInterval: The timer interval (sec) for refreshing Native Ads. Set `0` to disable refreshing.
    ///
    func configureAdMob(
        nativeAdCount: Int,
        nativeAdUnitID: String,
        canLoadNativeAds: Bool,
        nativeAdRefreshInterval: TimeInterval
    ) -> some View {
        modifier(
            AdMobConfiguration(
                nativeAdCount: nativeAdCount,
                nativeAdUnitID: nativeAdUnitID,
                canLoadNativeAds: canLoadNativeAds,
                nativeAdRefreshInterval: nativeAdRefreshInterval
            )
        )
    }
}

private struct AdMobConfiguration: ViewModifier {
    @Environment(\.scenePhase) var scenePhase
    @State private var hasAppeared = false

    private let networkObserver = NetworkObserver.shared
    private let nativeAdViewModel = NativeAdViewModel.shared
    let nativeAdCount: Int
    let nativeAdUnitID: String
    let canLoadNativeAds: Bool
    let nativeAdRefreshInterval: TimeInterval

    func body(content: Content) -> some View {
        content
            .task {
                guard !hasAppeared else { return }
                hasAppeared = true

                nativeAdViewModel.apply(
                    adCount: nativeAdCount,
                    adUnitID: nativeAdUnitID,
                    canLoadAds: canLoadNativeAds,
                    adRefreshInterval: nativeAdRefreshInterval
                )
            }
            .environment(nativeAdViewModel)
            .onChange(of: scenePhase) { _, newPhase in
                if newPhase == .active {
                    nativeAdViewModel.startAdRefreshingTimer()
                    networkObserver.startObservation()
                } else {
                    nativeAdViewModel.stopAdRefreshingTimer()
                    networkObserver.stopObservation()
                }
            }
    }
}
