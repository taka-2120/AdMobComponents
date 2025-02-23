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
    private var adCount: Int?
    private var adUnitID: String?
    private var canLoadAds: Bool?
    private var adRefreshInterval: TimeInterval?
    private var adRefreshTimer: Timer?
    private var adLoader: GADAdLoader?
    private(set) var nativeAds = [GADNativeAd]()
    private(set) var isLoading = false
    private(set) var unableToLoad = false

    @MainActor static let shared = NativeAdViewModel()
    override private init() {
        super.init()
    }

    deinit {
        stopAdRefreshingTimer()
    }

    func apply(adCount: Int, adUnitID: String, canLoadAds: Bool, adRefreshInterval: TimeInterval) {
        self.adCount = adCount
        self.adUnitID = adUnitID
        self.canLoadAds = canLoadAds
        self.adRefreshInterval = adRefreshInterval

        if adRefreshInterval == 0 {
            loadAds()
        } else {
            startAdRefreshingTimer()
        }
    }

    func startAdRefreshingTimer() {
        guard let adRefreshInterval else { return }
        if adRefreshTimer != nil { return }

        adRefreshTimer = Timer.scheduledTimer(
            timeInterval: adRefreshInterval,
            target: self,
            selector: #selector(loadAds),
            userInfo: nil,
            repeats: true
        )
        adRefreshTimer?.fire()
    }

    func stopAdRefreshingTimer() {
        guard let adRefreshTimer else { return }
        adRefreshTimer.invalidate()
        self.adRefreshTimer = nil
    }

    @objc private func loadAds() {
        guard let canLoadAds, let adCount, let adUnitID, canLoadAds else { return }
        isLoading = true

        for ad in nativeAds {
            ad.unregisterAdView()
        }
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
