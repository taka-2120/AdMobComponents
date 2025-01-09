//
//  BannerAdViewController.swift
//  AdMobComponents
//
//  Created by Yu Takahashi on 8/13/24.
//

import GoogleMobileAds
import UIKit

@Observable
class BannerAdViewController: UIViewController, GADBannerViewDelegate {
    private let adUnitID: String
    private var bannerView: GADBannerView?
    var isAdLoading = true

    init(adUnitID: String) {
        self.adUnitID = adUnitID
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        loadBannerAd()
    }

    private func loadBannerAd() {
        bannerView = GADBannerView(adSize: GADAdSizeBanner)
        bannerView?.adUnitID = adUnitID

        bannerView?.delegate = self
        bannerView?.rootViewController = self

        let bannerWidth = view.frame.size.width
        bannerView?.adSize = GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(bannerWidth)

        let request = GADRequest()
        request.scene = view.window?.windowScene
        bannerView?.load(request)

        guard let bannerView else {
            print("Unable to get banner ad.")
            return
        }
        setAdView(bannerView)
        isAdLoading = false
    }

    private func setAdView(_ view: GADBannerView) {
        bannerView = view
        self.view.addSubview(bannerView!)
        bannerView?.translatesAutoresizingMaskIntoConstraints = false
        let viewDictionary: [String: Any] = ["_bannerView": bannerView as Any]
        self.view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "H:|[_bannerView]|", metrics: nil, views: viewDictionary)
        )

        self.view.addConstraints(
            NSLayoutConstraint.constraints(withVisualFormat: "V:|[_bannerView]|", metrics: nil, views: viewDictionary)
        )
    }
}
