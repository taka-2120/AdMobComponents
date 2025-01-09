//
//  NativeAdViewModel.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 8/13/24.
//

import GoogleMobileAds
import SwiftUI

/// `NativeAdViewModel` loads and refreshes Native Ads via Google AdMob library.
///
/// - parameter adCount: The number of ads will be loaded.
/// - parameter adUnitID: The unit ID provided by Google AdMob.
/// - parameter canLoadAds: The flag determines wether load ads or not.
/// - parameter adRefreshInterval: The timer interval (sec) for refreshing ads. Set `0` to disable refreshing.
///
@Observable
class NativeAdViewModel: NSObject, GADNativeAdLoaderDelegate, GADNativeAdDelegate {
    private let adCount: Int
    private let adUnitID: String
    private let canLoadAds: Bool
    private let adRefreshInterval: TimeInterval
    private var adRefreshTimer: Timer?
    private var adLoader: GADAdLoader?
    private(set) var nativeAds = [GADNativeAd]()
    private(set) var isLoading = false
    private(set) var unableToLoad = false

    init(adCount: Int, adUnitID: String, canLoadAds: Bool, adRefreshInterval: TimeInterval) {
        self.adCount = adCount
        self.adUnitID = adUnitID
        self.canLoadAds = canLoadAds
        self.adRefreshInterval = adRefreshInterval
        super.init()

        if adRefreshInterval == 0 {
            loadAds()
        } else {
            startAdRefreshingTimer()
        }
    }

    deinit {
        stopAdRefreshingTimer()
    }

    private func startAdRefreshingTimer() {
        adRefreshTimer = Timer.scheduledTimer(
            timeInterval: adRefreshInterval,
            target: self,
            selector: #selector(loadAds),
            userInfo: nil,
            repeats: true
        )
        adRefreshTimer?.fire()
    }

    private func stopAdRefreshingTimer() {
        guard let adRefreshTimer else { return }
        adRefreshTimer.invalidate()
        self.adRefreshTimer = nil
    }

    @objc private func loadAds() {
        guard canLoadAds else { return }
        isLoading = true
        nativeAds.removeAll()

        let multipleAdOptions = GADMultipleAdsAdLoaderOptions()
        multipleAdOptions.numberOfAds = adCount
        adLoader = GADAdLoader(
            adUnitID: adUnitID,
            rootViewController: nil,
            adTypes: [.native], options: [multipleAdOptions]
        )
        guard let adLoader else {
            isLoading = false
            unableToLoad = true
            return
        }
        adLoader.delegate = self
        adLoader.load(GADRequest())
    }

    func adLoader(_: GADAdLoader, didReceive nativeAd: GADNativeAd) {
        nativeAds.append(nativeAd)
        nativeAd.delegate = self
        withAnimation {
            isLoading = false
        }
    }

    func adLoader(_ adLoader: GADAdLoader, didFailToReceiveAdWithError error: Error) {
        print("\(adLoader) failed with error: \(error.localizedDescription)")
    }
}
